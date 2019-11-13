Shader "TopCar/Env/Building_CubemapMask_Spec_v2f" {
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB) RefStrength (A)", 2D) = "white" {}

        [Header(Reflection Setting)]
        [Toggle(ENABLE_REFLECTION_ON)]_Enable_Reflection("Enable Reflection", Float) = 0
        [ConditionHide(_Enable_Reflection, 1)]_ReflectColor("Reflection Color", Color) = (1,1,1,0.5)
        //反射贴图
        [ConditionHide(_Enable_Reflection, 1)]_Cube ("Reflection Cubemap", Cube) = "_Skybox" {}
		[ConditionHide(_Enable_Reflection, 1)]_CubMaskDown("CubMapMaskBase (RGB)", 2D) = "Black" {}
		[ConditionHide(_Enable_Reflection, 1)]_CubValue("Cube Value", float) = 1
		//Glow效果
        [Header(Glow Setting)]
        [Toggle(ENABLE_GLOW_ON)]_Enable_Glow("Enable Glow", Float) = 0
        [ConditionHide(_Enable_Glow, 1)]_Glow("Glow", 2D) = "black"{}
        [ConditionHide(_Enable_Glow, 1)]_GlowValue("Glow Value", float) = 1
		//高光计算
		[Header(Specular Setting)]
        [Toggle(ENABLE_SPECULAR_ON)]_Enable_Specular("Enable Specular", Float) = 0
        [ConditionHide(_Enable_Specular, 1)]_Shininess("Shininess", Range(0.03, 1)) = 0.078125
        [ConditionHide(_Enable_Specular, 1)]_SpecularMask("Specular Texture", 2D) = "white"{}
        [ConditionHide(_Enable_Specular, 1)]_SpecularColor("Specular Tint", Color) = (1,1,1,1)
        [ConditionHide(_Enable_Specular, 1)]_Gloss("Gloss Value", Range(0.01, 255)) = 1
		
        [Header(Sun Light Setting)]
        _LightDir("Direction light position", Vector) = (0, 0, 0, 0.0)
		//烘焙后的方向光
        [Header(Bump Setting)]
        [Toggle(ENABLE_BUMP_ON)]_Enable_Bump("Enable Bump", Float) = 0
		//法线贴图
        [ConditionHide(_Enable_Bump, 1)][NoScaleOffset] _BumpMap("Normalmap", 2D) = "bump" {}
        [ConditionHide(_Enable_Bump, 1)]_BumpScale("Bump light scale", Range(0.01, 5)) = 1

		//_TransparencyLM("Transmissive Color", 2D) = "white" {}
	}
	SubShader {
		LOD 200
		Tags { "RenderType"="Opaque" }
	
		
	// ------------------------------------------------------------
	// Surface shader code generated out of a CGPROGRAM block:
	

	// ---- forward rendering base pass:
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardBase" }

CGPROGRAM
// compile directives
#pragma vertex vert_surf
#pragma fragment frag_surf
#pragma multi_compile_fog
#pragma multi_compile_fwdbase
#pragma multi_compile DUAL_PARABOLOID_OFF DUAL_PARABOLOID_ON
#pragma shader_feature ENABLE_REFLECTION_ON
#pragma shader_feature ENABLE_GLOW_ON
#pragma shader_feature ENABLE_BUMP_ON
#pragma shader_feature ENABLE_SPECULAR_ON
//#pragma multi_compile LIGHTMAP_OFF LIGHTMAP_ON
#include "HLSLSupport.cginc"
#include "UnityShaderVariables.cginc"
// Surface shader code generated based on:
// writes to per-pixel normal: YES
// writes to emission: YES
// writes to occlusion: no
// needs world space reflection vector: YES
// needs world space normal vector: no
// needs screen space position: no
// needs world space position: no
// needs view direction: no
// needs world space view direction: no
// needs world space position for lighting: no
// needs world space view direction for lighting: YES
// needs world space view direction for lightmaps: no
// needs vertex color: no
// needs VFACE: no
// passes tangent-to-world matrix to pixel shader: YES
// reads from normal: no
// 1 texcoords actually used
//   float2 _MainTex
#define UNITY_PASS_FORWARDBASE
#include "UnityCG.cginc"
#include "Lighting.cginc"
#include "AutoLight.cginc"
#include "DualParaboloidMap.cginc"

#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
#define WorldNormalVector(data,normal) fixed3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
//
//// Original surface shader snippet:
//#line 19 ""
//#ifdef DUMMY_PREPROCESSOR_TO_WORK_AROUND_HLSL_COMPILER_LINE_HANDLING
//#endif
///* UNITY: Original start of shader */
//		//#pragma surface surf MobileBlinnPhong exclude_path:prepass noforwardadd halfasview interpolateview //nolightmap 

		sampler2D _MainTex;
#if ENABLE_REFLECTION_ON
		samplerCUBE _Cube;
		sampler2D _CubMaskDown;
		fixed _CubValue;
		fixed4 _ReflectColor;
#endif

#if ENABLE_GLOW_ON
		sampler2D _Glow;
		fixed _GlowValue;
#endif
		fixed4 _LightDir;
		float4 _SpecularColor;

#if ENABLE_SPECULAR_ON
		sampler2D _SpecularMask;
		half _Shininess;
		fixed _Gloss;
#endif
#if ENABLE_BUMP_ON
		sampler2D _BumpMap;
		float _BumpScale;
#endif

		fixed4 _Color;

		struct Input {
			float2 uv_MainTex;
			float3 worldRefl;
			INTERNAL_DATA
		};

		struct SurfaceCustomOutput
		{
			fixed3 Albedo;
			fixed3 Normal;
			fixed3 Emission;
#if ENABLE_SPECULAR_ON
			fixed3 SpecularColor;
			half Specular;
			fixed Gloss;
#endif
			fixed Alpha;
		};

		inline fixed4 LightingMobileBlinnPhong(SurfaceCustomOutput s, fixed3 lightDir, fixed3 halfDir, fixed atten)
		{
			fixed diff = max(0, dot(s.Normal, lightDir));
//#ifdef LIGHTMAP_ON
			//diff *= 0.5;
//#endif
			fixed4 c = fixed4(0, 0, 0, 1);
#ifndef LIGHTMAP_ON
			c.rgb = s.Albedo * _SpecularColor.rgb * diff * atten;
#endif
#if ENABLE_SPECULAR_ON
			fixed nh = max(0, dot(s.Normal, halfDir));
			fixed spec = pow(nh, s.Specular * 128) * s.Gloss;
			float3 finalSpec = s.SpecularColor * spec * _Gloss;
			c.rgb += _SpecularColor.rgb * finalSpec * atten;
#endif
			UNITY_OPAQUE_ALPHA(c.a);
			return c;
		}

		void surf (Input IN, inout SurfaceCustomOutput o) {
			fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
			fixed4 c = tex;
			o.Albedo = c.rgb * _Color;

#if ENABLE_GLOW_ON
			o.Albedo = o.Albedo + tex2D(_Glow, IN.uv_MainTex) * _GlowValue;
#endif

#if ENABLE_REFLECTION_ON
			fixed4 reflcol = texCUBE (_Cube, IN.worldRefl); //玻璃部分法线有问题
			reflcol *= tex.a;
			fixed4 _cubeMask = tex2D(_CubMaskDown, IN.uv_MainTex);
			half3 cubeFactor = _cubeMask.rgb * _CubValue;
			o.Emission = reflcol.rgb * _ReflectColor.rgb * cubeFactor;
			o.Albedo *= (1 - cubeFactor);

			o.Alpha = reflcol.a * _ReflectColor.a;
#endif

#if ENABLE_BUMP_ON
			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_MainTex));
