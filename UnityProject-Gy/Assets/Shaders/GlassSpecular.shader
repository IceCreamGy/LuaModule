// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "TopCar/Env/SpecReflective"
{
	Properties
	{
		_Color("Diffuse Material Color (RGB)", Color) = (1,1,1,1)
		//效率考虑，不计算高光
		//_SpecColor("Specular Material Color (RGB)", Color) = (1,1,1,1)
		//_Shininess("Shininess", Range(0.01, 10)) = 1
		//_Gloss("Gloss", Range(0.0, 10)) = 1
		_MainTex("Diffuse Texture", 2D) = "white" {}
		//_MaskTex("Mask Map", 2D) = "white" {}
		_CubeTex("Reflection Map", Cube) = "" {}
		_Reflection("Reflection Power", Range(0.00, 1)) = 0
		_ShadowRelection("Shadow effect on glass", Range(0, 1)) = 0.5
		//_Contrast("Contrast", Range(0.00, 1)) = 1
		//_Brightness("Brightness", Float) = 1
		[Toggle] Lightmap("_Lightmap?", Float) = 1
		_FrezPow("Fresnel Power",Range(0,2)) = .25
		_FrezFalloff("Fresnal Falloff",Range(0,10)) = 4
	}
	SubShader
	{
		Tags { "QUEUE" = "Geometry" "RenderType"="Opaque" }
		LOD 400
		//LOD 100

		Pass
		{
			Tags{ "LightMode" = "ForwardBase" }
			CGPROGRAM

			// make fog work
			//#pragma multi_compile_fog
			#pragma fragmentoption ARB_precision_hint_fastest
			#pragma multi_compile_fwdbase
			#pragma multi_compile LIGHTMAP_OFF LIGHTMAP_ON 
			#pragma target 3.0

			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			#include "AutoLight.cginc"
			#include "Lighting.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				fixed3 normal : NORMAL;
				float2 uv_MainTex : TEXCOORD0;
				float2 uv_Lightmap : TEXCOORD1;
				//float2 uv_MaskTex : TEXCOORD1;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float4 posWorld : TEXCOORD0;
				fixed3 normalWorld : TEXCOORD1;
				float2 uv_MainTex : TEXCOORD2;
				float3 vertexLight: TEXCOORD5;
				//float2 uv_MaskTex : TEXCOORD3;
				//UNITY_FOG_COORDS(1)

#ifndef LIGHTMAP_OFF  
				half2 uvLM : TEXCOORD3;
#else
				LIGHTING_COORDS(3, 4)
#endif 
			};

			sampler2D _MainTex;
			//sampler2D _MaskTex;
			samplerCUBE _CubeTex;
			float4 _MainTex_ST;

			uniform fixed4 _Color;
			uniform fixed _Reflection;
			uniform fixed _ShadowRelection;
			//uniform half _Brightness;
			//uniform half _Contrast;
			//uniform fixed4 _SpecColor;
			//uniform half _Shininess;
			//uniform half _Gloss;

			fixed _FrezPow;
			half _FrezFalloff;
			fixed _refl;

			// The following built-in uniforms (except _LightColor0) 
			// are also defined in "UnityCG.cginc", 
			// i.e. one could #include "UnityCG.cginc" 
			//uniform fixed4 _LightColor0;
			// color of light source (from "Lighting.cginc")
			
			v2f vert (appdata v)
			{
				v2f o;
				//o.pos = UnityObjectToClipPos(v.vertex);
				o.pos = UnityObjectToClipPos(v.vertex);
				o.posWorld = mul(unity_ObjectToWorld, v.vertex);
				o.uv_MainTex = TRANSFORM_TEX(v.uv_MainTex, _MainTex);
				//o.uv_MaskTex = o.uv_MainTex;
				o.normalWorld = UnityObjectToWorldNormal(v.normal); //normalize( mul(v.normal, (float3x3)unity_WorldToObject) );

				o.vertexLight = fixed3(0, 0, 0);
				fixed3 normalDirection = normalize(o.normalWorld);
#ifndef LIGHTMAP_OFF  
				o.uvLM = v.uv_Lightmap.xy * unity_LightmapST.xy + unity_LightmapST.zw;
#else
				float3 shLight = ShadeSH9(float4(normalDirection, 1.0));
				float3 vertexLight = Shade4PointLights(
					unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
					unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb,
					unity_4LightAtten0, o.posWorld, normalDirection);
				o.vertexLight = vertexLight + shLight;
				TRANSFER_VERTEX_TO_FRAGMENT(o);
#endif
				//UNITY_TRANSFER_FOG(o,o.posWorld);
				return o;
			}
			
			fixed4 frag (v2f i) : COLOR //SV_Target
			{
				// sample the texture
				fixed3 normalDirection = normalize(i.normalWorld);
				fixed3 viewDirection = normalize(
					_WorldSpaceCameraPos - i.posWorld.xyz);
				//fixed3 lightDirection;
				fixed attenuation = 1.0; // no attenuation

				fixed4 textureColor = tex2D(_MainTex, i.uv_MainTex.xy);
				//fixed specularWeight = textureColor.a;
				fixed alpha = 1.0; //目前不透明玻璃反射，textureColor.a * _Color.a;

				//if (specularWeight < 0.1)
				//{
				//	return textureColor;
				//}

				//fixed3 ambientLighting =
				//	UNITY_LIGHTMODEL_AMBIENT.xyz * _Color.xyz;

				//fixed3 diffuseReflection =
				//	attenuation * _LightColor0.xyz * _Color.xyz
				//	* max(0.0, dot(normalDirection, lightDirection));

				//fixed3 specularReflection;

				//if (dot(normalDirection, lightDirection) < 0.0)
				//{
				//	specularReflection = fixed3(0.0, 0.0, 0.0);
				//}
				//else // light source on the right side
				//{ //玻璃alpha = 0.0
				//	specularReflection = attenuation * specularWeight * _LightColor0.rgb
				//		* _SpecColor.rgb * pow(max(0.0, 
				//			dot(reflect(lightDirection, normalDirection),viewDirection)
				//		), _Shininess);
				//}

				//specularReflection *= _Gloss;

				fixed3 viewReflectDir = reflect(-viewDirection, normalDirection);
				fixed4 reflTex = texCUBE(_CubeTex, viewReflectDir);

				//Calculate Reflection vector
				//fixed SurfAngle = clamp(abs(dot(viewReflectDir,i.normalWorld)),0,1);
				//fixed frez = pow(1 - SurfAngle,_FrezFalloff);
				//frez *= _FrezPow;

				//_Reflection += frez;

				//方便识别和操作，alpha越小，反射越强
				//方便计算，_refl越大，反射越强
				_refl = (1 - textureColor.a) * _Reflection;

				//reflTex.rgb *= saturate(_Reflection);

				//reflTex *= _Brightness;
				//contrast对比度：首先计算对比度最低的值
				//fixed4 avgColor = fixed4(0.5, 0.5, 0.5, 1.0);
				//根据Contrast在对比度最低的图像和原图之间差值  
				//reflTex = lerp(avgColor, reflTex, _Contrast);

				fixed4 finalColor = fixed4(textureColor.rgb * (1 - _refl) + reflTex * _refl , alpha); //* saturate(ambientLighting + diffuseReflection) + specularReflection  + reflTex + (frez * reflTex)

				fixed shadowEffect = _refl * _ShadowRelection;
#ifndef LIGHTMAP_OFF
				fixed3 lm = DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap, i.uvLM.xy));
				lm = lm + (1 - lm) * shadowEffect;
				finalColor.rgb *= lm;
#else
				fixed3 ambientLighting = UNITY_LIGHTMODEL_AMBIENT.xyz * _Color.xyz;
				fixed3 lightDirection = normalize(WorldSpaceLightDir(i.posWorld)); //世界坐标系做光照计算
				fixed3 diffuseReflection =
					attenuation * _LightColor0.xyz * _Color.xyz
					* max(0.0, dot(normalDirection, lightDirection));

				//fixed4 _SpecColor = fixed4(1, 1, 1, 1);
				//fixed _Shininess = 64;
				//fixed3 specularReflection = attenuation * _LightColor0.rgb
				//	* _SpecColor.rgb * pow(max(0.0, dot(
				//		reflect(-lightDirection, normalDirection),
				//		viewDirection)), _Shininess);

				//Calculate Reflection vector
				fixed SurfAngle = clamp(abs(dot(viewReflectDir, normalDirection)), 0, 1);
				fixed frez = pow(1 - SurfAngle, _FrezFalloff);
				frez *= _FrezPow;

				finalColor = fixed4(textureColor.rgb * saturate(diffuseReflection + i.vertexLight) + reflTex * _refl * shadowEffect + (frez * reflTex), alpha); //ambientLighting + ,没加ambientLighting,否则与内置Diffuse有色差，偏亮

				float  atten = LIGHT_ATTENUATION(i);
				atten = atten + (1 - atten) * shadowEffect;
				finalColor.rgb *= atten;
#endif
				return finalColor;

				// apply fog
				//UNITY_APPLY_FOG(i.fogCoord, col);
			}
			ENDCG
		}
	}
	// The definition of a fallback shader should be commented out 
	// during development:
	Fallback "Mobile/Diffuse"
}
