// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "TopCar/Mirrors/Bumped Specular"
{
	Properties
	{
		_Color("Main Color", Color) = (1,1,1,1)
		_MainTex("Base (RGB) Gloss (A)", 2D) = "white" {}
		_MaskTex("Mask Map", 2D) = "white" {}
		_BlendLevel("Main Material Blend Level",Range(0,1)) = 1
        [Header(Specular Light Setting)]
		_SpecColor("Specular Color", Color) = (0.5, 0.5, 0.5, 1)
		_Shininess("Shininess", Range(0.01, 10)) = 1
		_Gloss("Gloss", Range(0.0, 10)) = 1
        [Header(Bump Map Setting)]
		_BumpMap("Normalmap", 2D) = "bump" {}
		_Bumpness("Bump Rate",Range(0,1)) = 0.5
        _Distortion("Reflective Distortion", Range(0, 1)) = 0
		[Header(Planar Reflect Setting)]
        _Ref("For Mirror reflection,don't set it!", 2D) = "white" {}
		_RefColor("Reflection Color",Color) = (1,1,1,1)
		_RefRate("Reflective Rate", Range(0, 1)) = 1
        _RefCube("Reflection Map,don't set it!", Cube) = "_Skybox" {}
        [Header(Light Setting)]
		_LightDirection("Direction Light Direction", Vector) = (0, -1, 0)
		//[Toggle] Lightmap("_Lightmap?", Float) = 1
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
			#pragma multi_compile LIGHTMAP_OFF LIGHTMAP_ON
            #pragma multi_compile REFLECT_OFF REFLECT_ON
            #pragma multi_compile LOCAL_CORRECTION_OFF LOCAL_CORRECTION_ON
			#pragma target 3.0	
			#include "UnityCG.cginc"
			#include "AutoLight.cginc"
			#include "Lighting.cginc"

			sampler2D _MainTex;
			sampler2D _BumpMap;
			fixed4 _Color;
			half _Bumpness;
			half _BlendLevel;
			half _Distortion;

#if REFLECT_ON
			fixed4 _RefColor;
            half _RefRate;
            //实时反射图片
            sampler2D _Ref;
            //反射遮挡图片，如水渍部分反射更强
            sampler2D _MaskTex;
            //烘焙反射球，以减少实时反射负载
            uniform samplerCUBE _RefCube;
#if LOCAL_CORRECTION_ON
            // ----Passed from script Mirror.cs --------
            uniform float3 _BBoxMin;
            uniform float3 _BBoxMax;
            uniform float3 _EnviCubeMapPos;
#endif
#endif
			float4 _MainTex_ST;
			float4 _BumpMap_TexelSize;

			//uniform fixed4 _SpecColor;
			uniform half _Shininess;
			uniform half _Gloss;
			uniform fixed3 _LightDirection;

			//uniform fixed4 _LightColor0;

			struct vertexInput {
				float4 vertex : POSITION;
				fixed3 normal : NORMAL;
				float4 tangent : TANGENT;
				float2 uv_MainTex : TEXCOORD0;
				float2 uv_Lightmap : TEXCOORD1;
				float2 uv_MaskTex : TEXCOORD2;
				float4 screenPos : TEXCOORD3;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float4 posWorld : TEXCOORD0;
				float2 uv_MainTex : TEXCOORD1;
				float2 uv_MaskTex : TEXCOORD2;
				float3 normalWorld : TEXCOORD3;
				float3 tangentWorld : TEXCOORD4;
				float3 binormalWorld : TEXCOORD5;
				float4 screenPos : TEXCOORD6;
#ifndef LIGHTMAP_OFF  
				half2 uvLM : TEXCOORD7;
#endif 
				LIGHTING_COORDS(8, 9)
			};

#if REFLECT_ON && LOCAL_CORRECTION_ON
            float3 LocalCorrect(float3 origVec, float3 bboxMin, float3 bboxMax, float3 vertexPos, float3 cubemapPos)
            {
                // Find the ray intersection with box plane
                float3 invOrigVec = float3(1.0, 1.0, 1.0) / origVec;
                float3 intersecAtMaxPlane = (bboxMax - vertexPos) * invOrigVec;
                float3 intersecAtMinPlane = (bboxMin - vertexPos) * invOrigVec;
                // Get the largest intersection values (we are not intersted in negative values)
                float3 largestIntersec = max(intersecAtMaxPlane, intersecAtMinPlane);
                // Get the closest of all solutions
                float Distance = min(min(largestIntersec.x, largestIntersec.y), largestIntersec.z);
                // Get the intersection position
                float3 IntersectPositionWS = vertexPos + origVec * Distance;
                // Get corrected vector
                float3 localCorrectedVec = IntersectPositionWS - cubemapPos;
                return localCorrectedVec;
            }
#endif
			
			v2f vert(vertexInput v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos (v.vertex);
				o.uv_MainTex = v.uv_MainTex * _MainTex_ST.xy + _MainTex_ST.zw;
				o.uv_MaskTex = v.uv_MaskTex;
				o.posWorld = mul(unity_ObjectToWorld, v.vertex);
				o.normalWorld = UnityObjectToWorldNormal(v.normal); //normalize(fixed3(mul(fixed4(v.normal, 0.0), unity_WorldToObject).xyz));
				o.tangentWorld = UnityObjectToWorldDir(v.tangent.xyz);
				o.screenPos = ComputeScreenPos(o.pos);
				o.binormalWorld = cross(normalize(o.normalWorld), normalize(o.tangentWorld.xyz)) * v.tangent.w;
#ifndef LIGHTMAP_OFF  
				o.uvLM = v.uv_Lightmap.xy * unity_LightmapST.xy + unity_LightmapST.zw;	
#endif  
				TRANSFER_VERTEX_TO_FRAGMENT(o);
				return o;
			}

			////全是世界空间的参数
			//fixed4 PhondLightColor(v2f i, fixed3 color, fixed3 normal)
			//{
			//	fixed3 lightDir = normalize(_LightDirection); // normalize(fixed3(_WorldSpaceLightPos0.xyz));
			//	fixed3 viewDir = normalize(
			//		_WorldSpaceCameraPos - i.posWorld.xyz);
			//	half fShine = _Shininess;
			//	fixed3 vL = normalize(-lightDir.xyz);
			//	//水面法向
			//	float3 vN = normalize(normal + float3(0,1,0) );
			//	//fixed3 vN = normal;
			//	//计算半角向量
			//	fixed3 vH = normalize(viewDir - vL);
			//	//计算高光
			//	half  vSpec = pow(abs(max(dot(vN, vH), 0)), fShine);
			//	fixed4 c;
			//	c.rgb = (color.rgb +
			//		_SpecColor.rgb * vSpec);
			//	c.a = 1.0f;
			//	// specular passes by default put highlights to overbright
			//	return c;
			//}

			////自己的高光处理函数
			//fixed4 CaculateLightColor(v2f i, fixed3 color, fixed3 normalWorld)
			//{
			//	fixed3 normalDirection = normalWorld;//i.normalWorld;
			//	fixed3 viewDirection = normalize(
			//		_WorldSpaceCameraPos - i.posWorld.xyz);
			//	fixed3 lightDirection;
			//	fixed attenuation = 1.0; // no attenuation
			//	lightDirection = normalize(fixed3(_WorldSpaceLightPos0.xyz));

			//	fixed3 ambientLighting =
			//		UNITY_LIGHTMODEL_AMBIENT.xyz * _Color.xyz;

			//	fixed3 diffuseReflection =
			//		attenuation * _LightColor0.xyz * _Color.xyz
			//		* max(0.0, dot(normalDirection, lightDirection));


			//	fixed3 specularReflection;

			//	//if (dot(normalDirection, lightDirection) < 0.0)
			//	//{
			//	//	specularReflection = fixed3(0.0, 0.0, 0.0);
			//	//}
			//	//else // light source on the right side
			//	{
			//		specularReflection = attenuation * _LightColor0.rgb
			//			* _SpecColor.rgb * pow(max(0.0, dot(viewDirection,
			//				reflect(lightDirection, normalDirection))), _Shininess);
			//	}

			//	specularReflection *= _Gloss;

			//	

			//	fixed4 finalColor;
			//	finalColor.rgb = color * saturate(ambientLighting + diffuseReflection) + specularReflection;
			//	finalColor.a = 1.0;

			//	return finalColor;
			//}

			fixed4 frag(v2f i) : SV_Target
			{
				
				fixed3 tangentNormal = UnpackNormal(tex2D(_BumpMap, i.uv_MainTex)) * _Bumpness;

				fixed4 tex = tex2D(_MainTex, i.uv_MainTex);
				float2 screenUV = i.screenPos.xy / i.screenPos.w;
				screenUV += tangentNormal.xy * _Distortion;
#if REFLECT_ON
				fixed4 ref = tex2D(_Ref, screenUV);
                fixed4 cDistWeight = tex2D(_MaskTex, i.uv_MaskTex);
#endif
				
				float3x3 mTangentToWorld = transpose(float3x3(i.tangentWorld,i.binormalWorld,i.normalWorld));
				fixed3 normalDirection = normalize(mul(mTangentToWorld, tangentNormal));  //法线贴图的世界坐标
				
				//fixed4 finalColor = PhondLightColor(i, surfColor, normalDirection);
				//fixed4 finalColor = CaculateLightColor(i, surfColor, normalDirection);
				fixed3 viewDirection = normalize(
					_WorldSpaceCameraPos - i.posWorld.xyz);
				fixed3 lightDirection = -normalize(_LightDirection);
				half NdotH = max(dot(i.normalWorld, normalize(viewDirection + lightDirection)), 0.0);
				//half specIntensity = pow(NdotH, _Gloss);
				//specIntensity = specIntensity * _Shininess;\

				fixed4 finalColor;

#if REFLECT_ON
                fixed3 reflectView = reflect(-viewDirection, normalDirection);
#if LOCAL_CORRECTION_ON
                // Get local corrected reflection vector.
                reflectView = LocalCorrect(reflectView, _BBoxMin, _BBoxMax, i.posWorld, _EnviCubeMapPos);
#endif
                //sample reflected cube map
                fixed4 reflcol = texCUBE(_RefCube, reflectView);
                ref.rgb = ref.rgb + reflcol.rgb * (1 - ref.a);
#endif
				
#ifndef LIGHTMAP_OFF
                //反射颜色混合
#if REFLECT_ON
				fixed3 surfColor = lerp(tex.rgb * _Color.rgb * _BlendLevel, ref.rgb * _RefColor.rgb * _RefRate, cDistWeight.r);
#else
                fixed3 surfColor = tex.rgb *  _Color.rgb * _BlendLevel;
#endif
				finalColor.rgb = surfColor; // + _SpecColor * specIntensity;
				fixed3 lm = DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, i.uvLM.xy));
				finalColor.rgb *= lm;
#else
                //反射颜色混合
#if REFLECT_ON
				fixed3 surfColor = lerp(tex.rgb * _Color.rgb * _BlendLevel * NdotH * _LightColor0, ref.rgb * _RefColor.rgb * _RefRate, cDistWeight.r);
#else
                fixed3 surfColor = tex.rgb * _Color.rgb * _BlendLevel * NdotH * _LightColor0;
#endif
				//surfColor *= NdotH * _LightColor0;
				fixed3 vLight = Shade4PointLights(
					unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
					unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb,
					unity_4LightAtten0, i.posWorld, i.normalWorld);
				finalColor.rgb = surfColor + vLight; // + _SpecColor * specIntensity;
#endif   

				float  atten = LIGHT_ATTENUATION(i);
				finalColor.rgb *= atten;
				return finalColor;
			}
			ENDCG
	    }
	}
	Fallback "Mobile/Diffuse"
}