#endif

#if ENABLE_SPECULAR_ON
			o.Gloss = tex.a;
			float4 specMask = tex2D(_SpecularMask, IN.uv_MainTex) * _SpecularColor;
			o.Specular = _Shininess;
			o.SpecularColor = specMask.rgb;
#endif
		}
		

// vertex-to-fragment interpolation data
// no lightmaps:
#ifndef LIGHTMAP_ON
struct v2f_surf {
  float4 pos : SV_POSITION;
  float2 pack0 : TEXCOORD0; // _MainTex
  float4 tSpace0 : TEXCOORD1;
  float4 tSpace1 : TEXCOORD2;
  float4 tSpace2 : TEXCOORD3;
  float3 worldViewDir : TEXCOORD4;
  fixed3 vlight : TEXCOORD5; // ambient/SH/vertexlights
  SHADOW_COORDS(6)
  UNITY_FOG_COORDS(7)
  #if SHADER_TARGET >= 30
  float4 lmap : TEXCOORD8;
  #endif
  DUAL_PARABOLOID_ATTRIBUTE(8, 9)
  UNITY_VERTEX_INPUT_INSTANCE_ID
  UNITY_VERTEX_OUTPUT_STEREO
};
#endif
// with lightmaps:
#ifdef LIGHTMAP_ON
struct v2f_surf {
  float4 pos : SV_POSITION;
  float2 pack0 : TEXCOORD0; // _MainTex
  float4 tSpace0 : TEXCOORD1;
  float4 tSpace1 : TEXCOORD2;
  float4 tSpace2 : TEXCOORD3;
  float3 worldViewDir : TEXCOORD4;
  float4 lmap : TEXCOORD5;
  SHADOW_COORDS(6)
  UNITY_FOG_COORDS(7)
  DUAL_PARABOLOID_ATTRIBUTE(8, 9)
  UNITY_VERTEX_INPUT_INSTANCE_ID
  UNITY_VERTEX_OUTPUT_STEREO
};
#endif
float4 _MainTex_ST;

