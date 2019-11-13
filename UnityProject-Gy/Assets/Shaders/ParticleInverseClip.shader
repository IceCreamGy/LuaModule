// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "TopCar/ParticleInverseClip"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_ClipU("ClipU",Range(0,1)) = 0
		
	}
	CGINCLUDE
	#include "UnityCG.cginc"

	uniform sampler2D _MainTex;
	uniform half4 _MainTex_ST;

	uniform half _ClipU;
	//uniform half _ClipV;



	struct v2f
	{
		half4 pos : SV_POSITION;
		half2 uv : TEXCOORD0;
		
	};

	v2f vert(appdata_full v)
	{
		v2f o;

		o.pos = UnityObjectToClipPos(v.vertex);
		o.uv = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
		

		return o;
	}

	half4 frag(v2f i) : SV_Target
	{
		half4 color = tex2D(_MainTex,i.uv);
		

		if (1-i.uv.x < _ClipU)
			clip(-1);

		return color;
	}

	ENDCG

	SubShader
	{
		Tags { "RenderType"="Transparent" "Queue" = "Transparent" "IgnoreProjector" = "True"}
		LOD 100

		Pass
		{
			Cull Off
			ZTest Always
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma target 3.0
			ENDCG
			
		}
	}
}
