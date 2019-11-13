Shader "TopCar/Env/Terrain 3 Textures" {
Properties {
	_Splat0 ("Layer 1", 2D) = "white" {}
	_Splat1 ("Layer 2", 2D) = "white" {}
	_Splat2 ("Layer 3", 2D) = "white" {}
	_Tiling3("_Tiling4 x/y", Vector)=(1,1,0,0)
	_Control ("Control (RGBA)", 2D) = "white" {}
	_MainTex ("Never Used", 2D) = "white" {}
	//_ColorBrightness("Color Brightness", Range(0.01, 2)) = 1
}
                
SubShader {
	Tags {
   "SplatCount" = "3"
   "RenderType" = "Opaque"
	}
CGPROGRAM
#pragma surface surf Lambert
#pragma exclude_renderers xbox360 ps3


struct Input {
	float2 uv_Control : TEXCOORD0;
	float2 uv_Splat0 : TEXCOORD1;
	float2 uv_Splat1 : TEXCOORD2;
	float2 uv_Splat2 : TEXCOORD3;
};
 
sampler2D _Control;
sampler2D _Splat0,_Splat1,_Splat2;
float4 _Tiling3;
//float _ColorBrightness;
void surf (Input IN, inout SurfaceOutput o) {
	fixed4 splat_control = tex2D (_Control, IN.uv_Control).rgba;
		
	fixed3 lay1 = tex2D (_Splat0, IN.uv_Splat0);
	fixed3 lay2 = tex2D (_Splat1, IN.uv_Splat1);
	fixed3 lay3 = tex2D (_Splat2, IN.uv_Control*_Tiling3.xy);
	o.Alpha = 0.0;
	float total = splat_control.r + splat_control.g + splat_control.b;
	o.Albedo.rgb = (lay1 * splat_control.r / total + lay2 * splat_control.g / total + lay3 * splat_control.b / total)/* * _ColorBrightness*/;
}
ENDCG 
}
// Fallback to Diffuse
Fallback "Diffuse"
}
