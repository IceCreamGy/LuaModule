Shader "TopCar/UI/Discoloration"
{
	Properties
	{
        [PerRendererData] _MainTex("Texture", 2D) = "white" {}
        _Color("Tint", Color) = (1,1,1,1)
		[Toggle] _IsGray("Is Gray?", Float) = 0

		//此shader被MaskableGraphic使用,需要下面属性,否则不能被裁剪
        [Enum(UnityEngine.Rendering.CompareFunction)]_StencilComp("Stencil Comparison", Float) = 8
		_Stencil("Stencil ID", Float) = 0
        [Enum(UnityEngine.Rendering.StencilOp)]_StencilOp("Stencil Operation", Float) = 0
		_StencilWriteMask("Stencil Write Mask", Float) = 255
		_StencilReadMask("Stencil Read Mask", Float) = 255

        [Enum(UnityEngine.Rendering.ColorWriteMask)]_ColorMask("Color Mask", Float) = 15
	}

	SubShader
	{
		Tags
        {
            "Queue" = "Transparent"
            "IgnoreProjector" = "True"
            "RenderType" = "Transparent"
            "PreviewType" = "Plane"
            "CanUseSpriteAtlas" = "True"
        }

		Stencil
		{
			Ref[_Stencil]
			Comp[_StencilComp]
			Pass[_StencilOp]
			ReadMask[_StencilReadMask]
			WriteMask[_StencilWriteMask]
		}

		// No culling or depth
		Cull Off
        Lighting Off
		ZWrite Off
		ZTest[unity_GUIZTestMode]
		Blend SrcAlpha OneMinusSrcAlpha
        ColorMask[_ColorMask]

		Pass
		{
            Name "Default"
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
            #pragma target 2.0
			#pragma multi_compile __ _ISGRAY_ON
            #pragma multi_compile __ UNITY_UI_ALPHACLIP

			#include "UnityCG.cginc"
            #include "UnityUI.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
                float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct v2f
			{
                float4 vertex : SV_POSITION;
                fixed4 color : COLOR;
                float2 texcoord : TEXCOORD0;
                float4 worldPosition : TEXCOORD1;
                UNITY_VERTEX_OUTPUT_STEREO
            };

            sampler2D _MainTex;
            fixed4 _Color;
            float4 _ClipRect;

			v2f vert(appdata v)
			{
				v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                o.worldPosition = v.vertex;
				o.vertex = UnityObjectToClipPos(o.worldPosition);
				o.texcoord = v.texcoord;

                o.color = v.color * _Color;
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 color = tex2D(_MainTex, i.texcoord) * i.color;
#ifdef _ISGRAY_ON
				float gray = dot(color.rgb, fixed3(0.299, 0.587, 0.114));
                color.rgb = gray;
#endif
                color.a *= UnityGet2DClipping(i.worldPosition.xy, _ClipRect);

                return color;
			}
			ENDCG
		}
	}
}
