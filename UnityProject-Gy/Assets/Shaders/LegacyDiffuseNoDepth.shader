Shader "TopCar/Legacy/DiffuseNoDepth" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_MainTex ("Base (RGB)", 2D) = "white" {}
}

SubShader {
	Tags { "RenderType"="Opaque" "QUEUE" = "Geometry-1" }
	LOD 300

	ZWrite Off

CGPROGRAM
#pragma surface surf Lambert noforwardadd
#pragma multi_compile SPOTLIGHT_OFF SPOTLIGHT_ON
#ifdef SPOTLIGHT_ON
#include "SpotLight.cginc"
#endif

sampler2D _MainTex;
fixed4 _Color;

struct Input {
	float2 uv_MainTex;
	float3 worldPos;
	float3 worldNormal;
};

void surf (Input IN, inout SurfaceOutput o) {
	fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
#ifdef SPOTLIGHT_ON
	c.rgb += SpotLightColor(IN.worldPos, IN.worldNormal);
#endif
	o.Albedo = c.rgb;
	o.Alpha = c.a;
}
ENDCG  
}

FallBack "Legacy Shaders/Diffuse"
}
