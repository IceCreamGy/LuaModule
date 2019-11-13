// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "AdvCarShading/Scene/Light" {
	Properties {		
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_fadeStrength("Fade Strength", Range(0,50)) = 2.0
		_colorScale("Color Scale", Float) = 1.0
	}
	SubShader {
		Tags { 
			"Queue" = "Transparent"
			"RenderType"="Transparent" 
			"Reflection" = "RenderReflectionTransparentBlend"
		}
		
		Blend One One
		ZWrite Off
		
		pass
		{
			CGPROGRAM
						
			#include "../AdvCarCommon.cginc"
			#pragma target 3.0
			#pragma vertex vert
			#pragma fragment frag
			#pragma exclude_renderers xbox360 flash
			#pragma multi_compile _ ENABLE_PARABOLOID

			sampler2D _MainTex;
			half _fadeStrength;
			half _colorScale;
			
			struct appdata 
			{
			    float4 vertex : POSITION;
			    half3 normal : NORMAL;
			    float4 texcoord : TEXCOORD0;
			};
			
			struct VSOut
			{
				float4 pos		: SV_POSITION;
				float2 uv		: TEXCOORD0;
				half  alpha	: TEXCOORD1;
			#ifdef ENABLE_PARABOLOID
				half paraboloidHemisphere : TEXCOORD2;
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
				
				float3x3 worldMatrix3 = (float3x3)unity_ObjectToWorld;
				half3 normalW = normalize(mul(worldMatrix3, v.normal.xyz));												
				half3 posW = mul(unity_ObjectToWorld, v.vertex).xyz;
				half3 dirW = normalize(posW - _WorldSpaceCameraPos);
					
				o.uv = v.texcoord.xy;
				o.alpha = pow(abs(dot(normalW, dirW)), _fadeStrength) * _colorScale;
				
				return o;
			}
			
			half4 frag(VSOut i) : COLOR
			{	
		#ifdef ENABLE_PARABOLOID				
				if (ParaboloidDiscard(i.paraboloidHemisphere))
					discard;
			#endif		
				half4 color = tex2D(_MainTex, i.uv);
				color *= i.alpha;
				return color;
			}		
		
			ENDCG
		} 
	}
	FallBack "Diffuse"
}
