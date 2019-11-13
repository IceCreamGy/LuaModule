// Upgrade NOTE: unity_Scale shader variable was removed; replaced 'unity_Scale.w' with '1.0'
// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

#ifndef ADVCAR_INCLUDED
#define ADVCAR_INCLUDED

#include "UnityCG.cginc"
#include "AutoLight.cginc"
#include "Lighting.cginc"

#define PARABOLOID_OFFSET 2.0
//#define FORCE_SINGLE_PARABOLOID

sampler2D _HdrEyeAdaptionTexture;

sampler2D _MirrorReflectionTex;

//sampler2D _CarReflectionMaskTex;

//trackSpecular lightDir
half3 _RoadSpecularLightLocalDir;


float4x4 _LightMatrix; // transform from world space to light camera's projection space
float4x4 _LightCamMat;
sampler2D _FastShadowMap;


half2 _FastShadowUVScale;
half2 _FastShadowUVOffset;

//half3 _lobbyCarLightDir;
//half3 _loobyCarLightColor;


half NssPow(half base,half power)
{
	return pow(max(0.001,base), power + 0.01);
}

half2 CalcShadowUV(half4 worldPos)
{
	half4	shadowCoord = mul(_LightMatrix, worldPos);
	half2 ShadowTexC = shadowCoord.xy / shadowCoord.w;
	ShadowTexC = ShadowTexC * 0.5f + half2(0.5f, 0.5f);
	return ShadowTexC;
}

// 旧的，不传与光源的距离，不做远处糊模处理，用于兼容老的材质
half3 ModulateShadow(half3 light, half2 ShadowTexC)
{
#ifdef ENABLE_ROAD_SHADOW
	
	half3 atten = tex2D(_FastShadowMap, ShadowTexC).rgb;
	return light * atten;
#else
	return light;
#endif
}

/*
half3 ModulateShadow(half3 light, half4 shadowCoord, half4 dis)
{
#ifdef ENABLE_ROAD_SHADOW
	half3 ShadowTexC = shadowCoord.xyz / shadowCoord.w;
	ShadowTexC = ShadowTexC * 0.5f + half3(0.5f, 0.5f, 0.5f);
	ShadowTexC = saturate(ShadowTexC);
	half3 atten = tex2D(_FastShadowMap, ShadowTexC.xy).rgb;

	half f = -dis.z;
	half3 shadow = lerp(atten, 1, (f-50.0)/15.0);
	shadow = saturate(shadow);

	return light * shadow;
#else
	return light;
#endif
}*/

half4 ParaboloidTransform( in half4 paraboloidPos)
{
#ifndef SHADER_API_GLES
	paraboloidPos.x = -paraboloidPos.x;
#endif
	paraboloidPos.z = -paraboloidPos.z;
	
	//paraboloidPos.z -= PARABOLOID_OFFSET;
	
	half len = length( paraboloidPos.xyz );
	paraboloidPos = paraboloidPos / len;

	paraboloidPos.z = paraboloidPos.z + 1.0;
	//multi 0.90 to reserve uv space
	paraboloidPos.xy = paraboloidPos.xy / paraboloidPos.z;

	//Finally we set the z value as the distance from the vertex to the origin of the paraboloid, scaled and biased by the near and far planes of the paraboloid 'camera'.
	paraboloidPos.z = len/10000.0;
	paraboloidPos.w = 1.0; 
	return paraboloidPos;
}

half2 GetParaboloidReflectionUV(half3 reflectionVector)
{
 #ifndef SHADER_API_GLES
	half3 coord = half3(-reflectionVector.x, reflectionVector.z, reflectionVector.y);
#else
	half3 coord = half3(reflectionVector.x, -reflectionVector.z, reflectionVector.y);
#endif

	//half3 coord = half3(-reflectionVector.x, reflectionVector.z, reflectionVector.y);
	
	
	half z = coord.z;
	
	
 
	z += 1.0;
	
	coord.xy /= z;
	coord.xy = coord.xy * 0.5 + 0.5;
	
 

	

	return coord.xy;
}



half3 FetchReflectionColor(sampler2D reflectionMap, half2 coord)
{
	float3 color = tex2D(reflectionMap, coord).rgb; 
	//float3 reflectionMask = tex2D(_CarReflectionMaskTex,coord).rgb;
	
	//return reflectionMask;
	 
	return max(float3(0.0,0.0,0.0),color);
}


half3 FetchReflectionColor(sampler2D reflectionMap, half2 coord, half2 distort)
{

	half2 refuv = coord + distort;
	float3 color = tex2D(reflectionMap, refuv).rgb; 
	//float3 reflectionMask = tex2D(_CarReflectionMaskTex,refuv).rgb;
 
	return max(float3(0.0,0.0,0.0),color);
}

bool ParaboloidDiscard(half4 paraboloidHemisphere)
{
    //keep uv in circle 1 radius
	return paraboloidHemisphere.z  > 0.0;	
	//return false;
	
}

half3 WorldSpaceLightDir( in half3 worldPos )
{
#ifndef USING_LIGHT_MULTI_COMPILE
	return _WorldSpaceLightPos0.xyz - worldPos * _WorldSpaceLightPos0.w;
#else
	#ifndef USING_DIRECTIONAL_LIGHT
	return _WorldSpaceLightPos0.xyz - worldPos;
	#else
	return _WorldSpaceLightPos0.xyz;
	#endif
#endif
}

