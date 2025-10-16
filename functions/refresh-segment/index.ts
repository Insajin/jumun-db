// Refresh Segment Edge Function
// Recalculates customer count for auto segments

import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

interface RefreshSegmentRequest {
  segment_id: string;
}

interface CustomerSegment {
  id: string;
  brand_id: string;
  name: string;
  type: "manual" | "auto";
  conditions: any[] | null;
  customer_ids: string[] | null;
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

    // Create Supabase client with user's auth token
    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;
    const supabase = createClient(supabaseUrl, supabaseKey, {
      global: {
        headers: { Authorization: authHeader },
      },
    });

    // Parse request body
    const { segment_id }: RefreshSegmentRequest = await req.json();

    if (!segment_id) {
      return new Response(
        JSON.stringify({ error: "segment_id is required" }),
        { status: 400, headers: { "Content-Type": "application/json" } }
      );
    }

    // Fetch segment
    const { data: segment, error: segmentError } = await supabase
      .from("customer_segments")
      .select("*")
      .eq("id", segment_id)
      .single();

    if (segmentError || !segment) {
      console.error("Segment fetch error:", segmentError);
      return new Response(
        JSON.stringify({ error: "Segment not found" }),
        { status: 404, headers: { "Content-Type": "application/json" } }
      );
    }

    const typedSegment = segment as CustomerSegment;

    // Only refresh auto segments
    if (typedSegment.type !== "auto") {
      return new Response(
        JSON.stringify({
          success: false,
          error: "Only auto segments can be refreshed",
          segment_type: typedSegment.type,
        }),
        { status: 400, headers: { "Content-Type": "application/json" } }
      );
    }

    // Get all customers for this brand
    const { data: customers, error: customersError } = await supabase
      .from("customers")
      .select("id")
      .eq("brand_id", typedSegment.brand_id);

    if (customersError) {
      console.error("Customers fetch error:", customersError);
      return new Response(
        JSON.stringify({ error: "Failed to fetch customers" }),
        { status: 500, headers: { "Content-Type": "application/json" } }
      );
    }

    // Evaluate each customer against segment conditions
    const matchingCustomerIds: string[] = [];

    for (const customer of customers || []) {
      const { data: matches, error: matchError } = await supabase.rpc(
        "customer_matches_segment",
        {
          p_customer_id: customer.id,
          p_segment_id: segment_id,
        }
      );

      if (matchError) {
        console.error("Segment match error for customer:", customer.id, matchError);
        continue;
      }

      if (matches) {
        matchingCustomerIds.push(customer.id);
      }
    }

    // Update segment with new customer count
    const { error: updateError } = await supabase
      .from("customer_segments")
      .update({
        customer_count: matchingCustomerIds.length,
        updated_at: new Date().toISOString(),
      })
      .eq("id", segment_id);

    if (updateError) {
      console.error("Segment update error:", updateError);
      return new Response(
        JSON.stringify({ error: "Failed to update segment" }),
        { status: 500, headers: { "Content-Type": "application/json" } }
      );
    }

    return new Response(
      JSON.stringify({
        success: true,
        segment_id: segment_id,
        segment_name: typedSegment.name,
        customer_count: matchingCustomerIds.length,
        previous_count: typedSegment.customer_ids?.length || 0,
      }),
      {
        status: 200,
        headers: { "Content-Type": "application/json" },
      }
    );
  } catch (error) {
    console.error("Refresh Segment Error:", error);
    return new Response(
      JSON.stringify({
        success: false,
        error: error.message || "Failed to refresh segment",
      }),
      {
        status: 500,
        headers: { "Content-Type": "application/json" },
      }
    );
  }
});
