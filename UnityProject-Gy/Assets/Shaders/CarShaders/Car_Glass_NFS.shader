// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "QF/Car/Car_Glass_NFS" {
	Properties {
		_MainTex ("Base(RGB)", 2D) = "white" {}
		_NormalMap ("Normal(RGB)", 2D) = "bump" {}

		_ReflectionCubeMap ("ReflectionCube(RGB)", CUBE) = "black" {}
		//_DestroyMap ("Destroy(RGB)", 2D) = "white" {}
		//_DestroyAlphaMap ("DestroyAlpha(R)", 2D) = "white" {}
		//_RoadDirtMap("RoadDirt(RGB)",2D) = "white" {}
		//_RoadDirtAlphaMap("RoadDirtAlpha(R)",2D) = "white" {}
		
		_glassColor("Glass Color", Color) = (0.3, 0.3, 0.3, 0.3)	

		//_destroyAmount("Destroy Amount(0,1)", Float) = 0.0
		//_roadDirtAmount("RoadDirt Amount(0,1)", Float) = 0.0
		
		
		_lightIntensity("LightIntensity(0,1)", Float) = 1.0
	
		_specular("Specular(0,3)", Float) = 1.0
		_gloss("Gloss(0,50)", Float) = 50
		_specularColor("SpecularColor", Color) = (1.0, 1.0, 1.0, 1.0)		
		
		_reflection("Reflection(0,3)", Float) = 1.0
		_reflectionFresnel("Reflection Fresnel(0,1)", Float) = 0.5
		_reflectionFresnelWidth("Reflection Fresnel Width(0,50)", Float) = 10
		_reflectoinBump("Reflection Bump(0,1)", Float) = 0.5
	  	
	}
	SubShader {
		Tags { 
			"Queue"="Transparent"
			"RenderType"="Transparent" 
			"LightMode"="ForwardBase"
			"Reflection" = "RenderReflectionTransparentBlend"
		}
		
		Blend SrcAlpha OneMinusSrcAlpha
		
		Lighting Off
		ZWrite Off
		ZTest On
		Cull Off
		LOD 100
		Fog {Mode Off}
		CGINCLUDE

			#include "../AdvCarCommon.cginc"
			#pragma exclude_renderers xbox360 flash	
			#pragma glsl

			sampler2D _MainTex;
			
			sampler2D _NormalMap;
			half4 _NormalMap_ST;
			
		 
			samplerCUBE _ReflectionCubeMap;
	 
	
			//sampler2D _DestroyMap;
			//sampler2D _DestroyAlphaMap;
			//sampler2D _RoadDirtMap;
			//sampler2D _RoadDirtAlphaMap;
			
			half4 _glassColor;
		 
			
			//half _destroyAmount;		
			//half _roadDirtAmount;
			
			
			half _lightIntensity;
			
			half  _specular;
			half  _gloss;
			half3 _specularColor;
	 
			half  _reflection;
			half  _reflectionFresnel;
			half  _reflectionFresnelWidth;
			half  _reflectoinBump;
		 
		
				
			half3 _lightDir;
			half3 _lightColor;
			
			struct appdata 
			{
			    float4 vertex : POSITION;
			    half3 normal : NORMAL;
                half4 tangent : TANGENT;
			    float4 texcoord : TEXCOORD0;
		
			    float4 texcoord1 : TEXCOORD1;
				
			};
			
			struct VSOut
			{
				float4 pos			: SV_POSITION;
				float4 uv			: TEXCOORD0;
				
				half3 TS_viewDir		: TEXCOORD1;
				half3 TS_lightDir	: TEXCOORD2;
				half3 vlight 		: TEXCOORD3;
				half3 WS_normal : TEXCOORD4;
				half camDist : TEXCOORD5;
				//#if USE_CAR_EXTRA_EFF_ON	
				half2 vParaboloidUV : TEXCOORD6;
				//#endif
				half3 WS_reflectDir : TEXCOORD7;
				//LIGHTING_COORDS(8,9)
			}; 
			 
			VSOut vert_func(appdata v)
			{
				VSOut o;
				
				TANGENT_SPACE_ROTATION;
				
				o.uv.xy = v.texcoord.xy;
				 
				o.uv.zw = TRANSFORM_TEX( v.texcoord1.xy , _NormalMap);
		 
				
			
				 
				half3 WS_normal = mul( unity_ObjectToWorld, half4(v.normal,0)).rgb;
				 o.WS_normal = WS_normal;

				o.pos = UnityObjectToClipPos(v.vertex);
		
				
				half3 OS_viewDir = ObjSpaceViewDir(v.vertex); 
				
				
				
				half3 WS_viewDir = mul(unity_ObjectToWorld,half4(OS_viewDir,0)).rgb; 
				 
				
				o.TS_viewDir = mul(rotation, OS_viewDir); 
				
				half3 OS_lightDir =  ObjSpaceLightDir(v.vertex); 
				
				
				o.TS_lightDir = mul(rotation, OS_lightDir);
				 
				 
				o.camDist  = CalcCamDist(v.vertex);
				
				//#if USE_CAR_EXTRA_EFF_ON	
				o.WS_reflectDir = normalize(reflect( -WS_viewDir, WS_normal));
				o.vParaboloidUV = GetParaboloidReflectionUV(o.WS_reflectDir);
				//#endif
				
				//TRANSFER_VERTEX_TO_FRAGMENT(o);
				return o;
			}
			
			half4 frag_func(VSOut i)
			{					
				#ifdef ENABLE_WHITE_MODE
					return float4(i.vlight.rgb,0.5);
				#endif
				
				i.TS_viewDir = normalize(i.TS_viewDir);
				i.TS_lightDir = normalize(i.TS_lightDir);

				half3 diffuseColor = tex2D(_MainTex, i.uv.xy);
				
			 
				
				float3 TS_normal = UnpackNormal(tex2D(_NormalMap,i.uv.zw));
	
				
		
			
				half3 TS_halfDir = normalize(i.TS_viewDir + i.TS_lightDir);
				
				half NdotL = saturate(dot(TS_normal, i.TS_lightDir));	
				half NdotV = saturate(dot(TS_normal, i.TS_viewDir));	
				half NdotH = saturate(dot(TS_normal, TS_halfDir));	
				
		
				
			 
				half spec =  NssPow(NdotH,_gloss) * _specular ;
			
				
				
				//compute the eye fresnel to be used for the paint add color
				half eyeFresnel = 1.0 - NdotV;
				
			 
				half4 baseColor = _glassColor;
						 
				half3 RF = 0;
				//half alphaExtra = 0.0;
				//#if USE_CAR_EXTRA_EFF_ON
				
					//half3 destroyColor =  tex2D(_DestroyMap,i.uv.zw);
					//half3 roadDirtColor =  tex2D(_RoadDirtMap,i.uv.zw);
					//half destroyAlpha =  tex2D(_DestroyAlphaMap,i.uv.zw);
					//half roadDirtAlpha =  tex2D(_RoadDirtAlphaMap,i.uv.zw);
				
					//half destoryResult = destroyAlpha * _destroyAmount;
					//baseColor.rgb = lerp(baseColor.rgb, destroyColor.rgb ,  destoryResult );
					//alphaExtra += destoryResult;
					
					//half dirtResult = roadDirtAlpha * _roadDirtAmount;
					//baseColor.rgb = lerp(baseColor.rgb, roadDirtColor.rgb ,  dirtResult );
					//alphaExtra += dirtResult;
			
				
					half reflectionAmount = _reflection * (NssPow(1.0 - NdotV, _reflectionFresnelWidth) * (1.0 - _reflectionFresnel) + _reflectionFresnel);
					

					
					
					half2 vNormalDisturb = TS_normal.xy*_reflectoinBump;
					
					i.WS_reflectDir.xz += vNormalDisturb;
				    RF = texCUBE(_ReflectionCubeMap,i.WS_reflectDir);
					 
			
					  
				
					RF =  reflectionAmount * RF;
		
				 
				//#endif
				 
				half3 light =  i.vlight.rgb +  _lightIntensity * NdotL * _LightColor0;
			 
				half3 color = light *  baseColor.rgb +  /*(1.0 - alphaExtra) **/ (_specular * spec * _specularColor + RF);
				
				 
				half RF_luminance = baseColor.a +  dot(RF, half3(0.3, 0.59, 0.11));
				

				half alpha = saturate(RF_luminance  + spec /*+ alphaExtra*/);	
 

					
				return NssFog( i.camDist, half4(color,alpha));
			 	
			}
		
		ENDCG
		pass
		{

	
		
			Tags {"LightMode"="ForwardBase"}
			CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdbase
 
			#pragma multi_compile _ ENABLE_WHITE_MODE

			VSOut vert(appdata v)
			{
				VSOut o = vert_func(v);
				half3 shlight = ShadeSH9(half4(o.WS_normal, 1.0));
				
				o.vlight.rgb = shlight  ;
				
				
				return o;
			}
			
			half4 frag(VSOut i) : COLOR
			{
				return frag_func(i);
			}

			ENDCG
		}
		

	}
	Fallback "QF/Car/Car_GlassHighHost"
	CustomEditor "AdvCarMaterialEditor"
}
