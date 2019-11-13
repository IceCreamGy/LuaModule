// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

//like HIGH but without FLAKES

Shader "TopCar/Env/Diffuse Emission" {
	Properties{
			_Color("Diffuse Material Color (RGB)", Color) = (1,1,1,1)
			_MainTex("Diffuse Texture", 2D) = "white" {}
			_EmissionColor("Emission Color(RGB)", Color) = (0, 0, 0, 0)
			_EmissionTex("Emission Texture", 2D) = "black" {}
			_EmissionScale("Emission Scale", Float) = 1

			[Space(20)]
			//是否限制mipmap level最大层级
			[Toggle(ENABLE_MIPMAP_CLAMP)]_Enable_Mipmap_Clamp("Enable mipmap level clamp", Float) = 0
			_MipmapMaxLevel("Max Mipmap Level,Max Value = log2(图片分辨率)", Range(0, 11)) = 5
		}
		SubShader{
			Tags{ "QUEUE" = "Geometry" "RenderType" = "Opaque" "IgnoreProjector" = "True" "ExcludeBlurMask" = "True" }
			ColorMaterial AmbientAndDiffuse
			Pass{

				Tags{ "LightMode" = "ForwardBase" } // pass for 
													// 4 vertex lights, ambient light & first pixel light

				CGPROGRAM
		#pragma fragmentoption ARB_precision_hint_fastest
		#pragma vertex vert
		#pragma fragment frag
		#pragma multi_compile_fwdbase 
		#pragma multi_compile SHLIGHTING_OFF SHLIGHTING_ON 
		#pragma shader_feature ENABLE_MIPMAP_CLAMP
		#pragma target 2.0
		#pragma glsl
				//#pragma multi_compile USE_SPECULARMAP
				//#pragma exclude_renderers xbox360 ps3 d3d11 flash
				//#include "AutoLight.cginc"
		#include "UnityCG.cginc"


			// User-specified properties
			uniform sampler2D _MainTex;
			uniform float4	_MainTex_ST;
			uniform float4 _MainTex_TexelSize;
			uniform fixed4 _Color;
			//自发光
			uniform fixed4 _EmissionColor;
			uniform sampler2D _EmissionTex;
			uniform fixed _EmissionScale;

			uniform half _MipmapMaxLevel;

			// The following built-in uniforms (except _LightColor0) 
			// are also defined in "UnityCG.cginc", 
			// i.e. one could #include "UnityCG.cginc" 
			uniform fixed4 _LightColor0;
			// color of light source (from "Lighting.cginc")

			struct vertexInput {
				float4 vertex : POSITION;
				fixed3 normal : NORMAL;
				float2 texcoord : TEXCOORD0;
			};
			struct vertexOutput {
				float4 pos : SV_POSITION;
				float2 tex : TEXCOORD0;
				float3 normalWorld : TEXCOORD1;
		#ifdef SHLIGHTING_ON
				fixed3  SHLighting : COLOR;
		#endif
			};

			half NssPow(half base, half power)
			{
				return pow(max(0.001, base), power + 0.01);
			}

			float mip_map_level(in float2 texture_coordinate) // in texel units
			{
				float2  dx_vtc = ddx(texture_coordinate);
				float2  dy_vtc = ddy(texture_coordinate);
				float delta_max_sqr = max(dot(dx_vtc, dx_vtc), dot(dy_vtc, dy_vtc));
				return 0.5 * log2(delta_max_sqr);
			}

			fixed4 frag_func_simple(vertexOutput input)
			{
#if ENABLE_MIPMAP_CLAMP
				float2 uv = input.tex.xy;
				float lod = mip_map_level(uv * _MainTex_TexelSize.zw);
				fixed4 uv4 = fixed4(uv, 0, clamp(lod, 0, _MipmapMaxLevel));
				return tex2Dlod(_MainTex, uv4) * _Color;
#else
				fixed4 mainTexColor = tex2D(_MainTex, input.tex.xy * _MainTex_ST.xy + _MainTex_ST.zw);
				return mainTexColor * _Color;
#endif
			}

			vertexOutput vert(vertexInput v)
			{
				vertexOutput o;
				o.tex = v.texcoord;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.normalWorld = normalize(mul(unity_ObjectToWorld, float4(v.normal, 0.0)).xyz);
		#ifdef SHLIGHTING_ON
				o.SHLighting = ShadeSH9(float4(o.normalWorld, 1));
		#endif		   
				return o;
			}

			fixed4 frag(vertexOutput input) : COLOR
			{
				fixed4 color = frag_func_simple(input);
		#ifdef SHLIGHTING_ON
				color.rgb *= input.SHLighting;
		#endif
				fixed3 emissionClr = _EmissionColor.rgb * tex2D(_EmissionTex, input.tex.xy).rgb * _EmissionScale;
				color.rgb += emissionClr;

				return color;

			}
			ENDCG
			}
		}
		// The definition of a fallback shader should be commented out 
		// during development:
		Fallback "Diffuse"
}