// vertex shader
v2f_surf vert_surf (appdata_full v) {
  UNITY_SETUP_INSTANCE_ID(v);
  v2f_surf o;
  UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
  UNITY_TRANSFER_INSTANCE_ID(v,o);
  UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

  TRANSFER_VERTEX_TO_DUAL_PARABOLOID_SURF(o, v.vertex);
  o.pos = UnityObjectToClipPos(v.vertex);

  o.pack0.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
  float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
  fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);
  fixed3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
  fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;
  fixed3 worldBinormal = cross(worldNormal, worldTangent) * tangentSign;
  o.tSpace0 = float4(worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x);
  o.tSpace1 = float4(worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y);
  o.tSpace2 = float4(worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z);
  float3 viewDirForLight = UnityWorldSpaceViewDir(worldPos);
#ifndef LIGHTMAP_ON
  float3 worldLightDir = UnityWorldSpaceLightDir(worldPos);
  _SpecularColor = _LightColor0;
  _LightDir = half4(worldLightDir, 0);
#else
  _LightDir = -_LightDir; //获得的是Directional light物体的光照方向，反转,获得需要的光照方向
  _LightDir.w = 0.0; //direction light's pos
  float3 worldLightDir = normalize(_LightDir);
#endif
  viewDirForLight = normalize(normalize(viewDirForLight) + normalize(worldLightDir));
  o.worldViewDir = viewDirForLight;
  #ifdef DYNAMICLIGHTMAP_ON
  o.lmap.zw = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
  #endif
  #ifdef LIGHTMAP_ON
  o.lmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
  #endif

  // SH/ambient and vertex lights
  #ifndef LIGHTMAP_ON
  o.vlight = 0.0;
  #if UNITY_SHOULD_SAMPLE_SH
  float3 shlight = ShadeSH9 (float4(worldNormal,1.0));
  o.vlight = shlight;
  #else
  o.vlight = 0.0;
  #endif
  #ifdef VERTEXLIGHT_ON
  o.vlight += Shade4PointLights (
    unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
    unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb,
    unity_4LightAtten0, worldPos, worldNormal );
  #endif // VERTEXLIGHT_ON
  #endif // !LIGHTMAP_ON

  TRANSFER_SHADOW(o); // pass shadow coordinates to pixel shader
  UNITY_TRANSFER_FOG(o,o.pos); // pass fog coordinates to pixel shader
  return o;
}

// fragment shader
fixed4 frag_surf (v2f_surf IN) : SV_Target {
  UNITY_SETUP_INSTANCE_ID(IN);
  // prepare and unpack data
  Input surfIN;
  UNITY_INITIALIZE_OUTPUT(Input,surfIN);

  DUAL_PARABOLOID_CLIP_DEPTH(IN)
#ifdef DUAL_PARABOLOID_ON
  fixed4 tex = tex2D(_MainTex, IN.pack0.xy);
  fixed4 dualColor = tex * _Color;
#ifdef LIGHTMAP_ON
  fixed3 dualLm = DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, IN.lmap.xy));
  dualColor.rgb *= dualLm;
#endif
  return dualColor;
#endif

  surfIN.uv_MainTex.x = 1.0;
  surfIN.worldRefl.x = 1.0;
  surfIN.uv_MainTex = IN.pack0.xy;
  float3 worldPos = float3(IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w);
  //#ifndef USING_DIRECTIONAL_LIGHT
  //  fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
  //#else
  //  fixed3 lightDir = _WorldSpaceLightPos0.xyz;
  //#endif
#ifndef LIGHTMAP_ON
  _SpecularColor = _LightColor0;
  _LightDir = half4(UnityWorldSpaceLightDir(worldPos), 0);
#else
  _LightDir = -_LightDir; //获得的是Directional light物体的光照方向，反转,获得需要的光照方向
  _LightDir.w = 0.0; //direction light's pos
