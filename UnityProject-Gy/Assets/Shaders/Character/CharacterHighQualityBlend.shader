// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "TopCar/Character/Charater High Quality Blend" {
Properties {
	_MainTex ("Base (RGB)", 2D) = "white" {}
	_NormMap ("Normalmap", 2D) = "bump" {}

	//_Mask1Tex ("Mask1 (RGBA)", 2D) = "white" {}
	//_Mask2Tex ("Mask2 (RGBA)", 2D) = "white" {}


	_FresnelWarpTex ("FresnelWarp (RGB)", 2D) = "white" {}
	_DiffuseWarpTex ("DiffuseWarp (RGB)", 2D) = "white" {}


	fSpecularColor ("Specular Color", Color) = (1, 1, 1, 1)
	
	fSpecularScale ("Specular Scale", float) = 1

	_SpecTex("Specular Texture (RGB)", 2D) = "white" {}
	fSpecularExponent ("Specular Exponent", float) = 16
	//_SpecExpTex("Specular Exponent Texture (R)", 2D) = "white" {}

	fRimLightColor ("Rim Light Color", Color) = (1, 1, 1, 1)
	fRimLightScale ("Rim Light Scale", float) = 1

	_RimTex("Rim Texture (RGB)", 2D) = "white" {}
	_HighLight("HightLight Color", Color) = (0,0,0,0)
	shadowValue ("Shadow Value", float) = 1
	_ShadowColor("Shadow Color", Color) = (0,0,0,0)

}


