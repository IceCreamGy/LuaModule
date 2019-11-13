// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "TopCar/Env/Basic_AlphaBlend_Fade" {
	Properties {		
		_TintColor ("Tint Color", COLOR)=(0.5,0.5,0.5,0.5)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_AlphaTex("Alpha(A)",2D) = "white" {}
		_fadeStrength("Fade Strength", Range(0,50)) = 2.0
		
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
						
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#include "AdvCarCommon.cginc"	
			//#pragma multi_compile_fwdbase
		//	#pragma multi_compile _ ENABLE_PARABOLOID
			#pragma multi_compile _ DISABLE_VERTEX_COLOR 

			sampler2D _MainTex;
			sampler2D _AlphaTex;
			half4 _MainTex_ST;
			half4 _TintColor;
			half _fadeStrength;
			 
			
			struct appdata 
			{
				half4 color : COLOR;
			    float4 vertex : POSITION;
			    half3 normal : NORMAL;
			    float4 texcoord : TEXCOORD0;
			};
			
			struct VSOut
			{
				float4 pos		: SV_POSITION;
				float2 uv		: TEXCOORD0;
				half  alpha	: TEXCOORD1;
				half4 color	: TEXCOORD2;
		//	#ifdef ENABLE_PARABOLOID
		//		half paraboloidHemisphere : TEXCOORD3;
		//	#endif
			};
			
			VSOut vert(appdata v)
			{
				VSOut o;
							
			//#ifdef ENABLE_PARABOLOID
		//		o.pos = mul(UNITY_MATRIX_MV, v.vertex);	
		//		o.paraboloidHemisphere = o.pos.z;
		//		o.pos = ParaboloidTransform(o.pos);
				 
		//	#else
				o.pos = UnityObjectToClipPos(v.vertex);
		//	#endif	
				
				float3x3 worldMatrix3 = (float3x3)unity_ObjectToWorld;
				half3 normalW = normalize(mul(worldMatrix3, v.normal.xyz));												
				half3 posW = mul(unity_ObjectToWorld, v.vertex).xyz;
				half3 dirW = normalize(posW - _WorldSpaceCameraPos);
					
				o.uv.xy = TRANSFORM_TEX(v.texcoord.xy,_MainTex);
				half dotabs = abs(dot(normalW, dirW));
				o.alpha = pow(max(0.001, dotabs), _fadeStrength + 0.01);
				//o.alpha = tmp;
				//o.alpha = NssPow(dotabs, _fadeStrength);
				//o.alpha = pow(dotabs, _fadeStrength + 0.01);
			
			
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
				half3 diffuseCol = tex2D(_MainTex, uv0);		
				half alpha = tex2D(_AlphaTex,  uv0);
				half4 result = half4(diffuseCol,alpha *  i.alpha)  * i.color;
				
				return result;
			}		
		
			ENDCG
		} 
	}
	Fallback "QF/Env/0_Low/Basic_AlphaBlend_Low"
}
