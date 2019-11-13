#ifndef SPOTLIGHT_INCLUDED
#define SPOTLIGHT_INCLUDED

#include "UnityCG.cginc"


uniform fixed3 spotLightWorldPos;
uniform fixed3 spotLightDirection;
uniform fixed spotCutOff;   //radius
uniform fixed3 spotLightColor;
uniform fixed spotLightRange;   //����
uniform fixed spotLightIntensity;   //�ƹ�ǿ��

fixed3 SpotLightColor(fixed3 worldPos, fixed3 worldNormal)
{
	fixed radianCutoff = spotCutOff;
	fixed cosThta = cos(radianCutoff);

	fixed3 spotDirection = worldPos - spotLightWorldPos;

	fixed3 dist = length(spotDirection);

	spotDirection = normalize(spotDirection);

	fixed currentCosThta = max(0.0, dot(spotDirection, spotLightDirection));
	//if (currentCosThta > cosThta)

		//if (dot(viewDirForLight, worldNormal) > 0.0)//Ϊ�˼��ټ����������˵����䵽����Ĺ�

			//Ϊ���þ۹�Ʊ�Ե��Ĺ⻬
	fixed diffuseIntensity = pow(max(0, currentCosThta - cosThta) / (1.0 - cosThta), 2);

	fixed atten = diffuseIntensity * spotLightIntensity * (max(0, spotLightRange - dist) / spotLightRange);

	return max(spotLightColor * atten, fixed3(0, 0, 0));

}
#endif
