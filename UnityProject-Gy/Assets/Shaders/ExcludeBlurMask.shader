// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Hidden/TopCar/Env/ExcludeBlurMask"
{
	Properties
	{
	}
    SubShader
    {
        Tags{ "QUEUE" = "Geometry" "RenderType" = "Opaque" "ExcludeBlurMask" = "True" }
        LOD 400

        Pass
        {
            Tags{ "LightMode" = "ForwardBase" }

            ZWrite Off
            ZTest LEqual
            Offset -1, -1 //z-Fighting

            CGPROGRAM

            // make fog work
#pragma fragmentoption ARB_precision_hint_fastest
#pragma multi_compile_fwdbase
#pragma multi_compile_instancing
#pragma target 3.0

#pragma vertex vert
#pragma fragment frag

#include "UnityCG.cginc"
            struct appdata
            {
                float4 vertex : POSITION;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            v2f vert(appdata v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);

                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag(v2f i) : COLOR //SV_Target
            {
                UNITY_SETUP_INSTANCE_ID(i);
                return fixed4(1,0,0,0);
            }
            ENDCG
        }
        Pass
            {
                Name "ShadowCaster"
                Tags{ "LightMode" = "ShadowCaster" }

                Fog{ Mode Off }
                ZWrite On
                ZTest LEqual

                CGPROGRAM

#include "UnityCG.cginc"
#pragma vertex vert
#pragma fragment frag
#pragma multi_compile_shadowcaster
#pragma fragmentoption ARB_precision_hint_fastest
//#pragma multi_compile_instancing

            struct v2f
            {
                V2F_SHADOW_CASTER;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            v2f vert(appdata_full v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);

                TRANSFER_SHADOW_CASTER(o)
                return o;
            }

            float4 frag(v2f i) : COLOR
            {
                UNITY_SETUP_INSTANCE_ID(i);
                SHADOW_CASTER_FRAGMENT(i)
            }

            ENDCG
        }
    }
	SubShader
	{
		Tags { "QUEUE" = "Geometry" "RenderType"="Opaque" "ExcludeBlurMask" = "True"}
		LOD 400

		Pass
		{
			Tags{ "LightMode" = "ForwardBase"}

			ZWrite Off
			ZTest LEqual

			CGPROGRAM

			// make fog work
			//#pragma multi_compile_fog
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma multi_compile_fwdbase
			#pragma target 3.0

			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			//sampler2D _MainTex;
			//half4 _MainTex_ST;

			struct appdata
			{
				float4 vertex : POSITION;
				//fixed4 color : COLOR; //不作透明度剔除
				//float2 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				//fixed4 color : COLOR;
				//float2 texcoord : TEXCOORD0;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				//o.color = v.color;
				//o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : COLOR //SV_Target
			{
				//half4 col = tex2D(_MainTex, i.texcoord);
				//clip(col.a - 0.001);

				//clip(i.color.a - 0.001);
				return fixed4(1,0,0,0);
			}
			ENDCG
		}
	}
	// The definition of a fallback shader should be commented out 
	// during development:
	Fallback "Mobile/Diffuse"
}
