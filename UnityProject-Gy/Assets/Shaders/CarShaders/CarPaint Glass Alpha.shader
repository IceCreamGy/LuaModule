// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

//like MED but without POINT LIGHTS and with many optimisations

Shader "TopCar/Car/Car Paint Glass Alpha" {
   Properties {
   
	  _Color ("Diffuse Material Color (RGB)", Color) = (1,1,1,1) 
	  _SpecColor ("Specular Material Color (RGB)", Color) = (1,1,1,1) 
	  _LightGlassColor("Light Glass Color(RGB)", Color) = (1, 1, 1, 1)
	  _Shininess ("Shininess", Range (0.01, 10)) = 1
	  _Gloss ("Gloss", Range (0.0, 10)) = 1
	  _MainTex ("Diffuse Texture", 2D) = "white" {} 
	  _Cube("Reflection Map", Cube) = "" {}
	  _Reflection("Reflection Power", Range (0.00, 1)) = 0
	  _FrezPow("Fresnel Power",Range(0,2)) = .25
	  _FrezOffset("菲涅尔暗度",Range(0.4, 0.95)) = 0.5
	  _EmissionScreenTex("Emission Texture", 2D) = "black" {}
	  _FogBlend("Fog Blend", Range(0,1)) = 0.5
      [Header(Realtime Environment Map)]
      _EnvironmentFront("Realtime Environment Front", 2D) = "black" {}
      _EnvironmentBack("Realtime Environment Back", 2D) = "black" {}
      _EnvironmentAttenuation("Realtime Attenuation", Range(0, 1)) = 1
      _EnvironmentSmoothness("Realtime Environment Smooth, 0 最平滑", Range(0, 8)) = 1
      [Toggle(DUAL_MIPMAP)] _EnvironmentMipMap("Smoothness enable?", Float) = 1
   }
SubShader {
   Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}  	  
      Pass {  
		 Blend SrcAlpha OneMinusSrcAlpha // use alpha blending
         Tags { "LightMode" = "ForwardBase" } // pass for 
            // 4 vertex lights, ambient light & first pixel light
 
         CGPROGRAM
         #pragma fragmentoption ARB_precision_hint_fastest
         #pragma multi_compile_fwdbase 
		 #pragma multi_compile_fog
         #pragma vertex vert
         #pragma fragment frag
		 #pragma target 2.0	
#pragma multi_compile SPOTLIGHT_OFF SPOTLIGHT_ON 
#pragma multi_compile GHOST_OFF GHOST_ON
#pragma multi_compile CAR_ALPHA_OFF CAR_ALPHA_ON
#pragma multi_compile DUAL_PARABOLOID_MAPPED_OFF DUAL_PARABOLOID_MAPPED_ON
#pragma multi_compile __ DUAL_MIPMAP
		 //#pragma exclude_renderers d3d11 xbox360 ps3 d3d11_9x flash
		 //#include "AutoLight.cginc"
 		 #include "UnityCG.cginc"
#include "CarInclude.cginc"
#ifdef SPOTLIGHT_ON
#include "../SpotLight.cginc"
#endif
#include "../DualParaboloidMap.cginc"

		  uniform fixed _FogBlend;
 
         // User-specified properties
		 uniform sampler2D _MainTex; 
         uniform sampler2D _EmissionScreenTex;
         //uniform sampler2D _BumpMap; 
	 
		 
         //uniform fixed4 _BumpMap_ST;		 
         uniform fixed4 _Color; 
		 uniform fixed _Reflection;
         uniform fixed4 _SpecColor; 
		 uniform fixed4 _LightGlassColor;
         uniform half _Shininess;
		 uniform half _Gloss;
		 
		 //uniform fixed normalPerturbation;
		 
		 //uniform fixed4 _paintColor0; 
		 //uniform fixed4 _paintColorMid; 

		 uniform samplerCUBE _Cube;
		 //uniform float4x4 _ReflectCubeRotate;

		 fixed _FrezPow;
		 fixed _FrezOffset;
		 
 
         // The following built-in uniforms (except _LightColor0) 
         // are also defined in "UnityCG.cginc", 
         // i.e. one could #include "UnityCG.cginc" 
         uniform fixed4 _LightColor0; 
            // color of light source (from "Lighting.cginc")
 
         struct vertexInput {
            float4 vertex : POSITION;
            fixed3 normal : NORMAL;
			half4 texcoord : TEXCOORD0;
			
         };
         struct vertexOutput {
            float4 pos : SV_POSITION;
            float4 posWorld : TEXCOORD0;
            fixed3 normalDir : TEXCOORD1;
			half4 tex : TEXCOORD2;
			float4 screenPos : TEXCOORD3;
			//LIGHTING_COORDS(7,8)
         };
 
         vertexOutput vert(vertexInput input)
         {          
            vertexOutput o;
 
            o.posWorld = mul(unity_ObjectToWorld, input.vertex);
            o.normalDir = normalize(fixed3(mul(fixed4(input.normal, 0.0), unity_WorldToObject).xyz));
			   
			o.tex = input.texcoord;
            o.pos = UnityObjectToClipPos(input.vertex);
			o.screenPos = ComputeScreenPos(o.pos);
            //TRANSFER_VERTEX_TO_FRAGMENT(o);			   
            return o;
         }
 
         fixed4 frag(vertexOutput input) : COLOR
         {
		 
            fixed3 normalDirection = normalize(input.normalDir); 
            fixed3 viewDirection = normalize(
               _WorldSpaceCameraPos - input.posWorld.xyz);
            fixed3 lightDirection;
            fixed attenuation;
 
			fixed4 textureColor = tex2D(_MainTex, input.tex.xy);
			//fixed alpha = textureColor.a * _Color.a;
			fixed4 glassColor = lerp(_LightGlassColor, _Color, textureColor.r);
#ifdef GHOST_ON
			glassColor = fixed4(1 - glassColor.r, 1 - glassColor.g, 1 - glassColor.b, glassColor.a);
#endif
            attenuation = 1.0; // no attenuation
            lightDirection = normalize(fixed3(_WorldSpaceLightPos0.xyz));
 
            fixed3 ambientLighting = 
                UNITY_LIGHTMODEL_AMBIENT.xyz * glassColor.xyz;
 
            fixed3 diffuseReflection = 
               attenuation * _LightColor0.xyz * glassColor.xyz
               * max(0.0, dot(normalDirection, lightDirection));				  

            fixed3 specularReflection;
			
			if (dot(normalDirection, lightDirection) < 0.0) 
            {
               specularReflection = fixed3(0.0, 0.0, 0.0); 
            }
            else // light source on the right side
            {
               specularReflection = attenuation * _LightColor0.rgb
                  * _SpecColor.rgb * pow(max(0.0, dot(
                  reflect(-lightDirection, normalDirection), 
                  viewDirection)), _Shininess);
            }
		 
			specularReflection *= _Gloss;

			fixed3 reflectedDir = reflect(-viewDirection, normalDirection );

#ifdef DUAL_PARABOLOID_MAPPED_ON
            fixed4 reflTex = DUAL_PARABOLOID_SAMPLE(reflectedDir)
#else
            fixed4 reflTex = texCUBE(_Cube, float4(reflectedDir, 1.0));
#endif // DUAL_PARABOLOID_MAPPED_ON
            //return reflTex;

			//Calculate Reflection vector
			fixed viewAngleCos = clamp(dot(viewDirection, normalDirection), 0, 1);
			fixed frez = pow(2, viewAngleCos) - _FrezOffset;
			frez = saturate(frez);
			
			//_Reflection += frez;			
			
			reflTex.rgb *= saturate(_Reflection);
#if defined(FOG_LINEAR) || defined(FOG_EXP) || defined(FOG_EXP2)
			reflTex.rgb = lerp(reflTex.rgb, unity_FogColor.rgb, _FogBlend);
#endif

            fixed4 color = fixed4(glassColor.rgb * saturate(ambientLighting + diffuseReflection) + specularReflection + (frez * reflTex), glassColor.a);
#ifdef SPOTLIGHT_ON
			fixed3 spotColor = SpotLightColor(input.posWorld, input.normalDir);
			color.rgb += spotColor;
#endif
			float2 screenUV = input.screenPos.xy / input.screenPos.w;
			fixed4 emissionColor = tex2D(_EmissionScreenTex, screenUV);
			color += emissionColor;
			//color = lerp(color, emissionColor, emissionColor.a);
			//return emissionColor; // fixed4(emissionColor.a, 0, 0, 1);
#ifdef CAR_ALPHA_ON
			color.a *= carAlpha;
#endif
			return color;
			
         }
         ENDCG
      }
 }
   // The definition of a fallback shader should be commented out 
   // during development:
   Fallback "Mobile/Diffuse"
}