#ifndef WETNESS_INCLUDED
#define WETNESS_INCLUDED

#include "UnityCG.cginc"

#ifdef WETNESS_ON
float _WetLevel;
float _WetSpecMaxScale;

#define DIFFUSE_REALTIME_WET_REFLECTION(diffuseMask) DiffuseRealTimeWetReflection(diffuseMask)
#define DIFFUSE_LIGHTMAP_WET_REFLECTION(specMask) DiffuseLightMapWetReflection(specMask)
#define SPEC_WET_REFLECTION(specIntensity) (min(specIntensity * lerp(1.0, 2.5, _WetLevel), _WetSpecMaxScale)) //高光系数可能超过了1.0

float DiffuseRealTimeWetReflection(float diffuseMask)
{
#ifndef LIGHTMAP_OFF
	return 1; //有light map不应该调用此函数
#else
	return lerp(1.0, 0.3, _WetLevel * diffuseMask);
#endif
}

float DiffuseLightMapWetReflection(float specMask)
{
#ifndef LIGHTMAP_OFF
	return lerp(1.0, 0.3, _WetLevel * (1 - specMask)); //高光强的地方尽量保持颜色不减弱，其它地方漫反射减弱;
#else
	return 1; //没有light map不应该调用此函数
#endif
}

#ifdef WET_FLOW

float _FlowSpeed;
float _FlowRefraction;
sampler2D _HeightWetness;
sampler2D _WaterBumpMap;
float _WetnessHeightMapInfluence;
float _WaterBumpScale;
float _FlowHeightScale;

sampler2D _RainRipples;
float _RainIntensity;
float _RippleAnimSpeed;
float4 _RippleWindSpeed;
float _RippleTiling;
float _RippleHeightScale;

inline float2 ComputeRipple(float2 UV, float CurrentTime, float Weight)
{
	float4 ripple = tex2D(_RainRipples, UV);

	ripple.yz = ripple.yz * 2 - 1; // Decompress Normal
	float DropFrac = frac(ripple.w + CurrentTime); // Apply time shift
	float TimeFrac = DropFrac - 1.0f + ripple.x;
	float DropFactor = saturate(0.2f + Weight * 0.8f - DropFrac);
	float FinalFactor = DropFactor * ripple.x * sin(clamp(TimeFrac * 9.0f, 0.0f, 3.0f) * 3.141592653589793);
	return ripple.yz * FinalFactor * 0.35f;
}

inline fixed3 AddWaterFlow(float2 MainUV, float2 flowDirection, float worlNormalY, float overallWetness)
{
	float2 flowUV = MainUV * _WaterBumpScale;
	float2 fracTime = frac(float2(_Time.y, _Time.y + 0.5));
	float fade = abs(fracTime.x * 2 - 1);
	flowDirection *= _FlowSpeed;
	float4 flowBump = tex2D(_WaterBumpMap, flowUV + fracTime.xx * flowDirection);
	flowBump = lerp(flowBump, tex2D(_WaterBumpMap, flowUV + fracTime.yy * flowDirection), fade);
	fixed3 finalflowBump = UnpackNormal(flowBump);
	worlNormalY = saturate(worlNormalY);
	//return fixed4(finalflowBump, 0);
	//return fixed4((1 - worlNormalY * worlNormalY) * overallWetness * float3(_FlowHeightScale, _FlowHeightScale, 1), 0);
	return lerp(float3(0, 0, 1), finalflowBump, (1 - worlNormalY * worlNormalY) * overallWetness * float3(_FlowHeightScale, _FlowHeightScale, 1));
}

