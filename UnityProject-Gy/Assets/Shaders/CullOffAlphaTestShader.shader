// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "TopCar/Env/CulloffAlphaTest" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Cutoff("Base Alpha cutoff", Range(0,.9)) = .5
		//_SpecularColor("Specular Color", Color) = (1,1,1,1)
		//_Metallic ("Metallic", Range(0,1)) = 0.0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }		
		
		//uniform fixed4 _SpecularColor;

		Pass
		{
			Tags{ "LightMode" = "ForwardBase" }
			Cull Off
			CGPROGRAM
				//#include "../AdvCarCommon.cginc"	
#include "UnityCG.cginc"
#pragma target 3.0
#pragma vertex vert
#pragma fragment frag
#pragma exclude_renderers xbox360 flash	
#pragma multi_compile_fog


			sampler2D _MainTex;
			uniform float _Cutoff;
			//sampler2D _DiffuseAlpha;
			//half _overbright;

			struct appdata
			{
				half4 vertex : POSITION;
				half4 color : COLOR;
				half4 texcoord : TEXCOORD0;
			};

			struct VSOut
			{
				half4 pos		: SV_POSITION;
				half2 uv		: TEXCOORD0;
				half4 vColor	: TEXCOORD1;
				UNITY_FOG_COORDS(2)
			};

			VSOut vert(appdata v)
			{
				VSOut o;

				o.pos = UnityObjectToClipPos(v.vertex);								
				o.uv = v.texcoord.xy;
				o.vColor = v.color;
				UNITY_TRANSFER_FOG(o, o.pos); // pass fog coordinates to pixel shader
				return o;
			}

			half4 frag(VSOut i) : COLOR
			{
		
				half4 DF = tex2D(_MainTex, i.uv); // *half4((half3)1.0, tex2D(_DiffuseAlpha,  i.uv).r);
				clip(DF.a - _Cutoff);
				UNITY_APPLY_FOG(i.fogCoord, DF); // apply fog
				return DF;
			}

			ENDCG
		}

		Pass
		{
			Tags{ "LightMode" = "ShadowCaster" }

			Fog{ Mode Off }
			Cull Off

			CGPROGRAM
			//#include "../AdvCarCommon.cginc"	
#include "UnityCG.cginc"
#pragma vertex vert
#pragma fragment frag
#pragma multi_compile_shadowcaster

			sampler2D _MainTex;
			uniform float _Cutoff;

			struct v2f
			{
				V2F_SHADOW_CASTER;
				half2 uv : TEXCOORD1;
			};

			v2f vert(appdata_full v)
			{
				v2f o;
				TRANSFER_SHADOW_CASTER(o)
				o.uv = v.texcoord.xy;
				return o;
			}

			half4 frag(v2f i) : COLOR
			{
				half alpha = tex2D(_MainTex, i.uv).a;
				clip(alpha - _Cutoff);
				SHADOW_CASTER_FRAGMENT(i)
			}
			ENDCG
		}

		/*
		//half _Glossiness;
		//half _Metallic;
		fixed4 _Color;

		inline fixed4 LightingSimpleLambert(SurfaceOutput s, fixed3 lightDir, fixed atten)
		{
			fixed diff = max(0, dot(s.Normal, lightDir));

			fixed4 c;
			c.rgb = s.Albedo * _SpecularColor.rgb * (diff * atten * 2);
			c.a = s.Alpha;
			return c;
		}

		void surf (Input IN, inout SurfaceOutput o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			// Metallic and smoothness come from slider variables
			//o.Metallic = _Metallic;
			//o.Smoothness = _Glossiness;
			o.Alpha = c.a;
			clip(o.Alpha - _Cutoff);
		}
		*/
	}
	FallBack "Mobile/Diffuse"
}
