// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

//like HIGH but without FLAKES

Shader "TopCar/Car/Car Paint Top Level Mask 2 UV Shader" {
	Properties {
   
		_Color ("Diffuse Material Color (RGB)", Color) = (1,1,1,1) 
		_MainTex("Diffuse Texture，RGB车辆纹理，A与Car Paint Color做混合（[0 - 0.5]:MainTex - Car Paint Color, [0.5 - 1]:MainTex - Car Paint Color2）", 2D) = "white" {}
		_CarPaintColor("Car Paint Color (RGB)，车漆颜色1", Color) = (1,1,1,1)
		_CarPaintColor2("Car Paint Color (RGB)，车漆颜色2", Color) = (1,1,1,1)

		_DecalPaintTex("Decal Paint Texture，车辆贴花纹理，A与车漆颜色混合(0:车漆颜色，1：贴花颜色)", 2D) = "black" {}
		_DecalPaintColor("Decal Paint Color (RGB)", Color) = (1,1,1,1)
		_DecalMaskPaintTex("Decal Mask Paint (RGB)，R(DecalPaintTex & Decal Paint Color),控制贴花颜色(0:Decal Paint Tex, 1:Decal Paint Color)", 2D) = "black" {}

		//_AOTex("AO Texture", 2D) = "white" {}
		_SpecColor1 ("Specular Material Color (RGB)", Color) = (1,1,1,1) 
		_SpecularMap("SPMap(RGBA) R明暗，G高光强度，B反射强度，A光滑度", 2D) = "white" {}
		_Shininess ("Shininess", Range (0.01, 20)) = 1
		_Gloss ("Gloss", Range (0.0, 10)) = 1
		_SpecularScale("SpecularScale", Range(0, 1)) = 1
		_Smoothness("Smoothness", Range(0,1)) = 0.5
		_RealReflectionSmoothness("Real-time Environment Reflection  Smoothness",Range(0,2)) = 1
		_Cube("Reflection Map", Cube) = "_Skybox" {}
		_Reflection("Reflection Power", Range (0.00, 1)) = 0
		//_NormalMap("Normal (RGB)", 2D) = "bump" {}

		//Fresnel
		_FrezPow("Fresnel Power",Range(0,2)) = .25
		_FrezFalloff("Fresnel Falloff",Range(1,20)) = 4	  
		//_FrezOffset("菲涅尔暗度",Range(0.4, 0.95)) = 0.5

		_Metallic("Metallic", Range(0.0, 1)) = 0
		//_paintMidColor("Paint MidColor", Color) = (0.0, 0.0, 0.0, 1.0)
		//_paintAddColor("Paint AddColor", Color) = (0.0, 0.0, 0.0, 1.0)
		//_MaskTex("Mask (RGB)", 2D) = "white" {}
		[Toggle(EMISSION_ON)] _Emission("Emission enable?", Float) = 0
		_EmissionColor("Emission Color(RGB)", Color) = (0, 0, 0, 0)
		_EmissionTex("Emission Texture", 2D) = "black" {}
		_EmissionScale("Emission Scale", Float) = 1
		_SparkleTex("Sparkle Texture", 2D) = "white" {}
		_FlakeScale("Flake Scale", float) = 1
		_FlakePower("Flake Alpha",Range(0, 1)) = 0
		_LightScale("Light Scale",Range(0, 1)) = 1

		//_OuterFlakePower("Flake Outer Power", Range(1, 16)) = 2
		_paintColor2("Outer Flake Color (RGB)", Color) = (1,1,1,1)
		[Toggle] Shlighting("SHLighting enable?", Float) = 0

		//基于图片重新映射光照系数-----------------------------------------
		//漫反射映射
		_DiffuseWarp("Diffuse Warp Tex", 2D) = "white" {}
		//暗区变高亮区域映射
		_HighLight("HightLight Color", color) = (0,0,0,0)
		_OutColorPower("Outcolor Fresnel", float) = 8.0
		[Toggle(LIGHT_WARP_ON)] _LightWarpEnable("Light Warp enable?", Float) = 0

		//_Matcap("Matcap", 2D) = "black" {}
		//_MatcapReflectInt("Matcap Reflect Intensity", Range(0, 5)) = 0
		//[Toggle(MATCAP_ON)] _MatcapEnable("Matcap enable?", Float) = 0
	}
	SubShader {
		Tags { "QUEUE"="Geometry" "RenderType"="Opaque" " IgnoreProjector"="True" "ExcludeBlurMask"="True" }
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
		 #pragma shader_feature EMISSION_ON
		 #pragma shader_feature LIGHT_WARP_ON
		 //#pragma shader_feature MATCAP_ON
		 #pragma target 2.0	
		 #pragma glsl
		 //	#pragma multi_compile USE_SPECULARMAP
		 //#pragma exclude_renderers xbox360 ps3 d3d11 flash
		 //#include "AutoLight.cginc"
 		 #include "UnityCG.cginc"
		#include "AutoLight.cginc"
		#include "Lighting.cginc"

 
        // User-specified properties
		uniform sampler2D _MainTex; 
		uniform fixed4 _CarPaintColor;
		uniform fixed4 _CarPaintColor2;

		uniform sampler2D _DecalPaintTex;
		uniform fixed4 _DecalPaintColor;
		uniform sampler2D _DecalMaskPaintTex;

		//uniform sampler2D _BumpMap; 
		//uniform sampler2D _MaskTex;
		//uniform sampler2D _NormalMap;
		uniform sampler2D _SpecularMap;
		//uniform sampler2D _AOTex;
        //uniform fixed4 _BumpMap_ST;	
		uniform float4	_MainTex_ST;
        uniform fixed4 _Color; 

		uniform half _SpecularScale;
		//uniform fixed4 _paintMidColor;
		//uniform fixed4 _paintAddColor;
		uniform fixed _Reflection;
        uniform fixed4 _SpecColor1; 
        uniform half _Shininess;
		uniform half _Gloss;
		uniform half _Metallic;
		uniform fixed _Smoothness;
		uniform fixed _RealReflectionSmoothness;
		uniform fixed _LightScale;
#ifdef	EMISSION_ON
		uniform fixed4 _EmissionColor;
		uniform sampler2D _EmissionTex;
		uniform fixed _EmissionScale;
#endif
		//sparkle color usage
		uniform sampler2D _SparkleTex;
		uniform half _FlakeScale;
		uniform half _FlakePower;
		uniform half _OuterFlakePower;
		uniform fixed4 _paintColor2;
		//end
		
		//uniform samplerCUBE _Cube; 
		UNITY_DECLARE_TEXCUBE(_Cube);
		fixed _FrezPow;
		half _FrezFalloff;
		//fixed _FrezOffset;

#ifdef  LIGHT_WARP_ON
		uniform sampler2D _DiffuseWarp;
		uniform half4 _HighLight;
		uniform half _OutColorPower;
#endif
//#ifdef MATCAP_ON
//		 uniform sampler2D _Matcap;
//		 uniform half _MatcapReflectInt;
//#endif

         // The following built-in uniforms (except _LightColor0) 
         // are also defined in "UnityCG.cginc", 
         // i.e. one could #include "UnityCG.cginc" 
         //uniform fixed4 _LightColor0; 
            // color of light source (from "Lighting.cginc")
 
         struct vertexInput {
            float4 vertex : POSITION;
            fixed3 normal : NORMAL;
			float2 texcoord : TEXCOORD0;
			float2 texcoord1 : TEXCOORD1;
			//float4 tangent : TANGENT;
         };
         struct vertexOutput {
            float4 pos : SV_POSITION;
            float4 posWorld : TEXCOORD0;
            //fixed3 normalDir : TEXCOORD1;
			fixed3 vertexLighting : TEXCOORD1;
			float2 tex : TEXCOORD2;
			float2 tex1 : TEXCOORD3;
			fixed3 viewDir : TEXCOORD4;
			float3 normalWorld : TEXCOORD5;
#ifdef LIGHT_WARP_ON
			half3 dotResult : TEXCOORD6;
#endif
			//float3 tangentWorld : TEXCOORD5;
			//float3 binormalWorld : TEXCOORD6;
#ifdef SHLIGHTING_ON
			fixed3  SHLighting : COLOR;
#endif
//#ifdef MATCAP_ON
//			half2 capCoord : TEXCOORD7;
//#endif
         };

		 fixed D_Compute(fixed fRoughness, float NdH)
		 {
			 fixed m = fRoughness * fRoughness;
			 fixed m2 = m * m;
			 fixed NdH2 = NdH * NdH;
			 return exp((NdH2 - 1.0) / (m2 * NdH2)) / (UNITY_PI * m2 * NdH2 * NdH2);
		 }

		 fixed G_schlick(fixed roughness, fixed NdV, fixed NdL)
		 {
			 fixed k = roughness * roughness * 0.5;
			 fixed V = NdV * (1.0 - k) + k;
			 fixed L = NdL * (1.0 - k) + k;
			 return 0.25 / (V * L);
		 }

		 fixed3 CaculateSpeculationReflection(fixed fRoughness, fixed NdH, fixed NdV, fixed NdL, fixed3 SpecColor)
		 {
			 fixed D = D_Compute(fRoughness, NdH);

			 fixed G = G_schlick(fRoughness, NdV, NdL);

			 return D * G;
		 }

		 half NssPow(half base, half power)
		 {
			 return pow(max(0.001, base), power + 0.01);
		 }

		 fixed4 frag_func_simple(vertexOutput input)
		 {
			 
			 //float4 texN = tex2D(_NormalMap, input.tex.xy);
			 //float nDepth = 8 / (_BumpDepth * 8);
/*
			 //Unpack Normal
			 half3 localCoords = half3(2.0 * texN.ag - float2(1.0, 1.0), 0.0);
			 localCoords.z = 1;
			*/
			 //normal transpose matrix
			 //float3x3 local2WorldTranspose = float3x3
				// (
				//	 input.tangentWorld,
				//	 input.binormalWorld,
				//	 input.normalWorld
				//	 );
			

			 ////Calculate normal direction
			 //float3 normalDir = input.normalWorld;   //normalize(mul(localCoords, local2WorldTranspose));

			 ////fixed3 normalDirection = normalize(input.normalDir); 
			 //fixed3 TS_TexNormal = UnpackNormal(tex2D(_NormalMap, input.tex.xy));
			 //half3 WS_TexNormal = mul(TS_TexNormal, tangent2World);
			 fixed3 normalDirection = input.normalWorld;//mul(TS_TexNormal, local2WorldTranspose); //normalDir; //UnpackNormal(tex2D(_NormalMap, input.tex.xy));

			 float _Roughness = _Smoothness;
			 fixed3 viewDirection = normalize(input.viewDir);
			 fixed3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
			 fixed attenuation = 1.0; // no attenuation

			 //float3 halfVector = normalize(lightDirection + viewDirection);//normalize转化成单位向量  
			 //float NdotL = saturate(dot(normalDirection, normalize(lightDirection)));//入射光与表面法线向量的点积当作漫反射光照强度因子  
			 //float NdotH_raw = dot(normalDirection, halfVector);//两个单位向量的点积得到两个向量的夹角的cos值  
			 //float NdotH = saturate(/*NdotH_raw*/dot(normalDirection, halfVector));//如果x小于0返回 0;如果x大于1返回1;否则返回x;把x限制在0-1  
			 //float NdotV = saturate(dot(normalDirection, normalize(viewDirection)));
			 //float VdotH = saturate(dot(halfVector, normalize(viewDirection)));


			 //sparkle texture begin
			 fixed3 vNormal = fixed3(0.5, 0.5, 1.0);//encodedNormal;// tex2D( _BumpMap, input.tex );
													//fixed3 vNormal = fixed3(0.5,0.5,1.0);//encodedNormal;// tex2D( _BumpMap, input.tex );
													//fixed3 vNormal = normalize(input.worldNormal);//encodedNormal;// tex2D( _BumpMap, input.tex );
			 vNormal = 2 * vNormal - 1.0;

			 fixed3 vFlakesNormal = tex2D(_SparkleTex, input.tex.xy * _FlakeScale);

			 vFlakesNormal = 2 * vFlakesNormal - 1.0;
			 fixed3 vNp1 = vFlakesNormal + 4 * vNormal;
			 //fixed3 vView = normalize(input.viewDir);
			 //fixed3x3 mTangentToWorld = transpose(local2WorldTranspose);

			 //fixed3 vNormalWorld = normalize(mul(mTangentToWorld, vNormal));

			 //fixed3 vNp1World = normalize(mul(-vNp1, local2WorldTranspose));
			 fixed  fFresnel1 = saturate(dot(normalDirection, viewDirection));
			 fixed  fFresnel1Sq = fFresnel1 * fFresnel1;

			 fixed4 mainTexColor = tex2D(_MainTex, input.tex.xy * _MainTex_ST.xy + _MainTex_ST.zw);
			 //fixed4 maskTexColor = tex2D(_MaskTex, input.tex.xy);
			 //fixed4 aoTexColor = tex2D(_AOTex, input.tex.xy);
			 fixed4 SpTexColor = tex2D(_SpecularMap, input.tex.xy);
			 fixed AO = SpTexColor.r;
			 _Roughness *= SpTexColor.a;

			 //fixed4 paintColor = pow(fFresnel1Sq, _OuterFlakePower) * _paintColor2 * _FlakePower;

			 //fixed3 displayColor = saturate(lerp(mainTexColor.rgb * _Color.rgb, _CarPaintColor.rgb/* + fFresnel1Sq * _paintMidColor +
				// fFresnel1Sq * fFresnel1Sq * _paintAddColor*//* + paintColor*/, mainTexColor.a));
			 //获得车漆颜色,_CarPaintColor[0.5 - 1],_CarPaintColor2[0 - 0.5]
			 fixed4 carPaintColor = step(0.5, mainTexColor.a) * _CarPaintColor + step(mainTexColor.a, 0.5) * _CarPaintColor2;
			 fixed mainTexBlendFactor = (mainTexColor.a - step(0.5, mainTexColor.a) * 0.5) / 0.5;
			 fixed3 displayColor = saturate(lerp(mainTexColor.rgb * _Color.rgb, carPaintColor, mainTexBlendFactor));

			 //车贴花颜色
			 //第2套uv的纹理颜色，默认白色
			 fixed4 decalTexColor = tex2D(_DecalPaintTex, input.tex1.xy);
			 fixed4 decalMaskTexColor = tex2D(_DecalMaskPaintTex, input.tex1.xy);

			 //和第2套纹理的mask图做混合后的颜色
			 decalTexColor.rgb = saturate(lerp(decalTexColor.rgb, _DecalPaintColor.rgb, decalMaskTexColor.r));
			 displayColor = saturate(lerp(displayColor, decalTexColor.rgb, decalTexColor.a));

			 vFlakesNormal = lerp(fixed3(1, 1, 1), vFlakesNormal * _paintColor2, max(mainTexColor.a, decalTexColor.a));

			 fixed3 textureColor = displayColor * clamp((1.0f - _Metallic / 2), 0.5f, 1.0f) * AO;
#ifdef	SHLIGHTING_ON
			 textureColor.rgb *= input.SHLighting;
#endif
#ifdef LIGHT_WARP_ON
			 textureColor.rgb = tex2D(_DiffuseWarp, float2(input.dotResult.x, 0.5)) * textureColor;
			 half4 HightlightPortion = _HighLight * pow(input.dotResult.z, _OutColorPower) * SpTexColor.b;
			 textureColor.rgb += HightlightPortion.rgb;
#endif
//#ifdef MATCAP_ON
//			 half4 MatcapPortion = tex2D(_Matcap, input.capCoord) * SpTexColor.g * _MatcapReflectInt;
//			 textureColor.rgb += MatcapPortion.rgb;
//#endif

			 //fixed viewAngleCos = clamp(dot(viewDirection, normalDirection), 0, 1);
			 //fixed frez = pow(2, viewAngleCos) - _FrezOffset;
			 //frez = saturate(frez);
			 //textureColor.rgb *= frez;

			 //fixed frezFinal = step(0.2f, viewAngleCos);
			 //frez = (frezFinal == 0 ? frez : 1);
			 //frez = clamp(10 * frez, 0.2f, 1.0f);
			 //textureColor.rgb *= frez;
			 //sparkle texture end

			 fixed3 ambientLighting = UNITY_LIGHTMODEL_AMBIENT.xyz * _Color.xyz;

			 /*
			 fixed3 diffuseReflection =
				 attenuation * _LightColor0.xyz * textureColor.xyz
				 * max(0.0, dot(normalDirection, lightDirection));

			 fixed3 specularReflection;

			 float geoEnum = 2.0 * NdotH;
			 float3 G1 = (geoEnum * NdotV) / NdotH;
			 float3 G2 = (geoEnum * NdotL) / NdotH;
			 float3 G = min(1.0f, min(G1, G2));//取小的

			 if (NdotL < 0.0)
			 {
				 specularReflection = fixed3(0.0, 0.0, 0.0);
			 }
			 else // light source on the right side
			*/

			 fixed3 specularReflection = fixed3(0.0, 0.0, 0.0);
			 {
//#ifdef USE_SPECULARMAP
				 //fixed4 SpTexColor = tex2D(_SpecularMap, input.tex.xy);
				 //_SpecColor1 *= SpTexColor;
				 //_Roughness *= SpTexColor.a;
//#endif
				 //specularReflection = attenuation * (_LightColor0.xyz)
					// * (_SpecColor1.xyz) * pow(max(0.0, dot(
					//	 reflect(-lightDirection, normalDirection),
					//	 viewDirection)), _Shininess)  * G * _Roughness;

				 //half spec = /*specularFactor * */NssPow(NdotH, _Gloss) * SpTexColor.g;
				 half spec = SpTexColor.g * _SpecularScale;


				specularReflection = spec * _LightColor0.xyz
					*(_SpecColor1.xyz) * pow(max(0.0, dot(
					reflect(-lightDirection, normalDirection),
					viewDirection)), _Shininess) * _Gloss * _Roughness;
				specularReflection *= step(0, dot(normalDirection, lightDirection));

				specularReflection *= (vFlakesNormal * _FlakePower);

				 //specularReflection *= _Roughness;
				 //specularReflection = _Shininess * spec * _SpecColor1 * _Roughness;
			 }


			 //specularReflection *= _Gloss;

			 fixed3 reflectedDir = reflect(-viewDirection, normalize(normalDirection));
			 fixed3 reflTex = _Roughness > 0 ? UNITY_SAMPLE_TEXCUBE_LOD(_Cube, reflectedDir, (1.0f - _Roughness) * 8.0f * _RealReflectionSmoothness).rgb : 0;

			 //Calculate Reflection vector
			 fixed SurfAngle = clamp(abs(dot(reflectedDir, normalDirection)), 0, 1);
			 fixed frez = pow(1 - SurfAngle, _FrezFalloff);
			 frez *= _FrezPow;
			 _Reflection += frez;
			 reflTex.rgb *= saturate(_Reflection) * SpTexColor.b;

			 //线形减淡
			 //fixed4 color = fixed4(textureColor.rgb + specularReflection.rgb + reflTex.rgb, 1);
			 //滤色
			 textureColor.rgb += specularReflection.rgb;
			 textureColor.rgb = 1 - (1 - textureColor.rgb) * (1 - reflTex.rgb);
			 fixed4 color = fixed4(textureColor.rgb, 1.0f); //fixed4(textureColor.rgb * saturate(ambientLighting + diffuseReflection) + specularReflection, 1.0);
			 //Lighten
			 //fixed4 color = fixed4(max(textureColor.r, reflTex.r), max(textureColor.g, reflTex.g), max(textureColor.b, reflTex.b), 1);
			 //Darken
			 //fixed4 color = fixed4(min(textureColor.r, reflTex.r), min(textureColor.g, reflTex.g), min(textureColor.b, reflTex.b), 1);

			 //color.rgb += paintColor * _FlakePower;
			 //color.rgb += reflTex.rgb;
			 //color.rgb += frez * reflTex.rgb;
			 color.rgb *= _LightScale;

			 return color;
		 }
 
         vertexOutput vert(vertexInput v)
         {          
            vertexOutput o;
 
            o.posWorld = mul(unity_ObjectToWorld, v.vertex);
            //o.normalDir = normalize(fixed3(mul(fixed4(input.normal, 0.0), unity_WorldToObject).xyz));
			   
			o.tex = v.texcoord;
			o.tex1 = v.texcoord1;
            o.pos = UnityObjectToClipPos(v.vertex);

            //o.viewDir = normalize(mul(unity_ObjectToWorld, v.vertex) - fixed4(_WorldSpaceCameraPos.xyz, 1.0)).xyz;
			o.viewDir = UnityWorldSpaceViewDir(o.posWorld);
			fixed3 normalViewDir = normalize(o.viewDir);

			o.normalWorld = UnityObjectToWorldNormal(v.normal);//normalize(mul(unity_ObjectToWorld, float4(v.normal, 0.0)).xyz);//直接乘unity_ObjectToWorld在mat为non uniform时有误
			//o.tangentWorld = normalize(mul(unity_ObjectToWorld, half4(half3(v.tangent.xyz), 0)));
			//o.binormalWorld = normalize(cross(o.normalWorld, o.tangentWorld));
			   
            // Diffuse reflection by four "vertex lights"            
            o.vertexLighting = fixed3(0.0, 0.0, 0.0);
#ifdef SHLIGHTING_ON
			o.SHLighting = ShadeSH9(float4(o.normalWorld, 1));
#endif
#ifdef LIGHT_WARP_ON
			float3 worldLightDir = UnityWorldSpaceLightDir(o.posWorld);
			o.dotResult = half3(saturate(dot(o.normalWorld, worldLightDir))*0.5 + 0.5, saturate(dot(normalize(o.viewDir + worldLightDir), o.normalWorld)), 1 - saturate(dot(o.normalWorld, normalViewDir)));
#endif
//#ifdef MATCAP_ON
//			o.capCoord = (half2((dot(UNITY_MATRIX_IT_MV[0].xyz, v.normal)), (dot(UNITY_MATRIX_IT_MV[1].xyz, v.normal))) + 0.5)*0.5;
//#endif
            
            //TRANSFER_VERTEX_TO_FRAGMENT(o);			   
            return o;
         }
 
		fixed4 frag(vertexOutput input) : SV_Target
		{
			
			fixed4 color = frag_func_simple(input);

#ifdef	 EMISSION_ON
			fixed3 emissionClr = _EmissionColor.rgb * tex2D(_EmissionTex, input.tex.xy).rgb * _EmissionScale;
			color.rgb += emissionClr;
#endif
 
			return color; 
         }
         ENDCG
      }
 }
   // The definition of a fallback shader should be commented out 
   // during development:
   Fallback "Diffuse"
}