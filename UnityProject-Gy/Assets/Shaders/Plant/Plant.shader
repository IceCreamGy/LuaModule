// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "TopCar/Env/Plant" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		//_DiffuseAlpha ("Diffuse Alpha", 2D) = "white" {}
		_overbright("Overbright", Float) = 1.0
	}
	SubShader {
		Tags { 
			"Queue" = "Transparent"
			"RenderType"="Transparent" 
			"Reflection" = "RenderReflectionTransparentBlend"
		}
		
		Blend SrcAlpha OneMinusSrcAlpha
		ZWrite Off
		Cull Off
		
		Pass
		{
			Tags { "LightMode" = "ForwardBase" }
			CGPROGRAM			
			#include "../AdvCarCommon.cginc"	
			#include "UnityCG.cginc"
			#pragma target 3.0
			#pragma vertex vert
			#pragma fragment frag
			#pragma exclude_renderers xbox360 flash	
			#pragma multi_compile _ ENABLE_PARABOLOID
            #pragma multi_compile_fog

			sampler2D _MainTex;
			//sampler2D _DiffuseAlpha;
			half _overbright;
			
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
			#ifdef ENABLE_PARABOLOID
				half paraboloidHemisphere : TEXCOORD2;
			#endif
                UNITY_FOG_COORDS(3)
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
				o.uv  = v.texcoord.xy;
				o.vColor = v.color;	

                UNITY_TRANSFER_FOG(o, o.pos); // pass fog coordinates to pixel shader
				return o;
			}
			
			half4 frag(VSOut i) : COLOR
			{											
			#ifdef ENABLE_PARABOLOID				
				if (ParaboloidDiscard(i.paraboloidHemisphere))
					discard;
			#endif				
				half4 DF = tex2D(_MainTex, i.uv); // *half4((half3)1.0, tex2D(_DiffuseAlpha,  i.uv).r);
                DF.rgb *= (i.vColor * _overbright);

                UNITY_APPLY_FOG(i.fogCoord, DF); // apply fog
				return DF;
			}

			ENDCG
		} 
		
		Pass
        { 
			Tags { "LightMode" = "ShadowCaster" }
 
			Fog {Mode Off}
			ZWrite On
			ZTest Less
 
			CGPROGRAM
			//#include "../AdvCarCommon.cginc"	
			#include "UnityCG.cginc"
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_shadowcaster
			
			sampler2D _MainTex;
			
			struct v2f 
			{ 
				V2F_SHADOW_CASTER; 
				half2 uv : TEXCOORD1;
			};
			
			v2f vert( appdata_full v )
			{
				v2f o;
				TRANSFER_SHADOW_CASTER(o) 
				o.uv = v.texcoord.xy;
			  	return o;
			}
 
			half4 frag( v2f i ) : COLOR
			{
				half alpha = tex2D(_MainTex, i.uv).a;
				clip( alpha - 0.1f );
				SHADOW_CASTER_FRAGMENT(i)
			}
			ENDCG
        } 
	}
	FallBack "Transparent/Diffuse"
}
