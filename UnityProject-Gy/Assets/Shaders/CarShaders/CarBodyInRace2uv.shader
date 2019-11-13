// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "TopCar/Car/CarBodyInRace2uv" {
	Properties {
		_Color("Diffuse Material Color (RGB)", Color) = (1,1,1,1)
		_MainTex("Diffuse Texture，RGB车辆纹理，A与Car Paint Color做混合（[0 - 0.5]:MainTex - Car Paint Color, [0.5 - 1]:MainTex - Car Paint Color2）", 2D) = "white" {}
		_CarPaintColor("Car Paint Color (RGB)，车漆颜色1", Color) = (1,1,1,1)
		_CarPaintColor2("Car Paint Color (RGB)，车漆颜色2", Color) = (1,1,1,1)

		_DecalPaintTex("Decal Paint Texture，车辆贴花纹理，A与车漆颜色混合(0:车漆颜色，1：贴花颜色)", 2D) = "black" {}
		_DecalPaintColor("Decal Paint Color (RGB)", Color) = (1,1,1,1)
		_DecalMaskPaintTex("Decal Mask Paint (RGB)，R(DecalPaintTex & Decal Paint Color),控制贴花颜色(0:Decal Paint Tex, 1:Decal Paint Color)", 2D) = "black" {}

	    //_AOTex("AO Texture", 2D) = "white" {}
		_SpecColor1("Specular Material Color (RGB)", Color) = (1,1,1,1)
		_SpecularMap("SPMap(RGBA) R明暗，G高光强度，B反射强度，A光滑度", 2D) = "white" {}
		_Shininess("Shininess", Range(0.01, 20)) = 1
		_Gloss("Gloss", Range(0.0, 10)) = 1
		_SpecularScale("SpecularScale", Range(0, 1)) = 1
		_Smoothness("Smoothness", Range(0,1)) = 0.5
		_RealReflectionSmoothness("Real-time Environment Reflection  Smoothness",Range(0,2)) = 1
		_Cube("Reflection Map", Cube) = "_Skybox" {}
		//Material Capture纹理
		//_MatCap("MatCap", 2D) = "white" {}
		//_MatCapScale("MatCap Scale", Range(1,4)) = 1.8
		_Reflection("Reflection Power", Range(0.00, 1)) = 0
		_FrezPow("Fresnel Power",Range(0,2)) = .25
		//_FrezFalloff("Fresnal Falloff",Range(0,10)) = 4
		_FrezOffset("菲涅尔暗度",Range(0.4, 0.95)) = 0.5
		_Metallic("Metallic", Range(0.0, 1)) = 0
		//_MaskTex("Mask (RGB)", 2D) = "white" {}
		//_EmissionScale("Emission Scale", Float) = 1
		//_EmissionColor("Emission Color(RGB)", Color) = (0, 0, 0, 0)
		//_EmissionTex("Emission Texture", 2D) = "black" {}

		_SparkleTex("Sparkle Texture", 2D) = "white" {}
		_FlakeScale("Flake Scale", float) = 1
		_FlakePower("Flake Alpha",Range(0, 1)) = 0

		_FogBlend("Fog Blend", Range(0,1)) = 0.6		
		_paintColor2("Outer Flake Color (RGB)", Color) = (1,1,1,1)

        [Space(20)]
        _shLightFactor("SHLighint Factor", Range(0,1)) = 1
		[Toggle] Shlighting("_SHLighting?", Float) = 0

		[HideInInspector]  _SrcBlend("__src", Float) = 1.000000
		[HideInInspector]  _DstBlend("__dst", Float) = 0.000000
		[HideInInspector]  _ZWrite("__zw", Float) = 1.000000

		//基于图片重新映射光照系数-----------------------------------------
		//漫反射映射
        [Space(20)]
		_DiffuseWarp("Diffuse Warp Tex", 2D) = "white" {}
		//暗区变高亮区域映射
		_HighLight("HightLight Color", color) = (0,0,0,0)
		_OutColorPower("Outcolor Fresnel", float) = 8.0
		[Toggle(LIGHT_WARP_ON)] _LightWarpEnable("Light Warp enable?", Float) = 0

        //[Space(20)]
		////调整反射球反射效果
		//_ReflectMapCenter("Reflection Cube Map Center Position(XYZ) & Radius(W)", Vector) = (0,0,0,0)

        [Header(Realtime Environment Map)]
        _EnvironmentFront("Realtime Environment Front", 2D) = "black" {}
        _EnvironmentBack("Realtime Environment Back", 2D) = "black" {}
        _EnvironmentAttenuation("Realtime Attenuation", Range(0, 1)) = 1
        _EnvironmentSmoothness("Realtime Environment Smooth, 0 最平滑", Range(0, 8)) = 1
        [Toggle(DUAL_MIPMAP)] _EnvironmentMipMap("Smoothness enable?", Float) = 1
    }
	SubShader{
			Tags{ "QUEUE" = "Geometry" "RenderType" = "Opaque" " IgnoreProjector" = "True" "ExcludeBlurMask" = "True" }
			ColorMaterial AmbientAndDiffuse
			Pass{

				Tags{ "LightMode" = "ForwardBase" } // pass for 
													// 4 vertex lights, ambient light & first pixel light
			ZWrite[_ZWrite]
			Blend[_SrcBlend][_DstBlend]
				CGPROGRAM
	#pragma fragmentoption ARB_precision_hint_fastest
	#pragma multi_compile_fwdbase
	#pragma multi_compile_fog
	#pragma vertex vert
	#pragma fragment frag
	#pragma multi_compile SHLIGHTING_OFF SHLIGHTING_ON 
	#pragma multi_compile SPOTLIGHT_OFF SPOTLIGHT_ON 
	#pragma multi_compile GHOST_OFF GHOST_ON
	#pragma multi_compile CAR_ALPHA_OFF CAR_ALPHA_ON
    #pragma multi_compile DUAL_PARABOLOID_MAPPED_OFF DUAL_PARABOLOID_MAPPED_ON
    #pragma multi_compile __ DUAL_MIPMAP
	#pragma shader_feature LIGHT_WARP_ON
	//#pragma shader_feature LOCALIZING_REFLECTION
	#pragma target 3.0	
	#pragma glsl
			//	#pragma multi_compile USE_SPECULARMAP
			//#pragma exclude_renderers xbox360 ps3 d3d11 flash
			//#include "AutoLight.cginc"
#include "UnityCG.cginc"
#include "AutoLight.cginc"
#include "Lighting.cginc"
#include "CarInclude.cginc"
#ifdef SPOTLIGHT_ON
#include "../SpotLight.cginc"
#endif
#include "../DualParaboloidMap.cginc"

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

		uniform fixed4 _paintMidColor;
		uniform fixed4 _paintAddColor;
		uniform fixed _Reflection;
		uniform fixed4 _SpecColor1;
		uniform half _Shininess;
		uniform half _Gloss;
		uniform half _Metallic;
		uniform half _SpecularScale;
		uniform fixed _Smoothness;
		uniform fixed _RealReflectionSmoothness;

		//sparkle color usage
		uniform sampler2D _SparkleTex;
		uniform half _FlakeScale;
		uniform half _FlakePower;

		uniform fixed _FogBlend;

		//uniform fixed4 _EmissionColor;
		//uniform sampler2D _EmissionTex;
		//uniform fixed _EmissionScale;

		//sparkle color usage
		//uniform sampler2D _SparkleTex;
		//uniform half _OuterFlakePower;
		uniform fixed4 _paintColor2;
		//end

		//uniform samplerCUBE _Cube; 
		//sampler2D _MatCap;
		//uniform float _MatCapScale;

		UNITY_DECLARE_TEXCUBE(_Cube);
		fixed _FrezPow;
		//half _FrezFalloff;
		fixed _FrezOffset;

        uniform fixed _shLightFactor;

#ifdef LIGHT_WARP_ON
		uniform sampler2D _DiffuseWarp;
		uniform half4 _HighLight;
		uniform half _OutColorPower;
#endif

		//uniform float4 _ReflectMapCenter;

		uniform float4x4 _ReflectCubeRotate;

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
			//float3 tangentWorld : TEXCOORD5;
			//float3 binormalWorld : TEXCOORD6;
			//float2 matCapCoord: TEXCOORD6;
#ifdef LIGHT_WARP_ON
			half3 dotResult : TEXCOORD6;
#endif
#ifdef SHLIGHTING_ON
			fixed3  SHLighting : COLOR;
#endif
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
			//	(
			//		input.tangentWorld,
			//		input.binormalWorld,
			//		input.normalWorld
			//		);


			//Calculate normal direction
			float3 normalDirection = input.normalWorld;   //normalize(mul(localCoords, local2WorldTranspose));

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
			fixed3 vNormal = fixed3(0.5, 0.5, 1.0);
			vNormal = 2 * vNormal - 1.0;
			fixed3 vFlakesNormal = tex2D(_SparkleTex, input.tex.xy * _FlakeScale);
			vFlakesNormal = 2 * vFlakesNormal - 1.0;

			fixed4 mainTexColor = tex2D(_MainTex, input.tex.xy * _MainTex_ST.xy + _MainTex_ST.zw);
			//fixed4 maskTexColor = tex2D(_MaskTex, input.tex.xy);
			//fixed4 aoTexColor = tex2D(_AOTex, input.tex.xy);
			fixed4 SpTexColor = tex2D(_SpecularMap, input.tex.xy);
			fixed AO = SpTexColor.r;
			_Roughness *= SpTexColor.a;

			//获得车漆颜色,_CarPaintColor[0.5 - 1],_CarPaintColor2[0 - 0.5]
			fixed4 carPaintColor = step(0.5, mainTexColor.a) * _CarPaintColor + step(mainTexColor.a, 0.5) * _CarPaintColor2;
			fixed mainTexBlendFactor = (mainTexColor.a - step(0.5, mainTexColor.a) * 0.5) / 0.5;
			fixed4 displayColor = saturate(lerp(mainTexColor * _Color, carPaintColor, mainTexBlendFactor));

			//车贴花颜色
			fixed4 decalTexColor = tex2D(_DecalPaintTex, input.tex1.xy);
			fixed4 decalMaskTexColor = tex2D(_DecalMaskPaintTex, input.tex1.xy);

			//和第2套纹理的mask图做混合后的颜色
			decalTexColor.rgb = saturate(lerp(decalTexColor.rgb, _DecalPaintColor.rgb, decalMaskTexColor.r));
			displayColor.rgb = saturate(lerp(displayColor.rgb, decalTexColor.rgb, decalTexColor.a));

			vFlakesNormal = lerp(fixed3(1, 1, 1), vFlakesNormal * _paintColor2, max(mainTexColor.a, decalTexColor.a));

			fixed4 textureColor = displayColor * clamp((1.0f - _Metallic / 2), 0.5f, 1.0f) * AO;

#ifdef GHOST_ON
			textureColor = fixed4(1 - textureColor.r, 1 - textureColor.g, 1 - textureColor.b, textureColor.a);
#endif

			//sparkle texture end

#ifdef LIGHT_WARP_ON
			textureColor.rgb = tex2D(_DiffuseWarp, float2(input.dotResult.x, 0.5)) * textureColor;
			half4 HightlightPortion = _HighLight * pow(input.dotResult.z, _OutColorPower) * SpTexColor.b;
			textureColor.rgb += HightlightPortion.rgb;
#endif
#ifdef	SHLIGHTING_ON
			textureColor.rgb *= lerp(1, input.SHLighting, _shLightFactor);
#endif

			fixed3 ambientLighting = UNITY_LIGHTMODEL_AMBIENT.xyz * _Color.xyz;

			fixed3 specularReflection = fixed3(0.0, 0.0, 0.0);

			half spec = SpTexColor.g * _SpecularScale;

			specularReflection = spec /** _LightColor0.xyz*/
				* (_SpecColor1.xyz) * pow(max(0.0, dot(
					reflect(-lightDirection, normalDirection),
					viewDirection)), _Shininess) * _Gloss * _Roughness;
					
			specularReflection *= step(0, dot(normalDirection, lightDirection));

			specularReflection *= (vFlakesNormal * _FlakePower);
#ifdef	SHLIGHTING_ON
			specularReflection *= lerp(1, input.SHLighting, _shLightFactor);
#endif

			fixed3 reflectedDir = reflect(-viewDirection, normalize(normalDirection));

//#ifdef LOCALIZING_REFLECTION
//			//获得Corrected reflection direction
//			fixed3 cp = clamp((input.posWorld.xyz - _ReflectMapCenter.xyz) / _ReflectMapCenter.w, -1, 1);
//			//return fixed4(abs(cp), 1);
//			reflectedDir = normalize(reflectedDir + cp);
//#endif

#ifdef DUAL_PARABOLOID_MAPPED_ON
            fixed3 reflTex = DUAL_PARABOLOID_SAMPLE(reflectedDir)
#else
            fixed3 reflTex = _Roughness > 0 ? UNITY_SAMPLE_TEXCUBE_LOD(_Cube, reflectedDir, (1.0f - _Roughness) * 8.0f * _RealReflectionSmoothness).rgb : 0;
#endif // DUAL_PARABOLOID_MAPPED_ON
            //return fixed4(reflTex, 1);

			//Calculate Reflection vector
			fixed viewAngleCos = clamp(dot(viewDirection, normalDirection), 0, 1);
			fixed frez = pow(2, viewAngleCos) - _FrezOffset;
			frez = saturate(frez);
            textureColor.rgb *= frez;

			//fixed frezFinal = step(0.2f, viewAngleCos);
			//frez = (frezFinal == 0 ? frez : 1);
			//frez = clamp(10 * frez, 0.2f, 1.0f);
			

			//_Reflection += frez;

            //fixed SurfAngle = clamp(abs(dot(reflectedDir, normalDirection)), 0, 1);
            //fixed frez = pow(1 - SurfAngle, _FrezFalloff);
            //frez *= _FrezPow;
            //_Reflection += frez;

			reflTex.rgb *= saturate(_Reflection) * SpTexColor.b;
#if defined(FOG_LINEAR) || defined(FOG_EXP) || defined(FOG_EXP2)
			reflTex.rgb *= (1 - _FogBlend);
#endif

			//从提供的MatCap纹理中，提取出对应光照信息
			//float3 matCapColor = tex2D(_MatCap, input.matCapCoord.xy).rgb;

			fixed4 color = fixed4(textureColor.rgb/* * matCapColor * _MatCapScale*/ + specularReflection, 1.0f); 
			//color.rgb += reflTex.rgb * matCapColor * _MatCapScale;
			color.rgb += reflTex.rgb; // *matCapColor * _MatCapScale;
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

			o.viewDir = UnityWorldSpaceViewDir(o.posWorld);
			fixed3 normalViewDir = normalize(o.viewDir);

			o.normalWorld = UnityObjectToWorldNormal(v.normal);
			//o.tangentWorld = normalize(mul(unity_ObjectToWorld, half4(half3(v.tangent.xyz), 0)));
			//o.binormalWorld = normalize(cross(o.normalWorld, o.tangentWorld));

			// Diffuse reflection by four "vertex lights"            
			o.vertexLighting = fixed3(0.0, 0.0, 0.0);

			//MatCap坐标准备：将法线从模型空间转换到观察空间，存储于TEXCOORD1的后两个纹理坐标zw
			//o.matCapCoord.x = dot(normalize(UNITY_MATRIX_IT_MV[0].xyz), normalize(v.normal));
			//o.matCapCoord.y = dot(normalize(UNITY_MATRIX_IT_MV[1].xyz), normalize(v.normal));
			//归一化的法线值区间[-1,1]转换到适用于纹理的区间[0,1]
			//o.matCapCoord.xy = o.matCapCoord.xy * 0.5 + 0.5;

#ifdef SHLIGHTING_ON
			o.SHLighting = ShadeSH9(float4(o.normalWorld, 1));
#endif
#ifdef LIGHT_WARP_ON
			float3 worldLightDir = UnityWorldSpaceLightDir(o.posWorld);
			o.dotResult = half3(saturate(dot(o.normalWorld, worldLightDir))*0.5 + 0.5, saturate(dot(normalize(o.viewDir + worldLightDir), o.normalWorld)), 1 - saturate(dot(o.normalWorld, normalViewDir)));
#endif
			//TRANSFER_VERTEX_TO_FRAGMENT(o);			   
			return o;
		}

		fixed4 frag(vertexOutput input) : COLOR
		{
			fixed4 color = frag_func_simple(input);


			//fixed3 emissionClr = _EmissionColor.rgb * tex2D(_EmissionTex, input.tex.xy).rgb * _EmissionScale;
			//color.rgb += emissionClr;

#ifdef SPOTLIGHT_ON
			fixed3 spotColor = SpotLightColor(input.posWorld, input.normalWorld);
			color.rgb += spotColor;
#endif

#ifdef CAR_ALPHA_ON
			color.a *= carAlpha;
#endif
			return color;

		}
		ENDCG
	}
}
	FallBack "Diffuse"
}
