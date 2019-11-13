// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "TopCar/Env/Terrain"
{
	Properties
	{
		_Splat0("Layer 1", 2D) = "white" {}
		_Splat1("Layer 2", 2D) = "white" {}
		_Splat2("Layer 3", 2D) = "white" {}
		_Splat3("Layer 4", 2D) = "white" {}
		_Tiling3("_Tiling4 x/y", Vector) = (1,1,0,0)
		_Control("Control (RGBA)", 2D) = "white" {}
		//_MainTex("Never Used", 2D) = "white" {}
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
			//#pragma noforwardadd
			#pragma multi_compile_fog
			#pragma multi_compile_fwdbase 
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile LIGHTMAP_OFF LIGHTMAP_ON
#pragma multi_compile SPOTLIGHT_OFF SPOTLIGHT_ON   
			#pragma target 3.0	
			#include "UnityCG.cginc"
			#include "AutoLight.cginc"
			#include "Lighting.cginc"
#ifdef SPOTLIGHT_ON
#include "SpotLight.cginc"

#endif

			struct Input {
				float4 vertex : POSITION;
				fixed3 normal : NORMAL;
				float2 uv_Control : TEXCOORD0;
				//float2 uv_Splat0 : TEXCOORD1;
				//float2 uv_Splat1 : TEXCOORD2;
				//float2 uv_Splat2 : TEXCOORD3;
				//float2 uv_Splat3 : TEXCOORD4;
				float2 uv_Lightmap : TEXCOORD1;
			};

			sampler2D _Control;
			sampler2D _Splat0,_Splat1,_Splat2,_Splat3;
			float4 _Tiling3;

			float4 _Control_ST;
			float4 _Splat0_ST;
			float4 _Splat1_ST;
			float4 _Splat2_ST;
			float4 _Splat3_ST;

			struct v2f
			{
				float4 pos : SV_POSITION;
				float4 posWorld : TEXCOORD0;
				//fixed3 normalDir : TEXCOORD1;
				//fixed3 lightDir : TEXCOORD1;   //切线空间的光照方向
				float2 uv_Control : TEXCOORD1;
				float2 uv_Splat0 : TEXCOORD2;
				float2 uv_Splat1 : TEXCOORD3;
				float2 uv_Splat2 : TEXCOORD4;
				float2 uv_Splat3 : TEXCOORD5;
				half3 vViewDir : TEXCOORD6;
				//float4 refl : 
				//fixed3 viewDir : TEXCOORD4;
				half3 normalWorld : TEXCOORD7;
				//half3 vLightDir: TEXCOORD4;
				//fixed3 vlight : TEXCOORD7; //vertexlights
#ifndef LIGHTMAP_OFF  
				half2 uvLM : TEXCOORD8;
#endif 
				LIGHTING_COORDS(9, 10)
				UNITY_FOG_COORDS(11)
			};
			
			v2f vert(Input v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos (v.vertex);
				o.uv_Control = v.uv_Control * _Control_ST.xy + _Control_ST.zw;
				o.posWorld = mul(unity_ObjectToWorld, v.vertex);
				o.normalWorld = UnityObjectToWorldNormal(v.normal); //normalize(fixed3(mul(fixed4(v.normal, 0.0), unity_WorldToObject).xyz));
				o.vViewDir = (_WorldSpaceCameraPos.xyz - o.posWorld.xyz); //DON't normalize here!!!
				o.uv_Splat0 = v.uv_Control * _Splat0_ST.xy + _Splat0_ST.zw;
				o.uv_Splat1 = v.uv_Control * _Splat1_ST.xy + _Splat1_ST.zw;
				o.uv_Splat2 = v.uv_Control * _Splat2_ST.xy + _Splat2_ST.zw;
				o.uv_Splat3 = v.uv_Control * _Splat3_ST.xy + _Splat3_ST.zw;

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

			//自己的光照处理函数
			fixed4 LambertDiffuseColor(fixed3 normalWorld)
			{
				//fixed3 normalDirection = normalWorld;//i.normalWorld;
				//fixed3 viewDirection = normalize(_WorldSpaceCameraPos - posWorld);
				//fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
				fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
				float3 diffuseReflection = _LightColor0.xyz *  max(0.0, dot(normalWorld, worldLightDir));//计算兰伯特漫反射
				float3 lightFinal = diffuseReflection + UNITY_LIGHTMODEL_AMBIENT.xyz;
				//fixed3 reflectDir = normalize(reflect(-worldLightDir, normalWorld));
				//fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - posWorld);
				//fixed3 specular = _LightColor0.rgb * _SpecColor.rgb * pow(saturate(dot(reflectDir, viewDirection)), _Gloss);
				fixed4 finalColor = fixed4(lightFinal, 1.0f); // fixed4(ambient + diffuse, 1.0);

				return finalColor;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				//fixed4 tex = tex2D(_MainTex, i.uv_MainTex);
				
				fixed4 splat_control = tex2D(_Control, i.uv_Control).rgba;

				fixed3 lay1 = tex2D(_Splat0, i.uv_Splat0);
				fixed3 lay2 = tex2D(_Splat1, i.uv_Splat1);
				fixed3 lay3 = tex2D(_Splat2, i.uv_Splat2);
				fixed3 lay4 = tex2D(_Splat3, i.uv_Control * _Tiling3.xy);
				fixed3 terrainColor = (lay1 * splat_control.r + lay2 * splat_control.g + lay3 * splat_control.b + lay4 * splat_control.a);
				

				float  atten = LIGHT_ATTENUATION(i);
#ifndef LIGHTMAP_OFF  
				fixed4 finalColor = fixed4(terrainColor, 1);
				fixed3 lm = DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, i.uvLM.xy));
				fixed3 lmFinal = min(lm, fixed3(atten, atten, atten));
				finalColor.rgb *= lmFinal;
#else
				fixed4 finalColor = LambertDiffuseColor(i.normalWorld) + fixed4(terrainColor, 1);
				finalColor.rgb *= atten;
#endif 

#ifdef SPOTLIGHT_ON
				fixed3 spotColor = SpotLightColor(i.posWorld, i.normalWorld);
				finalColor.rgb += spotColor;
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