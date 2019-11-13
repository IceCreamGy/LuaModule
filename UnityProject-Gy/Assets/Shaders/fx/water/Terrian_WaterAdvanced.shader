// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "TopCar/Env/Water/Terrian_WaterAdvanced(Transparent)" {
	Properties
	{
		
	    _WaterColor("Water Color", Color) = (0,0.503546,1,1)
		_MainTex("Main tex", 2D) = "white" {}
		_TexScrollX ("Tex speed X", Float) = 1.0
		_TexScrollY ("Tex speed Y", Float) = 1.0
		 
		_Transparence("Transparence（透明度）", Range(0.0, 1.0)) = 1
		_DistortStrength("DistortStrength（折射强度）", Range(0,2)) = 0.2
	 
		_BumpDepth("Normal Depth（法线1和2强度）", Range(0.0, 1.0)) = 1
		_NormalMap("Normal Texture", 2D) = "bump" {}
		_ScrollX ("NorTex speed X", Float) = 1.0
		_ScrollY ("NorTex speed Y", Float) = 1.0
 
		_NormalMap2("Normal Texture2", 2D) = "bump" {}
		_ScrollX2 ("NorTex2 speed X", Float) = 1.0
		_ScrollY2 ("NorTex2 speed Y", Float) = 1.0
		
		_CubemapTintColor("Cubemap Color（Cube颜色）", Color) = (0,0.503546,1,1)
		_Cubemap("Reflection Cubemap", Cube) = "black" {}
		_CubeMapStrength("CubeMap Strength（Cube强度）", Range(0,1)) = 0.5
		
		_FresnelPower("Fresnel Power（菲尼尔强度）", Range(0,10)) = 1
		_FresnelInverseColor("Fresnel Inverse Color（菲尼尔填充色）", Color) = (0,0,0,1)
		
		_SpecularColor("Specular Color（高光颜色）", Color) = (0,0.503546,1,1)
		_Shiness("Shiness（高光大小）", Range(1, 50)) = 1
		_SpecularPower("Specular Power（高光强度）", Range(0, 1)) = 1
		_LightDir("Light Dir（高光方向）", Vector) = (1,1,1,0)
		
		_WaterBrightness("WaterBrightness（水面亮度）",Range(1.0, 4.0)) = 1
	}

		SubShader
	{
		  
			Tags{ "Queue" = "Geometry+102"  "RenderType" = "Opaque" "LightMode" = "ForwardBase"  "Reflection" = "RenderReflectionOpaque" }
		LOD 400
		ZWrite Off
		Cull Off

			GrabPass
        {
            "_InternelGrabPassTexture"
        }

		Pass
		{
			CGPROGRAM
	#include "UnityCG.cginc"  
	#include "UnityShaderVariables.cginc"
	#include "../../AdvCarCommon.cginc" 	
	#include "../../NssLightmap.cginc"
	#pragma vertex vert  
	#pragma fragment frag  
	#pragma multi_compile LIGHTMAP_OFF LIGHTMAP_ON  
	#pragma target 3.0

		sampler2D _InternelGrabPassTexture;
	
		sampler2D _MainTex;
		float4 _MainTex_ST;
		float _TexScrollX;
		float _TexScrollY;
	 
		sampler2D _NormalMap;
		float4 _NormalMap_ST;
		sampler2D _NormalMap2;
		float4 _NormalMap2_ST;
		float4 _WaterColor;
		float4 _CubemapTintColor;
		float _DistortStrength;
		float _CubeMapStrength;
		samplerCUBE _Cubemap;
		float   _BumpDepth;
		float   _FresnelPower;
		float _SpecularPower;
		float _Shiness;
		float _Transparence;
		float _ScrollX;
		float _ScrollY;
		float _ScrollX2;
		float _ScrollY2;

		half4 _LightDir;
		half4 _SpecularColor;
		half4 _FresnelInverseColor;
		float _WaterBrightness;

		struct vertexInput
		{
			float4 vertex : POSITION;
			float3 normal : NORMAL;
			float4 texcoord : TEXCOORD0;
			float4 texcoord1 : TEXCOORD1;
			float4 tangent : TANGENT;
			half4 color : COLOR; // clip space position
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
			float4 grabPos :TEXCOORD6;
			half3 camDist : TEXCOORD7;
			half4 color : TEXCOORD8;

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

			//计算抓屏的位置，其中主要是将坐标从(-1,1)转化到（0,1）空间并处理DX和GL纹理反向的问题  
			o.grabPos =  ComputeGrabScreenPos(o.pos);
		 
			o.tex.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
			o.tex.zw = v.texcoord.xy * _NormalMap_ST.xy + _NormalMap_ST.zw;
			o.tex2.xy = v.texcoord.xy * _NormalMap2_ST.xy + _NormalMap2_ST.zw;

	#ifndef LIGHTMAP_OFF
			o.tex2.zw = v.texcoord1 * unity_LightmapST.xy + unity_LightmapST.zw;
	#else
			o.tex2.zw = v.texcoord1;
	#endif
			o.camDist = CalcCamDist(v.vertex);
			 
			//o.camDist.z +=  (_WorldSpaceCameraPos.y > _FogSeaLevel) ? 1.0 : - 1.0;
			
			return o;
		}


		 


		fixed4 frag(v2f i) : SV_Target
		{
	 

			half3 tnormal1 = UnpackNormal(tex2D(_NormalMap, i.tex.zw + frac(float2(_ScrollX, _ScrollY) * _Time.x)));
			half3 tnormal2 = UnpackNormal(tex2D(_NormalMap2, i.tex2.xy + frac(float2(_ScrollX2, _ScrollY2) * _Time.x)));
			
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
			
			float NdotV = 1 - max(0.0, dot(N, V));
			float NdotH = clamp(dot(N, H), 0, 1);

			float4 albedo = tex2D(_MainTex, i.tex.xy + normal.xy + frac(float2(_TexScrollX, _TexScrollY) * _Time.x));

	#ifndef LIGHTMAP_OFF
			half3 lightMapCol = NssLightmap_Diffuse(i.tex2.zw);
			albedo.rgb = albedo.rgb * lightMapCol.rgb;
	#endif

			float fres = NssPow(NdotV, _FresnelPower);
		
			float3 diffuse = _WaterColor.xyz * albedo.rgb;
			
			//i.grabPos.xy += normal.xy * _DistortStrength;
			i.grabPos.xy /= i.grabPos.w;
			
			half3 refraction = tex2D(_InternelGrabPassTexture, i.grabPos.xy).rgb;
			
			//return float4(i.grabPos.xy , 0 ,1);
			//  return float4(refraction, 1.0);
			
			half3 skydata = _CubemapTintColor.rgb * texCUBE(_Cubemap, worldReflect).rgb * _CubeMapStrength;

			float3 spec = NssPow(NdotH, 50 - _Shiness) * _SpecularPower * _SpecularColor.rgb;

			half4 color;

			half3 diffAndRefrac = diffuse * _Transparence + refraction * (1 - _Transparence);
			return fixed4(diffAndRefrac, 1);

			color.rgb = (diffAndRefrac * (1 - _CubeMapStrength) + fres * skydata * _CubeMapStrength + (1-fres) * _FresnelInverseColor.rgb * _WaterColor.rgb * albedo.rgb + spec);
			color.rgb = color.rgb * i.color * _WaterBrightness;
			color.rgb = lerp(refraction,color.rgb ,i.color.a);

			return NssFog(i.camDist, color);
		}

			ENDCG
		}
	}
	
	Fallback "Mobile/Diffuse"
}
