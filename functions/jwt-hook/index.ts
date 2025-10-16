// JWT Hook - Add Custom Claims to Access Token
// This function adds role, brand_id, and store_id to JWT for RBAC

import { serve } from "https://deno.land/std@0.177.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

interface JWTPayload {
  user_id: string;
  email?: string;
  phone?: string;
  aud: string;
  role: string;
}

serve(async (req: Request) => {
  try {
    // Parse the JWT payload from the request
    const payload: JWTPayload = await req.json();

    // Create Supabase client with service role
    const supabaseUrl = Deno.env.get("SUPABASE_URL")!;
    const supabaseServiceKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!;

    const supabase = createClient(supabaseUrl, supabaseServiceKey);

    // Default claims for customer role
    let customClaims = {
      role: "customer",
      brand_id: null as string | null,
      store_id: null as string | null,
    };

    // Check if user is staff member
    const { data: staff, error: staffError } = await supabase
      .from("staff")
      .select(
        `
        role,
        store_id,
        stores!inner (
          id,
          brand_id
        )
      `
      )
      .eq("user_id", payload.user_id)
      .single();

    if (!staffError && staff) {
      // User is staff - set their role and associated IDs
      customClaims = {
        role: staff.role,
        brand_id: staff.stores.brand_id,
        store_id: staff.store_id,
      };
    }

    // Log for debugging (remove in production)
    console.log("JWT Hook - Custom Claims:", {
      user_id: payload.user_id,
      claims: customClaims,
    });

    // Return custom claims to be added to JWT
    return new Response(JSON.stringify(customClaims), {
      status: 200,
      headers: {
        "Content-Type": "application/json",
      },
    });
  } catch (error) {
    console.error("JWT Hook Error:", error);

    // Return default customer role on error
    return new Response(
      JSON.stringify({
        role: "customer",
        brand_id: null,
        store_id: null,
      }),
      {
        status: 200,
        headers: {
          "Content-Type": "application/json",
        },
      }
    );
  }
});
