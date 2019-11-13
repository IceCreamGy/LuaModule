// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

//like HIGH but without FLAKES

Shader "TopCar/Car/Car parts Top Level Shader" {
	Properties {
   
		_Color ("Diffuse Material Color (RGB)", Color) = (1,1,1,1) 
		_MainTex("Diffuse Texture", 2D) = "white" {}
		_SpecColor ("Specular Material Color (RGB)", Color) = (1,1,1,1) 
		_SpecularMap("SPMap(RGBA) R明暗，G高光强度，B反射强度，A光滑度", 2D) = "white" {}   //R颜色(车轮统一白色），G（金属度） A 光滑度
		_Shininess ("Shininess", Range (0.01, 10)) = 1
		_Gloss ("Gloss", Range (0.0, 10)) = 1
		_Smoothness("Smoothness", Range(0,1)) = 0.5
		_Cube("Reflection Map", Cube) = "_Skybox" {}
		_Reflection("Reflection Power", Range (0.00, 1)) = 0
		//_NormalMap("Normal (RGB)", 2D) = "bump" {}           //法线贴图
		//_FrezPow("Fresnel Power",Range(0,2)) = .25
		//_FrezFalloff("Fresnal Falloff",Range(0,10)) = 4	  
		_Metallic("Metallic", Range(0.0, 1)) = 0             //金属度
		//_MaskTex("Mask (RGB)", 2D) = "white" {}
		//_EmissionColor("Emission Color(RGB)", Color) = (0, 0, 0, 0)
		//_EmissionTex("Emission Texture", 2D) = "black" {}
		//_EmissionScale("Emission Scale", Float) = 1
		[Toggle] Shlighting("_SHLighting?", Float) = 0
		//_OuterFlakePower("Flake Outer Power", Range(1, 16)) = 2
		//_paintColor2("Outer Flake Color (RGB)", Color) = (1,1,1,1)
	}
	SubShader {
		Tags { "QUEUE"="Geometry" "RenderType"="Opaque" " IgnoreProjector"="True" "ExcludeBlurMask" = "True" }
		ColorMaterial AmbientAndDiffuse
		Pass {  
      
			Tags { "LightMode" = "ForwardBase" } // pass for 
            // 4 vertex lights, ambient light & first pixel light
 
			CGPROGRAM
         #pragma fragmentoption ARB_precision_hint_fastest
         #pragma multi_compile_fwdbase 
         #pragma vertex vert
         #pragma fragment frag
		 #pragma multi_compile SHLIGHTING_OFF SHLIGHTING_ON 
		 #pragma target 2.0	
		#pragma glsl
			//#pragma multi_compile USE_SPECULARMAP
		 //#pragma exclude_renderers xbox360 ps3 d3d11 flash
		 //#include "AutoLight.cginc"
 		 #include "UnityCG.cginc"
		
 
         // User-specified properties
		 uniform sampler2D _MainTex; 
         //uniform sampler2D _BumpMap; 
			//uniform sampler2D _MaskTex;
			//uniform sampler2D _NormalMap;
			uniform sampler2D _SpecularMap;
         //uniform fixed4 _BumpMap_ST;	
			uniform float4	_MainTex_ST;
         uniform fixed4 _Color; 
		 uniform fixed _Reflection;
         uniform fixed4 _SpecColor; 
         uniform half _Shininess;
		 uniform half _Gloss;
		 uniform half _Metallic;
		 uniform fixed _Smoothness;
		 //自发光
		 //uniform fixed4 _EmissionColor;
		 //uniform sampler2D _EmissionTex;
		 //uniform fixed _EmissionScale;
		 
		 //sparkle color usage
		 //uniform sampler2D _SparkleTex;
		 //uniform half _FlakeScale;
		 //uniform half _FlakePower;
		 //uniform half _OuterFlakePower;
		 //uniform fixed4 _paintColor2;
		 //end
		 
		 //uniform samplerCUBE _Cube; 
		 UNITY_DECLARE_TEXCUBE(_Cube);
		 //fixed _FrezPow;
		 //half _FrezFalloff;
		 
 
         // The following built-in uniforms (except _LightColor0) 
         // are also defined in "UnityCG.cginc", 
         // i.e. one could #include "UnityCG.cginc" 
         uniform fixed4 _LightColor0; 
            // color of light source (from "Lighting.cginc")
 
         struct vertexInput {
            float4 vertex : POSITION;
            fixed3 normal : NORMAL;
			float2 texcoord : TEXCOORD0;
			//float4 tangent : TANGENT;
         };
         struct vertexOutput {
            float4 pos : SV_POSITION;
            float4 posWorld : TEXCOORD0;
            //fixed3 normalDir : TEXCOORD1;
			//fixed3 vertexLighting : TEXCOORD1;
			float2 tex : TEXCOORD2;
			fixed3 viewDir : TEXCOORD3;
			float3 normalWorld : TEXCOORD4;
			//float3 tangentWorld : TEXCOORD5;
			//float3 binormalWorld : TEXCOORD6;
#ifdef SHLIGHTING_ON
			fixed3  SHLighting : COLOR;
#endif
         };

		 half NssPow(half base, half power)
		 {
			 return pow(max(0.001, base), power + 0.01);
		 }

		 fixed4 frag_func_simple(vertexOutput input)
		 {
			 fixed3 normalDirection = normalize(input.normalWorld);
			 //fixed3 normalDirection = normalDir; // UnpackNormal(tex2D(_NormalMap, input.tex.xy));

//#ifdef USE_SPECULARMAP
			 fixed4 SpTexColor = tex2D(_SpecularMap, input.tex.xy);
			 _SpecColor.rgb *= SpTexColor.g;
			 _Smoothness *= SpTexColor.a;
			 fixed reflectionScale = SpTexColor.b;
			 fixed fAO = SpTexColor.r;
			 //_Metallic *= SpTexColor.g;
//#endif

			 float _Roughness = _Smoothness;
			 fixed3 viewDirection = normalize(
				 _WorldSpaceCameraPos.xyz - input.posWorld.xyz);
			 fixed3 lightDirection;
			 fixed attenuation;

			 fixed4 mainTexColor = tex2D(_MainTex, input.tex.xy * _MainTex_ST.xy + _MainTex_ST.zw) * fAO;
			 //fixed4 maskTexColor = tex2D(_MaskTex, input.tex.xy);

			 //fixed4 displayColor = lerp(mainTexColor, _Color, maskTexColor.r);
			 fixed4 textureColor = mainTexColor * _Color * clamp((1.0f - _Metallic / 2), 0.5f, 1.0f);

			 //if (0.0 == _WorldSpaceLightPos0.w) // directional light?
			 {
				 attenuation = 1.0; // no attenuation
				 lightDirection =
					 normalize(_WorldSpaceLightPos0.xyz);
			 }
			 //else // point or spot light
			 //{
			 //   fixed3 vertexToLightSource = 
			 //      _WorldSpaceLightPos0.xyz - input.posWorld.xyz;
			 //   fixed distance = length(vertexToLightSource);
			 //   attenuation = 1.0 / distance; // linear attenuation 
			 //   lightDirection = normalize(vertexToLightSource);
			 //}

			 //attenuation = LIGHT_ATTENUATION(input);

			 float3 halfVector = normalize(lightDirection + viewDirection);//normalize转化成单位向量  
			 //float NdotL = saturate(dot(normalDirection, normalize(lightDirection)));//入射光与表面法线向量的点积当作漫反射光照强度因子  
			 //float NdotH_raw = dot(normalDirection, halfVector);//两个单位向量的点积得到两个向量的夹角的cos值  
			 half NdotH = saturate(dot(normalDirection, halfVector));//如果x小于0返回 0;如果x大于1返回1;否则返回x;把x限制在0-1  
			 //float NdotV = saturate(dot(normalDirection, normalize(viewDirection)));
			 //float VdotH = saturate(dot(halfVector, normalize(viewDirection)));

			
				half spec = NssPow(NdotH, _Gloss);
				fixed3 specularReflection = _Shininess * spec * _SpecColor * _Roughness;


			 //specularReflection *= _Gloss;

			 fixed3 reflectedDir = reflect(input.viewDir, normalize(normalDirection));
			 fixed3 reflTex = _Roughness > 0 ? UNITY_SAMPLE_TEXCUBE_LOD(_Cube, reflectedDir, (1.0f - _Roughness) * 8.0f).rgb : 0;

			 //Calculate Reflection vector
			 /*			fixed SurfAngle= clamp(abs(dot (reflectedDir, normalDirection)),0,1);
			 fixed frez = pow(1 - SurfAngle, _FrezFalloff) ;
			 frez *= _FrezPow;

			 _Reflection += frez;*/ 

			 reflTex.rgb *= saturate(_Reflection) * reflectionScale;

			 fixed4 color = fixed4(textureColor + specularReflection, 1.0f);  //fixed4(textureColor.rgb * saturate(ambientLighting + diffuseReflection) + specularReflection, 1.0);
			 //color.rgb += paintColor * _FlakePower;
			 color.rgb += reflTex.rgb;

			 return color;
		 }
 
         vertexOutput vert(vertexInput v)
         {          
            vertexOutput o;
 
            o.posWorld = mul(unity_ObjectToWorld, v.vertex);
            //o.normalDir = normalize(fixed3(mul(fixed4(input.normal, 0.0), unity_WorldToObject).xyz));
			   
			o.tex = v.texcoord;
            o.pos = UnityObjectToClipPos(v.vertex);

            o.viewDir = normalize(mul(unity_ObjectToWorld, v.vertex) - fixed4(_WorldSpaceCameraPos.xyz, 1.0)).xyz;
  
			o.normalWorld = normalize(mul(unity_ObjectToWorld, float4(v.normal, 0.0)).xyz);
			//o.tangentWorld = normalize(mul(unity_ObjectToWorld, half4(half3(v.tangent.xyz), 0)));
			//o.binormalWorld = normalize(cross(o.normalWorld, o.tangentWorld));
			   
            // Diffuse reflection by four "vertex lights"            
            //o.vertexLighting = fixed3(0.0, 0.0, 0.0);
#ifdef SHLIGHTING_ON
			o.SHLighting = ShadeSH9(float4(o.normalWorld, 1));
#endif

            
            //TRANSFER_VERTEX_TO_FRAGMENT(o);			   
            return o;
         }
 
		 fixed4 frag(vertexOutput input) : COLOR
		 {
			fixed4 color = frag_func_simple(input);
#ifdef SHLIGHTING_ON
			color.rgb *= input.SHLighting;
#endif
			//fixed3 emissionClr = _EmissionColor.rgb * tex2D(_EmissionTex, input.tex.xy).rgb * _EmissionScale;
			//color.rgb += emissionClr;

			return color;
			
         }
         ENDCG
      }
 }
   // The definition of a fallback shader should be commented out 
   // during development:
   Fallback "Diffuse"
}