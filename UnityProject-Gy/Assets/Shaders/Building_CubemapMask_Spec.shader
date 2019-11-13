Shader "TopCar/Env/Building_CubemapMask_Spec" {
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_ReflectColor ("Reflection Color", Color) = (1,1,1,0.5)
		_MainTex ("Base (RGB) RefStrength (A)", 2D) = "white" {} 
		_Cube ("Reflection Cubemap", Cube) = "_Skybox" { TexGen CubeReflect }
		_CubMaskDown("CubMapMaskBase (RGB)", 2D) = "Black" {}
		_Glow("Glow", 2D) = "black"{}
		_GlowValue("Glow Value", float) = 1
		_CubValue("Cube Value", float) = 1
		_Shininess("Shininess", Range(0.03, 1)) = 0.078125
		[NoScaleOffset] _BumpMap("Normalmap", 2D) = "bump" {}
		_SpecularMask("Specular Texture", 2D) = "white"{}
		_SpecularColor("Specular Tint", Color) = (1,1,1,1)
		_Gloss("Gloss Value", Range(0.01, 255)) = 1
	}
	SubShader {
		LOD 200
		Tags { "RenderType"="Opaque" }
	
		CGPROGRAM
		#pragma surface surf MobileBlinnPhong exclude_path:prepass nolightmap noforwardadd halfasview interpolateview

		sampler2D _MainTex;
		samplerCUBE _Cube;
		sampler2D _CubMaskDown;
		sampler2D _Glow;

		fixed _GlowValue;
		fixed _CubValue;

		sampler2D _SpecularMask;
		sampler2D _BumpMap;
		float4 _SpecularColor;
		half _Shininess;
		fixed _Gloss;

		fixed4 _Color;
		fixed4 _ReflectColor;

		struct Input {
			float2 uv_MainTex;
			float3 worldRefl;
			INTERNAL_DATA
		};

		struct SurfaceCustomOutput
		{
			fixed3 Albedo;
			fixed3 Normal;
			fixed3 Emission;
			fixed3 SpecularColor;
			half Specular;
			fixed Gloss;
			fixed Alpha;
		};

		inline fixed4 LightingMobileBlinnPhong(SurfaceCustomOutput s, fixed3 lightDir, fixed3 halfDir, fixed atten)
		{
			fixed diff = max(0, dot(s.Normal, lightDir));

			fixed nh = max(0, dot(s.Normal, halfDir));
			fixed spec = pow(nh, s.Specular * 128) * s.Gloss;
			float3 finalSpec = s.SpecularColor * spec * _SpecularColor.rgb * _Gloss;

			fixed4 c;
			c.rgb = (s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * finalSpec) * atten;
			UNITY_OPAQUE_ALPHA(c.a);
			return c;
		}

		void surf (Input IN, inout SurfaceCustomOutput o) {
			fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
			fixed4 c = tex;
			o.Albedo = (c.rgb * _Color + tex2D(_Glow, IN.uv_MainTex) * _GlowValue);

			fixed4 reflcol = texCUBE (_Cube, IN.worldRefl); //玻璃部分法线有问题
			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_MainTex));
			reflcol *= tex.a;
			fixed4 _cubeMask = tex2D(_CubMaskDown, IN.uv_MainTex);
			o.Emission = reflcol.rgb * _ReflectColor.rgb*_cubeMask.rgb * _CubValue;
			o.Alpha = reflcol.a * _ReflectColor.a;
			o.Gloss = tex.a;

			float4 specMask = tex2D(_SpecularMask, IN.uv_MainTex) * _SpecularColor;
			o.Specular = _Shininess;
			o.SpecularColor = specMask.rgb;
		}
		ENDCG
	}
	

	SubShader 
	{
			Lod 30
			Pass 
			{
				Lighting Off
				SetTexture [_MainTex] 
				{
					Combine texture, texture 
				}
			}
	}


	FallBack "Reflective/VertexLit"
	} 

