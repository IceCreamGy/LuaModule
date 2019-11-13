Shader "TopCar/Image Effect/MinNitrogenSign"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
	_Point("_Point", Range(0, 1)) = 0.3
		_Width("_Width", Range(0, 1)) = 0.1
	}
		SubShader
	{
		Tags{ "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }

		Pass
	{
		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha
		CGPROGRAM
#pragma vertex vert
#pragma fragment frag

#include "UnityCG.cginc"

		sampler2D _MainTex;
	float4 _MainTex_ST;
	float _Point;
	float _Width;

	struct appdata
	{
		float4 vertex : POSITION;
		float2 uv : TEXCOORD0;
	};

	struct v2f
	{
		float2 uv : TEXCOORD0;
		float4 vertex : SV_POSITION;
	};


	v2f vert(appdata v)
	{
		v2f o;
		o.vertex = UnityObjectToClipPos(v.vertex);
		o.uv = TRANSFORM_TEX(v.uv, _MainTex);
		return o;
	}

	fixed4 frag(v2f i) : SV_Target
	{
		// sample the texture
		fixed4 col = tex2D(_MainTex, i.uv);
	clip(-(i.uv.x - _Point));
	clip(i.uv.x - (_Point - _Width));
	return col;
	}
		ENDCG
	}
	}
}
