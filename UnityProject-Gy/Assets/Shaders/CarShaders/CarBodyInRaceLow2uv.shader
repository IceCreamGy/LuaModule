// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "TopCar/Car/CarBodyInRaceLow2uv" {
	Properties {
		_Color("Diffuse Material Color (RGB)", Color) = (1,1,1,1)
		_MainTex("Diffuse Texture", 2D) = "white" {}
	    _CarPaintColor("Car Paint Color (RGB)，车漆颜色1", Color) = (1,1,1,1)
		_CarPaintColor2("Car Paint Color (RGB)，车漆颜色2", Color) = (1,1,1,1)

		_DecalPaintTex("Decal Paint Texture，车辆贴花纹理，A与车漆颜色混合(0:车漆颜色，1：贴花颜色)", 2D) = "black" {}

		_SpecColor1("Specular Material Color (RGB)", Color) = (1,1,1,1)
		_SpecularMap("SPMap(RGBA) R明暗，G高光强度，B反射强度，A光滑度", 2D) = "white" {}
		_Shininess("Shininess", Range(0.01, 20)) = 1
		_Gloss("Gloss", Range(0.0, 10)) = 1
		_Smoothness("Smoothness", Range(0,1)) = 0.5
		//_RealReflectionSmoothness("Real-time Environment Reflection  Smoothness",Range(0,1)) = 1
		//_Cube("Reflection Map", Cube) = "_Skybox" {}
		//Material Capture纹理
		//_MatCap("MatCap", 2D) = "white" {}
		//_MatCapScale("MatCap Scale", Range(1,4)) = 1.8
		_Reflection("Reflection Power", Range(0.00, 1)) = 0
		//_FrezPow("Fresnel Power",Range(0,2)) = .25
		//_FrezFalloff("Fresnal Falloff",Range(0,10)) = 4
		//_FrezOffset("菲涅尔暗度",Range(0.4, 0.95)) = 0.5
		_Metallic("Metallic", Range(0.0, 1)) = 0
		//_EmissionScale("Emission Scale", Float) = 1
		//_EmissionColor("Emission Color(RGB)", Color) = (0, 0, 0, 0)
		//_EmissionTex("Emission Texture", 2D) = "black" {}
		[Toggle] Shlighting("_SHLighting?", Float) = 0
	}
	SubShader{
				Tags{ "QUEUE" = "Geometry" "RenderType" = "Opaque" " IgnoreProjector" = "True" "ExcludeBlurMask" = "True" }
				ColorMaterial AmbientAndDiffuse
				Pass{

				Tags{ "LightMode" = "ForwardBase" } // pass for 
													// 4 vertex lights, ambient light & first pixel light

				CGPROGRAM
	#pragma fragmentoption ARB_precision_hint_fastest
	#pragma multi_compile_fwdbase 
	#pragma vertex vert
	#pragma fragment frag
	#pragma multi_compile SHLIGHTING_OFF SHLIGHTING_ON 
	#pragma multi_compile SPOTLIGHT_OFF SPOTLIGHT_ON 
	#pragma multi_compile GHOST_OFF GHOST_ON
	#pragma target 3.0	
	#pragma glsl
			//	#pragma multi_compile USE_SPECULARMAP
			//#pragma exclude_renderers xbox360 ps3 d3d11 flash
			//#include "AutoLight.cginc"
#include "UnityCG.cginc"
#include "AutoLight.cginc"
#include "Lighting.cginc"
#ifdef SPOTLIGHT_ON
#include "../SpotLight.cginc"
#endif

		// User-specified properties
		uniform sampler2D _MainTex;
		uniform fixed4 _CarPaintColor;
		uniform fixed4 _CarPaintColor2;

		uniform sampler2D _DecalPaintTex;
		//uniform fixed4 _DecalPaintColor;
		//uniform sampler2D _DecalMaskPaintTex;

		uniform sampler2D _SpecularMap;
		//uniform sampler2D _AOTex;
		//uniform fixed4 _BumpMap_ST;	
		uniform float4	_MainTex_ST;
		uniform fixed4 _Color;
		uniform fixed _Reflection;
		uniform fixed4 _SpecColor1;
		uniform half _Shininess;
		uniform half _Gloss;
		uniform half _Metallic;
		uniform fixed _Smoothness;
		//uniform fixed _RealReflectionSmoothness;

		//uniform fixed4 _EmissionColor;
		//uniform sampler2D _EmissionTex;
		//uniform fixed _EmissionScale;


		struct vertexInput {
			float4 vertex : POSITION;
			fixed3 normal : NORMAL;
			float2 texcoord : TEXCOORD0;
			float2 texcoord1 : TEXCOORD1;
			//float4 tangent : TANGENT;
		};
		struct vertexOutput {
			float4 pos : SV_POSITION;
			float4 posWorld : TEXCOORD0;
			//fixed3 normalDir : TEXCOORD1;
			fixed3 vertexLighting : TEXCOORD1;
			float2 tex : TEXCOORD2;
			float2 tex1 : TEXCOORD3;
			fixed3 viewDir : TEXCOORD4;
			float3 normalWorld : TEXCOORD5;
			//float3 tangentWorld : TEXCOORD5;
			//float3 binormalWorld : TEXCOORD6;
			//float2 matCapCoord: TEXCOORD5;
#ifdef SHLIGHTING_ON
			fixed3  SHLighting : COLOR;
#endif
		};

		half NssPow(half base, half power)
		{
			return pow(max(0.001, base), power + 0.01);
		}

		fixed4 frag_func_simple(vertexOutput input)
		{
			//Calculate normal direction
			float3 normalDirection = input.normalWorld;   //normalize(mul(localCoords, local2WorldTranspose));

			float _Roughness = _Smoothness;
			fixed3 viewDirection = normalize(
				_WorldSpaceCameraPos.xyz - input.posWorld.xyz);
			fixed3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
			fixed attenuation = 1.0; // no attenuation

			fixed4 mainTexColor = tex2D(_MainTex, input.tex.xy * _MainTex_ST.xy + _MainTex_ST.zw);
			//fixed4 maskTexColor = tex2D(_MaskTex, input.tex.xy);
			//fixed4 aoTexColor = tex2D(_AOTex, input.tex.xy);
			fixed4 SpTexColor = tex2D(_SpecularMap, input.tex.xy);
			fixed AO = SpTexColor.r;
			_Roughness *= SpTexColor.a;

			//获得车漆颜色,_CarPaintColor[0.5 - 1],_CarPaintColor2[0 - 0.5]
			fixed4 carPaintColor = step(0.5, mainTexColor.a) * _CarPaintColor + step(mainTexColor.a, 0.5) * _CarPaintColor2;
			fixed mainTexBlendFactor = (mainTexColor.a - step(0.5, mainTexColor.a) * 0.5) / 0.5;
			fixed4 displayColor = saturate(lerp(mainTexColor * _Color, carPaintColor, mainTexBlendFactor));

			//车贴花颜色
			fixed4 decalTexColor = tex2D(_DecalPaintTex, input.tex1.xy);
			//fixed4 decalMaskTexColor = tex2D(_DecalMaskPaintTex, input.tex1.xy);

			//和第2套纹理的mask图做混合后的颜色
			//decalTexColor.rgb = saturate(lerp(decalTexColor.rgb, _DecalPaintColor.rgb, decalMaskTexColor.r));
			displayColor.rgb = saturate(lerp(displayColor.rgb, decalTexColor.rgb, decalTexColor.a));

			fixed4 textureColor = displayColor * clamp((1.0f - _Metallic / 2), 0.5f, 1.0f) * AO;
#ifdef GHOST_ON
			textureColor = fixed4(1 - textureColor.r, 1 - textureColor.g, 1 - textureColor.b, textureColor.a);
#endif
#ifdef	SHLIGHTING_ON
			textureColor.rgb *= input.SHLighting;
#endif
			//sparkle texture end

			fixed3 ambientLighting = UNITY_LIGHTMODEL_AMBIENT.xyz * _Color.xyz;


			fixed3 specularReflection;

			half spec = SpTexColor.g;

			if (dot(normalDirection, lightDirection) < 0.0)
			{
				specularReflection = fixed3(0.0, 0.0, 0.0);
			}
			else // light source on the right side
			{
				specularReflection = spec /** (_LightColor0.xyz)*/
					* (_SpecColor1.xyz) * pow(max(0.0, dot(
						reflect(-lightDirection, normalDirection),
						viewDirection)), _Shininess) * _Gloss * _Roughness;

				//specularReflection *= (vFlakesNormal * _FlakePower * _paintColor2);
			}

			fixed4 color = fixed4(textureColor + specularReflection, 1.0f); 

			return color;
		}

		vertexOutput vert(vertexInput v)
		{
			vertexOutput o;

			o.posWorld = mul(unity_ObjectToWorld, v.vertex);
			//o.normalDir = normalize(fixed3(mul(fixed4(input.normal, 0.0), unity_WorldToObject).xyz));

			o.tex = v.texcoord;
			o.tex1 = v.texcoord1;
			o.pos = UnityObjectToClipPos(v.vertex);

			o.viewDir = normalize(mul(unity_ObjectToWorld, v.vertex) - fixed4(_WorldSpaceCameraPos.xyz, 1.0)).xyz;

			o.normalWorld = normalize(mul(unity_ObjectToWorld, float4(v.normal, 0.0)).xyz);
			//o.tangentWorld = normalize(mul(unity_ObjectToWorld, half4(half3(v.tangent.xyz), 0)));
			//o.binormalWorld = normalize(cross(o.normalWorld, o.tangentWorld));

			// Diffuse reflection by four "vertex lights"            
			o.vertexLighting = fixed3(0.0, 0.0, 0.0);

#ifdef SHLIGHTING_ON
			o.SHLighting = ShadeSH9(float4(o.normalWorld, 1));
#endif
			//TRANSFER_VERTEX_TO_FRAGMENT(o);			   
			return o;
		}

		fixed4 frag(vertexOutput input) : COLOR
		{
			fixed4 color = frag_func_simple(input);

			//fixed3 emissionClr = _EmissionColor.rgb * tex2D(_EmissionTex, input.tex.xy).rgb * _EmissionScale;
			//color.rgb += emissionClr;

#ifdef SPOTLIGHT_ON
			fixed3 spotColor = SpotLightColor(input.posWorld, input.normalWorld);
			color.rgb += spotColor;
#endif

			return color;
		}
		ENDCG
	}
}
	FallBack "Diffuse"
}
