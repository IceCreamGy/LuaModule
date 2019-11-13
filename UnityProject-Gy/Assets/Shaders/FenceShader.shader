// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "TopCar/Env/Fence Shader"
{
	Properties
	{
		_Color("Main Color", Color) = (1,1,1,1)
		_MainTex("Base (RGBA)", 2D) = "white" {}
		_MainTexFar("Base (RGBA)", 2D) = "white" {}
		_Cutoff("Base Alpha cutoff", Range(0,.9)) = .5
		_SecondTexDist("Second Texture Distance", Range(0, 100)) = 5
		_SecondTexDistLerp("Second Texture Lerp Distance", Range(0, 100)) = 7
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
			#pragma target 3.0	
			#include "UnityCG.cginc"
			#include "AutoLight.cginc"
			#include "Lighting.cginc"

			sampler2D _MainTex;
			sampler2D _MainTexFar;
			fixed4 _Color;
			uniform half _Cutoff;
			uniform half _SecondTexDist;
			uniform half _SecondTexDistLerp;

			//uniform fixed4 _LightColor0;

			struct vertexInput {
				float4 vertex : POSITION;
				fixed3 normal : NORMAL;
				float4 tangent : TANGENT;
				float2 uv_MainTex : TEXCOORD0;
				float2 uv_Lightmap : TEXCOORD1;				
				//float2 uv_BumpMap : TEXCOORD2;
				//float2 uv_Ref : TEXCOORD2;
				//float4 screenPos : TEXCOORD3;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				//float4 posWorld : TEXCOORD0;
				//fixed3 normalDir : TEXCOORD1;
				//fixed3 lightDir : TEXCOORD1;   //切线空间的光照方向
				float2 uv_MainTex : TEXCOORD0;
				float  cameraToPos : TEXCOORD1;
				//float2 uv_MaskTex : TEXCOORD2;
				//float4 refl : 
				//fixed3 viewDir : TEXCOORD4;
				//float3 normalWorld : TEXCOORD3;
				//float3 tangentWorld : TEXCOORD4;
				//float3 binormalWorld : TEXCOORD5;
				//float4 screenPos : TEXCOORD6;
#ifndef LIGHTMAP_OFF  
				half2 uvLM : TEXCOORD2;
#endif 
				//LIGHTING_COORDS(4, 5)
			};
			
			v2f vert(vertexInput v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos (v.vertex);
				o.uv_MainTex = v.uv_MainTex;

				float3 posWorld = mul(unity_ObjectToWorld, v.vertex);
				o.cameraToPos = distance(_WorldSpaceCameraPos.xyz, posWorld);
				
#ifndef LIGHTMAP_OFF  
				o.uvLM = v.uv_Lightmap.xy * unity_LightmapST.xy + unity_LightmapST.zw;
#endif  
				//TRANSFER_VERTEX_TO_FRAGMENT(o);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 texColor1 = tex2D(_MainTex, i.uv_MainTex);
				fixed4 texColor2 = tex2D(_MainTexFar, i.uv_MainTex);
				fixed4 texColor = i.cameraToPos < _SecondTexDist ? texColor1 : lerp(texColor2, texColor1, saturate((_SecondTexDistLerp - _SecondTexDist) / (i.cameraToPos - _SecondTexDist)));

				clip(texColor.a - _Cutoff);
				fixed4 finalColor = texColor * _Color;
				//fixed4 finalColor = CaculateLightColor(i, surfColor, normalDirection);
#ifndef LIGHTMAP_OFF  
				fixed3 lm = DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, i.uvLM.xy));
				finalColor.rgb *= lm;
#endif 
				//float  atten = LIGHT_ATTENUATION(i);
				//finalColor.rgb *= atten;
				return finalColor;
			}
			ENDCG
	    }
	}
	Fallback "Mobile/Diffuse"
}