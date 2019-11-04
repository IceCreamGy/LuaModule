// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "TopCar/Particles/UV_Offset_Mask" {
	Properties {
		_Color ("Color", Color) = (1.0,1.0,1.0,1.0)
		_MainTex("Base (RGB)", 2D) = "white" {}
		_AlphaTex("Alpha (A)", 2D) = "white" {}
		_U("U", float) = 0.0
		_V("V", float) = 0.0
		_Brightness ("Brightness", float) = 1.0
        ///-----------------------------------------
        //     Disable culling.
        //    Off = 0,
        //     Cull front-facing geometry.
        //    Front = 1,
        //     Cull back-facing geometry.
        //    Back = 2
        ///-----------------------------------------
        [Enum(UnityEngine.Rendering.CullMode)] _Cull("Cull", int) = 2
        [Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend("Src Blend Mode", Float) = 5
        [Enum(UnityEngine.Rendering.BlendMode)] _DstBlend("Dst Blend Mode", Float) = 10
	}
	
	SubShader {
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
		Blend SrcAlpha OneMinusSrcAlpha
		Lighting Off
		ZWrite Off
		Fog { Mode Off }
		LOD 100
        Cull[_Cull]
        Blend[_SrcBlend][_DstBlend]

		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			sampler2D _AlphaTex;
			float4 _MainTex_ST;
			float4 _AlphaTex_ST;
			float _U;
			float _V;
			fixed4 _Color;
			fixed _Brightness;

			struct appdata_t
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				fixed4 color : COLOR;
			};
			
			struct v2f
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float2 uv2 : TEXCOORD1;
				fixed4 color : COLOR;
			};

			v2f vert (appdata_t v) {
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);

				float2 offset = float2(_U, _V);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex) + offset;
				o.uv2 = TRANSFORM_TEX(v.texcoord, _AlphaTex);

				o.color = v.color * _Color;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 texcol = tex2D(_MainTex, i.uv) * i.color * _Brightness;
				texcol.a *= tex2D(_AlphaTex, i.uv2).r;

				return texcol;
			}
			ENDCG
		}
	}
	Fallback "QF/Env/0_Low/Basic_AlphaBlend_Low"
}
