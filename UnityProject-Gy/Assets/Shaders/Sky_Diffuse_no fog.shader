// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "TopCar/Env/Sky_Diffuse_no fog" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		//_SkyColor ("SkyColor", Color) = (1,1,1,1)
        _SkyBrightness ("SkyBrightness", Float ) = 1
	}
	SubShader {
		LOD 10
		
		Tags { 		
			"Queue" = "Geometry-200"
			"RenderType"="Opaque"
			"LightMode"="ForwardBase"	
			"Reflection" = "RenderReflectionOpaque_NoLightmap"
		}
						
		pass
		{	
			Cull Off
			Fog {Mode Off}
			ZWrite Off
								
			CGPROGRAM		
			#include "AdvCarCommon.cginc"		
			//#pragma target 3.0
			#pragma vertex vert
			#pragma fragment frag
			//#pragma multi_compile_fwdbase
			#pragma exclude_renderers xbox360 flash	
		//	#pragma multi_compile _ ENABLE_PARABOLOID
			#pragma multi_compile _ DISABLE_VERTEX_COLOR 
			
			sampler2D _MainTex;
			//half4 _SkyColor;
			half _SkyBrightness;
			
			struct appdata 
			{
			    float4 vertex : POSITION;
			    float4 texcoord : TEXCOORD0;
			};
			
			struct VSOut
			{
				float4 pos		: SV_POSITION;
				float2 uv		: TEXCOORD0;
		//	#ifdef ENABLE_PARABOLOID
		//		half paraboloidHemisphere : TEXCOORD1;
		//	#endif
			};
			
			VSOut vert(appdata v)
			{
				VSOut o;
		//	#ifdef ENABLE_PARABOLOID
		//		o.pos = mul(UNITY_MATRIX_MV, v.vertex);	
		//		o.paraboloidHemisphere = o.pos.z;
		//		o.pos = ParaboloidTransform(o.pos);
				
		//	#else
				o.pos = UnityObjectToClipPos(v.vertex);
				//o.pos.z = o.pos.w;
		//	#endif	
				o.uv = v.texcoord.xy;
				
				return o;
			}
			
			half4 frag(VSOut i) : COLOR
			{											
			#ifdef ENABLE_PARABOLOID				
				if (ParaboloidDiscard(i.paraboloidHemisphere))
					discard;
			#endif	
			    half3 skyColor = tex2D(_MainTex, i.uv).rgb;
				//half4 finalCol = half4( skyColor * _SkyColor.rgb * _SkyLight, 1.f);
				return half4(skyColor * _SkyBrightness,1.0);
			}

			ENDCG
		} 
	}
	Fallback "Mobile/Diffuse"
}
