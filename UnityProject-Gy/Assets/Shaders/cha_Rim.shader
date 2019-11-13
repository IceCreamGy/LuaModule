// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "X_MMORPG/Character/Rim" 
{
	Properties 
	{
		_RimColor("Bian Yuan Guang",Color) = (1,1,1,1)
		_RimIntensity("BYG Intensity",range(0,5)) = 1
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_FLTex ("Blink Map", 2D) = "white" {}
		_FLColor("FL Color",Color) = (1,1,1,1)
		_FLIntensity ("FL Intensity", Range(0,20)) = 1
		_BlinkSpeed("Blink Speed",Range(0,20)) = 8
		//_DiffuseWarpTex ("DiffuseWarp (RGB)", 2D) = "white" {}
		[Toggle] _RimLightRamp ("Rim Light?", Float) = 0
		fRimLightRampColor ("Rim Light Color", Color) = (1, 1, 1, 1)
		fRimLightScale ("Rim Light Scale", float) = 1
	}

	SubShader 
	{
		Tags { "RenderType"="Opaque" "LightMode"="ForwardBase"}
		
		CGINCLUDE
		#include "UnityCG.cginc"
		ENDCG	
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest	
			#pragma target 2.0
			
			#pragma multi_compile _RIMLIGHTRAMP_OFF  _RIMLIGHTRAMP_ON
			#pragma multi_compile _FOG_OFF  _FOG_ON
			#pragma multi_compile _USEXRPGLIGHT_OFF _USEXRPGLIGHT_ON
			
			uniform half4 _LightColor0;
			uniform sampler2D _MainTex;
			uniform half4 _RimColor;
			uniform half _RimIntensity;
			
			sampler2D _FLTex;
			float4 _FLTex_ST;
			half _BlinkSpeed;
			half _FLIntensity;
			half4 _FLColor;
			
			//uniform sampler2D _DiffuseWarpTex;
			
			#ifdef _RIMLIGHTRAMP_ON
			half4 fRimLightRampColor; 
			half fRimLightScale;
			#endif

			#ifdef  _FOG_ON
			half4 _FogParam; 
			half4 _HeightFogColor; 
			half4 _DistanceFogColor; 
			#endif

			#if _USEXRPGLIGHT_ON
			half4 _XrpgLightDirection;
			half4 _XrpgLightColor;
			half _XrpgLightIntensity;
			#endif
			
			
			struct VertexInput {
		        half4 vertex : POSITION;
		        half3 normal : NORMAL;
		        half4 texcoord : TEXCOORD0;
		    };
		    struct VertexOutput {
		        half4 pos : SV_POSITION;
		        half4 uv : TEXCOORD0;
				half3 worldNormal : TEXCOORD1;
				half3 viewVec : TEXCOORD2;
				
				#ifdef  _FOG_ON
				half2 fogdensity : TEXCOORD3;
				#endif
		    };

		    VertexOutput vert (VertexInput v)
			{
				VertexOutput o = (VertexOutput)0;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.worldNormal = normalize(mul((float3x3)unity_ObjectToWorld, v.normal));
				o.viewVec =  normalize( WorldSpaceViewDir(v.vertex));
				o.uv.xy = v.texcoord.xy;
				o.uv.zw =  TRANSFORM_TEX(v.texcoord,_FLTex).xy + float2(0,_Time.x * _BlinkSpeed);

				#ifdef  _FOG_ON
				//Vector4(top, bottom, near, far);
				float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.fogdensity.x = (worldPos.y - _FogParam.y) / (_FogParam.x - _FogParam.y);
				o.fogdensity.y = (o.pos.w - _FogParam.w) / (_FogParam.z - _FogParam.w);
				#endif
				
				return o;
			}

			half4 frag (VertexOutput i) : COLOR
			{
				half3 N = i.worldNormal;
				half3 mainTexColor = tex2D(_MainTex, i.uv.xy);
				
				
				
				#if _USEXRPGLIGHT_ON
				half3 L = normalize(_XrpgLightDirection.xyz);
				#else
				half3 L = normalize(_WorldSpaceLightPos0.xyz);
				#endif
				
				half NdotL = saturate(dot(N,L));
				//half halfLambert = NdotL * 0.5 + 0.5;
				half halfLambert = (NdotL + 3)/4;
				half3 diffuseLight = halfLambert;//tex2D(_DiffuseWarpTex,float2(halfLambert,0.25f));
				
				#if _USEXRPGLIGHT_ON
				diffuseLight *= _XrpgLightColor * _XrpgLightIntensity;
				#else
				diffuseLight *= _LightColor0;
				#endif
				
				half3 final = mainTexColor * diffuseLight;
				
				half3 V = normalize(i.viewVec);
				half VdotN = saturate(1 - saturate( dot(V, N) ) );
				//half3 bygLighting = (_RimColor * VdotN * _RimIntensity)*(0.3+max(0,sin(_Time.b*1.2)));
				half3 bygLighting = pow(_RimColor * VdotN * _RimIntensity,2);
				final += bygLighting;
				
				#ifdef _RIMLIGHTRAMP_ON
				half3 rimLighting = fRimLightRampColor * VdotN * fRimLightScale;
				final += rimLighting;
				#endif
				
				final += tex2D(_FLTex,i.uv.zw)*_FLColor*_FLIntensity;
				//final +=  pow((max(0,i.uv.y - fmod(_Time.y/10,1))),3);
				//final +=  pow(abs(i.uv.y - cos(_Time.y*0.33)*sin(_Time.y)) ,32);
				//final += fmod(_Time.y,1)-i.uv.y;
				#ifdef  _FOG_ON
				final.rgb = lerp(_HeightFogColor.rgb,final.rgb,saturate(i.fogdensity.x));
				final.rgb = lerp(_DistanceFogColor.rgb,final.rgb,saturate(i.fogdensity.y));
				#endif

				return half4(final,1.0f);
			}
			ENDCG 
		}
	}
}