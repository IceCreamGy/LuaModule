Shader "TopCar/Env/ColorAdustment"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Brightness("Brightness", Float) = 1
		_Saturation("Saturation", Float) = 1
		_Contrast("Contrast", Float) = 1
		_BlendTex("Texture", 2D) = "white" {}
	}

	CGINCLUDE
	#include "UnityCG.cginc"

	uniform sampler2D _MainTex;
	uniform sampler2D _BlendTex;
	uniform half _Brightness;
	uniform half _Saturation;
	uniform half _Contrast;
	uniform half4 _MainTex_TexelSize;
	ENDCG

	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Off
		Fog { Mode off }

		// 0
		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest

			fixed4 frag (v2f_img i) : SV_Target
			{
				fixed4 renderTex = tex2D(_MainTex, i.uv);

				//brigtness亮度直接乘以一个系数，也就是RGB整体缩放，调整亮度
				fixed3 finalColor = renderTex * _Brightness;
				return fixed4(finalColor, renderTex.a);
			}
			ENDCG
		}
		// 1
		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest

			fixed4 frag(v2f_img i) : SV_Target
			{
				fixed4 mainTex = tex2D(_MainTex, i.uv);
				fixed2 uv = i.uv;

#if UNITY_UV_STARTS_AT_TOP
				if (_MainTex_TexelSize.y < 0)
					uv.y = 1 - uv.y;
#endif

				fixed4 blendTex = tex2D(_BlendTex, uv);

				//brigtness亮度直接乘以一个系数，也就是RGB整体缩放，调整亮度
				fixed3 finalColor = blendTex * _Brightness;
				fixed3 I = fixed3(1.0, 1.0, 1.0);
				finalColor = I - (I - mainTex) * (I - finalColor);
				return fixed4(finalColor, mainTex.a);
			}
			ENDCG
		}
		// 2
		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest

			fixed4 frag(v2f_img i) : SV_Target
			{
				fixed4 renderTex = tex2D(_MainTex, i.uv);

				//brigtness亮度直接乘以一个系数，也就是RGB整体缩放，调整亮度
				fixed3 finalColor = renderTex * _Brightness;
				//saturation饱和度：首先根据公式计算同等亮度情况下饱和度最低的值：  
				fixed gray = 0.2125 * renderTex.r + 0.7154 * renderTex.g + 0.0721 * renderTex.b;
				fixed3 grayColor = fixed3(gray, gray, gray);
				//根据Saturation在饱和度最低的图像和原图之间差值  
				finalColor = lerp(grayColor, finalColor, _Saturation);
				//contrast对比度：首先计算对比度最低的值
				fixed3 avgColor = fixed3(0.5, 0.5, 0.5);
				//根据Contrast在对比度最低的图像和原图之间差值  
				finalColor = lerp(avgColor, finalColor, _Contrast);
				//返回结果，alpha通道不变
				return fixed4(finalColor, renderTex.a);
			}
			ENDCG
		}
	}
	Fallback off
}
