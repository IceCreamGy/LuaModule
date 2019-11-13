// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "TopCar/Env/Terrian_Water" {
Properties {
        
        _MainTex ("Base (RGB) Emission Tex", 2D) = "white" {}
        _Cube ("Reflection Cubemap", Cube) = "black" {}
        _BumpMap ("Normalmap", 2D) = "bump" {}
		_BumpMap2 ("Normalmap2", 2D) = "bump" {}
		
		_Color ("Main Color", Color) =  (1,1,1,1)
        _ReflectColor ("Reflection Color", Color) =  (1,1,1,1)
		_ReflectionStrength ("ReflectionStrength", Range (0, 3)) = 0.3
		
		
        _Fresnel("Fresnel", Range (1, 5)) = 3.0
        _FresnelPercentage("Fresnel Percentage", Range (0, 1)) = 0.5
		 

		_ScrollXSpeed("X speed",Range(-0.3,0.3)) = 0.2
		_ScrollYSpeed("Y speed",Range(-0.3,0.3)) = 0.2

}

SubShader 
{
 
		Tags { "Queue" = "Geometry+100"  "RenderType"="Opaque"  "Reflection" = "RenderReflectionOpaque"}
        LOD 300
		Fog {Mode Off}
		
		pass
		{
			Cull Back
			Fog {Mode Off}
			CGPROGRAM		
			#include "AdvCarCommon.cginc"	
			#include "NssLightmap.cginc"
			#pragma target 3.0
			#pragma glsl
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile LIGHTMAP_OFF LIGHTMAP_ON  
			#pragma exclude_renderers xbox360 flash	
 
		 
			#pragma multi_compile _ DISABLE_LIGHTMAPS_DIFFUSE
		 
			#pragma multi_compile _ ENABLE_WHITE_MODE
			#pragma multi_compile _ DISABLE_VERTEX_COLOR 
			 

			  
			sampler2D _MainTex;
			half4 _MainTex_ST;
				
			sampler2D _BumpMap;
			half4 _BumpMap_ST;
				
			sampler2D _BumpMap2;
			half4 _BumpMap2_ST;
			
			samplerCUBE _Cube;

			half3 _Color;
			half3 _ReflectColor;
			half _ReflectionStrength;
			half _Fresnel;
			half _FresnelPercentage;
		 

			half _ScrollXSpeed;
			half _ScrollYSpeed;

			struct appdata 
			{
				half4 color : COLOR;
			    float4 vertex : POSITION;
				half3 normal : NORMAL;
                half4 tangent : TANGENT;
			    float2 texcoord : TEXCOORD0;
			    float2 texcoord1 : TEXCOORD1;
			};
			

			struct VSOut
			{
				half3 color : COLOR;
				float4 pos : SV_POSITION;
				half2 uv_MainTex : TEXCOORD0;
				half2 uv_BumpMap : TEXCOORD1;
				half2 uv_BumpMap2 : TEXCOORD2;
				half2 uv_LightMap : TEXCOORD3;
				half3 TS_viewDir : TEXCOORD4;
				//half3 WS_reflectDir :TEXCOORD5;
				half3 camDist : TEXCOORD6;
			};
			
			
			
			VSOut vert(appdata v)
			{
				VSOut o;
				TANGENT_SPACE_ROTATION;
			 
				o.pos = UnityObjectToClipPos(v.vertex);
				
				half time = _Time.y;
				half2 ScrollSpeed = half2(_ScrollXSpeed,_ScrollYSpeed) * time;
				
				o.uv_MainTex = TRANSFORM_TEX(v.texcoord,_MainTex) + ScrollSpeed * 0.3;
				o.uv_BumpMap = TRANSFORM_TEX(v.texcoord,_BumpMap) + ScrollSpeed * 0.6;
				o.uv_BumpMap2 = TRANSFORM_TEX(v.texcoord.xy,_BumpMap2) + ScrollSpeed;

			 
			#ifndef LIGHTMAP_OFF
				o.uv_LightMap = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
			#else
				o.uv_LightMap = v.texcoord1.xy;
			#endif
			
				half3 OS_viewDir = ObjSpaceViewDir(v.vertex); 
				o.TS_viewDir = mul(rotation, OS_viewDir); 
				
				//half3 OS_reflectDir = reflect(-OS_viewDir,v.normal);
			//	o.WS_reflectDir = mul(_Object2World, half4(OS_reflectDir,0)).rgb;
			#ifdef DISABLE_VERTEX_COLOR
				o.color = _Color;
			#else
				o.color = v.color * _Color;
			#endif
				
				o.camDist  = CalcCamDist(v.vertex);
					
				return o;
			}
			
			
			
 
			half4 frag(VSOut IN) : COLOR
			{		
				IN.TS_viewDir = normalize(IN.TS_viewDir);
				half2 scrolledUV = IN.uv_BumpMap;

	  
				half3 mainTex = tex2D(_MainTex, IN.uv_MainTex).rgb;
				half3 color = mainTex * _Color;

				
	 
				
				half3 TS_normal = UnpackNormal(tex2D(_BumpMap, scrolledUV)) + UnpackNormal(tex2D(_BumpMap2, IN.uv_BumpMap2));
				TS_normal = normalize(TS_normal);
			   
			  
			   
				half3 lightMapCol = NssLightmap_Diffuse(IN.uv_LightMap);
					 
					 
			   
			   
				half3 TS_worldRefl = reflect (IN.TS_viewDir , TS_normal);
				
		

				half3 reflcol = texCUBE (_Cube, TS_worldRefl).rgb;
					
			 
	  
				half fresnel = saturate(1.0 - dot(TS_normal, normalize(IN.TS_viewDir)));
				fresnel = NssPow(fresnel, _Fresnel);
				
				fresnel = _FresnelPercentage + (1.0 - _FresnelPercentage) * fresnel;
				
				//return fresnel;

				reflcol = reflcol * fresnel * _ReflectColor * _ReflectionStrength;

 
				color = reflcol  +  color * lightMapCol;
				half4 finalColor = half4(color, 1.0); 
				//return finalColor;
				return NssFog(IN.camDist, finalColor);
				
			}
		ENDCG
		}
	}
	Fallback "QF/Env/Basic_Diffuse"
}