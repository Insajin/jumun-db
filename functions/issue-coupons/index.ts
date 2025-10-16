// Issue Coupons Edge Function
// Generates bulk coupons from a template

import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

interface IssueCouponsRequest {
  template_id: string;
}

interface CouponTemplate {
  id: string;
  brand_id: string;
  name: string;
  type: string;
  value: number;
  code_prefix: string;
  quantity: number;
  per_customer_limit: number;
  expires_at: string;
  target_segment: string | null;
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
    const { template_id }: IssueCouponsRequest = await req.json();

    if (!template_id) {
      return new Response(
        JSON.stringify({ error: "template_id is required" }),
        { status: 400, headers: { "Content-Type": "application/json" } }
      );
    }

    // Fetch template
    const { data: template, error: templateError } = await supabase
      .from("coupon_templates")
      .select("*")
      .eq("id", template_id)
      .single();

    if (templateError || !template) {
      console.error("Template fetch error:", templateError);
      return new Response(
        JSON.stringify({ error: "Template not found" }),
        { status: 404, headers: { "Content-Type": "application/json" } }
      );
    }

    const typedTemplate = template as CouponTemplate;

    // Get target customers
    let customerIds: string[] = [];

    if (typedTemplate.target_segment) {
      // Get customers from segment
      const { data: segment, error: segmentError } = await supabase
        .from("customer_segments")
        .select("customer_ids, conditions, type")
        .eq("id", typedTemplate.target_segment)
        .single();

      if (segmentError) {
        console.error("Segment fetch error:", segmentError);
        return new Response(
          JSON.stringify({ error: "Failed to fetch segment" }),
          { status: 500, headers: { "Content-Type": "application/json" } }
        );
      }

      if (segment.type === "manual" && segment.customer_ids) {
        customerIds = segment.customer_ids;
      } else if (segment.type === "auto") {
        // For auto segments, get all customers and evaluate conditions
        const { data: customers, error: customersError } = await supabase
          .from("customers")
          .select("id")
          .eq("brand_id", typedTemplate.brand_id);

        if (customersError) {
          console.error("Customers fetch error:", customersError);
          return new Response(
            JSON.stringify({ error: "Failed to fetch customers" }),
            { status: 500, headers: { "Content-Type": "application/json" } }
          );
        }

        // Evaluate segment conditions for each customer
        for (const customer of customers || []) {
          const { data: matches } = await supabase.rpc(
            "customer_matches_segment",
            {
              p_customer_id: customer.id,
              p_segment_id: typedTemplate.target_segment,
            }
          );

          if (matches) {
            customerIds.push(customer.id);
          }
        }
      }
    } else {
      // No segment targeting - get all customers for this brand
      const { data: customers, error: customersError } = await supabase
        .from("customers")
        .select("id")
        .eq("brand_id", typedTemplate.brand_id);

      if (customersError) {
        console.error("Customers fetch error:", customersError);
        return new Response(
          JSON.stringify({ error: "Failed to fetch customers" }),
          { status: 500, headers: { "Content-Type": "application/json" } }
        );
      }

      customerIds = customers?.map((c) => c.id) || [];
    }

    // Generate unique coupon codes
    const couponsToInsert = [];
    const totalCoupons = Math.min(typedTemplate.quantity, customerIds.length * typedTemplate.per_customer_limit);

    let customerIndex = 0;
    let customerCouponCount: Record<string, number> = {};

    for (let i = 0; i < totalCoupons; i++) {
      // Round-robin distribution to customers
      const customerId = customerIds[customerIndex % customerIds.length];

      // Check per-customer limit
      if (!customerCouponCount[customerId]) {
        customerCouponCount[customerId] = 0;
      }

      if (customerCouponCount[customerId] >= typedTemplate.per_customer_limit) {
        customerIndex++;
        continue;
      }

      // Generate unique code
      const randomSuffix = Math.random().toString(36).substring(2, 7).toUpperCase();
      const code = `${typedTemplate.code_prefix}${randomSuffix}`;

      couponsToInsert.push({
        brand_id: typedTemplate.brand_id,
        customer_id: customerId,
        code: code,
        type: typedTemplate.type,
        value: typedTemplate.value,
        expires_at: typedTemplate.expires_at,
        issued_by: template.created_by,
        is_active: true,
        usage_count: 0,
        usage_limit: 1,
      });

      customerCouponCount[customerId]++;
      customerIndex++;
    }

    // Insert coupons in batches
    const batchSize = 100;
    let issuedCount = 0;

    for (let i = 0; i < couponsToInsert.length; i += batchSize) {
      const batch = couponsToInsert.slice(i, i + batchSize);
      const { error: insertError } = await supabase
        .from("coupons")
        .insert(batch);

      if (insertError) {
        console.error("Coupon insert error:", insertError);
        // Continue with remaining batches even if one fails
      } else {
        issuedCount += batch.length;
      }
    }

    return new Response(
      JSON.stringify({
        success: true,
        issued_count: issuedCount,
        template_name: typedTemplate.name,
        targeted_customers: customerIds.length,
      }),
      {
        status: 200,
        headers: { "Content-Type": "application/json" },
      }
    );
  } catch (error) {
    console.error("Issue Coupons Error:", error);
    return new Response(
      JSON.stringify({
        success: false,
        error: error.message || "Failed to issue coupons",
      }),
      {
        status: 500,
        headers: { "Content-Type": "application/json" },
      }
    );
  }
});
