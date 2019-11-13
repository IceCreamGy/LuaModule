// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "X_MMORPG/FX/WaterPlane_Reflection"
{
	Properties
	{
		_BaseColor("Base Color",Color) = (0.005,0.31,0.34,1)
		_Cube("Reflection Cubemap", Cube) = "white" {}
		_BumpMap ("Texture", 2D) = "white" {}
		_BumpStrength("Bump Strength",Float) = 0.3214
		_BumpDirection("Bump Direction",Vector) = (0.2,1,10,-4)
		_BumpTiling("Bump Tiling",Vector) = (0.1,0.1,0.05,0.05)
		_FresnelParams("Fresnel Params",Vector) = (0.15,1,1,-0.18)
		//Rim parameter
		_RimColor ("Rim Color", Color) = (1,1,1,0.734)
		_RimMap ("_RimMap", 2D) = "white" {}
		_RimSize ("Rim Size", Range(0, 4)) = 1.25
        _Rimfalloff ("Rim falloff", Range(0, 5)) = 0.25
        _Rimtiling ("Rim tiling", Float ) = 2
        _RimSpeed("Rim speed", Float ) = 10
        //Transparent parameter
        _AlphaValue ("Transparent", Range(0,1)) = 1
        _FarDis ("Far Distance", Range(1,300)) = 100

	}
	SubShader
	{
		Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
		Blend SrcAlpha OneMinusSrcAlpha
		Lighting Off ZWrite Off
		Fog { Mode Off }
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile _FOG_OFF  _FOG_ON
			#pragma multi_compile _RIM_OFF _RIM_ON
			#pragma multi_compile _TRANSPARENT_OFF  _TRANSPARENT_ON

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
			#ifdef _RIM_ON
				float3 color : COLOR;
				float2 texcoord0 : TEXCOORD0;
			#endif
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float4 viewDir : TEXCOORD0;
				float4 bumpuv : TEXCOORD1;

			#ifdef  _FOG_ON
				float2 fogdensity : TEXCOORD2;
			#endif

			#ifdef _RIM_ON
				float3 color : COLOR;
				float4 rimUV : TEXCOORD3;
			#endif
				
			};

			float4 _BaseColor;
			sampler2D _BumpMap;
			samplerCUBE _Cube;
			float _BumpStrength;
			float4 _BumpDirection;
			float4 _BumpTiling;
			float4 _FresnelParams;

		#ifdef  _FOG_ON
			float4 _FogParam;
			float4 _HeightFogColor;
			float4 _DistanceFogColor;
		#endif
			
		#ifdef _RIM_ON
			float4 _RimColor;
			sampler2D _RimMap;
			float _RimSize;
			float _Rimfalloff;
			float _Rimtiling;
			float _RimSpeed;
		#endif

		#if _TRANSPARENT_ON
			float _AlphaValue;
			float _FarDis;
		#endif

			v2f vert (appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos (v.vertex);
				float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.viewDir.xyz = worldPos - _WorldSpaceCameraPos.xyz;
				o.viewDir.w = o.pos.w;
				o.bumpuv  =  (worldPos.xzxz + (_Time.x * _BumpDirection)) * _BumpTiling;

			#ifdef  _FOG_ON
				o.fogdensity.x = (worldPos.y - _FogParam.y) / (_FogParam.x - _FogParam.y);
				o.fogdensity.y = (_FogParam.w - o.pos.w) / (_FogParam.w - _FogParam.z);
			#endif

			#ifdef _RIM_ON
				o.color = v.color;
				float speed = _Time.x * _RimSpeed;
				float2 uvTiling = 20 * v.texcoord0.xy * _Rimtiling;
				o.rimUV.xy = (uvTiling + speed * float2(1,0));
				o.rimUV.zw = (uvTiling + speed * float2(0,1));
			#endif
				return o;
			}
			
			float4 frag (v2f i) : SV_Target
			{
				float4 bump01 = tex2D(_BumpMap,i.bumpuv.xy);
				float4 bump02 = tex2D(_BumpMap,i.bumpuv.zw);
				float4 temp10 = bump01 + bump02;
				float4 bump7;
				bump7.zw = temp10.zw;
				bump7.xy = temp10.xy - float2(1,1);
				float3 temp11 = normalize(float3(0,1,0) + ((bump7.xxy * _BumpStrength) * float3(1,0,1)));
				float3 worldNormal;
				worldNormal.y = temp11.y;
				worldNormal.xz = temp11.xz * _FresnelParams.x;
				float3 viewDir = normalize(i.viewDir.xyz);
				float3 temp13 = normalize(viewDir - (2 * (dot(temp11,viewDir) * temp11)));
				float4 refCol = texCUBE(_Cube,temp13);
				float bias = _FresnelParams.w;
				float power = _FresnelParams.z;
				float4 col;
//				col.xyz = lerp(_BaseColor,refCol,float4(clamp(clamp((bias + ((1-bias)*pow(clamp((1-max(dot(-(viewDir),worldNormal),0)),0,1) ,power))),0,1), 0 ,1))).xyz;
				col.xyz = lerp(_BaseColor, refCol, float(clamp (clamp ((bias + ((1.0 - bias) * pow (clamp ((1.0 - max (dot (-(viewDir), worldNormal), 0.0)), 0.0, 1.0), power))), 0.0, 1.0), 0.0, 1.0))).xyz;
				col.a = 1;

			#ifdef _RIM_ON
				float RimSize = ((1.0 - pow(saturate(i.color/_RimSize),_Rimfalloff))*_RimColor.a);
				float3 rimTex01 = tex2D(_RimMap,i.rimUV.xy).rgb;
				float3 rimTex02 = tex2D(_RimMap,i.rimUV.zw).rgb;
				col.rgb = lerp(col.rgb,_RimColor.rgb,saturate( RimSize +  (RimSize*(1.0 - (rimTex01.r*rimTex02.r))*_RimColor.a)  )  );
			#endif

			#ifdef  _FOG_ON
				col.rgb = lerp(_DistanceFogColor.rgb,col.rgb,saturate(i.fogdensity.y));
				col.rgb = lerp(_HeightFogColor.rgb,col.rgb,saturate(i.fogdensity.x));
			#endif

			#if _TRANSPARENT_ON
				col.a = _AlphaValue * lerp(_BaseColor.a,0,(i.viewDir.w -_FarDis)/(_FarDis));//_Color.a;
			#else
				col.a = 1;
			#endif

				return col;
			}
			ENDCG
		}
	}
	CustomEditor "XrpgReflectionWaterMaterialEditor"
}