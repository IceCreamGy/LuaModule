// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

/*
说明:继承Mobile/Transparent/Vertex Color.shader
应用面:顶点软边透贴,主要是草跟树叶,通用性比较高,目前漂移版里plant类引用
color主要用来调整明暗调整的.比如在暗部的一些树
*/

Shader "TopCar/Env/Plant_VertexColor_EX" 
{
	Properties 
	{
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
        _Overbright("Overbright", Range(0.01, 100)) = 2.0
        _CutOff("Alpha cutoff", Range(0, 1)) = 0.5
    }

    CGINCLUDE
        #include "UnityCG.cginc"

        struct v2f
        {
            float4 vertex : POSITION;
            fixed2 texcoord : TEXCOORD0;
            fixed4 color : COLOR;
            UNITY_FOG_COORDS(1)
        };

        sampler2D _MainTex;
        fixed4 _MainTex_ST;
        fixed4 _Color;
        half _Overbright;
        fixed _CutOff;

        v2f vert(appdata_full v)
        {
            v2f o;
            o.vertex = UnityObjectToClipPos(v.vertex);
            o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
            o.color = v.color;
            UNITY_TRANSFER_FOG(o, o.vertex); // pass fog coordinates to pixel shader
            return o;
        }

        fixed4 frag(v2f i) : COLOR
        {
            fixed4 col = tex2D(_MainTex, i.texcoord) * i.color  * _Color;
            col.rgb *= _Overbright;

            UNITY_APPLY_FOG(i.fogCoord, col); // apply fog
            return col;
        }

        v2f vertDepth(appdata_full v)
        {
            v2f o;
            o.vertex = UnityObjectToClipPos(v.vertex);
            o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
            o.color = v.color;
            return o;
        }

        fixed4 fragDepth(v2f i) : COLOR
        {
            fixed4 col = tex2D(_MainTex, i.texcoord);
            clip(col.a - _CutOff);
            return fixed4(1,1,1,1);
        }
    ENDCG

	Category 
	{
        Tags
        {
            "Queue" = "Transparent"
            "IgnoreProjector" = "True"
            "RenderType" = "Transparent"
        }
        Cull off

		SubShader
		{
			Lod 30

            Pass
            {
                Tags
                {
                    "LightMode" = "ForwardBase"
                }
                ZWrite On
                ColorMask 0

                CGPROGRAM

                #pragma vertex vertDepth
                #pragma fragment fragDepth

                ENDCG
            }

			Pass 
			{
				Lighting Off
                ZWrite Off
                Blend SrcAlpha OneMinusSrcAlpha
            
				CGPROGRAM
					
				#pragma vertex vert
				#pragma fragment frag
				#pragma multi_compile_fog
					
				ENDCG 
			}

            Pass
            {
                Tags 
                {
                    "LightMode" = "ShadowCaster" 
                }
                Name "PlantShadowCasterEX"

                ZWrite On
                ZTest LEqual
                Cull Off

                CGPROGRAM
                #pragma vertex vertShadow
                #pragma fragment fragShadow
                #pragma target 2.0
                #pragma multi_compile_shadowcaster
                #include "UnityCG.cginc"

                struct v2fShadow
                {
                    V2F_SHADOW_CASTER;
                    half2 uv : TEXCOORD1;
                };

                v2fShadow vertShadow(appdata_full v)
                {
                    v2fShadow o;
                    TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
                    o.uv = v.texcoord.xy;
                    return o;
                }

                half4 fragShadow(v2fShadow i) : SV_Target
                {
                    half alpha = tex2D(_MainTex, i.uv).a;
                    clip( alpha - 0.1);
                    SHADOW_CASTER_FRAGMENT(i)
                }
                ENDCG
            }

		}
	}

    FallBack "Unlit/Transparent"
}