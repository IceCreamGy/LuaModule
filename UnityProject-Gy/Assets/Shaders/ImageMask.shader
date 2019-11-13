// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "TopCar/Image Effect/ImageMask" {
Properties {
	_TintColor ("Tint Color", Color) = (1,1,1,1)
	_MainTex ("Image Texture", 2D) = "white" {}
	_MaskTex ("Mask Texture", 2D) = "white" {}
	[Toggle(FLIP_X)] _FlipX("Flip X", Float) = 0
}

Category {
	Tags { "Queue"="Transparent" "RenderType"="Transparent" }
	Blend SrcAlpha OneMinusSrcAlpha
	Lighting Off
	ZWrite Off
	BindChannels {
		Bind "Color", color
		Bind "Vertex", vertex
		Bind "TexCoord", texcoord
	}

	SubShader {
		Pass {
CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma fragmentoption ARB_precision_hint_fastest
#pragma multi_compile_particles
#pragma multi_compile __ FLIP_X
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
float4 _MainTex_ST;
float4 _MaskTex_ST;
sampler2D _MainTex;
sampler2D _MaskTex;

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
	fixed2 uv = i.uvmain;
#ifdef FLIP_X
	uv.x = 1 - uv.x;
#endif
	return _TintColor * tex2D( _MainTex, uv) * tex2D(_MaskTex, i.uvmask).a;
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
