// Upgrade NOTE: unity_Scale shader variable was removed; replaced 'unity_Scale.w' with '1.0'
// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

#ifndef CAR_INCLUDED
#define CAR_INCLUDED

#include "UnityCG.cginc"

uniform fixed carAlpha;

half NssPow(half base, half power)
{
	return pow(max(0.001, base), power + 0.01);
}

half specular_light(fixed3 lightDir, fixed viewDir, fixed3 normalDir, fixed gloss)
{
	fixed3 halfVector = normalize(lightDir + viewDir);//normalize转化成单位向量  
	half NdotH = saturate(dot(normalDir, halfVector));//如果x小于0返回 0;如果x大于1返回1;否则返回x;把x限制在0-1  

	half spec = NssPow(NdotH, gloss);

	return spec;
	//fixed3 specularReflection = _Shininess * spec * _SpecColor * _Roughness;
}

			
#endif