#endif
  fixed3 lightDir = normalize(_LightDir);
  fixed3 worldViewDir = normalize(IN.worldViewDir);

  float3 viewDir = UnityWorldSpaceViewDir(worldPos);
  surfIN.worldRefl = reflect(-viewDir, fixed3(IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z));

  surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
  surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
  surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
  #ifdef UNITY_COMPILER_HLSL
  SurfaceCustomOutput o = (SurfaceCustomOutput)0;
  #else
  SurfaceCustomOutput o;
  #endif
  o.Albedo = 0.0;
  o.Emission = 0.0;
#if ENABLE_SPECULAR_ON
  o.Specular = 0.0;
#endif
  o.Alpha = 0.0;
  fixed3 normalWorldVertex = fixed3(0,0,1);

  // call surface function
  surf (surfIN, o);

  // compute lighting & shadowing factor
  UNITY_LIGHT_ATTENUATION(atten, IN, worldPos)
  fixed4 c = 0;
#ifdef ENABLE_BUMP_ON
  fixed3 worldN;
  worldN.x = dot(IN.tSpace0.xyz, o.Normal);
  worldN.y = dot(IN.tSpace1.xyz, o.Normal);
  worldN.z = dot(IN.tSpace2.xyz, o.Normal);
  o.Normal = worldN;
#else
  o.Normal = fixed3(IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z);
#endif
  #ifndef LIGHTMAP_ON
  c.rgb += o.Albedo * IN.vlight;
  #endif // !LIGHTMAP_ON

  // lightmaps
  #ifdef LIGHTMAP_ON
    #if DIRLIGHTMAP_COMBINED
      // directional lightmaps
      fixed4 lmtex = UNITY_SAMPLE_TEX2D(unity_Lightmap, IN.lmap.xy);
      fixed4 lmIndTex = UNITY_SAMPLE_TEX2D_SAMPLER(unity_LightmapInd, unity_Lightmap, IN.lmap.xy);
      half3 lm = DecodeDirectionalLightmap (DecodeLightmap(lmtex), lmIndTex, o.Normal);
    #elif DIRLIGHTMAP_SEPARATE
      // directional with specular - no support
      half4 lmtex = 0;
      half3 lm = 0;
    #else
      // single lightmap
      fixed4 lmtex = UNITY_SAMPLE_TEX2D(unity_Lightmap, IN.lmap.xy);
      fixed3 lm = DecodeLightmap (lmtex);
    #endif

  #endif // LIGHTMAP_ON


  // realtime lighting: call lighting function
  #ifndef LIGHTMAP_ON
	//c += fixed4(o.Albedo * UNITY_LIGHTMODEL_AMBIENT.xyz, 1.0 );
	c += LightingMobileBlinnPhong (o, lightDir, worldViewDir, atten);
	c.a = o.Alpha;
	o.Emission *= atten;
  #else
	c += LightingMobileBlinnPhong(o, lightDir, worldViewDir, lm);
    c.a = o.Alpha;
	o.Emission *= lm;
#endif

  #ifdef LIGHTMAP_ON

#if ENABLE_BUMP_ON
	fixed diff = abs(dot(o.Normal, lightDir));
	fixed4 worldNormal = fixed4(IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z, 0);
	diff = pow(diff, 3);
	diff = lerp(1, diff, abs(dot(worldNormal, lightDir)));
	o.Albedo *= diff * _BumpScale;
#endif

    // combine lightmaps with realtime shadows
    #ifdef SHADOWS_SCREEN
      #if defined(UNITY_NO_RGBM)
      c.rgb += o.Albedo * min(lm, atten*2);
      #else
      c.rgb += o.Albedo * max(min(lm,(atten*2)*lmtex.rgb), lm*atten);
      #endif
    #else // SHADOWS_SCREEN
      c.rgb += o.Albedo * lm;
    #endif // SHADOWS_SCREEN
  #endif // LIGHTMAP_ON

  #ifdef DYNAMICLIGHTMAP_ON
  fixed4 dynlmtex = UNITY_SAMPLE_TEX2D(unity_DynamicLightmap, IN.lmap.zw);
  c.rgb += o.Albedo * DecodeRealtimeLightmap (dynlmtex);
  #endif

  c.rgb += o.Emission;
  UNITY_APPLY_FOG(IN.fogCoord, c); // apply fog
  UNITY_OPAQUE_ALPHA(c.a);
  return c;
}

ENDCG

}

