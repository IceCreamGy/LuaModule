// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Simplified Alpha Blended Particle shader. Differences from regular Alpha Blended Particle one:
// - no Tint color
// - no Smooth particle support
// - no AlphaTest
// - no ColorMask

Shader "TopCar/Particles/AlphaBlended_Shadow" 
{
Properties 
{
	_MainTex ("Particle Texture", 2D) = "white" {}
	_TintColor ("Tint Color",COLOR) = (0.5,0.5,0.5,0.5)
	_ClipValue("ClipValue", Float) = 0
}

Category 
{	
	SubShader
	{
		Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
		LOD 100

		Lighting Off
		ZWrite Off
		//Cull Off
		Blend SrcAlpha OneMinusSrcAlpha

		Pass 
		{
			Fog { Mode Off }
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			
			sampler2D _MainTex;
			fixed4 _MainTex_ST;
			fixed4 _MirrorPosInWorld;
			fixed4 _TintColor;
			fixed _ClipValue;

			struct appdata_t 
			{
				float4 vertex : POSITION;
				fixed4 color :COLOR;
				float2 texcoord : TEXCOORD0;
			};
				   
			struct v2f 
			{
				float4 vertex : SV_POSITION;
				fixed4 color : COLOR;
				half2 texcoord : TEXCOORD0;
			};

			v2f vert (appdata_t v) 
			{
				v2f o; 
				o.vertex = UnityObjectToClipPos(v.vertex);
				
				o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.color = v.color;
				return o;
			}

			half4 frag(v2f i) : COLOR 
			{
				 fixed4 color = tex2D(_MainTex, i.texcoord)  * i.color * _TintColor;
				 return fixed4(color.rgb,color.a*(1-_ClipValue));
			}
			ENDCG
		}
	}
}
}
