// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "TopCar/Env/TransparentCommon" {
	Properties {
		[Enum(UnityEngine.Rendering.BlendMode)] SrcFactor ("SrcFactor", Float) = 5
		[Enum(UnityEngine.Rendering.BlendMode)] DstFactor ("DstFactor", Float) = 10
		[Enum(UnityEngine.Rendering.BlendOp)] OpColor ("OpColor", Float) = 0

	
		_Color ("Color", COLOR)=(0.5,0.5,0.5,0.5)
		_ColorMulti("ColorMulti", Range(0,5)) = 2.0
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_AlphaTex("Alpha (A)",2D) = "white" {}
		
		_frontAmount("FrontAmount[0,0.05]", Float) = 0.0
		_U ("U", Float) = 0.0
		_V ("V", Float) = 0.0
		[Toggle(ENABLE_FOG)] _EnableFog ("EnableFog", Float) = 0
		
		//[KeywordEnum(None, Direction)] _Fade ("FadeMode", Float) = 0
		[Toggle(ENABLE_FADE)] _EnableFade ("EnableFade", Float) = 0
		_fadeStrength("Fade Strength", Range(0,10)) = 2.0
		_fadeParamA("Fade Param A (outside=A:0 B:1      inside=A:1 B:-1)", Float) = 0
	    _fadeParamB("Fade Param B", Float) = 0
		[Toggle(ENABLE_BILLBOARD)] _EnableBillboard ("EnableBillboard", Float) = 0
		
		
		_VertexColoAsUVSpped_UMin ("VertexColoAsUVSpped_UMin", Float) = -10.0
		_VertexColoAsUVSpped_UMax ("VertexColoAsUVSpped_UMax", Float) = 10.0
		
		_VertexColoAsUVSpped_VMin ("_VertexColoAsUVSpped_VMin", Float) = -10.0
		_VertexColoAsUVSpped_VMax ("_VertexColoAsUVSpped_VMax", Float) = 10.0
		 
		[Toggle(ENABLE_VERTEX_COLOR_AS_UV_SPEED)] _EnableVertexColorAsUVSpeed ("EnableVertexColorAsUVSpeed", Float) = 0
		
		
		[Toggle(ENABLE_DISSOLVE)] _EnableDissolve("EnableDissolve", Float) = 0
		_DisolveTex ("DisolveTex (A)", 2D) = "white" {}
		_Disolve ("Disolve", Range(0.0,2.0)) = 0
		_DisolveCutoff ("DisolveCutoff", Range(0.0,1.0)) = 0.5
		
		
		[Toggle(ENABLE_BLACK_EDGE_FADE_AND_INNER_COLOR)] _EnableBlackEdgeFadeAndInnerColor("EnableBlackEdgeFadeAndInnerColor", Float) = 0
		_BlackEdgeFade("BlackEdgeFade", Range(0.0,1.0)) = 0
	 
	}
	SubShader {
		Tags 
		{			
			"Queue" = "Transparent"
			"IgnoreProjector"="True"
			"RenderType"="Transparent" 
			"Reflection" = "RenderReflectionTransparentBlend"
		}
		
		LOD 10
		Lighting Off
		ZWrite Off
		Cull Off
		
		Blend [SrcFactor] [DstFactor]
		BlendOp [OpColor]
		
		
		pass
		{
			Fog {Mode Off}
			CGPROGRAM			
			#include "AdvCarCommon.cginc"	
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdbase
			#include "UnityCG.cginc"
			#pragma multi_compile _ ENABLE_PARABOLOID
			#pragma multi_compile _ DISABLE_VERTEX_COLOR
			#pragma multi_compile _ ENABLE_FOG
			#pragma multi_compile _ ENABLE_FADE
			#pragma multi_compile _ ENABLE_BILLBOARD
			#pragma multi_compile _ ENABLE_VERTEX_COLOR_AS_UV_SPEED
			#pragma multi_compile _ ENABLE_DISSOLVE
			#pragma multi_compile _ ENABLE_FRESNEL
			#pragma multi_compile _ ENABLE_BLACK_EDGE_FADE_AND_INNER_COLOR
			//#pragma multi_compile _FADE_NONE _FADE_DIRECTION

			sampler2D _MainTex;
			sampler2D _AlphaTex;
			
			half _frontAmount;
			half4 _MainTex_ST;
			
			half4 _Color;
			half _ColorMulti;
			float _U;
			float _V;
			//half _Fresnel;
			#ifdef ENABLE_FADE
			half _fadeStrength;
			half _fadeParamA;
			half _fadeParamB;
			#endif
			
			#ifdef ENABLE_VERTEX_COLOR_AS_UV_SPEED
			float _VertexColoAsUVSpped_UMin;
			float _VertexColoAsUVSpped_UMax;
			float _VertexColoAsUVSpped_VMin;
			float _VertexColoAsUVSpped_VMax;
			#endif

			
			#ifdef ENABLE_DISSOLVE
			sampler2D _DisolveTex;
			half4 _DisolveTex_ST;
			half _Disolve;
			half _DisolveCutoff;
			#endif
			
			
			#ifdef ENABLE_BLACK_EDGE_FADE_AND_INNER_COLOR
			half _BlackEdgeFade;
			#endif
			
			struct appdata 
			{
			    float4 vertex : POSITION;
				half4 color : COLOR;
			    float2 texcoord : TEXCOORD0;
				#ifdef ENABLE_FADE
				half3 normal : NORMAL;
				#endif
			};
			
			struct VSOut
			{
				float4 pos		: SV_POSITION;
				half4 color	: TEXCOORD0;
				
			#ifdef ENABLE_DISSOLVE	
				float4 uv		: TEXCOORD1;
			#else
				float2 uv		: TEXCOORD1;
			#endif
				
			#ifdef ENABLE_PARABOLOID
				half paraboloidHemisphere : TEXCOORD2;
			#endif
			#ifdef ENABLE_FOG
				half camDist : TEXCOORD3;
			#endif
			};
			
			VSOut vert(appdata v)
			{
				VSOut o;
				
				
			#ifdef ENABLE_BILLBOARD
				float scaleX = length(mul(unity_ObjectToWorld, float4(1.0, 0.0, 0.0, 0.0)));
				float scaleY = length(mul(unity_ObjectToWorld, float4(0.0, 1.0, 0.0, 0.0)));
				float4 VS_pos = mul(UNITY_MATRIX_MV, float4(0.0, 0.0, 0.0, 1.0)) - float4(v.vertex.x * scaleX, v.vertex.y * scaleY, 0.0, 0.0);
				v.texcoord.y = -v.texcoord.y;
			#endif
				
				
				
			#ifdef ENABLE_PARABOLOID
				#ifdef ENABLE_BILLBOARD
				o.pos = VS_pos;	
				#else
				o.pos = mul(UNITY_MATRIX_MV, v.vertex);
				#endif
				
				o.paraboloidHemisphere = o.pos.z;
				o.pos = ParaboloidTransform(o.pos);
				
			#else
				#ifdef ENABLE_BILLBOARD
				o.pos = mul(UNITY_MATRIX_P, VS_pos);
				#else
				o.pos = UnityObjectToClipPos(v.vertex);
				#endif
			#endif
				o.pos.z -= _frontAmount;
			
		
			o.uv.xy = TRANSFORM_TEX(v.texcoord.xy,_MainTex);
			o.uv.xy += float2(_U,_V);
				
			#ifdef ENABLE_VERTEX_COLOR_AS_UV_SPEED	
			 
				o.uv.x += lerp(_VertexColoAsUVSpped_UMin,_VertexColoAsUVSpped_UMax, v.color.r);
				o.uv.y += lerp(_VertexColoAsUVSpped_VMin,_VertexColoAsUVSpped_VMax, v.color.g);
			 
			#endif	
				
			#ifdef ENABLE_DISSOLVE	
				o.uv.zw = TRANSFORM_TEX(v.texcoord.xy,_DisolveTex);
			#endif
			
			#if defined(DISABLE_VERTEX_COLOR) || defined(ENABLE_VERTEX_COLOR_AS_UV_SPEED)
				o.color = _Color;
				o.color.a *= v.color.a;
			#else
				o.color = _Color * v.color;
			#endif
			o.color.rgb *= _ColorMulti;
		 
			
			#ifdef ENABLE_FOG
				o.camDist  = CalcCamDist(v.vertex);
			#endif
			
			
			#ifdef ENABLE_FADE
				half3 objView = normalize(ObjSpaceViewDir(v.vertex));
				half dotabs = _fadeParamA + _fadeParamB * abs(dot(v.normal, objView));
				o.color *= NssPow(dotabs, _fadeStrength);
			#endif
				return o;
			}
			
			half4 frag(VSOut i) : COLOR
			{				
		 
			#ifdef ENABLE_PARABOLOID				
				if (ParaboloidDiscard(i.paraboloidHemisphere))
					discard;
			#endif	
			
				
		 
				half3 diffuseCol = tex2D(_MainTex,  i.uv.xy).rgb * i.color.rgb;	
 	 
				half alpha = tex2D(_AlphaTex, i.uv.xy).r * i.color.a;
				
				
			#ifdef ENABLE_DISSOLVE
				half dislove = saturate(_Disolve - tex2D(_DisolveTex, i.uv.zw).r);
				diffuseCol *= (1.0 - dislove);
				alpha -= dislove;
				
				alpha = (alpha < _DisolveCutoff) ? 0.0 : alpha;
			#endif		
			
				
				
			#ifdef ENABLE_BLACK_EDGE_FADE_AND_INNER_COLOR	
				half gray = dot(diffuseCol , float3(0.299, 0.587, 0.114));
				gray = 1.0 - gray;
				half blackEdgeFade = _BlackEdgeFade * alpha * gray;
				blackEdgeFade = saturate(blackEdgeFade);
				diffuseCol += blackEdgeFade;
				 
			#endif	
			
			
			half4 result = half4(diffuseCol,alpha);
			
			#ifdef ENABLE_FOG
				return NssFog(i.camDist, result);
			#else
				return result;
			#endif
			}

			ENDCG
		} 
	}
	Fallback "Transparent/Diffuse"
}
