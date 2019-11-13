// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Hidden/Image/AlphaBlend" 
{
	Properties
	{
		_MainTex("Base (RGB)", 2D) = "white" {}
		_Alpha("Alpha", 2D) = "white" {}
	}
	
	CGINCLUDE
	#include "UnityCG.cginc"
	sampler2D _MainTex;
	sampler2D _Alpha;
	fixed4 _MainTex_ST;

	struct appdata_t
	{
		fixed4 vertex : POSITION;
		fixed2 uv : TEXCOORD0;
	};

	struct v2f
	{
		float4 vertex : SV_POSITION;
		half2 uv : TEXCOORD0;
	};

	v2f vert(appdata_t v)
	{
		v2f o;
		o.vertex = UnityObjectToClipPos(v.vertex);
		o.uv = TRANSFORM_TEX(v.uv, _MainTex);
		return o;
	}

	half4 alphaBlend(v2f i) : COLOR
	{
		fixed3 color = tex2D(_MainTex, i.uv);
		fixed alpha = tex2D(_Alpha, i.uv).a;
		return fixed4(color,alpha);
	}

	half4 alphaBlendMax(v2f i) : COLOR
	{
		half4 color = tex2D(_MainTex, i.uv);
		fixed alpha = max(tex2D(_Alpha, i.uv).a, color.a);
		//恢复alpha
		alpha = sqrt(alpha);
		//恢复颜色
		fixed scale = max(alpha, step(alpha, 0.0001)) + 0.001;
		color.rgb = clamp(color.rgb / scale, 0, 1);
		return fixed4(color.rgb, alpha);
	}
	ENDCG

	SubShader {
		Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
		LOD 100

		Lighting Off
		ZWrite Off
		Cull Off
		Blend One Zero

		//0
		Pass {
			Fog { Mode Off }
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment alphaBlend
			
			ENDCG
		}

		//1
		Pass{
			Fog{ Mode Off }
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment alphaBlendMax

			ENDCG
		}
	}
}