// hight quality
SubShader {
	Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
	LOD 300
	Lighting On
	ZWrite On                                                                                                                                                                    
	ZTest On
	Blend SrcAlpha OneMinusSrcAlpha
	Cull Back
	ColorMask RGB
	Fog {Mode Off}

	Pass {
		Name "ForwardBase"

		
		CGPROGRAM
		#pragma multi_compile_fwdbase
		#pragma vertex vert
		#pragma fragment frag
		#pragma fragmentoption ARB_precision_hint_fastest	
		#include "UnityCG.cginc"
		#include "AutoLight.cginc"
		//#pragma only_renderers gles d3d9 
//		#pragma target 3.0

		//#define OPTIMIZE
	
		uniform half4 _LightColor0;
		uniform sampler2D _MainTex;
		uniform sampler2D _NormMap;
		//uniform sampler2D _Mask1Tex;
		//uniform sampler2D _Mask2Tex;
		uniform sampler2D _FresnelWarpTex;
		uniform sampler2D _DiffuseWarpTex;
		uniform half4   fSpecularColor;
		uniform float	fSpecularExponent;
		uniform float   fSpecularScale;
		uniform half4 fRimLightColor;
		uniform float  fRimLightScale;
		uniform sampler2D _SpecTex;
		//uniform sampler2D _SpecExpTex;
		uniform sampler2D _RimTex;
		uniform half4   _HighLight;
		uniform half4 _ShadowColor;

		struct VertexInput {
	        float4 vertex : POSITION;
	        float3 normal : NORMAL;
	        float4 texcoord : TEXCOORD0;
			float4 tangent	: TANGENT;
			LIGHTING_COORDS(1,2)
	    };
	    struct VertexOutput {
	        float4 pos : SV_POSITION;
	        float4 uv : TEXCOORD0;
	        fixed3 lightDir : TEXCOORD1;
			float3 viewDir : TEXCOORD2;
			fixed3 up	:	TEXCOORD3;
			LIGHTING_COORDS(4,5)

	    };

	    VertexOutput vert (VertexInput v)
		{
			VertexOutput o = (VertexOutput)0; 
			o.pos = UnityObjectToClipPos(v.vertex);
			TANGENT_SPACE_ROTATION;
			o.lightDir = mul (rotation, ObjSpaceLightDir(v.vertex));
			o.viewDir = mul (rotation, ObjSpaceViewDir(v.vertex));
			fixed3 oUp = mul((float3x3)unity_WorldToObject, fixed3(0.0, 1.0, 0.0 ));

			o.up = mul (rotation, oUp);
			o.uv.xy = v.texcoord.xy;
			TRANSFER_VERTEX_TO_FRAGMENT(o);
			return o;
		}

		fixed4 frag (VertexOutput i) : COLOR
		{
			half atten = LIGHT_ATTENUATION(i);
			float2 texCoord = i.uv.xy;
			fixed3 V = normalize(i.viewDir);
			fixed3 L = normalize(i.lightDir);

			fixed3 N = UnpackNormal(tex2D(_NormMap,texCoord));

			//return fixed4(N,1.0f);
			
			float3 flSpecularMask      = tex2D(_SpecTex,texCoord);
			float3 flRimMask           = tex2D(_RimTex,texCoord);
			//float flSpecularExponent  = tex2D(_SpecExpTex,texCoord).r;
			float flSpecularExponent  = flSpecularMask.r+0.01;//remove black point

			float VdotN = saturate( dot( V, N ) );
			float3 FresnelTerm = tex2D( _FresnelWarpTex, float2( VdotN, 0.5f )).rgb;

			float3 diffuseColor = tex2D(_MainTex, texCoord);

			//diffuseColor = pow(diffuseColor, 2.2f);

			//return fixed4(diffuseColor,1.0f);
			//float flFresnelColorWarp =  FresnelTerm.g;
			//return fixed4(flFresnelColorWarp.xxx,1.0);
			//diffuseColor = lerp( diffuseColor, float3(0.0,0.0,0.0), flFresnelColorWarp );
			//return fixed4(diffuseColor,1.0f);

			// Do lighting ...   _LightColor0;

			float NdotL = dot(N,L);
			half shadowStrenth = _LightShadowData.r;
			//atten =step(0.1,NdotL) *(atten -shadowStrenth) + shadowStrenth; 
			atten = clamp(NdotL,0,1) *(atten - shadowStrenth) + shadowStrenth; 
			fixed3 shadow = (1-flSpecularMask.g)*(1-atten)*(_ShadowColor.rgb-1) + 1;

			//lerp(atten,1,flSpecularMask.g);
			
			float halfLambert = NdotL * 0.5 + 0.5;
			
			float3 diffuseLight = tex2D(_DiffuseWarpTex,float2(halfLambert,0.1));
			diffuseLight = diffuseLight * _LightColor0.rgb ;
			//diffuseLight =diffuseLight * _LightColor0.rgb * atten ;
			//return fixed4(diffuseLight,1.0f);

			//NdotL = saturate( NdotL );
			float3 R = reflect( V, N ); 
			float RdotL = saturate( dot( L, -R ) );
			
			fSpecularExponent *= flSpecularExponent;
			//flSpecularExponent *= fSpecularExponent;
			
			float3 SpecularLighting = pow( RdotL, fSpecularExponent);
			SpecularLighting *= _LightColor0.rgb;

			float3 final = diffuseLight * diffuseColor;
			float3 cSpecular = SpecularLighting * fSpecularScale;
			cSpecular *= flSpecularExponent;
			cSpecular *= fSpecularColor;
			//cSpecular *= FresnelTerm.b;
			final += cSpecular;

			//return fixed4(cSpecular,1.0f);

			float3 rimLighting = (FresnelTerm.r * fRimLightScale) * flRimMask; 
			rimLighting *= saturate(dot(N, i.up)); 
			rimLighting *= fRimLightColor;

			final += rimLighting;
			return fixed4(final* shadow + _HighLight.rgb,flSpecularMask.b);

			//return fixed4(rimLighting,1.0);
			//return fixed4(pow(final, 0.4545f),1.0);
		}
		ENDCG 
	}

}


