// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "TopCar/FX/TransparentVertexDisolve" {
	Properties{
		[Enum(UnityEngine.Rendering.BlendMode)] SrcFactor("SrcFactor", Float) = 5
		[Enum(UnityEngine.Rendering.BlendMode)] DstFactor("DstFactor", Float) = 10
		[Enum(UnityEngine.Rendering.BlendOp)] OpColor("OpColor", Float) = 0

		_MainTex("Base (RGB)", 2D) = "white" {}
		_Color("Color", COLOR) = (0.5,0.5,0.5,0.5)
		_ColorMulti("ColorMulti",Float) = 2.0
		
		_ScrollSpeed("Scroll Speed", Float) = 1.0

		_DisolveTex ("DisolveTex (A)", 2D) = "white" {}
		_Disolve ("Disolve", Range(0.0,2.0)) = 0
	}
		SubShader
	{

		Tags{ "Queue" = "Transparent" }
		// draw after all opaque geometry has been drawn
		Pass{
		ZWrite Off
		Lighting Off
		ZWrite Off
		Cull Off
		Blend[SrcFactor][DstFactor]
		BlendOp[OpColor]

		CGPROGRAM
#include "UnityCG.cginc"

	half4 _Color;
	half _ColorMulti;
	sampler2D _MainTex;
	half4 _MainTex_ST;

	float _ScrollSpeed;

	sampler2D _DisolveTex;
	half4 _DisolveTex_ST;

#pragma vertex vert 
#pragma fragment frag

	struct appdata
	{
		float4 vertex : POSITION;
		half4 color : COLOR;
		float2 texcoord : TEXCOORD0;
	};

	struct VSOut
	{
		float4 pos		: SV_POSITION;
		half4 color	: TEXCOORD0;
		float4 uv		: TEXCOORD1;
	};

	VSOut vert(appdata v)
	{
		VSOut o;

		o.color = _Color ;
		o.color.rgb *= _ColorMulti;
		o.uv.xy = TRANSFORM_TEX(v.texcoord.xy, _MainTex);
		o.uv.zw = TRANSFORM_TEX(v.texcoord.xy,_DisolveTex);
		o.uv.y += frac(_ScrollSpeed * _Time);
		
		o.pos = UnityObjectToClipPos(v.vertex);
		return o;
	}

	half4 frag(VSOut i) : COLOR
	{
		half4 col;
		half3 diffuseCol =  tex2D(_MainTex, i.uv.xy).rgb;
		half alpha = diffuseCol.r * i.color.a;
		diffuseCol *= i.color.rgb;

		half dislove = tex2D(_DisolveTex, i.uv.zw).r;
		diffuseCol *= dislove;
		alpha -= (1 - dislove);
		col.a = clamp(alpha, 0, 1);

		col.rgb = diffuseCol;

		return col;
	}

		ENDCG
	}
	}
	Fallback "Mobile/Diffuse"
}