half3 approximateFresnel(half3 specularFactor,half3 V,half3 H)
{
	half vdoth = max(0.0,dot(V,H));
	half e1 = -5.55473 * vdoth;
	half e2 = ( e1 - 6.98316) * vdoth;
	return specularFactor + (half3(1,1,1) - specularFactor) * NssPow(2,e2);
}
half GGXD(half3 N, half3 H,half roughness)
{ 
   half a = roughness * roughness;
   half ndoth = max(0.0,dot(N,H));
   half t = ndoth * ndoth * (a * a - 1) + 1;
   t = max(0.0001, t);
   return  a * a / (3.1415926 * t * t);
}

half GGXG(half3 N,half3 H,half3 L,half3 V, half roughness)
{  
   half k = (roughness + 1) / 2;
   k = k * k / 2;
   half ndoth = max(dot(N,H),0.0);
   half ndotv = max(dot(N,V),0.0);
   half ndotl = max(dot(N,L),0.0);
   half vdoth = max(dot(N,H),0.0);
   half G_V =  ndotv / (ndotv * ( 1 - k) + k);
   half G_L =  ndotl / (ndotl * ( 1 - k) + k);
   
   return G_L * G_V;
}

half3 torranceSparrowReflector_GGX(half3 N,half3 V,half3 L,half3 H, half3 specularFactor,half roughness)
{
	half3 cookColor;
	half D = GGXD(N,H,roughness);

	half G = GGXG(N,H,L,V,roughness);
	half3 F = approximateFresnel(specularFactor,V,H);
	cookColor = D * G * F;
	half vdotn = clamp(dot(V,N),0.00001,1.0f);
	cookColor /= (4.0 * vdotn);
	return cookColor;
}

half3 GetOutputDir(half3 inVec)
{
	half3 outVec = (inVec + 1.0) * 0.5;
	return outVec;
}





half _FogHorizontalNearDistance;
half _FogHorizontalFarDistance;

 

sampler2D _FogTexture;

half CalcCamDist(half4 vertex)
{
	half4 worldPos = mul(unity_ObjectToWorld,vertex);
	half4 viewPos = mul(UNITY_MATRIX_MV,vertex);
	half camHorizontalDist =  -viewPos.z;
	half factorHorizontal = (camHorizontalDist - _FogHorizontalNearDistance) / (_FogHorizontalFarDistance - _FogHorizontalNearDistance);
	return factorHorizontal;
}

		
half4 NssFog(half factorHorizontal,half4 finalColor)
{	
	half4 fogColor = tex2D(_FogTexture,half2(factorHorizontal,0.5));
	
	finalColor.rgb = lerp(finalColor.rgb ,fogColor.rgb, fogColor.a);  
	
	return finalColor;	
}


sampler2D samplerReflectionMap;
half4 samplerReflectionMap_ST;



void WriteTangentSpaceData (appdata_full v, out half3 ts0, out half3 ts1, out half3 ts2) {
	TANGENT_SPACE_ROTATION;
	ts0 = mul(rotation, unity_ObjectToWorld[0].xyz * 1.0);
	ts1 = mul(rotation, unity_ObjectToWorld[1].xyz * 1.0);
	ts2 = mul(rotation, unity_ObjectToWorld[2].xyz * 1.0);				
}

half2 EthansFakeReflection (half4 vtx) {
	half3 worldSpace = mul(unity_ObjectToWorld, vtx).xyz;
	worldSpace = (-_WorldSpaceCameraPos * 0.6 + worldSpace) * 0.07;
	return worldSpace.xz;
}


sampler2D _ReflectionTex;




//dynamicShadow
uniform float4x4 _SGameShadowMatrix;

uniform sampler2D _SGameShadowTexture;
			
 

float getShadowDepth(float2 uv)
{
	float4 c = tex2D(_SGameShadowTexture, uv);
	return DecodeFloatRGBA(c);
}
		
float sampleShadow(float3 coord,float fade)
{
	float shadowDepth = getShadowDepth(coord.xy);
	float shadowValue = 2 - exp((coord.z - shadowDepth) * fade);
	return clamp(shadowValue , -1.0 , 1);
}



	
float CalcShadow(float4 shadowPos,float bias,float fade,float _ShadowSoft)
{
	float3 coord = shadowPos.xyz / shadowPos.w;

	#if !defined(SHADER_API_D3D9) && !defined(SHADER_API_D3D11) && !defined(SHADER_API_D3D11_9X)
		coord = coord * 0.5 + 0.5;
	#else
		coord.xy = coord.xy * 0.5 + 0.5;
	#endif
	coord.z = coord.z - bias;
	 

	float texelSize = _ShadowSoft * 0.0009765625;
	  
	float shadow = sampleShadow(coord,fade);

	float3 coordAdd = coord;
	coordAdd.xy += float2(texelSize, texelSize);
	shadow += sampleShadow(coordAdd,fade);
	
 
	return shadow * 0.5;
}

				


			
#endif