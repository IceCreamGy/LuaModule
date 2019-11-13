// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "TopCar/Env/Road"
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

		_DetailTex("Detail Texture (RGB)", 2D) = "black" {}
		_BlurDetailTex("Blur Detail Texture (RGB)", 2D) = "black" {}
		_RoadBlurFactors("Road Blur factor", Range(0, 1)) = 0
		[Toggle(SWAP_UV_ON)]_SwapUV("Swap UV", Float) = 0
		[Toggle(ENABLE_DETAIL_ON)]_EnableDetail("Enable Detail", Float) = 0

			//spotLightWorldPos("spot light position", Vector) = (0, 0, 0)
			//spotLightDirection("spot light direction", Vector) = (0, 0, 1)
			//spotLightColor("spot light color", Color) = (0.5, 0.5, 0.5, 1)
			//spotCutOff("spot light angle(radius)", Float) = 0
		//[Toggle] Lightmap("_Lightmap?", Float) = 1
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
			#include "Wetness.cginc"
#ifdef SPOTLIGHT_ON
			#include "SpotLight.cginc"
#endif
            #include "DualParaboloidMap.cginc"

			sampler2D _MainTex;
			sampler2D _BumpMap;
			sampler2D _SPMask;
			fixed4 _Color;
			//half _RefRate;
			//half _Bumpness;
			//half _BlendLevel;
			//half _Distortion;
			//fixed4 _RefColor;
			//sampler2D _Ref;
			//sampler2D _MaskTex;
			float4 _MainTex_ST;
			//float4 _BumpMap_TexelSize;

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

			//uniform fixed4 _LightColor0;

			struct vertexInput {
				float4 vertex : POSITION;
				fixed3 normal : NORMAL;
				float4 tangent : TANGENT;
				float2 uv_MainTex : TEXCOORD0;
				float2 uv_Lightmap : TEXCOORD1;
				//float2 uv_MaskTex : TEXCOORD2;
				
				//float2 uv_BumpMap : TEXCOORD2;
				//float2 uv_Ref : TEXCOORD2;
				float4 screenPos : TEXCOORD3;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float4 posWorld : TEXCOORD0;
				//fixed3 normalDir : TEXCOORD1;
				//fixed3 lightDir : TEXCOORD1;   //切线空间的光照方向
				float4 uv_MainTex : TEXCOORD1;
				half3 vViewDir : TEXCOORD2;
				//float4 refl : 
				//fixed3 viewDir : TEXCOORD4;
				half3 normalWorld : TEXCOORD3;
				half3 tangentWorld : TEXCOORD4;
				half3 binormalWorld : TEXCOORD5;
				half3 vLightDir: TEXCOORD6;
				//fixed3 vlight : TEXCOORD7; //vertexlights
#ifndef LIGHTMAP_OFF  
				half2 uvLM : TEXCOORD8;
#endif
                DUAL_PARABOLOID_ATTRIBUTE(7, 12)
				LIGHTING_COORDS(9, 10)
				UNITY_FOG_COORDS(11)
			};
			
			v2f vert(vertexInput v)
			{
				v2f o;
                TRANSFER_VERTEX_TO_DUAL_PARABOLOID_SURF(o, v.vertex);
                o.pos = UnityObjectToClipPos(v.vertex);

				o.uv_MainTex.xy = v.uv_MainTex * _MainTex_ST.xy + _MainTex_ST.zw;
#ifdef ENABLE_DETAIL_ON
				o.uv_MainTex.zw = v.uv_MainTex * _DetailTex_ST.xy + _DetailTex_ST.zw;
#else
                o.uv_MainTex.zw = fixed2(0, 0);
#endif
				o.posWorld = mul(unity_ObjectToWorld, v.vertex);
				o.normalWorld = UnityObjectToWorldNormal(v.normal); //normalize(fixed3(mul(fixed4(v.normal, 0.0), unity_WorldToObject).xyz));
				o.tangentWorld = UnityObjectToWorldDir(v.tangent.xyz);
				o.binormalWorld = cross(normalize(o.normalWorld), normalize(o.tangentWorld.xyz)) * v.tangent.w;
				o.vViewDir = (_WorldSpaceCameraPos.xyz - o.posWorld.xyz); //DON't normalize here!!!
				o.vLightDir = normalize(_LightDir);//normalize(WorldSpaceLightDir(v.vertex));

#ifdef SPOTLIGHT_ON
				//o.vlight = SpotLightColor(o.posWorld, o.normalWorld);
#else
				//o.vlight = fixed3(1, 0, 0);
#endif
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
				//fixed3 normalDirection = normalWorld;//i.normalWorld;
				//fixed3 viewDirection = normalize(_WorldSpaceCameraPos - posWorld);
				//fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
				fixed3 worldLightDir = UnityWorldSpaceLightDir(wordPos);//normalize(_WorldSpaceLightPos0.xyz);
				normalWorld = lerp(normalWorld, vertNormal, 1 - diffuseMask.r);
				float3 diffuseReflection = _LightColor0.xyz *  max(0.0, dot(normalWorld, worldLightDir));//计算兰伯特漫反射
#ifdef WETNESS_ON
				diffuseReflection *= DIFFUSE_REALTIME_WET_REFLECTION(diffuseMask.r);
#endif
				float3 lightFinal = diffuseReflection + UNITY_LIGHTMODEL_AMBIENT.xyz;
				//fixed3 reflectDir = normalize(reflect(-worldLightDir, normalWorld));
				//fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - posWorld);
				//fixed3 specular = _LightColor0.rgb * _SpecColor.rgb * pow(saturate(dot(reflectDir, viewDirection)), _Gloss);
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

				fixed3 tangentNormal = UnpackNormal(tex2D(_BumpMap, i.uv_MainTex.xy));

				fixed4 tex = tex2D(_MainTex, i.uv_MainTex.xy);

#ifdef DUAL_PARABOLOID_ON
                fixed4 dualColor = tex * _Color;
#ifndef LIGHTMAP_OFF
                fixed3 dualLm = DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, i.uvLM.xy));
                dualColor.rgb *= dualLm;
#endif
                return dualColor;
#endif
				
				float3x3 mTangentToWorld = transpose(float3x3(i.tangentWorld,i.binormalWorld,i.normalWorld));
				fixed3 normalDirection = normalize(mul(mTangentToWorld, tangentNormal));  //法线贴图的世界坐标
				
				half3 ViewDir = normalize(i.vViewDir);
				half NdotH = max(dot(normalDirection, normalize(ViewDir - i.vLightDir)), 0.0);
				half specIntensity = pow(NdotH, _Gloss);
				specIntensity = specIntensity * _Shininess;
				//fixed4 finalColor = PhondLightColor(i, surfColor, normalDirection);
				//fixed4 finalColor = CaculateLightColor(i.posWorld, tex, normalDirection);
				fixed4 spMask = tex2D(_SPMask, i.uv_MainTex.xy);

				float  atten = LIGHT_ATTENUATION(i);

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
				//fixed3 lmFinal = min(lm, fixed3(atten, atten, atten)); //lm被增强时,效果异常
				fixed3 lmFinal = lm * atten;
				finalColor.rgb *= lmFinal;
#else
				fixed4 finalColor = LambertDiffuseColor(normalDirection, i.posWorld, spMask, i.normalWorld) * _Color * tex + spMask * _SpecColor * specIntensity;
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

				//finalColor.rgb += i.vlight;
				UNITY_APPLY_FOG(i.fogCoord, finalColor); // apply fog
				return finalColor;
			}
			ENDCG
	    }
	}
	Fallback "Mobile/Diffuse"
}