// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "TopCar/Env/Basic_AlphaAdd" {
	Properties {
		_TintColor ("Tint Color", COLOR)=(0.5,0.5,0.5,0.5)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		//_Mult("Mult",Float) = 1.0
	}
	SubShader {
		Tags 
		{			
			"Queue" = "Transparent"
			"IgnoreProjector"="True"
			"RenderType"="Transparent" 
			"Reflection" = "RenderReflectionTransparentAdd"
		}
		
		LOD 10
		Lighting Off
		ZWrite Off
		Cull Off
		Blend SrcAlpha One
		
		pass
		{
			Cull Off
			Fog {Mode Off}
			Tags { "LightMode" = "ForwardBase"}
			CGPROGRAM			
			#include "AdvCarCommon.cginc"	
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			#pragma multi_compile_fwdbase
			#pragma multi_compile _ ENABLE_PARABOLOID
			#pragma multi_compile _ DISABLE_VERTEX_COLOR 

			sampler2D _MainTex;
			sampler2D _AlphaTex;
			half4 _MainTex_ST;
			half4 _TintColor;
			//half _Mult;

			struct appdata 
			{
			    float4 vertex : POSITION;
				half4 color : COLOR;
			    float2 texcoord : TEXCOORD0;
			};
			
			struct VSOut
			{
				float4 pos		: SV_POSITION;
				half4 color	: TEXCOORD0;
				float2 uv		: TEXCOORD1;
			#ifdef ENABLE_PARABOLOID
				half paraboloidHemisphere : TEXCOORD2;
			#endif
				
			};
			
			VSOut vert(appdata v)
			{
				VSOut o;
			#ifdef ENABLE_PARABOLOID
				o.pos = mul(UNITY_MATRIX_MV, v.vertex);	
				o.paraboloidHemisphere = o.pos.z;
				o.pos = ParaboloidTransform(o.pos);
				
			#else
				o.pos = UnityObjectToClipPos(v.vertex);
			#endif	
				o.uv.xy =  TRANSFORM_TEX(v.texcoord.xy,_MainTex);
			
				#ifdef DISABLE_VERTEX_COLOR
				o.color = _TintColor  * 2.0;
				
				#else
				o.color = v.color * _TintColor * 2.0;
				#endif
				
				
				
				return o;
			}
			
			half4 frag(VSOut i) : COLOR
			{					
			
			 
			#ifdef ENABLE_PARABOLOID				
				if (ParaboloidDiscard(i.paraboloidHemisphere))
					discard;
			#endif	
			
				float2 uv0 = i.uv.xy;	
				half4 diffuseCol = tex2D(_MainTex, uv0);		
				half4 result = diffuseCol * i.color;
				
				return result;
				//return NssFog(i.camDist, result);
			}

			ENDCG
		} 
	}
	Fallback "Transparent/Diffuse"
}
