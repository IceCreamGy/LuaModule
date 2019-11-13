// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "FX/TransparentVertexScaleDisolve" {
	Properties{
		[Enum(UnityEngine.Rendering.BlendMode)] SrcFactor("SrcFactor", Float) = 5
		[Enum(UnityEngine.Rendering.BlendMode)] DstFactor("DstFactor", Float) = 10
		[Enum(UnityEngine.Rendering.BlendOp)] OpColor("OpColor", Float) = 0

		_MainTex("Base (RGB)", 2D) = "white" {}
		_Color("Color", COLOR) = (0.5,0.5,0.5,0.5)
		_ColorMulti("ColorMulti",Float) = 2.0
		_ScaleDirection("ScaleDirection", Vector) = (1,0,0,0)
		_Scale("Scale",float) = 1

		_Bias("Bias",float) = 0
		_TimeOnDuration("ON duration",float) = 0.5
		_TimeOffDuration("OFF duration",float) = 0.5
		_BlinkingTimeOffsScale("Blinking time offset scale (seconds)",float) = 5
		_NoiseAmount("Noise amount (when zero, pulse wave is used)", Range(0,0.5)) = 0

		_ScrollSpeed("Scroll Speed", Float) = 1.0

		_DisolveTex ("DisolveTex (A)", 2D) = "white" {}
		_Disolve ("Disolve", Range(0.0,2.0)) = 0
		_DisolveCutoff ("DisolveCutoff", Range(0.0,1.0)) = 0.5

		_frontAmount("FrontAmount[0,0.05]", Float) = 0.0
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

	half _frontAmount;
	float	_Bias;
	float	_Scale;
	float _TimeOnDuration;
	float	_TimeOffDuration;
	float _BlinkingTimeOffsScale;
	float _NoiseAmount;
	float4 _ScaleDirection;

	float _ScrollSpeed;

	sampler2D _DisolveTex;
	half4 _DisolveTex_ST;
	half _Disolve;
	half _DisolveCutoff;

#pragma vertex vert 
#pragma fragment frag

	struct appdata
	{
		float4 vertex : POSITION;
		half4 color : COLOR;
		float2 texcoord : TEXCOORD0;
		float2 texcoord2 : TEXCOORD1;
	};

	struct VSOut
	{
		float4 pos		: SV_POSITION;
		half4 color	: TEXCOORD0;
		float4 uv		: TEXCOORD1;
		float2 uv2		: TEXCOORD2;
	};

	VSOut vert(appdata v)
	{
		VSOut o;

		float time = _Time.y + _BlinkingTimeOffsScale * v.color.b;
		float fracTime = fmod(time, _TimeOnDuration + _TimeOffDuration);
		float wave = smoothstep(0, _TimeOnDuration * 0.25, fracTime)  * (1 - smoothstep(_TimeOnDuration * 0.75, _TimeOnDuration, fracTime));
		float noiseTime = time *  (6.2831853f / _TimeOnDuration);
		float noise = sin(noiseTime) * (0.5f * cos(noiseTime * 0.6366f + 56.7272f) + 0.5f);
		float noiseWave = _NoiseAmount * noise + (1 - _NoiseAmount);

		wave = _NoiseAmount < 0.01f ? wave : noiseWave;
		wave += _Bias;

		//o.color = _Color;
		o.color = _Color ;
		o.color.rgb *= _ColorMulti;
		//o.color.a = v.color.a;
		o.uv.xy = TRANSFORM_TEX(v.texcoord.xy, _MainTex);
		o.uv.zw = TRANSFORM_TEX(v.texcoord.xy,_DisolveTex);

		o.uv.y += frac(_ScrollSpeed * _Time);
		
		o.uv2.xy = TRANSFORM_TEX(v.texcoord2.xy, _MainTex);
		//o.pos = mul(UNITY_MATRIX_MVP, v.vertex + wave * _Scale *  _ScaleDirection  * v.color.r);
		o.pos = UnityObjectToClipPos(v.vertex + wave * _Scale *  _ScaleDirection  * o.uv2.x);
		o.pos.z -= _frontAmount;
		return o;
	}

	half4 frag(VSOut i) : COLOR
	{
		half4 col;
		//half3 diffuseCol = tex2D(_MainTex, i.uv.xy).rgb * i.color.rgb;
		half3 diffuseCol =  tex2D(_MainTex, i.uv.xy).rgb * i.color.rgb;
		//half3 diffuseCol = tex2D(_MainTex, i.uv.xy).rgb ;
		//half3 diffuseCol = tex2D(_MainTex, i.uv.xy).rgb;
		half alpha =  tex2D(_MainTex, i.uv.xy).r * i.color.a;


		half dislove = saturate(_Disolve - tex2D(_DisolveTex, i.uv.zw).r);
		diffuseCol *= (1.0 - dislove);
		alpha -= dislove;
		alpha = (alpha < _DisolveCutoff) ? 0.0 : alpha;
		col.a = alpha;
		//col.a = 1;

		col.rgb = diffuseCol;
		//col.rgb = i.color;

		//return col;
		return col;
	}

		ENDCG
	}
	}
	Fallback "QF/Env/0_Low/Basic_AlphaBlend_Low"
}
