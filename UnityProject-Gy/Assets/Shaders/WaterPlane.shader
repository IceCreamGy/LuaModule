// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "TopCar/Env/WaterPlane"
{
	Properties 
	{
		_Color ("base color", COLOR)  = (1,1,1,1)
		//_WaveScale ("Wave scale", Range (0.02,0.15)) = 0.063
		_WaveScale ("Wave scale", Range (0.1,15)) = 1
		_ReflDistort ("Reflection distort", Range (0,1.5)) = 0.44
		_WaveSpeed ("Wave speed (map1 x,y; map2 x,y)", Vector) = (19,9,-16,-7)
		_HorizonColor ("Simple water horizon color", COLOR)  = ( .172, .463, .435, 1)
		_Offest("HorizonColor Offest",Range (0,2)) = 1
		//_RefrDistort ("Refraction distort", Range (0,1.5)) = 0.40
		//_RefrColor ("Refraction color", COLOR)  = ( .34, .85, .92, 1)
		//[NoScaleOffset] _Fresnel ("Fresnel (A) ", 2D) = "gray" {}
		
		[NoScaleOffset] _BumpMap ("Normalmap ", 2D) = "bump" {}
		[NoScaleOffset] _ReflectiveColor ("Reflective color (RGB) fresnel (A) ", 2D) = "" {}
		[Toggle] _Reflect ("_Reflect?", Float) = 0
		_Cube("Reflection Cubemap", Cube) = "white" {}
		_ReflectAmount("Reflection Amount",Range (0,2)) = 1
		//[Toggle] _Fog("_Fog?", Float) = 0
		//_ReflectionTex ("Internal Reflection", 2D) = "" {}
		//_RefractionTex ("Internal Refraction", 2D) = "" {}
	}

// -----------------------------------------------------------
// Fragment program cards


	Subshader 
	{
		Tags { "Queue"="Geometry" "RenderType"="Opaque" }
		Fog { Mode Off }
		Pass 
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			//#pragma multi_compile_fog
			//#pragma multi_compile _FOG_OFF  _FOG_ON
			#pragma multi_compile _REFLECT_OFF  _REFLECT_ON
			#pragma multi_compile_fog
			#include "UnityCG.cginc"

			/*#ifdef  _FOG_ON
			float4 _FogParam;
			fixed4 _HeightFogColor;
			fixed4 _DistanceFogColor;
			#endif*/
			
			half4 _Color;
			uniform half _WaveScale;
			uniform half4 _WaveSpeed;
			half _Offest;
			sampler2D _ReflectiveColor;
			uniform half4 _HorizonColor;
			sampler2D _BumpMap;
			
			#ifdef _REFLECT_ON
			samplerCUBE _Cube;
			half _ReflectAmount;
			#endif
			
			struct appdata 
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f 
			{
				float4 pos : SV_POSITION;
				float2 bumpuv0 : TEXCOORD0;
				float2 bumpuv1 : TEXCOORD1;
				float3 viewDir : TEXCOORD2;
				
				/*#ifdef  _FOG_ON
				half2 fogdensity : TEXCOORD3;
				#endif*/

				UNITY_FOG_COORDS(3)
				
				//#ifdef _REFLECT_ON
				//float3 worldReflection : TEXCOORD4;	
				//#endif
			};

			v2f vert(appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos (v.vertex);
				half4 temp;
				half4 wpos = mul (unity_ObjectToWorld, v.vertex);
				half wscale = _WaveScale * 0.01;
				half4 waveScale4 = float4(wscale,wscale,wscale * 0.4,wscale * 0.45);
				half4 offestClamped;
				offestClamped.x = fmod(_WaveSpeed.x * waveScale4.x * _Time.x,1.0);
				offestClamped.y = fmod(_WaveSpeed.y * waveScale4.y * _Time.x,1.0);
				offestClamped.z = fmod(_WaveSpeed.z * waveScale4.z * _Time.x,1.0);
				offestClamped.w = fmod(_WaveSpeed.w * waveScale4.w * _Time.x,1.0);
				temp.xyzw = wpos.xzxz * waveScale4 + offestClamped;
				o.bumpuv0 = temp.xy;
				o.bumpuv1 = temp.wz;
				o.viewDir.xzy = WorldSpaceViewDir(v.vertex);
				
				/*#ifdef  _FOG_ON
				o.fogdensity.x = (wpos.y - _FogParam.y) / (_FogParam.x - _FogParam.y);
				o.fogdensity.y = (_FogParam.w - o.pos.w) / (_FogParam.w - _FogParam.z);
				#endif*/
				UNITY_TRANSFER_FOG(o, o.pos); // pass fog coordinates to pixel shader
				return o;
			}

			half4 frag( v2f i ) : SV_Target
			{
				i.viewDir = normalize(i.viewDir);
				
				// combine two scrolling bumpmaps into one
				half3 bump1 = UnpackNormal(tex2D( _BumpMap, i.bumpuv0 )).rgb;
				half3 bump2 = UnpackNormal(tex2D( _BumpMap, i.bumpuv1 )).rgb;
				half3 bump = (bump1 + bump2) * 0.5;
				
				// fresnel factor
				half fresnelFac = dot( i.viewDir, bump );
				
				half4 col;
				half4 water = tex2D( _ReflectiveColor, float2(fresnelFac,fresnelFac) );

				col.rgb = lerp( water.rgb, _HorizonColor.rgb, water.a * _Offest);
				col.a = _HorizonColor.a;
				col *= _Color;
				
				#ifdef _REFLECT_ON
				half3 worldReflection = reflect(-i.viewDir,bump);
				half4 refColor = texCUBE(_Cube,worldReflection) * (1-fresnelFac);
				refColor *=_ReflectAmount;
				col.rgb += refColor;
				#endif
				
				/*#ifdef  _FOG_ON
				col.rgb = lerp(_DistanceFogColor.rgb,col.rgb,saturate(i.fogdensity.y));
				col.rgb = lerp(_HeightFogColor.rgb,col.rgb,saturate(i.fogdensity.x));
				#endif*/
				UNITY_APPLY_FOG(i.fogCoord, col); // apply fog
				return col;
			}
			ENDCG
		}
	}
}