//#ifndef LIGHTMAP_ON
Pass{
	Tags{ "LightMode" = "ForwardAdd" }
	Blend One One
	ZWrite Off
	Cull Off

	CGPROGRAM
	// compile directives
#pragma vertex vert_surf
#pragma fragment frag_surf
#pragma multi_compile_fwdadd
#pragma shader_feature ENABLE_REFLECTION_ON
#pragma shader_feature ENABLE_GLOW_ON
#pragma shader_feature ENABLE_BUMP_ON
#pragma shader_feature ENABLE_SPECULAR_ON
#include "HLSLSupport.cginc"
#include "UnityShaderVariables.cginc"
	// Surface shader code generated based on:
	// writes to per-pixel normal: YES
	// writes to emission: YES
	// writes to occlusion: no
	// needs world space reflection vector: YES
	// needs world space normal vector: no
	// needs screen space position: no
	// needs world space position: no
	// needs view direction: no
	// needs world space view direction: no
	// needs world space position for lighting: no
	// needs world space view direction for lighting: YES
	// needs world space view direction for lightmaps: no
	// needs vertex color: no
	// needs VFACE: no
	// passes tangent-to-world matrix to pixel shader: YES
	// reads from normal: no
	// 1 texcoords actually used
	//   float2 _MainTex
#include "UnityCG.cginc"
#include "Lighting.cginc"
#include "AutoLight.cginc"

#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
#define WorldNormalVector(data,normal) fixed3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))

	// Original surface shader snippet:
//#line 19 ""
//#ifdef DUMMY_PREPROCESSOR_TO_WORK_AROUND_HLSL_COMPILER_LINE_HANDLING
//#endif
	/* UNITY: Original start of shader */
	//#pragma surface surf MobileBlinnPhong exclude_path:prepass noforwardadd halfasview interpolateview //nolightmap 

	sampler2D _MainTex;
#if ENABLE_REFLECTION_ON
	samplerCUBE _Cube;
	sampler2D _CubMaskDown;
	fixed _CubValue;
	fixed4 _ReflectColor;
#endif

#if ENABLE_GLOW_ON
	sampler2D _Glow;
	fixed _GlowValue;
#endif
	fixed4 _LightDir;
	float4 _SpecularColor;

#if ENABLE_SPECULAR_ON
	sampler2D _SpecularMask;
	half _Shininess;
	fixed _Gloss;
#endif

#if ENABLE_BUMP_ON
	sampler2D _BumpMap;
	float _BumpScale;
#endif

	fixed4 _Color;

	struct Input {
		float2 uv_MainTex;
		float3 worldRefl;
		INTERNAL_DATA
	};

	struct SurfaceCustomOutput
	{
		fixed3 Albedo;
		fixed3 Normal;
		fixed3 Emission;
#if ENABLE_SPECULAR_ON
		fixed3 SpecularColor;
		half Specular;
		fixed Gloss;
#endif
		fixed Alpha;
	};

inline fixed4 LightingMobileBlinnPhong(SurfaceCustomOutput s, fixed3 lightDir, fixed3 halfDir, fixed atten)
{
	fixed diff = max(0, dot(s.Normal, lightDir));
	fixed4 c = fixed4(0, 0, 0, 1);
#ifndef LIGHTMAP_ON
	c.rgb = s.Albedo * _SpecularColor.rgb * diff * atten;
#endif
#if ENABLE_SPECULAR_ON
	fixed nh = max(0, dot(s.Normal, halfDir));
	fixed spec = pow(nh, s.Specular * 128) * s.Gloss;
	float3 finalSpec = s.SpecularColor * spec * _Gloss;
	c.rgb += _SpecularColor.rgb * finalSpec * atten;
#endif
	UNITY_OPAQUE_ALPHA(c.a);
	return c;
}

void surf(Input IN, inout SurfaceCustomOutput o) {
	fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
	fixed4 c = tex;
	o.Albedo = c.rgb * _Color;

#if ENABLE_GLOW_ON
	o.Albedo = o.Albedo + tex2D(_Glow, IN.uv_MainTex) * _GlowValue;
#endif

#if ENABLE_REFLECTION_ON
	fixed4 reflcol = texCUBE(_Cube, IN.worldRefl); //玻璃部分法线有问题
	reflcol *= tex.a;
	fixed4 _cubeMask = tex2D(_CubMaskDown, IN.uv_MainTex);
	//o.Emission = reflcol.rgb * _ReflectColor.rgb * _cubeMask.rgb * _CubValue;
	o.Emission = fixed4(0, 0, 0, 1);
	o.Alpha = reflcol.a * _ReflectColor.a;
#endif

#if ENABLE_BUMP_ON
	o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_MainTex));
#endif

#if ENABLE_SPECULAR_ON
	o.Gloss = tex.a;
	float4 specMask = tex2D(_SpecularMask, IN.uv_MainTex) * _SpecularColor;
	o.Specular = _Shininess;
	o.SpecularColor = specMask.rgb;
#endif
}


