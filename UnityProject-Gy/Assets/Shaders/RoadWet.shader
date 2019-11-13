Shader "TopCar/Env/RoadWet"
{
	Properties
	{
		_Color("Main Color", Color) = (1,1,1,1)
		_MainTex("Base (RGB) Gloss (A)", 2D) = "white" {}
		_SPMask("Specular mask", 2D) = "white" {}
		_SpecColor("Specular Color", Color) = (0.5, 0.5, 0.5, 1)
		_Shininess("Shininess", Range(0.1, 10)) = 1
		_Gloss("Gloss", Range(0.0, 100)) = 1
		_BumpMap("Normalmap", 2D) = "bump" {}
		_LightDir("Direction light direction", Vector) = (0, 1.0, 0)

		_WetLevel("Wet level", Range(0,1)) = 0
		_WetSpecMaxScale("Wet Specular Scale", Range(0,5)) = 5

		_HeightWetness("Heightmap(A) Puddle Noise(R)", 2D) = "white" {}
		_WetnessHeightMapInfluence("Wetness HeightMap Influence", Float) = 1.0
		_FlowSpeed("Water Flow Speed", Float) = 1
		_FlowRefraction("Water Flow Refraction", Float) = 0.01
		_WaterBumpMap("Water Normalmap", 2D) = "bump" {}
		_WaterBumpScale("Water Normalmap Scale", Float) = 1
		_FlowHeightScale("Water Flow Height Scale", Float) = 1

		_RainRipples("Water Ripples (RGB)", 2D) = "white" {}
		_RainIntensity("Water Ripples Intensity", Float) = 1
		_RippleAnimSpeed("Ripple Anim Speed", Float) = 1.0
		_RippleWindSpeed("Ripple Wind Speed", Vector) = (0.5, 0.25, 0.5, 0.25)
		_RippleTiling("Ripple Tiling", Float) = 0.5
		_RippleHeightScale("Water Ripple Height Scale", Float) = 1

		_ReflectionTex("For Mirror reflection,don't set it!", 2D) = "white" {}
		_RefColor("Reflection Color",Color) = (1,1,1,1)
		_RefRate("Reflective Rate", Range(0, 5)) = 1
		_RefLerp("Lerp between road and reflection", Range(0,1)) = 0.5
		_RefDistortion("Reflective Distortion", Range(0, 1)) = 0.03
		_RefLodLevel("Reflect Lod level", Range(0, 8)) = 2
		_LightFactor("Reflective Light factor(0 for night, 1 for day)", Range(0, 1)) = 1

		_DetailTex("Detail Texture (RGB)", 2D) = "black" {}
		_BlurDetailTex("Blur Detail Texture (RGB)", 2D) = "black" {}
		_RoadBlurFactors("Road Blur factor", Range(0, 1)) = 0
		[Toggle(SWAP_UV_ON)]_SwapUV("Swap UV", Float) = 0
		[Toggle(ENABLE_DETAIL_ON)]_EnableDetail("Enable Detail", Float) = 0
	}
	SubShader
	{
		//Tags { "RenderType"="Opaque" }
		Tags{ "QUEUE" = "Geometry-2" "RenderType" = "Opaque" " IgnoreProjector" = "True" }
		//Blend SrcAlpha OneMinusSrcAlpha
		LOD 400
 
		Pass {
			Tags{ "LightMode" = "ForwardBase" }
			CGPROGRAM
			#pragma fragmentoption ARB_precision_hint_fastest
			//#pragma noforwardadd
			#pragma multi_compile_fog
			#pragma multi_compile_fwdbase 
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile LIGHTMAP_OFF LIGHTMAP_ON
			#pragma multi_compile SPOTLIGHT_OFF SPOTLIGHT_ON  
			#pragma multi_compile WETNESS_OFF WETNESS_ON
            #pragma multi_compile DUAL_PARABOLOID_OFF DUAL_PARABOLOID_ON
			#pragma shader_feature SWAP_UV_ON
			#pragma shader_feature ENABLE_DETAIL_ON
			//#pragma multi_compile WETNESS_ON WETNESS_OFF
			#pragma target 3.0	
			#include "UnityCG.cginc"
			#include "AutoLight.cginc"
			#include "Lighting.cginc"
#ifdef SPOTLIGHT_ON
			#include "SpotLight.cginc"
#endif
			#define WET_FLOW
			#define WET_REFLECTION
			#include "Wetness.cginc"
            #include "DualParaboloidMap.cginc"

			sampler2D _MainTex;
			sampler2D _BumpMap;
			sampler2D _SPMask;
			fixed4 _Color;
			float4 _MainTex_ST;

			//uniform fixed4 _SpecColor;
			uniform half _Shininess;
			uniform half _Gloss;
			uniform fixed3 _LightDir;

#ifdef ENABLE_DETAIL_ON
			uniform sampler2D _DetailTex;
			uniform sampler2D _BlurDetailTex;
			uniform fixed _RoadBlurFactors;
			float4 _DetailTex_ST;
#endif

			struct vertexInput {
				float4 vertex : POSITION;
				fixed3 normal : NORMAL;
				float4 tangent : TANGENT;
				float2 uv_MainTex : TEXCOORD0;
				float2 uv_Lightmap : TEXCOORD1;
				float4 screenPos : TEXCOORD3;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float4 posWorld : TEXCOORD0;
				float4 uv_MainTex : TEXCOORD1;
				half3 vViewDir : TEXCOORD2;
				half3 normalWorld : TEXCOORD3;
				half3 tangentWorld : TEXCOORD4;
				half3 binormalWorld : TEXCOORD5;
				half3 vLightDir: TEXCOORD6;
#ifndef LIGHTMAP_OFF  
				half2 uvLM : TEXCOORD7;
#endif 
				LIGHTING_COORDS(8, 9)
				UNITY_FOG_COORDS(10)
				float4 screenPos: TEXCOORD11;
                DUAL_PARABOLOID_ATTRIBUTE(12, 13)
			};
			
			v2f vert(vertexInput v)
			{
				v2f o;
                float3 vertex = v.vertex;
                TRANSFER_VERTEX_TO_DUAL_PARABOLOID_SURF(o, v.vertex);
				o.pos = UnityObjectToClipPos(v.vertex);

				o.uv_MainTex.xy = v.uv_MainTex * _MainTex_ST.xy + _MainTex_ST.zw;
#ifdef ENABLE_DETAIL_ON
				o.uv_MainTex.zw = v.uv_MainTex * _DetailTex_ST.xy + _DetailTex_ST.zw;
#else
                o.uv_MainTex.zw = fixed2(0, 0);
#endif
				o.screenPos = ComputeScreenPos(o.pos);
				o.posWorld = mul(unity_ObjectToWorld, fixed4(vertex, 1));
				o.normalWorld = UnityObjectToWorldNormal(v.normal);
				o.tangentWorld = UnityObjectToWorldDir(v.tangent.xyz);
				o.binormalWorld = cross(normalize(o.normalWorld), normalize(o.tangentWorld.xyz)) * v.tangent.w * unity_WorldTransformParams.w;
				o.vViewDir = (_WorldSpaceCameraPos.xyz - o.posWorld.xyz); //DON't normalize here!!!
				o.vLightDir = normalize(_LightDir);//normalize(WorldSpaceLightDir(v.vertex));

#ifndef LIGHTMAP_OFF  
				o.uvLM = v.uv_Lightmap.xy * unity_LightmapST.xy + unity_LightmapST.zw;
#endif  
				TRANSFER_VERTEX_TO_FRAGMENT(o);
				UNITY_TRANSFER_FOG(o, o.pos); // pass fog coordinates to pixel shader
				return o;
			}

			//全是世界空间的参数
			fixed4 PhondLightColor(v2f i, fixed3 color, fixed3 normal)
			{
				fixed3 lightDir = normalize(fixed3(_WorldSpaceLightPos0.xyz));
				fixed3 viewDir = normalize(
					_WorldSpaceCameraPos - i.posWorld.xyz);
				half fShine = _Shininess;
				fixed3 vL = normalize(-lightDir.xyz);
				//水面法向
				float3 vN = normalize(normal + float3(0,1,0) );
				//fixed3 vN = normal;
				//计算半角向量
				fixed3 vH = normalize(viewDir - vL);
				//计算高光
				half  vSpec = pow(abs(max(dot(vN, vH), 0)), fShine);
				fixed4 c;
				c.rgb = (color.rgb +
					_SpecColor.rgb * vSpec);
				c.a = 1.0f;
				// specular passes by default put highlights to overbright
				return c;
			}

			//自己的光照处理函数
			fixed4 LambertDiffuseColor(fixed3 normalWorld, fixed3 wordPos, fixed4 diffuseMask, fixed3 vertNormal)
			{
				fixed3 worldLightDir = normalize(UnityWorldSpaceLightDir(wordPos));//normalize(_WorldSpaceLightPos0.xyz);
				normalWorld = lerp(normalWorld, vertNormal, 1 - diffuseMask.r);
				float3 diffuseReflection = _LightColor0.xyz *  max(0.0, dot(normalWorld, worldLightDir));//计算兰伯特漫反射
#ifdef WETNESS_ON
				diffuseReflection *= DIFFUSE_REALTIME_WET_REFLECTION(diffuseMask.r);
#endif
				float3 lightFinal = diffuseReflection + UNITY_LIGHTMODEL_AMBIENT.xyz;
				fixed4 finalColor = fixed4(lightFinal, 1.0f); // fixed4(ambient + diffuse, 1.0);
				return finalColor;
			}

			inline half4 mix(half4 a, half4 b, float t)
			{
				return a * (1.0 - t) + b * t;
			}

			fixed4 frag(v2f i) : SV_Target
			{
                DUAL_PARABOLOID_CLIP_DEPTH(i)

#ifdef DUAL_PARABOLOID_ON
                fixed4 texColor = tex2D(_MainTex, i.uv_MainTex.xy);
                fixed4 dualColor = texColor * _Color;
#ifndef LIGHTMAP_OFF
                fixed3 dualLm = DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, i.uvLM.xy));
                dualColor.rgb *= dualLm;
#endif
                return dualColor;
#endif

				float2 uv = i.uv_MainTex.xy;
				float  atten = LIGHT_ATTENUATION(i);
				float2 main_uv = uv;
				fixed4 spMask = tex2D(_SPMask, uv);
				fixed3 tangentNormal = UnpackNormal(tex2D(_BumpMap, main_uv));
				float3x3 mW2T = float3x3(i.tangentWorld, i.binormalWorld, i.normalWorld); //世界空间到切线空间的转换,坐标基基于世界坐标建立,移除平移矩阵
																						  //i.tangentWorld,i.binormalWorld,i.normalWorld均已归一化
																						  //mW2T转置是否为逆，在于是否标准正交,尽管unity_ObjectToWorld不保证标准正交，但可以保证mW2T标准正交
				fixed3 normalDirection = normalize(mul(tangentNormal, mW2T));  //获得切线空间到世界空间的变换,法线贴图的世界坐标
#ifdef WETNESS_ON
				// Water influence on material BRDF
				float2 aniNoise = GetWetAnimationNoise(uv, normalDirection, mW2T, 1 - spMask.r, i.posWorld);
				main_uv = main_uv + aniNoise/* * spMask.rg*/;

				//rippleNormal = rippleNormal * 0.5 + 0.5;
				//return fixed4(rippleNormal, 0);

				//修正高光计算
				tangentNormal = UnpackNormal(tex2D(_BumpMap, main_uv));
				mW2T = float3x3(i.tangentWorld, i.binormalWorld, i.normalWorld);
				normalDirection = normalize(mul(tangentNormal, mW2T));
#endif
				half3 ViewDir = normalize(i.vViewDir);
				half NdotH = max(dot(normalDirection, normalize(ViewDir - i.vLightDir)), 0.0);
				half specIntensity = pow(NdotH, _Gloss);
				specIntensity = specIntensity * _Shininess;

				fixed4 tex = tex2D(_MainTex, main_uv);

#ifdef WETNESS_ON
				spMask = tex2D(_SPMask, main_uv); //修正高光贴图位置，否则错位
				specIntensity = SPEC_WET_REFLECTION(specIntensity);
#ifdef WET_REFLECTION
				//fixed2 reflectNoise = fixed2(tangentNormal.x, tangentNormal.y)/* + aniNoise*/;
				fixed2 reflectNoise = fixed2(tangentNormal.x, 1.0 - tangentNormal.z) + aniNoise;
				fixed4 ref = GetReflectColor(i.screenPos, reflectNoise);

				tex = MixReflectTex(tex, ref);
#endif
#endif

#ifdef WETNESS_ON
				// Water influence on material BRDF
				specIntensity = SPEC_WET_REFLECTION(specIntensity);
#endif
#ifndef LIGHTMAP_OFF
				fixed  diffuse = 1;
#ifdef WETNESS_ON
				diffuse = DIFFUSE_LIGHTMAP_WET_REFLECTION(spMask.r);
#endif
				fixed4 finalColor = _Color * tex * diffuse + spMask * _SpecColor * specIntensity;
				fixed3 lm = DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, i.uvLM.xy));
				//fixed3 lmFinal = min(lm, fixed3(atten, atten, atten));
                fixed3 lmFinal = lm *atten;  //lm被增强时,效果异常
				finalColor.rgb *= lmFinal;
#else
#ifdef LIGHTMAP_ON
				fixed4 finalColor = _Color * tex + spMask * _SpecColor * specIntensity;
#else
				fixed4 finalColor = LambertDiffuseColor(normalDirection, i.posWorld, spMask, i.normalWorld) * _Color * tex + spMask * _SpecColor * specIntensity;
#endif
				finalColor.rgb *= atten;
#endif 

#ifdef SPOTLIGHT_ON
				fixed3 spotColor = SpotLightColor(i.posWorld, normalDirection);
				finalColor.rgb += spotColor;
#endif

#ifdef ENABLE_DETAIL_ON
				fixed2 detailUV = i.uv_MainTex.zw;
#ifdef SWAP_UV_ON
				detailUV.xy = detailUV.yx;
#endif
				finalColor = (finalColor * mix(tex2D(_DetailTex, detailUV), tex2D(_BlurDetailTex, detailUV), _RoadBlurFactors)) * 2;
#endif

				UNITY_APPLY_FOG(i.fogCoord, finalColor); // apply fog
				return finalColor;
			}
			ENDCG
	    }
	}
	Fallback "Mobile/Diffuse"
}