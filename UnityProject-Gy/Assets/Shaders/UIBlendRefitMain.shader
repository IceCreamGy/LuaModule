// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "TopCar/UI/UIBlendRefitMain"
{
	Properties
	{
		_UpColor("UpColor", Color) = (1,1,1,1)
		//_CenterColor("CenterColor", Color) = (1,1,1,1)
		_DownColor("DownColor", Color) = (0,0,0,1)
        _LineWidth("Line Width",  Range(0, 0.48)) = 0.007
        _RadarAlpha("Radar Alpha", Range(0.2, 1)) = 0.7
	}
	SubShader
	{
		Tags{ "Queue" = "Transparent"}

		Cull Off 
		ZWrite Off 
		ZTest Off
		Blend SrcAlpha OneMinusSrcAlpha
		
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
			half _OutlineWidth;
			float4 _OutlineColor;
			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
				float4 color : COLOR;
			};

			fixed4 _UpColor;
			//fixed4 _CenterColor;
			fixed4 _DownColor;
            fixed _LineWidth;
            fixed _RadarAlpha;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				o.color = v.color;				
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				fixed4 colorUp = _UpColor * clamp(1 - i.uv.y, 0, 1);
				//fixed4 colorCenterUp = _CenterColor * clamp(1 - i.uv.y, -1, 1) * 0.5;
				//fixed4 colorCenterDown = _CenterColor * clamp(i.uv.y, -1, 1) * 0.5;
				fixed4 colorDown = _DownColor * clamp(i.uv.y, 0, 1);
				fixed4 col = colorUp + colorDown;

                fixed uOutAlpha = smoothstep(0, 0.01, i.uv.x) * smoothstep(1, 0.99, i.uv.x);
                fixed vOutAlpha = smoothstep(0, 0.01, i.uv.y) * smoothstep(1, 0.99, i.uv.y);
                fixed outAlpha = min(uOutAlpha, vOutAlpha);

                fixed lu = 0.01 + _LineWidth + 0.01;
                fixed ru = 1 - 0.01 - _LineWidth - 0.01;
                fixed uInternalAlpha = smoothstep(lu, lu - 0.01, i.uv.x) + smoothstep(ru, ru + 0.01, i.uv.x);
                fixed vInternalAlpha = smoothstep(lu, lu - 0.01, i.uv.y) + smoothstep(ru, ru + 0.01, i.uv.y);
                fixed internalAlpha = max(uInternalAlpha, vInternalAlpha);

                fixed frameAlpha = outAlpha * internalAlpha;
                col.a = max(outAlpha * _RadarAlpha, frameAlpha);
                col.rgb = (1 - frameAlpha) * step(0.99, outAlpha) * col.rgb + frameAlpha;
								
				return col;
			}
			ENDCG
		}
	}
}
