// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "TopCar/Env/CameraRadialBlur"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_Level("Level",Range(1,100)) = 11
		_CenterX("Center.x",Range(0,1)) = 0.5
		_CenterY("Center.y",Range(0,1)) = 0.5
		//_XStrength("X Strength",Range(0,1)) = 1.0
		//_YStrength("Y Strength",Range(0,1)) = 1.0
		//_SampleStrength("Sample Strength",Range(0,1)) = 1
		_OrgTex("Texture", 2D) = "white" {}
		_MaskTex("Mask", 2D) = "white" {}
		_ExcludeBlurMask("ExcludeBlurMask", 2D) = "white" {}
		//_BlurStep("Blur Step",Range(0.001, 0.01)) = 0.01
	}
	SubShader
	{
		Tags{ "RenderType" = "Opaque" }

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			#pragma multi_compile __ ENABLE_MOTION_CULL

			#include "UnityCG.cginc"

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

			sampler2D _MainTex;
			sampler2D _OrgTex;
			sampler2D _MaskTex;
			sampler2D _ExcludeBlurMask;

			float4 _MainTex_ST;
			float4 _MainTex_TexelSize;
			float4 _OrgTex_TexelSize;
			float4 _MaskTex_TexelSize;
			int _Level;
			fixed _CenterX;
			fixed _CenterY;
			//fixed _XStrength;
			//fixed _YStrength;
			//float _SampleStrength;
			//float _BlurStep;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				//设置径向模糊的中心位置，一般来说都是图片重心（0.5，0.5）
				fixed2 center = fixed2(_CenterX,_CenterY);

				//计算像素与中心点的距离，距离越远偏移越大
				fixed2 uv = i.uv - center;
				half3 col1 = fixed3(0,0,0);

				fixed2 orgUV = i.uv;
				fixed2 maskUV = i.uv;
#if UNITY_UV_STARTS_AT_TOP
				if (_OrgTex_TexelSize.y < 0)
					orgUV.y = 1 - orgUV.y;
				if (_MaskTex_TexelSize.y < 0)
					maskUV.y = 1 - maskUV.y;
#endif
				half exclude = tex2D(_ExcludeBlurMask, maskUV).r;
				half sumCount = 0;
				fixed4 col = fixed4(0, 0, 0, 1);
				fixed2 maskOffsetUV = maskUV - center;
				for (fixed j = 0; j < _Level; j++) //_Level不能变量，也不能嵌套if判断，所以车辆在后面单独做剔除
				{
#if ENABLE_MOTION_CULL
					exclude = 1 - tex2D(_ExcludeBlurMask, maskOffsetUV*(1 - 0.01*j) + center).r;
#else
					exclude = 1.0;
#endif
					//根据设置的level对像素进行叠加，然后求平均值
					col1 += tex2D(_MainTex, uv*(1 - 0.01*j) + center).rgb * exclude;
					sumCount += exclude;
				}
				sumCount = max(1, sumCount);
				col = fixed4(col1.rgb / sumCount, 1);
				fixed4 mainCol = tex2D(_OrgTex, orgUV);
				fixed weight = tex2D(_MaskTex, maskUV).r;
#if ENABLE_MOTION_CULL
				exclude = tex2D(_ExcludeBlurMask, maskUV).r;
				weight *= (1 - exclude);
#endif
				col = col * weight + (1 - weight) * mainCol;
				return col;
			}
			ENDCG
		}
	}
	// The definition of a fallback shader should be commented out 
	// during development:
	Fallback "Diffuse"
}
