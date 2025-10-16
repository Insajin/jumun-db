// Send Notification Edge Function
// Sends push notifications to targeted customers

import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

interface SendNotificationRequest {
  notification_id: string;
}

interface Notification {
  id: string;
  brand_id: string;
  title: string;
  body: string;
  category: string;
  target: "all" | "segment" | "individual";
  segment_id: string | null;
  customer_ids: string[] | null;
  status: string;
}

interface PushToken {
  customer_id: string;
  token: string;
  platform: "ios" | "android" | "web";
}

serve(async (req: Request) => {
  try {
    // Get Authorization header
    const authHeader = req.headers.get("Authorization");
    if (!authHeader) {
      return new Response(
        JSON.stringify({ error: "Missing authorization header" }),
        { status: 401, headers: { "Content-Type": "application/json" } }
      );
    }

    // Create Supabase client
    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const supabase = createClient(supabaseUrl, supabaseKey, {
      global: {
        headers: { Authorization: authHeader },
      },
    });

    // Parse request body
    const { notification_id }: SendNotificationRequest = await req.json();

    if (!notification_id) {
      return new Response(
        JSON.stringify({ error: "notification_id is required" }),
        { status: 400, headers: { "Content-Type": "application/json" } }
      );
    }

    // Fetch notification
    const { data: notification, error: notificationError } = await supabase
      .from("notifications")
      .select("*")
      .eq("id", notification_id)
      .single();

    if (notificationError || !notification) {
      console.error("Notification fetch error:", notificationError);
      return new Response(
        JSON.stringify({ error: "Notification not found" }),
        { status: 404, headers: { "Content-Type": "application/json" } }
      );
    }

    const typedNotification = notification as Notification;

    // Update status to sending
    await supabase
      .from("notifications")
      .update({ status: "sending" })
      .eq("id", notification_id);

    // Get target customer IDs
    let targetCustomerIds: string[] = [];

    if (typedNotification.target === "all") {
      // Get all customers for this brand
      const { data: customers, error: customersError } = await supabase
        .from("customers")
        .select("id")
        .eq("brand_id", typedNotification.brand_id);

      if (customersError) {
        console.error("Customers fetch error:", customersError);
        throw new Error("Failed to fetch customers");
      }

      targetCustomerIds = customers?.map((c) => c.id) || [];
    } else if (typedNotification.target === "segment" && typedNotification.segment_id) {
      // Get customers from segment
      const { data: segment, error: segmentError } = await supabase
        .from("customer_segments")
        .select("customer_ids, conditions, type")
        .eq("id", typedNotification.segment_id)
        .single();

      if (segmentError) {
        console.error("Segment fetch error:", segmentError);
        throw new Error("Failed to fetch segment");
      }

      if (segment.type === "manual" && segment.customer_ids) {
        targetCustomerIds = segment.customer_ids;
      } else if (segment.type === "auto") {
        // Get all customers and evaluate conditions
        const { data: customers, error: customersError } = await supabase
          .from("customers")
          .select("id")
          .eq("brand_id", typedNotification.brand_id);

        if (customersError) {
          console.error("Customers fetch error:", customersError);
          throw new Error("Failed to fetch customers");
        }

        // Evaluate segment conditions for each customer
        for (const customer of customers || []) {
          const { data: matches } = await supabase.rpc(
            "customer_matches_segment",
            {
              p_customer_id: customer.id,
              p_segment_id: typedNotification.segment_id,
            }
          );

          if (matches) {
            targetCustomerIds.push(customer.id);
          }
        }
      }
    } else if (typedNotification.target === "individual" && typedNotification.customer_ids) {
      targetCustomerIds = typedNotification.customer_ids;
    }

    // Get push tokens for target customers
    // Note: This assumes you have a push_tokens table
    // You'll need to create this table in a future migration
    const { data: pushTokens, error: tokensError } = await supabase
      .from("push_tokens")
      .select("customer_id, token, platform")
      .in("customer_id", targetCustomerIds)
      .eq("active", true);

    if (tokensError) {
      console.error("Push tokens fetch error:", tokensError);
      // Continue without push tokens - just update counts
    }

    const tokens = (pushTokens as PushToken[]) || [];

    // Send push notifications using FCM (Firebase Cloud Messaging)
    const fcmServerKey = Deno.env.get("FCM_SERVER_KEY");
    let deliveredCount = 0;

    if (fcmServerKey && tokens.length > 0) {
      // Group tokens by platform for batch sending
      const fcmTokens = tokens.map((t) => t.token);

      // Send via FCM (supports both iOS and Android)
      const fcmResponse = await fetch(
        "https://fcm.googleapis.com/fcm/send",
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            Authorization: `key=${fcmServerKey}`,
          },
          body: JSON.stringify({
            registration_ids: fcmTokens,
            notification: {
              title: typedNotification.title,
              body: typedNotification.body,
              sound: "default",
            },
            data: {
              notification_id: notification_id,
              category: typedNotification.category,
            },
          }),
        }
      );

      const fcmResult = await fcmResponse.json();
      deliveredCount = fcmResult.success || 0;

      console.log("FCM Response:", fcmResult);
    }

    // Update notification with sent counts
    const { error: updateError } = await supabase
      .from("notifications")
      .update({
        status: "sent",
        sent_count: targetCustomerIds.length,
        delivered_count: deliveredCount,
        updated_at: new Date().toISOString(),
      })
      .eq("id", notification_id);

    if (updateError) {
      console.error("Notification update error:", updateError);
    }

    return new Response(
      JSON.stringify({
        success: true,
        notification_id: notification_id,
        sent_count: targetCustomerIds.length,
        delivered_count: deliveredCount,
        title: typedNotification.title,
      }),
      {
        status: 200,
        headers: { "Content-Type": "application/json" },
      }
    );
  } catch (error) {
    console.error("Send Notification Error:", error);

    // Update notification status to failed
    try {
      const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
      const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
      const supabase = createClient(supabaseUrl, supabaseKey);

      const { notification_id } = await req.json();
      if (notification_id) {
        await supabase
          .from("notifications")
          .update({ status: "failed" })
          .eq("id", notification_id);
      }
    } catch (updateError) {
      console.error("Failed to update notification status:", updateError);
    }

    return new Response(
      JSON.stringify({
        success: false,
        error: error.message || "Failed to send notification",
      }),
      {
        status: 500,
        headers: { "Content-Type": "application/json" },
      }
    );
  }
});