inline float3 AddWaterFlowRipples(float i_wetFactor, float3 i_worldPos, float i_worldNormalFaceY)
{
	float4 Weights = _RainIntensity - float4(0, 0.25, 0.5, 0.75);
	Weights = saturate(Weights * 4);
	float animSpeed = _Time.y * _RippleAnimSpeed;
	float2 Ripple1 = ComputeRipple(i_worldPos.xz * _RippleTiling + float2(0.25f, 0.0f) + _RippleWindSpeed.xy * _Time.y, animSpeed, Weights.x);
	float2 Ripple2 = ComputeRipple(i_worldPos.xz * _RippleTiling + float2(-0.55f, 0.3f) + _RippleWindSpeed.zw * _Time.y, animSpeed * 0.71, Weights.y);
	float3 rippleNormal = float3(Weights.x * Ripple1.xy + Weights.y * Ripple2.xy, 1);
	// Blend and fade out Ripples
	return lerp(float3(0, 0, 1), rippleNormal, /*i_wetFactor * */i_wetFactor * _RippleHeightScale * i_worldNormalFaceY * i_worldNormalFaceY);
}

inline float2 ComputeWaterAccumulation(float i_puddlemask, float2 i_heightmask, float i_worlnormalface_y)
{
	float2 accumulatedWaters = float2(0, 0);
	accumulatedWaters.x = 1.0 - i_heightmask.x * _WetnessHeightMapInfluence;
	return accumulatedWaters;
}

inline float2 GetWetAnimationNoise(fixed2 uv, fixed3 worldNormalDir, float3x3  mW2T, float heightScale, fixed4 posWorld)
{
	fixed4 heightWetness = tex2D(_HeightWetness, uv);
	//float2 wetFactor = float2(0, 0);
	//Puddle heightWetness.g
	//Wetness heightWetness.b
	//wetFactor = ComputeWaterAccumulation(heightWetness.g, heightWetness.ar, worldNormalDir.y) * heightWetness.b;
	//return fixed4(wetFactor, 0, 0);

	//TANGENT_SPACE_ROTATION; //v2f字段名不一致,直接计算rotation
	float3 flowNormal = float3(1, 0.2, 1);
	float2 flowDirection = mul(mW2T, flowNormal).xy; //方便做UV动画
													 //flowDirection = flowDirection * 0.5 + 0.5;
													 //return fixed4(flowDirection, 0, 0);
	flowNormal = AddWaterFlow(uv, flowDirection, worldNormalDir.y, 1/*wetFactor.x*/);
	flowNormal = normalize(mul(flowNormal, mW2T));

	//flowNormal = flowNormal * 0.5 + 0.5;
	//return fixed4(flowNormal, 0);

	float3 rippleNormal = float3(0, 0, 1);
	rippleNormal = AddWaterFlowRipples(heightWetness.b * heightScale, posWorld, saturate(worldNormalDir.y));

	return flowNormal.xy * _FlowRefraction + rippleNormal.xy;
}

#endif

#ifdef WET_REFLECTION
half _RefRate;
fixed4 _RefColor;
fixed _RefLerp;
sampler2D _ReflectionTex;
half _RefDistortion;
fixed _LightFactor;
half _RefLodLevel;
inline fixed4 GetReflectColor(fixed4 clipPos, float2 aniNoise)
{
	float2 screenUV = clipPos.xy / clipPos.w;
	screenUV += aniNoise * _RefDistortion;
	//return tex2D(_ReflectionTex, screenUV);
	float4 uv = float4(screenUV, 0, screenUV.y * _RefLodLevel);
	return tex2Dlod(_ReflectionTex, uv);
}
inline fixed4 MixReflectTex(fixed4 mainTex, fixed4 refTex)
{
	fixed4 lerpValue = lerp(refTex, fixed4(_RefLerp, _RefLerp, _RefLerp, _RefLerp), _LightFactor);
	return lerp(mainTex, refTex * _RefColor * _RefRate, lerpValue);
}
#endif

#else
#define DIFFUSE_REALTIME_WET_REFLECTION(diffuseMask) 1
#define DIFFUSE_LIGHTMAP_WET_REFLECTION(specMask) 1
#define SPEC_WET_REFLECTION(specIntensity) 1
#endif

#endif
