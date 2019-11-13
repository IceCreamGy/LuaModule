// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "TopCar/Particles/AlphaBlend_Flip2" 
{
	Properties
	{
		_MainTex("Base (RGB)", 2D) = "white" {}
		_ScaleX("Screen X Scale",float) = 1.0
		_Alpha("Alpha", 2D) = "white" {}
	}
	SubShader {
		Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
		LOD 100

		Lighting Off
		ZWrite Off
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha

		Pass {
			Fog { Mode Off }
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			
			sampler2D _MainTex;
			sampler2D _Alpha;
			fixed4 _MainTex_ST;
			float _ScaleX;
			float4 _MirrorPosInWorld;

			struct appdata_t 
			{
				fixed4 vertex : POSITION;
				fixed4 color : COLOR;
				fixed2 texcoord : TEXCOORD0;
			};
				   
			struct v2f 
			{
				float4 vertex : SV_POSITION;
				fixed4 color : COLOR;
				half2 texcoord : TEXCOORD0;
			};

			v2f vert (appdata_t v) 
			{
				v2f o;
				float4 pos = UnityObjectToClipPos(v.vertex);
				float4 originalpos = mul(UNITY_MATRIX_VP,_MirrorPosInWorld);
				
				pos -= originalpos;
				pos.x = pos.x * _ScaleX ;
				pos += originalpos;
				o.color = v.color;
				o.vertex = pos;
				o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
				return o;
			}

			half4 frag(v2f i) : COLOR 
			{
				 fixed4 color = tex2D(_MainTex, i.texcoord);
				 fixed alpha = tex2D(_Alpha, i.texcoord).r;
				 return fixed4(color.rgb,alpha)* i.color ;
			}
			ENDCG
		}
	}
}

