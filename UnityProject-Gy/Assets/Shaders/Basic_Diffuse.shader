// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "TopCar/Env/Basic_Diffuse" {
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" "LightMode"="ForwardBase" "Reflection" = "RenderReflectionOpaque"}
		LOD 100
				
		pass
		{
			Cull Back
			Fog {Mode Off}
			CGPROGRAM		
			#include "AdvCarCommon.cginc"	
			#include "NssLightmap.cginc"
			//#pragma target 3.0
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			#pragma multi_compile LIGHTMAP_OFF LIGHTMAP_ON  
			#pragma exclude_renderers xbox360 flash	
 
			//#pragma multi_compile _ ENABLE_PARABOLOID
			#pragma multi_compile _ ENABLE_WHITE_MODE
			#pragma multi_compile _ DISABLE_LIGHTMAPS_DIFFUSE
			#pragma multi_compile _ DISABLE_VERTEX_COLOR 
            #pragma multi_compile_instancing

			sampler2D _MainTex;
			half4 _MainTex_ST;
			half4 _Color;
			
			struct appdata 
			{
				half4 color : COLOR;
			    float4 vertex : POSITION;
			    float2 texcoord : TEXCOORD0;
			    float2 texcoord1 : TEXCOORD1;
                UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct VSOut
			{
				half4 color : COLOR;
				float4 pos		: SV_POSITION;
				float4 uv		: TEXCOORD0;
		//	#ifdef ENABLE_PARABOLOID
		//		float paraboloidHemisphere : TEXCOORD1;
		//	#endif
				half3 camDist : TEXCOORD2;
				UNITY_FOG_COORDS(3)
                UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			VSOut vert(appdata v)
			{
				VSOut o;

                UNITY_SETUP_INSTANCE_ID(v);

		//	#ifdef ENABLE_PARABOLOID
		//		o.pos = mul(UNITY_MATRIX_MV, v.vertex);	
		//		o.paraboloidHemisphere = o.pos.z;
		//		o.pos = ParaboloidTransform(o.pos);
				
		//	#else
				o.pos = UnityObjectToClipPos(v.vertex);
		//	#endif	
				o.uv.xy = TRANSFORM_TEX(v.texcoord,_MainTex);

				o.camDist  = CalcCamDist(v.vertex);
				
			#ifndef LIGHTMAP_OFF
				o.uv.zw = v.texcoord1 * unity_LightmapST.xy + unity_LightmapST.zw;
			#else
				o.uv.zw = v.texcoord1;
			#endif

				#ifdef DISABLE_VERTEX_COLOR
				o.color = half4(1.0,1.0,1.0,1.0);
				#else
				o.color = v.color;
				#endif
				
				UNITY_TRANSFER_FOG(o, o.pos);
				return o;
			}

			half4 frag(VSOut i) : COLOR
			{		
                UNITY_SETUP_INSTANCE_ID(i);

		//     #ifdef ENABLE_PARABOLOID
		//		if (ParaboloidDiscard(i.paraboloidHemisphere))
		//			 discard;
		//	#endif	
			
				float2 uv0 = i.uv.xy;
				float2 uv1 = i.uv.zw;
	
				half3 diffuseCol = tex2D(_MainTex, uv0);

				half3 lightMapCol = NssLightmap_Diffuse(uv1);
				#ifdef ENABLE_WHITE_MODE
					return half4(lightMapCol,1.0);
				#endif

				half3 color = diffuseCol * lightMapCol;
				half4 finalColor = half4(color, 1) * i.color * _Color; 
				
				//return i.color;
				//return NssFog(i.camDist, finalColor ) ;
				UNITY_APPLY_FOG(i.fogCoord, finalColor); // apply fog
				return finalColor;
			}

			ENDCG
		} 
	}
	Fallback "Mobile/Diffuse"
}
