// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "AdvCarShading/AspTrack/Cloud" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_DiffuseAlpha ("Diffuse Alpha", 2D) = "white" {}
		_SmokeMap ("Smoke Map (RGB)", 2D) = "white" {}
		_TintColor("Tint Color (RGB)", Vector) = (1.0, 1.0, 1.0, 1.0)
		_Speed("Speed (XY)", Vector) = (0.0, 0.0, 0.0, 0.0)
		_AlphaScale("Alpha Scale", Float) = 1.0
	}
	SubShader {
		Tags { 
			"Queue" = "Transparent"
			"RenderType"="Transparent" 
			"LightMode"="ForwardBase"
			"Reflection" = "RenderReflectionTransparentBlend"
		}
		
		Blend SrcAlpha OneMinusSrcAlpha
		ZWrite Off
		
		pass
		{
			CGPROGRAM			
			#include "AdvCarCommon.cginc"
			#pragma target 3.0
			#pragma vertex vert
			#pragma fragment frag
			#pragma exclude_renderers xbox360 flash	
			#pragma multi_compile _ ENABLE_PARABOLOID

			sampler2D _MainTex;
			sampler2D _DiffuseAlpha;
			sampler2D _SmokeMap;
			half4 _SmokeMap_ST;
			half3 _TintColor;
			half2 _Speed;
			half _AlphaScale;
			
			struct appdata 
			{
			    half4 vertex : POSITION;
			    half3 normal : NORMAL;
			    half4 texcoord : TEXCOORD0;
			};
			
			struct VSOut
			{
				half4 pos		: SV_POSITION;
				half2 uv		: TEXCOORD0;
				half2 uvMov	: TEXCOORD1;
				half3 TintColor: TEXCOORD2;
			#ifdef ENABLE_PARABOLOID
				half paraboloidHemisphere : TEXCOORD3;
			#endif
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
				
				half4 wPos = mul(unity_ObjectToWorld, v.vertex);				
				half2 xyCoord 	= frac(_Time.yy*_Speed);
					
				o.uv  = v.texcoord.xy;
				o.uvMov = TRANSFORM_TEX( v.texcoord, _SmokeMap ) + xyCoord;
								
				float3x3 worldMatrix3 = (float3x3)unity_ObjectToWorld;
				half3 Normal = normalize(mul(worldMatrix3, v.normal));
				half3 ViewDirection = normalize(_WorldSpaceCameraPos - wPos.xyz);				
				half NdotV =  abs(dot(Normal, ViewDirection));
				o.TintColor = _TintColor * max(NdotV, 0.0);
				
				return o;
			}
			
			half4 frag(VSOut i) : COLOR
			{					
			#ifdef ENABLE_PARABOLOID				
				if (ParaboloidDiscard(i.paraboloidHemisphere))
					discard;
			#endif				
				half4 DF = tex2D(_MainTex, i.uv)* half4((half3)1.0, tex2D(_DiffuseAlpha,  i.uv).r);
				half3 SM = tex2D(_SmokeMap, i.uvMov).rgb;
				half3 Complete = DF.rgb + (SM * DF.rgb);
				return half4(Complete * i.TintColor, DF.a) * _AlphaScale;
			}

			ENDCG
		} 
	}
	FallBack "Transparent/Diffuse"
}
