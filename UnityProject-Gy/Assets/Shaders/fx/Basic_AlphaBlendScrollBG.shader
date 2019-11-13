// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "QF/Env/Transparent/Basic_AlphaBlendScrollBG" {
	Properties {
		_TintColor ("Tint Color", COLOR)=(0.5,0.5,0.5,0.5)
		_BackGroundTex ("BackGround (RGB)", 2D) = "white" {}
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_AlphaTex("Alpha(A)",2D) = "white" {}
		_ScrollXspeed("x Scroll Speed",Float) = 2
		_ScrollYspeed("y Scroll Speed",Float) = 2
		_frontAmount("FrontAmount[0,0.05]", Float) = 0.005
	}
	SubShader {
		Tags 
		{			
			"Queue" = "Transparent"
			"IgnoreProjector"="True"
			"RenderType"="Transparent" 
			"Reflection" = "RenderReflectionTransparentBlend"
		}
		
		LOD 10
		Lighting Off
		ZWrite Off
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha
		
		
		pass
		{
			 
			Fog {Mode Off}
			CGPROGRAM			
			#include "../AdvCarCommon.cginc"	
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			//#pragma multi_compile_fwdbase
		//#pragma multi_compile _ ENABLE_PARABOLOID
			#pragma multi_compile _ DISABLE_VERTEX_COLOR 

			sampler2D _BackGroundTex;
			sampler2D _MainTex;
			sampler2D _AlphaTex;
			half4 _BackGroundTex_ST;
			half4 _MainTex_ST;
			half4 _TintColor;
		
			half  _ScrollXspeed;
			half  _ScrollYspeed;
			
			half _frontAmount;

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
				float4 uv		: TEXCOORD1;
		//	#ifdef ENABLE_PARABOLOID
		//		half paraboloidHemisphere : TEXCOORD2;
		//	#endif
				half3 camDist : TEXCOORD3;
			};
			
			VSOut vert(appdata v)
			{
				VSOut o;
		//	#ifdef ENABLE_PARABOLOID
		//		o.pos = mul(UNITY_MATRIX_MV, v.vertex);	
				
		//		o.pos = ParaboloidTransform(o.pos);
		//		o.paraboloidHemisphere = o.pos.z;
		//	#else
				o.pos = UnityObjectToClipPos(v.vertex);
				o.pos.z -= _frontAmount;
		//	#endif	
				o.uv.xy =  TRANSFORM_TEX(v.texcoord.xy,_BackGroundTex);
				o.uv.zw =  TRANSFORM_TEX(v.texcoord.xy,_MainTex);
				
				float xScrollValue = _ScrollXspeed * _Time.y;	
				float yScrollValue = _ScrollYspeed * _Time.y;
				o.uv.zw += float2(xScrollValue,yScrollValue);
				
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
		//	#ifdef ENABLE_PARABOLOID				
		//		if (ParaboloidDiscard(i.paraboloidHemisphere))
		//			discard;
		//	#endif	
			
				float2 uv0 = i.uv.xy;	
				float2 uv1 = i.uv.zw;
				
				half3 backGroundColor = tex2D(_BackGroundTex, uv0);	
				half3 diffuseCol = tex2D(_MainTex, uv1);	
				half alpha = tex2D(_AlphaTex,  uv1);
				
			 
				half4 result = half4(diffuseCol + backGroundColor,alpha)  * i.color ;
				
				return result;
				//return NssFog(i.camDist, result);
			}

			ENDCG
		} 
	}
	Fallback "QF/Env/0_Low/Basic_AlphaBlend_Low"
}
