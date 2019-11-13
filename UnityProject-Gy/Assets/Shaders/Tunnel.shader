// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "TopCar/Env/Tunnel"
{
	Properties
	{
		_Color("Diffuse Material Color (RGB)", Color) = (1,1,1,1)
		_MainTex("Diffuse Texture", 2D) = "white" {}
		_CullMask("Cull shadow mask", Range(0.00, 1)) = 0.5
		_LightAttenuation("Light Attenuation", Range(0.00, 10000)) = 1
		_InnerAddColor("Inner Add Color (RGB)", Color) = (0.01, 0.01, 0.01, 1)
	}
	SubShader
	{
		Tags { "QUEUE" = "Geometry" "RenderType"="Opaque" }
		LOD 400

		Pass
		{
			Tags{ "LightMode" = "ForwardBase" }
			CGPROGRAM

			// make fog work
			//#pragma multi_compile_fog
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma multi_compile_fwdbase
			#pragma multi_compile LIGHTMAP_OFF LIGHTMAP_ON 
			#pragma multi_compile SPOTLIGHT_OFF SPOTLIGHT_ON
			#pragma target 3.0
			#pragma multi_compile_fog

			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			#include "AutoLight.cginc"
			#include "Lighting.cginc"
#ifdef SPOTLIGHT_ON
#include "SpotLight.cginc"
#endif

			struct appdata
			{
				float4 vertex : POSITION;
				fixed3 normal : NORMAL;
				float2 uv_MainTex : TEXCOORD0;
				float2 uv_Lightmap : TEXCOORD1;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float4 posWorld : TEXCOORD0;
				fixed3 normalWorld : TEXCOORD1;
				float2 uv_MainTex : TEXCOORD2;
				//float3 vertexLight: TEXCOORD5;

#ifndef LIGHTMAP_OFF  
				half2 uvLM : TEXCOORD3;
#else
				LIGHTING_COORDS(3, 4)
#endif 
				UNITY_FOG_COORDS(5)
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;

			uniform fixed4 _Color;
			uniform fixed _CullMask;
			uniform fixed4 _InnerAddColor;

			// The following built-in uniforms (except _LightColor0) 
			// are also defined in "UnityCG.cginc", 
			// i.e. one could #include "UnityCG.cginc" 
			//uniform fixed4 _LightColor0;
			// color of light source (from "Lighting.cginc")
			
			v2f vert (appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.posWorld = mul(unity_ObjectToWorld, v.vertex);
				o.uv_MainTex = TRANSFORM_TEX(v.uv_MainTex, _MainTex);
				o.normalWorld = UnityObjectToWorldNormal(v.normal);

				fixed3 normalDirection = normalize(o.normalWorld);
#ifndef LIGHTMAP_OFF  
				o.uvLM = v.uv_Lightmap.xy * unity_LightmapST.xy + unity_LightmapST.zw;
#else
				TRANSFER_VERTEX_TO_FRAGMENT(o);
#endif
				UNITY_TRANSFER_FOG(o,o.pos);
				return o;
			}
			
			fixed4 frag (v2f i) : COLOR //SV_Target
			{
				// sample the texture
				fixed4 textureColor = tex2D(_MainTex, i.uv_MainTex.xy);
				fixed alpha = 1.0;

				fixed4 finalColor = textureColor;
#ifndef LIGHTMAP_OFF
				fixed3 lm = DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, i.uvLM.xy));
				//finalColor.rgb *= _Color.rgb;
				finalColor.rgb *= _Color.rgb * lm;
#else
				float atten = LIGHT_ATTENUATION(i);
				fixed4 lightColor = _LightColor0;
				fixed fixedShadow = step(_CullMask, atten);
				lightColor.rgb *= fixedShadow * atten;

				fixed3 normalDirection = normalize(i.normalWorld);
				fixed attenuation = 1.0; // no attenuation
				fixed3 lightDirection = normalize(UnityWorldSpaceLightDir(i.posWorld)); //世界坐标系做光照计算
				fixed3 diffuseReflection =
					attenuation * lightColor.rgb
					* max(0, dot(normalDirection, lightDirection));

				fixed3 ambientLighting = UNITY_LIGHTMODEL_AMBIENT.xyz * _Color.xyz * (_LightColor0 * fixedShadow + fixed4(1, 1, 1, 1) - fixedShadow); //_LightColor0 * fixedShadow + (1 - fixedShadow) * fixed4(1,1,1,1)
				//float3 shLight = ShadeSH9(float4(normalDirection, 1.0));
				float3 vertexLight = Shade4PointLights(
					unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
					unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb,
					unity_4LightAtten0, i.posWorld, normalDirection);

				finalColor = fixed4(textureColor.rgb * _Color.xyz * (diffuseReflection + ambientLighting + vertexLight), alpha);
				finalColor.rgb += textureColor.rgb * _InnerAddColor;

#ifdef SPOTLIGHT_ON
				fixed3 spotColor = SpotLightColor(i.posWorld, normalDirection);
				finalColor.rgb += spotColor;
#endif
#endif
				UNITY_APPLY_FOG(i.fogCoord, finalColor); // apply fog
				return finalColor;
			}
			ENDCG
		}

		Pass
		{
			Tags{ "LightMode" = "ForwardAdd" }
			Blend One One
			ZWrite Off
			//Cull Off

			CGPROGRAM
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma multi_compile_fwdadd
			#pragma target 3.0

			#pragma vertex vert
			#pragma fragment frag

			#include "TunnelCom.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;
			uniform fixed _LightAttenuation;

			pointv2f vert(appdata v)
			{
				pointv2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.posWorld = mul(unity_ObjectToWorld, v.vertex);
				o.uv_MainTex = TRANSFORM_TEX(v.uv_MainTex, _MainTex);
				o.normalWorld = UnityObjectToWorldNormal(v.normal);

				fixed3 normalDirection = normalize(o.normalWorld);

				TRANSFER_VERTEX_TO_FRAGMENT(o);

				return o;
			}

			fixed4 frag(pointv2f i) : SV_Target
			{
#ifdef USING_DIRECTIONAL_LIGHT
			discard;
			//return _LightColor0;
			//return fixed4(1,1,1,1);
#endif
			fixed4 textureColor = tex2D(_MainTex, i.uv_MainTex.xy);
			fixed4 finalColor = textureColor;
			finalColor.rgb *= CalculatePointLightColor(i, _LightColor0, _LightAttenuation);
			return finalColor;
			}
			ENDCG
		}

			Pass
			{
				Name "Meta"
				Tags{ "LightMode" = "Meta" }
				Cull Off

				CGPROGRAM
#pragma vertex vert_meta
#pragma fragment frag_meta

#include "Lighting.cginc"
#include "UnityMetaPass.cginc"

				struct v2f
				{
					float4 pos:SV_POSITION;
					float2 uv:TEXCOORD1;
					float3 worldPos:TEXCOORD0;
				};

				uniform fixed4 _Color;
				uniform sampler2D _MainTex;
				v2f vert_meta(appdata_full v)
				{
					v2f o;
					UNITY_INITIALIZE_OUTPUT(v2f,o);
					o.pos = UnityMetaVertexPosition(v.vertex,v.texcoord1.xy,v.texcoord2.xy,unity_LightmapST,unity_DynamicLightmapST);
					o.uv = v.texcoord.xy;
					return o;
				}

				fixed4 frag_meta(v2f IN) :SV_Target
				{
					UnityMetaInput metaIN;
					UNITY_INITIALIZE_OUTPUT(UnityMetaInput,metaIN);
					metaIN.Albedo = tex2D(_MainTex,IN.uv).rgb * _Color.rgb * 0.5; //0.5,magic number, fixed4(0, 0, 0, 1);
					metaIN.Emission = 0;
					return UnityMetaFragment(metaIN);
				}

				ENDCG
			}
	}
	// The definition of a fallback shader should be commented out 
	// during development:
	Fallback "Legacy Shaders/Diffuse"
}
