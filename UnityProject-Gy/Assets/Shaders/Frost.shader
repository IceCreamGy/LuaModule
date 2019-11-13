
Shader "TopCar/Image Effect/Frost"
{
	Properties
	{
		_MainTex("Frost Mask (RGB)", 2D) = "white" {}
		_TintColor("Color (RGB)", Color) = (1, 1, 1, 1)
		_FrostTex("Frost Texture (RGB))", 2D) = "white" {}
		_FrostCenterTex("Frost Center Mask (RGB))", 2D) = "white" {}
	}

	SubShader
	{
		Tags{ "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
		LOD 100

		Pass
		{
			ZTest Always Cull Off ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha
			Fog{ Mode off }

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest 
			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;
			uniform sampler2D _FrostTex;
			uniform sampler2D _FrostCenterTex;
			uniform float4 _TintColor;
			float4 _FrostTex_TexelSize;
			float4 _FrostTex_ST;
			float4 _FrostCenterTex_TexelSize;
			float4 _FrostCenterTex_ST;

			struct appdata_t
			{
				float4 vertex : POSITION;
				fixed4 color : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				half2 uv : TEXCOORD0;
				fixed4 color : COLOR;
				float4 srcPos : TEXCOORD2;
			};

			v2f vert(appdata_t v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.srcPos = ComputeScreenPos(o.pos);
				o.uv = v.texcoord;
				o.color = v.color;
				return o;
			}

			float4 frag(v2f i) : COLOR
			{
				float2 uv = i.uv;
				float4 mainCol = tex2D(_MainTex, uv);
				float4 centerCol = tex2D(_FrostCenterTex, uv);
				fixed2 screenUV = i.srcPos.xy / i.srcPos.w;
//不需要区分是否上下颠倒
//#if UNITY_UV_STARTS_AT_TOP
//				if (_FrostTex_TexelSize.y < 0)
//					screenUV.y = 1 - screenUV.y;
//#endif
				screenUV = TRANSFORM_TEX(screenUV, _FrostTex);
				float4 frostCol = tex2D(_FrostTex, screenUV);
				fixed4 finalCol = frostCol * _TintColor  * i.color;
				float centerA = centerCol.a * 0.4 * pow(i.color.a, 3);
				centerCol.rgb = centerCol.rgb * centerA * frostCol;
				finalCol.rgb = finalCol.rgb + centerCol.rgb;
				float outA = 1;
				finalCol.a *= mainCol.r * (outA + min(centerCol.r, 0.8));
				return finalCol;
			}
			ENDCG
		}
	}
		Fallback off
}