// vertex-to-fragment interpolation data
// no lightmaps:
#ifndef LIGHTMAP_ON
struct v2f_surf {
	float4 pos : SV_POSITION;
	float2 pack0 : TEXCOORD0; // _MainTex
	float4 tSpace0 : TEXCOORD1;
	float4 tSpace1 : TEXCOORD2;
	float4 tSpace2 : TEXCOORD3;
	float3 worldViewDir : TEXCOORD4;
	fixed3 vlight : TEXCOORD5; // ambient/SH/vertexlights
	SHADOW_COORDS(6)
	UNITY_FOG_COORDS(7)
#if SHADER_TARGET >= 30
	float4 lmap : TEXCOORD8;
#endif
	UNITY_VERTEX_INPUT_INSTANCE_ID
	UNITY_VERTEX_OUTPUT_STEREO
};
#endif
// with lightmaps:
#ifdef LIGHTMAP_ON
struct v2f_surf {
	float4 pos : SV_POSITION;
	float2 pack0 : TEXCOORD0; // _MainTex
	float4 tSpace0 : TEXCOORD1;
	float4 tSpace1 : TEXCOORD2;
	float4 tSpace2 : TEXCOORD3;
	float3 worldViewDir : TEXCOORD4;
	float4 lmap : TEXCOORD5;
	SHADOW_COORDS(6)
	UNITY_FOG_COORDS(7)
	UNITY_VERTEX_INPUT_INSTANCE_ID
	UNITY_VERTEX_OUTPUT_STEREO
};
#endif
	float4 _MainTex_ST;

// vertex shader
v2f_surf vert_surf(appdata_full v) {
	UNITY_SETUP_INSTANCE_ID(v);
	v2f_surf o;
	UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
	UNITY_TRANSFER_INSTANCE_ID(v,o);
	UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
	o.pos = UnityObjectToClipPos(v.vertex);
	o.pack0.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
	float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
	fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);
	fixed3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
	fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;
	fixed3 worldBinormal = cross(worldNormal, worldTangent) * tangentSign;
	o.tSpace0 = float4(worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x);
	o.tSpace1 = float4(worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y);
	o.tSpace2 = float4(worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z);
	float3 viewDirForLight = UnityWorldSpaceViewDir(worldPos);
	float3 worldLightDir = UnityWorldSpaceLightDir(worldPos);
	viewDirForLight = normalize(normalize(viewDirForLight) + normalize(worldLightDir));
	o.worldViewDir = viewDirForLight;
#ifdef DYNAMICLIGHTMAP_ON
	o.lmap.zw = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
#endif
#ifdef LIGHTMAP_ON
	o.lmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
#endif

	// SH/ambient and vertex lights
	o.vlight = 0.0;

	TRANSFER_SHADOW(o); // pass shadow coordinates to pixel shader
	UNITY_TRANSFER_FOG(o,o.pos); // pass fog coordinates to pixel shader
	return o;
}

// fragment shader
fixed4 frag_surf(v2f_surf IN) : SV_Target{
	UNITY_SETUP_INSTANCE_ID(IN);
	// prepare and unpack data
	Input surfIN;
	UNITY_INITIALIZE_OUTPUT(Input,surfIN);

    fixed4 tex = tex2D(_MainTex, IN.pack0.xy);
    return tex;

	surfIN.uv_MainTex.x = 1.0;
	surfIN.worldRefl.x = 1.0;
	surfIN.uv_MainTex = IN.pack0.xy;
	float3 worldPos = float3(IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w);
	#ifndef USING_DIRECTIONAL_LIGHT
		fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
	#else
		fixed3 lightDir = _WorldSpaceLightPos0.xyz;
	#endif
	#ifndef LIGHTMAP_ON
		_SpecularColor = _LightColor0;
		_LightDir = fixed4(lightDir, 0);
	#else
		lightDir = _LightDir.xyz;
	#endif
	fixed3 worldViewDir = normalize(IN.worldViewDir);
	surfIN.worldRefl = -worldViewDir;
	surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
	surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
	surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
	#ifdef UNITY_COMPILER_HLSL
	SurfaceCustomOutput o = (SurfaceCustomOutput)0;
	#else
	SurfaceCustomOutput o;
	#endif
	o.Albedo = 0.0;
	o.Emission = 0.0;
#if ENABLE_SPECULAR_ON
	o.Specular = 0.0;
#endif
	o.Alpha = 0.0;
	fixed3 normalWorldVertex = fixed3(0,0,1);

	// call surface function
	surf(surfIN, o);

	// compute lighting & shadowing factor
	UNITY_LIGHT_ATTENUATION(atten, IN, worldPos)
	fixed4 c = 0;
#if ENABLE_BUMP_ON
	fixed3 worldN;
	worldN.x = dot(IN.tSpace0.xyz, o.Normal);
	worldN.y = dot(IN.tSpace1.xyz, o.Normal);
	worldN.z = dot(IN.tSpace2.xyz, o.Normal);
	o.Normal = worldN;
#else
	o.Normal = fixed3(IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z);
#endif
	#ifndef LIGHTMAP_ON
	c.rgb += o.Albedo * IN.vlight;
	#endif // !LIGHTMAP_ON

	// lightmaps
	#ifdef LIGHTMAP_ON
	half4 lmtex = 0;
	half3 lm = 0;
	#endif // LIGHTMAP_ON


	// realtime lighting: call lighting function
	#ifndef LIGHTMAP_ON
		c += LightingMobileBlinnPhong(o, lightDir, worldViewDir, atten);
	#else
		c.a = o.Alpha;
	#endif

	c.rgb += o.Emission;
	UNITY_APPLY_FOG(IN.fogCoord, c); // apply fog
	UNITY_OPAQUE_ALPHA(c.a);
	return c;
}

