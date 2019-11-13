// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "QF/FX/FX_Warp2Tex" {
    Properties {
		[Enum(UnityEngine.Rendering.BlendMode)] SrcFactor ("SrcFactor", Float) = 5
		[Enum(UnityEngine.Rendering.BlendMode)] DstFactor ("DstFactor", Float) = 10
		[Enum(UnityEngine.Rendering.BlendOp)] OpColor ("OpColor", Float) = 0
		
		_MainTex1 ("Tex1(RGB)", 2D) = "white" {}
		_MainTex2 ("Tex2(RGB)", 2D) = "white" {}
		_ScrollX ("Tex1 speed X", Float) = 1.0
		_ScrollY ("Tex1 speed Y", Float) = 0.0
		_Scroll2X ("Tex2 speed X", Float) = 1.0
		_Scroll2Y ("Tex2 speed Y", Float) = 0.0
		_Color("Color", Color) = (1,1,1,1)
		_UVXX("UVXX", vector)=(0.3,1,1,1)	
		_MMultiplier ("Layer Multiplier", Float) = 2.0
   
		//[Toggle(ENABLE_FOG)] _EnableFog ("EnableFog", Float) = 0
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
			"Reflection" = "RenderReflectionTransparentBlend"
        }
        Pass {
            Name "ForwardBase"
            Tags {
                "LightMode"="ForwardBase"
            }
            		
			Blend [SrcFactor] [DstFactor]
			BlendOp [OpColor]
			Cull Off
			Lighting Off
			ZWrite Off
            LOD 10
            
            Fog {Mode Off}
            CGPROGRAM
			#include "../AdvCarCommon.cginc"	
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            //#pragma multi_compile_fwdbase
            #pragma exclude_renderers xbox360 ps3 flash d3d11_9x 
            //#pragma target 3.0
			//#pragma multi_compile _ DISABLE_VERTEX_COLOR
			//#pragma multi_compile _ ENABLE_FOG
			//#pragma multi_compile _ ENABLE_FADE
			
           	sampler2D _MainTex1;
			sampler2D _MainTex2;

			float4 _MainTex1_ST;
			float4 _MainTex2_ST;
			
			float _ScrollX;
			float _ScrollY;
			float _Scroll2X;
			float _Scroll2Y;
			float _MMultiplier;
			float4 _UVXX;
			float4 _Color;

			struct v2f {
				float4 pos : SV_POSITION;
				float4 uv : TEXCOORD0;
				fixed4 color : TEXCOORD1;
			};

			
			v2f vert (appdata_full v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv.xy = TRANSFORM_TEX(v.texcoord.xy,_MainTex1) + frac(float2(_ScrollX, _ScrollY) * _Time.x);
				o.uv.zw = TRANSFORM_TEX(v.texcoord.xy,_MainTex2) + frac(float2(_Scroll2X, _Scroll2Y) * _Time.x);
				
				o.color = _MMultiplier * _Color * v.color;
				return o;
			}


         	 fixed4 frag (v2f i) : COLOR
			{
				fixed4 o;
				fixed4 tex = tex2D (_MainTex1, i.uv.xy);
				half2 uv=tex.r * _UVXX.x;
				
				fixed4 tex2 = tex2D (_MainTex2, i.uv.zw + uv);
				
				o = tex * tex2 * i.color;
				return o;
			}
            ENDCG
        }
    }
    Fallback "QF/Env/0_Low/Basic_AlphaBlend_Low" 
   
}
