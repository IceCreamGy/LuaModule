// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "QF/Env/Water/Terrian_WaterAdvanced(Opaque)" {
	Properties
	{
		_MainTex("Main tex", 2D) = "white" {}
		_WaterColor("Water Color", Color) = (0,0.503546,1,1)
		_FlowDirection0("MainTex Flow Direction", Vector) = (1,1,0,0)
		_NormalMap("NoiseTexture", 2D) = "white" {}
		_FlowDirection1("NoiseTexture Direction", Vector) = (1,1,0,0)
		_NormalMap2("NoiseTexture2", 2D) = "white" {}
		_FlowDirection2("NoiseTexture2 Direction", Vector) = (1,1,0,0)
		_CubeMapStrength("CubeMap Strength", Range(0,1)) = 0.5
		_Cubemap("Reflection Cubemap", Cube) = "black" {}
		_CubemapTintColor("Cubemap Tint Color", Color) = (0,0.503546,1,1)
		_BumpDepth("Bump Depth", Range(0.0, 1.0)) = 1
		_FresnelPower("Fresnel Power", Range(0, 1)) = 1
		_FresnelInverseColor("Fresnel Inverse Color", Color) = (0,0,0,1)
		_Shiness("Shiness", Range(1, 50)) = 1
		_SpecularPower("Specular Power", Range(0, 1)) = 1
		_SpecularColor("Specular Color", Color) = (0,0.503546,1,1)
		_LightDir("Light Dir", Vector) = (1,1,1,0)
		_WaterBrightness("WaterBrightness",Range(1.0, 2.0)) = 1
	}

	SubShader
	{
		LOD 300

		Tags{ "Queue" = "Geometry+102"  "RenderType" = "Opaque" "LightMode" = "ForwardBase"  "Reflection" = "RenderReflectionOpaque" }

		//Blend SrcAlpha OneMinusSrcAlpha
		ZWrite On
		Cull Off

		Pass
		{
			CGPROGRAM
			#include "UnityCG.cginc"  
			#include "UnityShaderVariables.cginc"
			#include "../../AdvCarCommon.cginc"	
			#include "../../NssLightmap.cginc"
			#pragma multi_compile LIGHTMAP_OFF LIGHTMAP_ON  
			#pragma vertex vert  
			#pragma fragment frag  
			#pragma target 3.0

			sampler2D _MainTex;
			float4 _MainTex_ST;
	 
			sampler2D _NormalMap;
			float4 _NormalMap_ST;
			sampler2D _NormalMap2;
			float4 _NormalMap2_ST;
			float4 _WaterColor;
			float4 _CubemapTintColor;
			float _CubeMapStrength;
			samplerCUBE _Cubemap;
			float   _BumpDepth;
			float   _FresnelPower;
			float _SpecularPower;
			float _Shiness;
			half4 _FlowDirection0;
			half4 _FlowDirection1;
			half4 _FlowDirection2;
			half4 _LightDir;
			half4 _SpecularColor;
			half4 _FresnelInverseColor;
			float _WaterBrightness;

			struct vertexInput
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
				float4 tangent : TANGENT;
				half4 color : COLOR; 
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float4 tex : TEXCOORD0;
				float4 tex2 : TEXCOORD1;
				half3 tspace0 : TEXCOORD2; // tangent.x, bitangent.x, normal.x
				half3 tspace1 : TEXCOORD3; // tangent.y, bitangent.y, normal.y
				half3 tspace2 : TEXCOORD4; // tangent.z, bitangent.z, normal.z
				float4 posWorld : TEXCOORD5;
				half4 color : TEXCOORD6;
				half3 camDist : TEXCOORD7;
				

			};


			v2f vert(vertexInput v)
			{
				v2f o;

				o.posWorld = mul(unity_ObjectToWorld, v.vertex);
				o.pos = UnityObjectToClipPos(v.vertex);
				o.color = v.color;

				half3 wNormal = normalize(mul(float4(v.normal, 0.0), unity_WorldToObject).xyz);
				half3 wTangent = normalize(mul(unity_ObjectToWorld, half4(half3(v.tangent.xyz), 0)).xyz);
				half3 wBitangent = normalize(cross(wNormal, wTangent) * v.tangent.w);

				o.tspace0 = half3(wTangent.x, wBitangent.x, wNormal.x);
				o.tspace1 = half3(wTangent.y, wBitangent.y, wNormal.y);
				o.tspace2 = half3(wTangent.z, wBitangent.z, wNormal.z);

				o.tex.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				o.tex.zw = v.texcoord.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
				o.tex2.xy = v.texcoord.xy * _NormalMap2_ST.xy + _NormalMap2_ST.zw;

			#ifndef LIGHTMAP_OFF
				o.tex2.zw = v.texcoord.xy * unity_LightmapST.xy + unity_LightmapST.zw;
			#else
				o.tex2.zw = v.texcoord.xy;
			#endif
				o.camDist = CalcCamDist(v.vertex);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				float4 albedo = tex2D(_MainTex,   i.tex.xy - _Time.x * _FlowDirection0.xy);
				//half3 lightMapCol = NssLightmap_Diffuse(i.tex2.zw);
				//albedo.rgb = albedo.rgb * lightMapCol.rgb;

				half3 tnormal1 = UnpackNormal(tex2D(_NormalMap, i.tex.zw - _Time.x  * _FlowDirection1.xy));
				half3 tnormal2 = UnpackNormal(tex2D(_NormalMap2, i.tex2.xy - _Time.x  * _FlowDirection2.xy));
				half3 normal = tnormal1 + tnormal2;
				normal = normalize(lerp(half3(0, 0, 1), normal, _BumpDepth));

				half3 worldNormal;
				worldNormal.x = dot(i.tspace0, normal);
				worldNormal.y = dot(i.tspace1, normal);
				worldNormal.z = dot(i.tspace2, normal);

				float3 N = normalize(worldNormal);
				float3 V = normalize(_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
		 
				float3 L = normalize(_LightDir);
				float3 H = normalize(V + L);

				float3 worldReflect = reflect(-V,N);

				//lighting
				float NdotV = 1 - max(0.0, dot(N, V));
				float NdotH = clamp(dot(N, H), 0, 1);


				float fres = NssPow(NdotV, _FresnelPower);

				float3 diffuse = _WaterColor.xyz * albedo.rgb;

				float3 rim = fres * _WaterColor.rgb * _WaterColor.a;

				half3 skydata = _WaterBrightness*_CubemapTintColor.rgb * texCUBE(_Cubemap, worldReflect).rgb * _CubeMapStrength;

				float3 spec = NssPow(NdotH, 50 - _Shiness) * _SpecularPower * _SpecularColor.rgb;

				fixed4 color;
				color.rgb = diffuse * (1 - _CubeMapStrength) + fres * skydata * _CubeMapStrength + (1 - fres) * _FresnelInverseColor.rgb * _WaterColor.rgb * albedo.rgb + spec;
				//color.rgb =  fres * skydata * _CubeMapStrength + spec;
				color.rgb = color.rgb * i.color;
				return NssFog(i.camDist, color);
			}

		ENDCG
		}
	}
	Fallback "QF/Env/Water/Terrian_WaterAdvanced(Opaque)Middle"
}
