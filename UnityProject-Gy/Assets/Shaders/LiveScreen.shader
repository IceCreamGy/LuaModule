// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "TopCar/Env/LiveScreen" {
	Properties
	{
		_MainTex("Base", 2D) = ""{}
		_MaskTex("Mask Tex", 2D) = ""{}
		_MaskTexAlpha("Mask Tex Alpa", 2D) = ""{}
        [Enum(Off, 0, On, 1)] _UpsideDown("Upside Down,兼容现有场景,默认上下颠倒", Float) = 0
        [Enum(Off, 0, On, 1)] _SwapRight("Swap Right,左右交换", Float) = 0
        [HideInInspector] _GrabpassUpsideDown("Anti Aliasing开启时，需要上下颠倒", Float) = 0
	}

	CGINCLUDE

	#include "UnityCG.cginc"

	struct v2f
	{
		float4 position : SV_POSITION;
		float2 uv0 : TEXCOORD0;
        float4 uv :TEXCOORD1;
	};

	sampler2D _MainTex;
	sampler2D _MaskTex;
	sampler2D _MaskTexAlpha;
	float4 _MainTex_ST;
    float4 _MainTex_TexelSize;
    float4 _InternelGrabPassTexture_TexelSize;

    //uv颠倒交换配置
    float _SwapRight;
    float _UpsideDown;
    float _GrabpassUpsideDown;

	sampler2D _InternelGrabPassTexture;

	v2f vert(appdata_base v)
	{
		v2f o;
		o.position = UnityObjectToClipPos(v.vertex);
		o.uv0 = TRANSFORM_TEX(v.texcoord, _MainTex);

        fixed2 uv = o.uv0;
        o.uv0.x = uv.x * (1 - _SwapRight) + (1 - uv.x) * _SwapRight;
        o.uv0.y = uv.y * (1 - _UpsideDown) + (1 - uv.y) * _UpsideDown;

		return o;
	}

    float4 frag(v2f i) : COLOR
    {
        fixed2 uv = i.uv0;

#if UNITY_UV_STARTS_AT_TOP
    if (_InternelGrabPassTexture_TexelSize.y < 0)
        uv.y = 1 - uv.y;
#endif
        uv.y = uv.y * (1 - _GrabpassUpsideDown) + (1 - uv.y) * _GrabpassUpsideDown;

        half4 color = tex2D(_InternelGrabPassTexture, uv);
        return color;
        half4 Mask = tex2D(_MaskTexAlpha, uv).r;
        //add
        return half4(color.rgb + tex2D(_MaskTex, uv) * Mask.r, 1);
    }

	ENDCG

	SubShader
	{
		Tags{ "RenderType" = "Opaque" "Queue" = "Transparent-100" }
		LOD 400

		GrabPass
		{
			"_InternelGrabPassTexture"
		}

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			ENDCG
		}
	}
	Fallback "Diffuse"
}
