#ifndef TUNNEL_COMMON
#define TUNNEL_COMMON

#include "UnityCG.cginc"
#include "AutoLight.cginc"
#include "Lighting.cginc"

struct appdata
{
	float4 vertex : POSITION;
	fixed3 normal : NORMAL;
	float2 uv_MainTex : TEXCOORD0;
};

struct pointv2f
{
	float4 pos : SV_POSITION;
	float3 posWorld : TEXCOORD0;
	fixed3 normalWorld : TEXCOORD1;
	float2 uv_MainTex : TEXCOORD2;

	LIGHTING_COORDS(3, 4)
};

//#ifdef POINT
//#define USER_LIGHT_ATTENUATION(destName, input, worldPos) \
//	unityShadowCoord3 lightCoord = mul(unity_WorldToLight, unityShadowCoord4(worldPos, 1)).xyz; \
//	fixed destName = (tex2D(_LightTexture0, dot(lightCoord, lightCoord).rr).UNITY_ATTEN_CHANNEL * SHADOW_ATTENUATION(input));
//#endif

fixed3 CalculatePointLightColor(pointv2f i,fixed3 lightColor, fixed lightAttenuation)
{
	fixed3 normalDirection = normalize(i.normalWorld);
	fixed attenuation = 1.0; // no attenuation

	fixed3 lightDirection = normalize(UnityWorldSpaceLightDir(i.posWorld)); //世界坐标系做光照计算
	fixed3 diffuseReflection =
		attenuation * lightColor.rgb
		* abs(dot(normalDirection, lightDirection));

	UNITY_LIGHT_ATTENUATION(atten, i, i.posWorld)
	//#ifdef POINT
	//	USER_LIGHT_ATTENUATION(atten, i, i.posWorld)
	//#else
	//	float atten = LIGHT_ATTENUATION(i); //获得点光距离衰减(没开阴影，没有阴影衰减)
	//#endif

#ifndef USING_DIRECTIONAL_LIGHT
	//float len = distance(i.posWorld, _WorldSpaceLightPos0);
	//atten /= (lightAttenuation * (1 + len + len * len));
#endif

	return saturate(diffuseReflection * atten);
}
#endif