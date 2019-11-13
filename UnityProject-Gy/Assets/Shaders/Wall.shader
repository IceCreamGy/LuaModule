Shader "AdvCarShading/AspTrack/Wall" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_DiffuseAlpha ("Diffuse Alpha", 2D) = "white" {}
		_Speed("Speed (XY)", Vector) = (0.0, 0.0, 0.0, 0.0)
		[Toggle]_FlipX("Flip X", Float) = 0
		//_FlipX("Flip X", Float) = 0
	}
	SubShader {
		//Tags { 
		//	"Queue" = "Transparent"
		//	"RenderType"="Transparent" 
		//	"LightMode"="ForwardBase"
		//	 "Reflection" = "RenderReflectionOpaque"
		//}
		Tags{ "QUEUE" = "Geometry" "RenderType" = "Opaque" }
		//Blend SrcAlpha OneMinusSrcAlpha
		//ZWrite Off
		
		pass
		{
			CGPROGRAM

			#include "AdvCarCommon.cginc"	
            #include "DualParaboloidMap.cginc"
            #pragma target 3.0
			#pragma vertex vert
			#pragma fragment frag
			#pragma exclude_renderers xbox360 flash	
			#pragma multi_compile _ ENABLE_PARABOLOID
			#pragma multi_compile  _FLIPX_OFF  _FLIPX_ON
            #pragma multi_compile DUAL_PARABOLOID_OFF DUAL_PARABOLOID_ON
			//#pragma shader_feature FLIP_X


			sampler2D _MainTex;
			sampler2D _DiffuseAlpha;
			half2 _Speed;	
			//float _FlipX;
			struct appdata 
			{
			    float4 vertex : POSITION;
			    half4 color : COLOR;
			    float4 texcoord : TEXCOORD0;
			};
			
			struct VSOut
			{
				float4 pos		: SV_POSITION;
				float2 uv		: TEXCOORD0;
				half  VCalpha	: TEXCOORD1;
			#ifdef ENABLE_PARABOLOID
				half paraboloidHemisphere : TEXCOORD2;
			#endif
                DUAL_PARABOLOID_ATTRIBUTE(3, 4)
			};
			
			VSOut vert(appdata v)
			{
				VSOut o;
			#ifdef ENABLE_PARABOLOID
				o.pos = mul(UNITY_MATRIX_MV, v.vertex);	
				o.paraboloidHemisphere = o.pos.z;
				o.pos = ParaboloidTransform(o.pos);
				
			#else
                TRANSFER_VERTEX_TO_DUAL_PARABOLOID_SURF(o, v.vertex);
                o.pos = UnityObjectToClipPos(v.vertex);
			#endif

			o.uv.xy = v.texcoord.xy;
#ifdef _FLIPX_ON
			//if(_FlipX == 1)
			o.uv.x = 1 - v.texcoord.x;
#endif 
			//else
			o.uv.xy = o.uv.xy + frac(_Time.yy * _Speed);

			o.VCalpha = (v.color.r + v.color.g + v.color.b) / 3.0;			
			return o;
			}
			
			half4 frag(VSOut i) : COLOR
			{
                DUAL_PARABOLOID_CLIP_DEPTH(i)

			#ifdef ENABLE_PARABOLOID				
				if (ParaboloidDiscard(i.paraboloidHemisphere))
					discard;
			#endif		
				half4 finalColor = tex2D(_MainTex, i.uv)* half4((half3)1.0, tex2D(_DiffuseAlpha,  i.uv).r);				
				half A = finalColor.a * i.VCalpha;
				clip(A - 0.7);
				return half4(finalColor.rgb, A);
			}

			ENDCG
		} 
	}
	FallBack "Transparent/Diffuse"
}
