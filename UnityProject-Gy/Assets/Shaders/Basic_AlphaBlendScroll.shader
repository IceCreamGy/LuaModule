// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "TopCar/Effect/Basic_AlphaBlendScroll" {
	Properties {
		_TintColor ("Tint Color", COLOR)=(0.5,0.5,0.5,0.5)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_AlphaTex("Alpha(A)",2D) = "white" {}
		_ScrollXspeed("x Scroll Speed",Float) = 2
		_ScrollYspeed("y Scroll Speed",Float) = 2
	}
	SubShader {
		Tags 
		{			
			"Queue" = "Transparent"
			"IgnoreProjector"="True"
			"RenderType"="Transparent" 
			"Reflection" = "RenderReflectionTransparentBlend"
		}
		
		LOD 300
		Lighting Off
		ZWrite Off
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha
		
		
		pass
		{
			Cull Off
			Fog {Mode Off}
			CGPROGRAM			
			#include "AdvCarCommon.cginc"	
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#pragma multi_compile_fwdbase
			#pragma multi_compile _ ENABLE_PARABOLOID
			#pragma multi_compile _ DISABLE_VERTEX_COLOR 

			sampler2D _MainTex;
			sampler2D _AlphaTex;
			half4 _MainTex_ST;
			half4 _TintColor;
		
			half  _ScrollXspeed;
			half  _ScrollYspeed;

			struct appdata 
			{
			    float4 vertex : POSITION;
				half4 color : COLOR;
			    float2 texcoord : TEXCOORD0;
			};
			
			struct VSOut
			{
				float4 pos		: SV_POSITION;
				half4 color	: TEXCOORD0;
				float2 uv		: TEXCOORD1;
			#ifdef ENABLE_PARABOLOID
				half paraboloidHemisphere : TEXCOORD2;
			#endif
				half camDist : TEXCOORD3;
			};
			
			VSOut vert(appdata v)
			{
				VSOut o;
			#ifdef ENABLE_PARABOLOID
				o.pos = mul(UNITY_MATRIX_MV, v.vertex);	
				o.paraboloidHemisphere = o.pos.z;
				o.pos = ParaboloidTransform(o.pos);
				
			#else
				o.pos = UnityObjectToClipPos(v.vertex);
			#endif	
				o.uv.xy = TRANSFORM_TEX(v.texcoord.xy,_MainTex);
				
				half xScrollValue = _ScrollXspeed * _Time.y;	
				half yScrollValue = _ScrollYspeed * _Time.y;
				o.uv.xy += half2(xScrollValue,yScrollValue);
				
				o.camDist  = CalcCamDist(v.vertex);
				#ifdef DISABLE_VERTEX_COLOR
				o.color = _TintColor  * 2.0;
				#else
				o.color = v.color * _TintColor * 2.0;
				#endif
				return o;
			}
			
			half4 frag(VSOut i) : COLOR
			{					
			#ifdef ENABLE_PARABOLOID				
				if (ParaboloidDiscard(i.paraboloidHemisphere))
					discard;
			#endif	
				//return i.color.a;
			
				float2 uv0 = i.uv.xy;	
				half3 diffuseCol = tex2D(_MainTex, uv0);		
				half alpha = tex2D(_AlphaTex,  uv0);
				half4 result = half4(diffuseCol,alpha)  * i.color;
				
				return result;
				//return NssFog(i.camDist, result);
			}

			ENDCG
		} 
	}
	Fallback "QF/Env/Basic_AlphaBlend"
}
