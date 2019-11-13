Shader "TopCar/FX/ScreenFlare"
{
	Properties
	{
		[PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
		_Color ("Tint", Color) = (1,1,1,1)
		
        [HideInInspector][Enum(UnityEngine.Rendering.CompareFunction)] _StencilComp ("Stencil Comparison", Float) = 8
        [HideInInspector]_Stencil ("Stencil ID", Float) = 0
        [HideInInspector][Enum(UnityEngine.Rendering.StencilOp)] _StencilOp ("Stencil Operation", Float) = 0
        [HideInInspector]_StencilWriteMask ("Stencil Write Mask", Float) = 255
        [HideInInspector]_StencilReadMask ("Stencil Read Mask", Float) = 255
        [Enum(UnityEngine.Rendering.BlendMode)] _SrcBlend("Src Blend Mode", Float) = 5
        [Enum(UnityEngine.Rendering.BlendMode)] _DstBlend("Dst Blend Mode", Float) = 1

        [HideInInspector][Enum(UnityEngine.Rendering.ColorWriteMask)]_ColorMask ("Color Mask", Float) = 15

        [HideInInspector][Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0

        [Header(Line Parameter Setting)]_LineParam("Line Parameter", Vector) = (0, 0.0, 1)
        _Region("Visible Range", Vector) = (0.1, 0.5, 0)
        [Header(Brightness Setting)]_MinBrightness("Min Brightness", Range(0, 20)) = 0.5
        _MaxBrightness("Max Brightness", Range(0, 20)) = 0.8
	}

	SubShader
	{
		Tags
		{ 
			"Queue"="Transparent" 
			"IgnoreProjector"="True" 
			"RenderType"="Transparent" 
			"PreviewType"="Plane"
			"CanUseSpriteAtlas"="True"
		}
		
		Stencil
		{
			Ref [_Stencil]
			Comp [_StencilComp]
			Pass [_StencilOp] 
			ReadMask [_StencilReadMask]
			WriteMask [_StencilWriteMask]
		}

		Cull Off
		Lighting Off
		ZWrite Off
		ZTest [unity_GUIZTestMode]
        Blend[_SrcBlend][_DstBlend]
		ColorMask [_ColorMask]

		Pass
        {
            Name "Default"
        CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 2.0
#pragma glsl

            #include "UnityCG.cginc"
            #include "UnityUI.cginc"

            #pragma multi_compile __ UNITY_UI_ALPHACLIP

            struct appdata_t
            {
                float4 vertex   : POSITION;
                float4 color    : COLOR;
                float2 texcoord : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float4 vertex   : SV_POSITION;
                fixed4 color : COLOR;
                float2 texcoord  : TEXCOORD0;
                float4 worldPosition : TEXCOORD1;
                float4 screenPos: TEXCOORD2;
                UNITY_VERTEX_OUTPUT_STEREO
            };

            fixed4 _Color;
            fixed4 _TextureSampleAdd;
            float4 _ClipRect;

            v2f vert(appdata_t IN)
            {
                v2f OUT;
                UNITY_SETUP_INSTANCE_ID(IN);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
                OUT.worldPosition = IN.vertex;
                OUT.vertex = UnityObjectToClipPos(OUT.worldPosition);

                OUT.screenPos = ComputeScreenPos(OUT.vertex);

                OUT.texcoord = IN.texcoord;

                OUT.color = IN.color * _Color;
                return OUT;
            }

            sampler2D _MainTex;
            uniform float4 _LineParam;
            uniform float2 _Region;
            uniform float _MinBrightness;
            uniform float _MaxBrightness;

			fixed4 frag(v2f IN) : SV_Target
			{
				half4 color = (tex2D(_MainTex, IN.texcoord) + _TextureSampleAdd) * IN.color;
				
				color.a *= UnityGet2DClipping(IN.worldPosition.xy, _ClipRect);
				
				#ifdef UNITY_UI_ALPHACLIP
				clip (color.a - 0.001);
				#endif

                float2 screenPos = IN.screenPos.xy / IN.screenPos.w;

                float d = abs(_LineParam.x * screenPos.x + _LineParam.y * screenPos.y + _LineParam.z) / _LineParam.w;
                fixed alpha = clamp(d / _Region.y, 0, 1);
                color.a *= 1 - alpha;

                ////三角函数叠加，不规则变化
                //fixed seed = (sin(_Time.y) + sin(_Time.y / 2)) / 2;
                //fixed bright = abs(seed);
                //规则变化
                fixed bright = frac(_Time.y);
                bright = abs(bright - 0.5) * 2;
                fixed percent = 1 - bright;
                color.rgb *= lerp(_MinBrightness, _MaxBrightness, percent);

				return color;
			}
		ENDCG
		}
	}
}
