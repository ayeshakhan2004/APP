import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.3"

Deno.serve(async (req) => {
  try {
    const supabaseUrl = Deno.env.get('SUPABASE_URL') ?? '';
    const supabaseKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '';
    const supabase = createClient(supabaseUrl, supabaseKey);

    const body = await req.json();

    // Map strictly to the columns shown in your screenshots
    const { data, error } = await supabase
      .from('signals')
      .insert([{ 
        source: body.source || "field_report", 
        // Wrap the string in an object because the column is jsonb!
        location: { area: body.location || "Unknown" }, 
        // Shove the entire payload (including the text) into raw_data
        raw_data: body,
        // Provide defaults for the remaining columns
        credibility_score: 0.5,
        urgency_score: 0.5,
        contradiction_level: 0.0,
        is_verified: false
      }])
      .select();

    if (error) {
      return new Response(JSON.stringify({ database_error: error }), {
        headers: { "Content-Type": "application/json" },
        status: 200, 
      });
    }

    return new Response(JSON.stringify({ success: true, data }), {
      headers: { "Content-Type": "application/json" },
      status: 200,
    });

  } catch (error) {
    return new Response(JSON.stringify({ code_error: error.message }), {
      headers: { "Content-Type": "application/json" },
      status: 200,
    });
  }
});