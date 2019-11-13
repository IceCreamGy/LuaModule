// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "TopCar/Env/Water"
{
	Properties
	{
		_Color("Main Color", Color) = (1,1,1,1)
		_MainTex("Base (RGB) Gloss (A)", 2D) = "white" {}
		//_MaskTex("Mask Map", 2D) = "white" {}
		//_BlendLevel("Main Material Blend Level",Range(0,1)) = 1
		_SpecColor("Specular Color", Color) = (0.5, 0.5, 0.5, 1)
		_Shininess("Shininess", Range(0.01, 255)) = 1
		//_Gloss("Gloss", Range(0.0, 10)) = 1
		_BumpMap("Normalmap", 2D) = "bump" {}
		_WaveScale("Wave scale", Range(0.001,0.15)) = 0.01
		_WaveSpeed("Wave speed (map1 x,y; map2 x,y)", Vector) = (19,9,-16,-7)
		_Bumpness("Bump Rate",Range(0,1)) = 0.5
		//_DUDVTex("UVOffset texture", 2D) = "white" {}
		[Toggle] _Reflect("_Reflect?", Float) = 0
		_Ref("For Mirror reflection,don't set it!", 2D) = "white" {}
		_RefColor("Reflection Color",Color) = (1,1,1,1)
		_RefRate("Reflective Rate", Range(0, 1)) = 1
		_Distortion("Reflective Distortion", Range(0, 10)) = 0
		//_FlowSpeed("Flow speed", Range(0.1, 1)) = 1
	}
	SubShader
	{
		//Tags { "RenderType"="Opaque" }
		Tags{ "QUEUE" = "Geometry" "RenderType" = "Opaque" " IgnoreProjector" = "True" }
		//Blend SrcAlpha OneMinusSrcAlpha
		LOD 400
 
		Pass {
			Tags{ "LightMode" = "ForwardBase" }
			CGPROGRAM
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma exclude_path:prepass noforwardadd
			#pragma multi_compile_fwdbase 
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile LIGHTMAP_ON LIGHTMAP_OFF
			#pragma multi_compile _REFLECT_OFF _REFLECT_ON 
			#pragma target 3.0	
			#include "UnityCG.cginc"
			#include "AutoLight.cginc"
			#include "Lighting.cginc"

			sampler2D _MainTex;
			sampler2D _BumpMap;
			//sampler2D _BumpMap2;
			//sampler2D _DUDVTex;
			fixed4 _Color;
			half _RefRate;
			half _Bumpness;
			uniform half _WaveScale;
			uniform half4 _WaveSpeed;
			half _Distortion;
			fixed4 _RefColor;
			sampler2D _Ref;
			//sampler2D _MaskTex;
			float4 _MainTex_ST;
			float4 _BumpMap_TexelSize;

			//uniform fixed4 _SpecColor;
			uniform half _Shininess;
			uniform half _Gloss;
			uniform half _FlowSpeed;

			//uniform fixed4 _LightColor0;

			struct vertexInput {
				float4 vertex : POSITION;
				fixed3 normal : NORMAL;
				float4 tangent : TANGENT;
				float2 uv_MainTex : TEXCOORD0;
				
				
				//float2 uv_BumpMap : TEXCOORD2;
				//float2 uv_Ref : TEXCOORD2;
				float4 screenPos : TEXCOORD1;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float4 posWorld : TEXCOORD0;
				//fixed3 normalDir : TEXCOORD1;
				//fixed3 lightDir : TEXCOORD1;   //切线空间的光照方向
				float2 uv_MainTex : TEXCOORD1;
				float2 bumpuv0 : TEXCOORD2;
				float2 bumpuv1 : TEXCOORD3;
				//float2 uv_MaskTex : TEXCOORD2;
				//float4 refl : 
				//fixed3 viewDir : TEXCOORD4;
				float3 normalWorld : TEXCOORD4;
				float3 tangentWorld : TEXCOORD5;
				float3 binormalWorld : TEXCOORD6;
#ifdef _REFLECT_ON
				float4 screenPos : TEXCOORD7;
#endif
#ifndef LIGHTMAP_OFF  
				//half2 uvLM : TEXCOORD7;
#endif 
				//LIGHTING_COORDS(8, 9)
			};
			
			v2f vert(vertexInput v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos (v.vertex);
				o.uv_MainTex = v.uv_MainTex * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 temp;
				float4 wpos = mul(unity_ObjectToWorld, v.vertex);
				half wscale = _WaveScale;
				half4 waveScale4 = float4(wscale, wscale, wscale * 0.4, wscale * 0.45);
				
				half4 offestClamped;
				offestClamped.x = fmod(_WaveSpeed.x * _Time.x / 100, 1.0);
				offestClamped.y = fmod(_WaveSpeed.y * _Time.x / 100, 1.0);
				offestClamped.z = fmod(_WaveSpeed.z * _Time.x / 100, 1.0);
				offestClamped.w = fmod(_WaveSpeed.w * _Time.x / 100, 1.0);
				temp.xyzw = wpos.xzxz * waveScale4 + offestClamped;
				
				//float4 temp;
				//temp.xyzw = v.vertex.xzxz * _WaveScale / 1.0; // +_WaveOffset;
				//o.bumpuv0 = temp.xy * float2(.4, .45) + fmod(_Time.x, 1.0f) * _WaveSpeed.xy / 100;
				//o.bumpuv1 = temp.wz + fmod(_Time.x, 1.0f) * _WaveSpeed.zw / 100;
				o.bumpuv0 = temp.xy;
				o.bumpuv1 = temp.wz;
				//o.uv_MaskTex = v.uv_MaskTex;
				o.posWorld = mul(unity_ObjectToWorld, v.vertex);
				o.normalWorld = UnityObjectToWorldNormal(v.normal); //normalize(fixed3(mul(fixed4(v.normal, 0.0), unity_WorldToObject).xyz));
				o.tangentWorld = UnityObjectToWorldDir(v.tangent.xyz);
				
				o.binormalWorld = cross(normalize(o.normalWorld), normalize(o.tangentWorld.xyz)) * v.tangent.w;
#ifdef _REFLECT_ON
				o.screenPos = ComputeScreenPos(o.pos);
#endif
#ifndef LIGHTMAP_OFF  
				//o.uvLM = v.uv_Lightmap.xy * unity_LightmapST.xy + unity_LightmapST.zw;
#endif  
				//TRANSFER_VERTEX_TO_FRAGMENT(o);
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
				fixed3 vN = normalize(normal/* + float3(0,1,0)*/);
				//fixed3 vN = normal;
				//计算半角向量
				fixed3 vH = normalize(reflect(vL, vN));
				half vDotH = dot(viewDir, vH);
				//计算高光
				half  vSpec = pow(abs(max(vDotH, 0)), fShine);
				fixed4 c;
				c.rgb = (color.rgb +
					_SpecColor.rgb * vSpec);
				c.a = 1.0f;
				//c.rgb = fixed3(vDotH, vDotH, vDotH);
				// specular passes by default put highlights to overbright
				return c;
			}

			fixed4 frag(v2f i) : SV_Target
			{

				fixed3 tangentNormal = UnpackNormal(tex2D(_BumpMap, /*i.uv_MainTex + */i.bumpuv0)) * _Bumpness;//fmod(_Time.x, 1.0f)));
				fixed3 tangentNormal2 = UnpackNormal(tex2D(_BumpMap, /*i.uv_MainTex + */i.bumpuv1)) * _Bumpness;//fmod(_Time.x, 1.0f)));
				//float4 dudvTex = tex2D(_DUDVTex, i.uv_MainTex + _Time.x * _FlowSpeed);
				
				float3x3 mTangentToWorld = transpose(float3x3(i.tangentWorld, i.binormalWorld, i.normalWorld));
				  //法线贴图的世界坐标
				float2 distortionUV = (tangentNormal.xy + tangentNormal2.xy) * 0.5f * _Distortion; //tangentNormal.xy * (2 * dudvTex.rg - 1.0f) * _Distortion; // *_Time.x;
				//float2 distortionUV2 = tangentNormal2.xy * (2 * dudvTex.rg - 1.0f) * _Distortion; // *_Time.x;
				fixed4 tex = tex2D(_MainTex, i.uv_MainTex + distortionUV);
#ifdef _REFLECT_ON
				float2 screenUV = i.screenPos.xy / i.screenPos.w;
				//screenUV += tangentNormal.xy * _Distortion * _Time.x;
				fixed4 ref = tex2D(_Ref, screenUV + distortionUV);
				//fixed4 cDistWeight = tex2D(_MaskTex, i.uv_MaskTex);
				fixed3 surfColor = lerp(tex.rgb * _Color.rgb, ref.rgb * _RefColor.rgb, _RefRate);
#else
				fixed3 surfColor = tex.rgb * _Color.rgb;
#endif
				//fixed3 surfColor = tex.rgb * _Color.rgb * ref.rgb;
				
				
				fixed3 normalDirection = normalize(mul(mTangentToWorld, UnpackNormal(tex2D(_BumpMap, /*i.uv_MainTex + */distortionUV))));
				fixed4 finalColor = PhondLightColor(i, surfColor, normalDirection);
				//finalColor.rgb = normalDirection;
				//fixed4 finalColor = CaculateLightColor(i, surfColor, normalDirection);
#ifndef LIGHTMAP_OFF  
				//fixed3 lm = DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, i.uvLM.xy));
				//finalColor.rgb *= lm;
#endif 
				//float  atten = LIGHT_ATTENUATION(i);
				//finalColor.rgb *= atten;
				//finalColor.rgb = fixed3(unity_DeltaTime.x, unity_DeltaTime.x, unity_DeltaTime.x);
				return finalColor;
			}
			ENDCG
	    }
	}
	Fallback "Mobile/Diffuse"
}