ENDCG

}
//#endif

// ---- meta information extraction pass:
Pass{
	Name "Meta"
	Tags{ "LightMode" = "Meta" }
	Cull Off

	CGPROGRAM
	// compile directives
//#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
//#pragma skip_variants INSTANCING_ON
#pragma vertex vert_meta
#pragma fragment frag_meta2
#pragma shader_feature ENABLE_REFLECTION_ON
#pragma shader_feature ENABLE_GLOW_ON
#pragma shader_feature ENABLE_BUMP_ON
#pragma shader_feature ENABLE_SPECULAR_ON
//#pragma shader_feature _EMISSION
//#pragma shader_feature _METALLICGLOSSMAP
//#pragma shader_feature ___ _DETAIL_MULX2
#include "HLSLSupport.cginc"
#include "UnityShaderVariables.cginc"
	// Surface shader code generated based on:
	// writes to per-pixel normal: YES
	// writes to emission: YES
	// writes to occlusion: no
	// needs world space reflection vector: YES
	// needs world space normal vector: no
	// needs screen space position: no
	// needs world space position: no
	// needs view direction: no
	// needs world space view direction: no
	// needs world space position for lighting: no
	// needs world space view direction for lighting: YES
	// needs world space view direction for lightmaps: no
	// needs vertex color: no
	// needs VFACE: no
	// passes tangent-to-world matrix to pixel shader: YES
	// reads from normal: no
	// 1 texcoords actually used
	//   float2 _MainTex
//#define UNITY_PASS_META
#include "UnityCG.cginc"
#include "Lighting.cginc"
#include "UnityMetaPass.cginc"

#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
#define WorldNormalVector(data,normal) fixed3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))

	// Original surface shader snippet:
#line 19 ""
#ifdef DUMMY_PREPROCESSOR_TO_WORK_AROUND_HLSL_COMPILER_LINE_HANDLING
#endif
	/* UNITY: Original start of shader */
	//#pragma surface surf MobileBlinnPhong exclude_path:prepass noforwardadd halfasview interpolateview //nolightmap 

	sampler2D _MainTex;
#if ENABLE_REFLECTION_ON
	samplerCUBE _Cube;
	sampler2D _CubMaskDown;
	fixed _CubValue;
	fixed4 _ReflectColor;
#endif

#if ENABLE_GLOW_ON
	sampler2D _Glow;
	fixed _GlowValue;
#endif
	float4 _SpecularColor;

#if ENABLE_SPECULAR_ON
	sampler2D _SpecularMask;
	half _Shininess;
	fixed _Gloss;
#endif

#if ENABLE_BUMP_ON
	sampler2D _BumpMap;
#endif

	fixed4 _Color;

	struct Input {
		float2 uv_MainTex;
		float3 worldRefl;
		INTERNAL_DATA
	};

struct SurfaceCustomOutput
{
	fixed3 Albedo;
	fixed3 Normal;
	fixed3 Emission;
#if ENABLE_SPECULAR_ON
	fixed3 SpecularColor;
	half Specular;
	fixed Gloss;
#endif
	fixed Alpha;
};

inline fixed4 LightingMobileBlinnPhong(SurfaceCustomOutput s, fixed3 lightDir, fixed3 halfDir, fixed atten)
{
	fixed diff = max(0, dot(s.Normal, lightDir));

	fixed4 c = fixed4(0, 0, 0, 1);
#ifndef LIGHTMAP_ON
	c.rgb = s.Albedo * _SpecularColor.rgb * diff * atten;
#endif
#if ENABLE_SPECULAR_ON
	fixed nh = max(0, dot(s.Normal, halfDir));
	fixed spec = pow(nh, s.Specular * 128) * s.Gloss;
	float3 finalSpec = s.SpecularColor * spec * _Gloss;
	c.rgb += _SpecularColor.rgb * finalSpec * atten;
#endif

	UNITY_OPAQUE_ALPHA(c.a);
	return c;
}

void surf(Input IN, inout SurfaceCustomOutput o) {
	fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
	fixed4 c = tex;
	o.Albedo = c.rgb * _Color;

#if ENABLE_GLOW_ON
	o.Albedo = o.Albedo + tex2D(_Glow, IN.uv_MainTex) * _GlowValue;
#endif
	//o.Albedo = fixed4(0, 0, 0, 1);

#if ENABLE_REFLECTION_ON
	fixed4 reflcol = texCUBE(_Cube, IN.worldRefl); //玻璃部分法线有问题
	reflcol *= tex.a;
	fixed4 _cubeMask = tex2D(_CubMaskDown, IN.uv_MainTex);
	o.Emission = reflcol.rgb * _ReflectColor.rgb*_cubeMask.rgb * _CubValue;
	o.Alpha = reflcol.a * _ReflectColor.a;
#endif

#if ENABLE_BUMP_ON
	o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_MainTex));
