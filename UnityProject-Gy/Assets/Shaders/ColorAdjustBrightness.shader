Shader "TopCar/Env/ColorAdustBrightness"
{
	Properties
	{
		_Color("Diffuse Material Color (RGB)", Color) = (1,1,1,1)
		_MainTex ("Texture", 2D) = "white" {}
		_Brightness("Brightness", Float) = 1
		_Contrast("Contrast", Float) = 1
	}

	


	SubShader
	{
		// No culling or depth
		
		Fog { Mode off }

		// 0
		Pass
		{
			Cull Off ZWrite Off ZTest Off
			CGPROGRAM
			
			#pragma vertex vert_img
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;
		uniform half _Brightness;
		uniform half4 _MainTex_TexelSize;
		uniform fixed4 _Color;

			fixed4 frag (v2f_img i) : SV_Target
			{
				fixed4 renderTex = tex2D(_MainTex, i.uv);

				//brigtness亮度直接乘以一个系数，也就是RGB整体缩放，调整亮度
				fixed3 finalColor = renderTex * _Brightness;
				return fixed4(finalColor, renderTex.a);
			}
			ENDCG
		}
	}
	Fallback "Mobile/Diffuse"
}
