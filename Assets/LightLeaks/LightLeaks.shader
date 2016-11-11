Shader "FX/LightLeaks"
{
    Properties
    {
        _MainTex("", 2D) = "white"{}
    }

    CGINCLUDE

    #include "UnityCG.cginc"
    #pragma shader_feature SCREEN_BLENDMODE

    sampler2D _MainTex;
    float _Intensity;
    float _Red;
    float _Yellow;
    float _Blue;
    float _MoveSpeed;

    fixed4 Lighten (fixed4 a, fixed4 b)
    {
        fixed4 r = max(a, b);
        r.a = b.a;
        return r;
    }

    fixed4 Screen (fixed4 a, fixed4 b)
    {
        fixed4 r = 1.0 - (1.0 - a) * (1.0 - b);
        r.a = b.a;
        return r;
    }


    fixed4 frag(v2f_img i) : SV_Target
    {
        fixed4 source = tex2D(_MainTex, i.uv);

          
        float2 uv = i.uv;
        
   		float t=_Time.y + cos(_Time.y*_MoveSpeed);
   		fixed4 finalColor = fixed4(0,0,0,1.0);

        float yellowPosition = (sin(uv.x*cos(t)*6.*cos(uv.y*t/232.)) + sin(uv.y*sin(t)*3.*cos(uv.x*t/212.)));
   		fixed4 yellow = fixed4(1.0 *  yellowPosition, 0.9 *  yellowPosition, 0.63 * yellowPosition,1);

        fixed4 red = fixed4(1.0 * ( cos(uv.x*sin(t)*5.*cos(uv.y*t/211.)) + sin(uv.y*sin(t)*6.*cos(uv.x*t/234.))), 0, 0, 1);
        fixed4 blue = fixed4(0, 0, ( cos(uv.x*cos(t)*4.*cos(uv.y*t/311.)) + sin(uv.y*sin(t)*7.*cos(uv.x*t/321.))), 1);

        finalColor += yellow * _Yellow;
        finalColor += red * _Red;
        finalColor += blue * _Blue;
     # if SCREEN_BLENDMODE
        finalColor= lerp(source, Screen(source,finalColor),_Intensity);
     # else
        finalColor= lerp(source, Lighten(source,finalColor),_Intensity);
     #endif
     return finalColor;
    }

    ENDCG

    SubShader
    {
        Cull Off ZWrite Off ZTest Always
        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            #pragma target 3.0
            ENDCG
        }
    }
}
