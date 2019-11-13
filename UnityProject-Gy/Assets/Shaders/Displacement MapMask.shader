// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "TopCar/FX/Displacement Map Mask" {
Properties {
	_TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
	_NoiseTex ("Distort Texture (RG)", 2D) = "white" {}
	_MainTex ("Alpha (A)", 2D) = "white" {}
	_MaskTex ("Mask Texture", 2D) = "white" {}
	_HeatTime  ("Heat Time", range (-1,1)) = 0
	_ForceX  ("Strength X", range (0,1)) = 0.1
	_ForceY  ("Strength Y", range (0,1)) = 0.1
	_FillAmount ("Fill Amount", range(0,1)) = 1.0
}

Category {
	Tags { "Queue"="Transparent" "RenderType"="Transparent" }
	Blend SrcAlpha One
	//Cull Back
	Cull Off
	Lighting Off ZWrite Off Fog { Color (0,0,0,0) }
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
	float2 uvmask : TEXCOORD2;
};

fixed4 _TintColor;
fixed _ForceX;
fixed _ForceY;
fixed _HeatTime;
float4 _MainTex_ST;
float4 _MaskTex_ST;
float4 _NoiseTex_ST;
fixed _FillAmount;
sampler2D _NoiseTex;
sampler2D _MainTex;
sampler2D _MaskTex;
float4 _MaskTex_TexelSize;

v2f vert (appdata_t v)
{
	v2f o;
	o.vertex = UnityObjectToClipPos(v.vertex);
	o.color = v.color;
	o.uvmain = TRANSFORM_TEX( v.texcoord, _MainTex );
	o.uvmask = TRANSFORM_TEX( v.texcoord, _MaskTex);
	return o;
}

fixed4 frag( v2f i ) : COLOR
{
	fixed alpha = tex2D(_MaskTex, i.uvmask).a;
	//noise effect
	fixed4 offsetColor1 = tex2D(_NoiseTex, i.uvmain + _Time.xz*_HeatTime);
	fixed4 offsetColor2 = tex2D(_NoiseTex, i.uvmain + _Time.yx*_HeatTime);
	i.uvmain.x += ((offsetColor1.r + offsetColor2.r) - 1) * _ForceX;
	i.uvmain.y += ((offsetColor1.r + offsetColor2.r) - 1) * _ForceY;

#if UNITY_UV_STARTS_AT_TOP
	if (_MaskTex_TexelSize.y < 0)
	{
		i.uvmask.y = 1 - i.uvmask.y;
	}
#endif

	alpha = alpha * step(i.uvmask.x, _FillAmount);
	return 2.0f * i.color * _TintColor * tex2D( _MainTex, i.uvmain) * alpha;
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
