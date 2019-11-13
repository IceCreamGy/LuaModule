// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "TopCar/ClipRectShader"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
	/*_ClipU_Min("ClipU_Min",Range(0,1)) = 0
	_ClipU_Max("ClipU_Max",Range(0,1)) = 0

	_ClipV_Min("ClipV_Min",Range(0,1)) = 0
	_ClipV_Max("ClipV_Max",Range(0,1)) = 0*/

	_Clip1("Clip1",	Vector) = (0,0,0,0)
	_Clip2("Clip2",	Vector) = (0,0,0,0)
	_Color_A("Color_A",Range(0,1)) = 0

	}
		CGINCLUDE
#include "UnityCG.cginc"

		uniform sampler2D _MainTex;
	uniform half4 _MainTex_ST;

	/*uniform half _ClipU_Min;
	uniform half _ClipU_Max;

	uniform half _ClipV_Min;
	uniform half _ClipV_Max;*/
	uniform half _Color_A;

	uniform fixed4   _Clip1;
	uniform fixed4   _Clip2;


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


		/*	if (i.uv.x > _ClipU_Min&&i.uv.x < _ClipU_Max&&i.uv.y > _ClipV_Min&&i.uv.y < _ClipV_Max)
				clip(-1);*/

			if (i.uv.x > _Clip1.x&&i.uv.x < _Clip1.y&&i.uv.y > _Clip1.z&&i.uv.y < _Clip1.w)
				clip(-1);
			if (i.uv.x > _Clip2.x&&i.uv.x < _Clip2.y&&i.uv.y > _Clip2.z&&i.uv.y < _Clip2.w)
				clip(-1);

			return half4(color.xyz, _Color_A);
	}

		ENDCG

		SubShader
	{
		Tags{ "RenderType" = "Transparent" "Queue" = "Transparent" "IgnoreProjector" = "True" }
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
