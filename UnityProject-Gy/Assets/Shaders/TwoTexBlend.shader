// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "TopCar/FX/Two Texture Blend" {
Properties {
	_TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
	_MainTex ("Main Texture", 2D) = "white" {}
	_SecondTex ("Second Texture", 2D) = "white" {}
	_BlendPercent("Blend Percent", range(0,1)) = 0
}

Category {
	Tags { "Queue"="Transparent" "RenderType"="Transparent" }
	Blend SrcAlpha OneMinusSrcAlpha
	Cull Off Lighting Off ZWrite Off Fog { Color (0,0,0,0) }
	BindChannels {
		Bind "Color", color
		Bind "Vertex", vertex
		Bind "TexCoord", texcoord
	}

	SubShader {
		//Stencil{
		//	Ref 1
		//	Comp equal
		//}
		Pass {
CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma fragmentoption ARB_precision_hint_fastest
#pragma multi_compile_particles
#include "UnityCG.cginc"

struct appdata_t {
	float4 vertex : POSITION;
	fixed4 color : COLOR;
	float2 texcoord: TEXCOORD0;
};

struct v2f {
	float4 vertex : POSITION;
	fixed4 color : COLOR;
	float2 uvmain : TEXCOORD1;
	float2 uvsecond : TEXCOORD2;
};

fixed4 _TintColor;
float4 _MainTex_ST;
float4 _SecondTex_ST;
float _BlendPercent;
sampler2D _MainTex;
sampler2D _SecondTex;

v2f vert (appdata_t v)
{
	v2f o;
	o.vertex = UnityObjectToClipPos(v.vertex);
	o.color = v.color;
	o.uvmain = TRANSFORM_TEX( v.texcoord, _MainTex );
	o.uvsecond = TRANSFORM_TEX( v.texcoord, _SecondTex);
	return o;
}

fixed4 frag( v2f i ) : COLOR
{
	fixed4 finalColor = lerp(tex2D(_SecondTex, i.uvsecond), tex2D(_MainTex, i.uvmain), _BlendPercent);
	return i.color * _TintColor * finalColor;
}
ENDCG
		}
}
	// ------------------------------------------------------------------
	// Fallback for older cards and Unity non-Pro
	
	SubShader {
		Blend DstColor Zero
		Pass {
			Name "BASE"
			SetTexture [_MainTex] {	combine texture }
		}
	}
}
}
