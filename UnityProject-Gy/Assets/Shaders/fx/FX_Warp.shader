// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "QF/FX/FX_Warp" { //扭曲
    Properties {
		[Enum(UnityEngine.Rendering.BlendMode)] SrcFactor ("SrcFactor", Float) = 5
		[Enum(UnityEngine.Rendering.BlendMode)] DstFactor ("DstFactor", Float) = 10
		[Enum(UnityEngine.Rendering.BlendOp)] OpColor ("OpColor", Float) = 0
		
        _Color ("Color", Color) = (0.5,0.5,0.5,1)
		_ColorMulti("ColorMulti",Float) = 1.0
        _MainTex ("MainTex", 2D) = "white" {}
		_AlphaTex("Alpha (A)",2D) = "white" {}
		_frontAmount("FrontAmount[0,0.05]", Float) = 0.0
		
        _WarpSpeed ("WarpSpeed", Vector) = (0,0,0,0)
        _WarpTex ("WarpTex", 2D) = "white" {}
        _U_Value ("U_Value", Float ) = 0
        _V_Value ("V_Value", Float ) = 0
   
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
			
            uniform float4 _TimeEditor;
            uniform sampler2D _MainTex; uniform float4 _MainTex_ST;
			sampler2D _AlphaTex;
			float _frontAmount;
            uniform float4 _Color;
            uniform float4 _WarpSpeed;
            uniform sampler2D _WarpTex; uniform float4 _WarpTex_ST;
            uniform float _U_Value;
            uniform float _V_Value;
			float _ColorMulti;
			
			//#ifdef ENABLE_FADE
			float _fadeStrength;
			float _fadeParamA;
			float _fadeParamB;
			//#endif
			
			
            struct VertexInput {
                float4 vertex : POSITION;
				float3 normal :NORMAL;
                float2 texcoord0 : TEXCOORD0;
                float4 color : COLOR;
	
            }; 
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 color : COLOR;
				
			//#ifdef ENABLE_FOG
				float camDist : TEXCOORD1;
			//#endif
				
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.color = v.color;
                o.pos = UnityObjectToClipPos(v.vertex);
				o.pos.z -= _frontAmount;
			 //#ifdef ENABLE_FOG
				o.camDist  = CalcCamDist(v.vertex);
			// #endif
			
			//#ifdef ENABLE_FADE
				float3 objView = normalize(ObjSpaceViewDir(v.vertex));
				float dotabs = _fadeParamA + _fadeParamB * abs(dot(v.normal, objView));
				o.color *= NssPow(dotabs, _fadeStrength);	
			//#endif

                return o;
            }
            float4 frag(VertexOutput i) : COLOR {
 
                float4 time = _Time;
                float2 uvForWarp = (i.uv0+(float2(_WarpSpeed.b,_WarpSpeed.a)*time.g));
                float2 _WarpTex_var = tex2D(_WarpTex,TRANSFORM_TEX(uvForWarp, _WarpTex)).rg;
               // float node_6707 = dot(_WarpTex_var.rgb,float3(0.3,0.59,0.11));
			   _WarpTex_var = _WarpTex_var * 2.0 - 1.0;
			   _WarpTex_var.x *= _U_Value;
			   _WarpTex_var.y *= _V_Value;
			    
			   
                float2 uvForMain = i.uv0 + float2(_WarpSpeed.r,_WarpSpeed.g)*time.g + _WarpTex_var;
				uvForMain = TRANSFORM_TEX(uvForMain, _MainTex);
                float3 _MainTex_var = tex2D(_MainTex,uvForMain).rgb;
				float _AlphaTex_var = tex2D(_AlphaTex,uvForMain).r; 
                float3 finalColor = (_Color.rgb*_MainTex_var*i.color.rgb) * _ColorMulti;
				
				 
				
				float alpha = _Color.a*_AlphaTex_var*i.color.a;
			
				
		 
			
                float4 result = float4(finalColor,alpha);
				
	 
			//#ifdef ENABLE_FOG
				return NssFog(i.camDist, result);
			//#else
			// 	return result;
			//#endif
			
			
            }
            ENDCG
        }
    }
    Fallback "QF/Env/0_Low/Basic_AlphaBlend_Low" 
   
}
