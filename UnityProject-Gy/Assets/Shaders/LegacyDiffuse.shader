Shader "TopCar/Legacy/Diffuse" {
Properties {
	_Color ("Main Color", Color) = (1,1,1,1)
	_MainTex ("Base (RGB)", 2D) = "white" {}
	//_BumpMap ("Normalmap", 2D) = "bump" {}
}

SubShader {
	Tags { "RenderType"="Opaque" }
	LOD 300

CGPROGRAM
#pragma surface surf Lambert noforwardadd vertex:surf_vert finalcolor:dual_color
#pragma multi_compile DUAL_PARABOLOID_OFF DUAL_PARABOLOID_ON
#pragma multi_compile SPOTLIGHT_OFF SPOTLIGHT_ON
#ifdef SPOTLIGHT_ON
#include "SpotLight.cginc"
#endif
#include "DualParaboloidMap.cginc"

sampler2D _MainTex;
fixed4 _Color;

struct Input {
    float4 pos;
    float2 uv_MainTex;
	float3 worldPos;
	float3 worldNormal;
    DUAL_PARABOLOID_ATTRIBUTE_SURF
};

void surf_vert(inout appdata_full v, out Input o) {
    UNITY_INITIALIZE_OUTPUT(Input, o);

    //maybe a little joke,have to translate to object space for surface shader
    TRANSFER_VERTEX_TO_DUAL_PARABOLOID_SURF(o, v.vertex);
#if defined(DUAL_PARABOLOID_ON) && defined(LIGHTMAP_ON)
    o.dualLmp = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
#endif
}

void dual_color(Input IN, SurfaceOutput o, inout fixed4 color)
{                   
#ifdef DUAL_PARABOLOID_ON
    DUAL_PARABOLOID_CLIP_DEPTH(IN)
    color = tex2D(_MainTex, IN.uv_MainTex) * _Color;
#ifdef LIGHTMAP_ON
    fixed4 lmtex = UNITY_SAMPLE_TEX2D(unity_Lightmap, IN.dualLmp);
    fixed3 lm = DecodeLightmap(lmtex);
    color.rgb *= lm;
#endif //LIGHTMAP_ON END
#endif //DUAL_PARABOLOID_ON END
}

void surf(Input IN, inout SurfaceOutput o) 
{
#ifdef DUAL_PARABOLOID_ON
    o.Albedo = fixed3(0, 0, 0);
    o.Alpha = 1;
    return;
#endif

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