// low quality
SubShader {
	Tags { "RenderType"="Opaque" "LightMode"="ForwardBase"}
	LOD 200

	Fog {Mode Off}
	
	Pass {
		Name "ForwardBase"

		CGPROGRAM
		#pragma multi_compile_fwdbase
		#pragma vertex vert
		#pragma fragment frag
		#pragma fragmentoption ARB_precision_hint_fastest	
		#include "UnityCG.cginc"
		#include "AutoLight.cginc"
	
		uniform half4 _LightColor0;
		uniform sampler2D _MainTex;
		uniform sampler2D _NormMap;
		uniform sampler2D _DiffuseWarpTex;
		uniform half4   fSpecularColor;
		uniform float	fSpecularExponent;
		uniform float   fSpecularScale;
		uniform sampler2D _SpecTex;
		uniform sampler2D _RimTex;
		uniform half4   _HighLight;

		struct VertexInput {
	        float4 vertex : POSITION;
	        float3 normal : NORMAL;
	        float4 texcoord : TEXCOORD0;
			float4 tangent	: TANGENT;
	    };
	    struct VertexOutput {
	        float4 pos : SV_POSITION;
	        float4 uv : TEXCOORD0;
	        fixed3 lightDir : TEXCOORD1;
			float3 viewDir : TEXCOORD2;
			fixed3 up	:	TEXCOORD3;
	    };

	    VertexOutput vert (VertexInput v)
		{
			VertexOutput o = (VertexOutput)0; 
			o.pos = UnityObjectToClipPos(v.vertex);
			TANGENT_SPACE_ROTATION;
			o.lightDir = mul (rotation, ObjSpaceLightDir(v.vertex));
			o.viewDir = mul (rotation, ObjSpaceViewDir(v.vertex));
			fixed3 oUp = mul((float3x3)unity_WorldToObject, fixed3(0.0, 1.0, 0.0 ));

			o.up = mul (rotation, oUp);
			o.uv.xy = v.texcoord.xy;
			return o;
		}

		fixed4 frag (VertexOutput i) : COLOR
		{
			float2 texCoord = i.uv.xy;
			fixed3 V = normalize(i.viewDir);
			fixed3 L = normalize(i.lightDir);

			fixed3 N = UnpackNormal(tex2D(_NormMap,texCoord));
			
			float3 flSpecularMask      = tex2D(_SpecTex,texCoord);
			float flSpecularExponent  = flSpecularMask.r+0.01;//remove black point
	

			float3 diffuseColor = tex2D(_MainTex, texCoord);

			
			float NdotL = dot(N,L);

			float halfLambert = NdotL * 0.5 + 0.5;
			
			float3 diffuseLight = tex2D(_DiffuseWarpTex,float2(halfLambert,0.1));
			diffuseLight =diffuseLight * _LightColor0.rgb ;

			float3 R = reflect( V, N ); 
			float RdotL = saturate( dot( L, -R ) );
			
			fSpecularExponent *= flSpecularExponent;
			
			float3 SpecularLighting =pow( RdotL, fSpecularExponent);
			SpecularLighting *= _LightColor0.rgb;

			float3 final = diffuseLight * diffuseColor;
			float3 cSpecular = SpecularLighting * fSpecularScale;
			cSpecular *= flSpecularExponent;
			cSpecular *= fSpecularColor;
			final += cSpecular;

			return fixed4(final + _HighLight.rgb,1.0f);
			
		}
		ENDCG 
	}

}

SubShader {
	Tags { "RenderType"="Opaque" "LightMode"="ForwardBase"}
	LOD 100

	Fog {Mode Off}
	
	Pass {
		Name "ForwardBase"

		CGPROGRAM
		#pragma multi_compile_fwdbase
		#pragma vertex vert
		#pragma fragment frag
		#pragma fragmentoption ARB_precision_hint_fastest	
		#include "UnityCG.cginc"
		#include "AutoLight.cginc"
	
		uniform half4 _LightColor0;
		uniform sampler2D _MainTex;
		uniform sampler2D _NormMap;
		uniform sampler2D _DiffuseWarpTex;
		uniform half4   fSpecularColor;
		uniform float	fSpecularExponent;
		uniform float   fSpecularScale;
		uniform sampler2D _SpecTex;
		uniform sampler2D _RimTex;
		uniform half4   _HighLight;

		struct VertexInput {
	        float4 vertex : POSITION;
	        float3 normal : NORMAL;
	        float4 texcoord : TEXCOORD0;
			float4 tangent	: TANGENT;
	    };
	    struct VertexOutput {
	        float4 pos : SV_POSITION;
	        float4 uv : TEXCOORD0;
	        fixed3 lightDir : TEXCOORD1;
	    };

	    VertexOutput vert (VertexInput v)
		{
			VertexOutput o = (VertexOutput)0; 
			o.pos = UnityObjectToClipPos(v.vertex);
			TANGENT_SPACE_ROTATION;
			o.lightDir = mul (rotation, ObjSpaceLightDir(v.vertex));
			fixed3 oUp = mul((float3x3)unity_WorldToObject, fixed3(0.0, 1.0, 0.0 ));
			o.uv.xy = v.texcoord.xy;
			return o;
		}

		fixed4 frag (VertexOutput i) : COLOR
		{
			float2 texCoord = i.uv.xy;

			fixed3 L = normalize(i.lightDir);

			fixed3 N = UnpackNormal(tex2D(_NormMap,texCoord));
			
			float3 diffuseColor = tex2D(_MainTex, texCoord);

			
			float NdotL = dot(N,L);

			float halfLambert = NdotL * 0.5 + 0.5;
			
			float3 diffuseLight = tex2D(_DiffuseWarpTex,float2(halfLambert,0.1));
			diffuseLight =diffuseLight * _LightColor0.rgb ;


			float3 final = diffuseLight * diffuseColor;


			return fixed4(final,1.0f);
			
		}
		ENDCG 
	}

}
	FallBack "Diffuse"
}