#endif

#if ENABLE_SPECULAR_ON
	o.Gloss = tex.a;
	float4 specMask = tex2D(_SpecularMask, IN.uv_MainTex) * _SpecularColor;
	o.Specular = _Shininess;
	o.SpecularColor = specMask.rgb;
#endif
}

// vertex-to-fragment interpolation data
struct v2f_surf {
	float4 pos : SV_POSITION;
	float2 pack0 : TEXCOORD0; // _MainTex
	float4 tSpace0 : TEXCOORD1;
	float4 tSpace1 : TEXCOORD2;
	float4 tSpace2 : TEXCOORD3;
};
float4 _MainTex_ST;

// vertex shader
v2f_surf vert_meta(appdata_full v) {
	v2f_surf o;
	UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
	o.pos = UnityMetaVertexPosition(v.vertex, v.texcoord1.xy, v.texcoord2.xy, unity_LightmapST, unity_DynamicLightmapST);
	o.pack0.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
	float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
	fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);
	fixed3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
	fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;
	fixed3 worldBinormal = cross(worldNormal, worldTangent) * tangentSign;
	o.tSpace0 = float4(worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x);
	o.tSpace1 = float4(worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y);
	o.tSpace2 = float4(worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z);
	return o;
}

// fragment shader
fixed4 frag_meta2(v2f_surf IN) : SV_Target{
	// prepare and unpack data
	Input surfIN;
	UNITY_INITIALIZE_OUTPUT(Input,surfIN);
	surfIN.uv_MainTex.x = 1.0;
	surfIN.worldRefl.x = 1.0;
	surfIN.uv_MainTex = IN.pack0.xy;
	float3 worldPos = float3(IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w);
	#ifndef USING_DIRECTIONAL_LIGHT
	fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
	#else
	fixed3 lightDir = _WorldSpaceLightPos0.xyz;
	#endif
	fixed3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
	worldViewDir = normalize(worldViewDir + lightDir);
	surfIN.worldRefl = -worldViewDir;
	surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
	surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
	surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
	#ifdef UNITY_COMPILER_HLSL
	SurfaceCustomOutput o = (SurfaceCustomOutput)0;
	#else
	SurfaceCustomOutput o;
	#endif
	o.Albedo = 0.0;
	o.Emission = 0.0;
#if ENABLE_SPECULAR_ON
	o.Specular = 0.0;
#endif
	o.Alpha = 0.0;
	fixed3 normalWorldVertex = fixed3(0,0,1);

	// call surface function
	surf(surfIN, o);
	UnityMetaInput metaIN;
	UNITY_INITIALIZE_OUTPUT(UnityMetaInput, metaIN);
	//metaIN.Albedo = tex2D(_MainTex, IN.pack0.xy).rgb * _Color.rgb;
	metaIN.Albedo = 0;
	metaIN.Emission = 0;
	//metaIN.Albedo = o.Albedo;
	//metaIN.Emission = o.Emission;
	return UnityMetaFragment(metaIN);
}

ENDCG

}

	// ---- end of surface shader generated code

//#LINE 90

	}
//	
//
//	SubShader 
//	{
//			Lod 30
//			Pass 
//			{
//				Lighting Off
//				SetTexture [_MainTex] 
//				{
//					Combine texture, texture 
//				}
//			}
//	}


//	FallBack "Reflective/VertexLit"
	Fallback "Legacy Shaders/Diffuse"
	} 

