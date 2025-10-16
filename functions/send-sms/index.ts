// SMS Sending Edge Function
// Supports multiple SMS providers: Aligo (Korea), Twilio (International)

import { serve } from "https://deno.land/std@0.177.0/http/server.ts";

interface SMSRequest {
  phone: string;
  code?: string;
  message?: string;
  provider?: "aligo" | "twilio";
}

interface AligoResponse {
  result_code: string;
  message: string;
  msg_id?: string;
}

serve(async (req: Request) => {
  try {
    const { phone, code, message, provider = "aligo" }: SMSRequest = await req.json();

    // Validate input
    if (!phone) {
      return new Response(
        JSON.stringify({ error: "Phone number is required" }),
        { status: 400, headers: { "Content-Type": "application/json" } }
      );
    }

    if (!code && !message) {
      return new Response(
        JSON.stringify({ error: "Either code or message is required" }),
        { status: 400, headers: { "Content-Type": "application/json" } }
      );
    }

    // Determine message content
    const smsMessage = message || `Jumun 인증번호: ${code}`;

    // Send SMS based on provider
    let result;
    if (provider === "aligo") {
      result = await sendAligoSMS(phone, smsMessage);
    } else if (provider === "twilio") {
      result = await sendTwilioSMS(phone, smsMessage);
    } else {
      return new Response(
        JSON.stringify({ error: "Unsupported SMS provider" }),
        { status: 400, headers: { "Content-Type": "application/json" } }
      );
    }

    return new Response(JSON.stringify(result), {
      status: result.success ? 200 : 500,
      headers: { "Content-Type": "application/json" },
    });
  } catch (error) {
    console.error("SMS Sending Error:", error);
    return new Response(
      JSON.stringify({
        success: false,
        error: error.message || "Failed to send SMS",
      }),
      {
        status: 500,
        headers: { "Content-Type": "application/json" },
      }
    );
  }
});

/**
 * Send SMS via Aligo (Korean SMS provider)
 * Docs: https://smartsms.aligo.in/admin/api/spec.html
 */
async function sendAligoSMS(
  phone: string,
  message: string
): Promise<{ success: boolean; message: string; msg_id?: string }> {
  const apiKey = Deno.env.get("ALIGO_API_KEY");
  const userId = Deno.env.get("ALIGO_USER_ID");
  const sender = Deno.env.get("ALIGO_SENDER_NUMBER");

  if (!apiKey || !userId || !sender) {
    console.error("Aligo credentials not configured");
    return {
      success: false,
      message: "Aligo SMS provider not configured",
    };
  }

  // Prepare form data for Aligo API
  const formData = new URLSearchParams({
    key: apiKey,
    user_id: userId,
    sender: sender,
    receiver: phone,
    msg: message,
    msg_type: "SMS", // SMS or LMS (long message)
    title: "Jumun", // Title for LMS
  });

  try {
    const response = await fetch("https://apis.aligo.in/send/", {
      method: "POST",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: formData.toString(),
    });

    const data: AligoResponse = await response.json();

    if (data.result_code === "1") {
      // Success
      return {
        success: true,
        message: "SMS sent successfully via Aligo",
        msg_id: data.msg_id,
      };
    } else {
      // Failed
      console.error("Aligo API Error:", data);
      return {
        success: false,
        message: data.message || "Failed to send SMS via Aligo",
      };
    }
  } catch (error) {
    console.error("Aligo Request Error:", error);
    return {
      success: false,
      message: "Network error while sending SMS via Aligo",
    };
  }
}

/**
 * Send SMS via Twilio (International SMS provider)
 * Docs: https://www.twilio.com/docs/sms/api
 */
async function sendTwilioSMS(
  phone: string,
  message: string
): Promise<{ success: boolean; message: string; msg_id?: string }> {
  const accountSid = Deno.env.get("TWILIO_ACCOUNT_SID");
  const authToken = Deno.env.get("TWILIO_AUTH_TOKEN");
  const fromNumber = Deno.env.get("TWILIO_FROM_NUMBER");

  if (!accountSid || !authToken || !fromNumber) {
    console.error("Twilio credentials not configured");
    return {
      success: false,
      message: "Twilio SMS provider not configured",
    };
  }

  const url = `https://api.twilio.com/2010-04-01/Accounts/${accountSid}/Messages.json`;

  // Prepare form data for Twilio API
  const formData = new URLSearchParams({
    To: phone,
    From: fromNumber,
    Body: message,
  });

  try {
    const response = await fetch(url, {
      method: "POST",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        Authorization: `Basic ${btoa(`${accountSid}:${authToken}`)}`,
      },
      body: formData.toString(),
    });

    const data = await response.json();

    if (response.ok && data.sid) {
      // Success
      return {
        success: true,
        message: "SMS sent successfully via Twilio",
        msg_id: data.sid,
      };
    } else {
      // Failed
      console.error("Twilio API Error:", data);
      return {
        success: false,
        message: data.message || "Failed to send SMS via Twilio",
      };
    }
  } catch (error) {
    console.error("Twilio Request Error:", error);
    return {
      success: false,
      message: "Network error while sending SMS via Twilio",
    };
  }
}
