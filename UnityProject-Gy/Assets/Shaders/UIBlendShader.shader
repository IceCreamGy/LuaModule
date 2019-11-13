// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/UIBlendShader"
{
	Properties
	{
		_UpColor("UpColor", Color) = (1,1,1,1)
		_DownColor("DownColor", Color) = (0,0,0,1)

		//此shader被RawImage使用,RawImage : MaskableGraphic,需要下面属性,否则不能被裁剪
		_StencilComp("Stencil Comparison", Float) = 8
		_Stencil("Stencil ID", Float) = 0
		_StencilOp("Stencil Operation", Float) = 0
		_StencilWriteMask("Stencil Write Mask", Float) = 255
		_StencilReadMask("Stencil Read Mask", Float) = 255

		_ColorMask("Color Mask", Float) = 15
	}
	SubShader
	{
		Tags{ "Queue" = "Transparent"}

		Stencil
		{
			Ref[_Stencil]
			Comp[_StencilComp]
			Pass[_StencilOp]
			ReadMask[_StencilReadMask]
			WriteMask[_StencilWriteMask]
		}

		Cull Off 
		ZWrite Off 
		ZTest[unity_GUIZTestMode]
		Blend SrcAlpha OneMinusSrcAlpha
		ColorMask[_ColorMask]
		
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			#pragma multi_compile_fwdbase
			#pragma multi_compile USESUBCOLOR_OFF USESUBCOLOR_ON

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

			fixed4 _UpColor;
			fixed4 _DownColor;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 col = _DownColor;
#ifdef USESUBCOLOR_ON
				col = lerp(_DownColor, _UpColor, pow(i.uv.y, 2.2));
#endif
				return col;		
			}
			ENDCG
		}
	}
}
