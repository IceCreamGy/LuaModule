
Shader "TopCar/Image Effect/WaterDrop"
{
	Properties
	{
		_MainTex("Water Drop (RGB)", 2D) = "white" {}
		_TintColor("Color (RGB)", Color) = (1, 1, 1, 1)
		_RefractTex("Refraction (RG), Colormask (B)", 2D) = "bump" {}
		_DropMaskTex("Alpha Mask (RGB))", 2D) = "white" {}
		_SpeedStrength("Speed (XY), Strength (ZW)", Vector) = (1, 1, 1, 1)
		_ScreenTex("Screen (RGB) DON`T TOUCH IT! :)", 2D) = "white" {}
		_NoiseTex("Noise (RGB)", 2D) = "white" {}
		_NoiseSpeed("Noise Speed", Vector) = (1,1,1,1)
		_WaterDrop("Water Drop", Float) = 0.3
	}

	SubShader
	{
		Tags{ "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
		LOD 100

		Pass
		{
			ZTest Always Cull Off ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha
			Fog{ Mode off }

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest 
			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;
			uniform sampler2D _RefractTex;
			uniform sampler2D _ScreenTex;
			uniform sampler2D _NoiseTex;
			uniform sampler2D _DropMaskTex;
			uniform float4 _TintColor;
			uniform float4 _SpeedStrength;
			uniform float4 _NoiseSpeed;
			float4 _RefractTex_TexelSize;
			float _WaterDrop;

			struct appdata_t
			{
				float4 vertex : POSITION;
				fixed4 color : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				half2 uv : TEXCOORD0;
				fixed4 color : COLOR;
				float4 srcPos : TEXCOORD1;
			};

			v2f vert(appdata_t v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.srcPos = ComputeScreenPos(o.pos);
				o.uv = v.texcoord;
				o.color = v.color;
				return o;
			}

			float4 frag(v2f i) : COLOR
			{
				float2 refrtcUV = i.uv;
#if UNITY_UV_STARTS_AT_TOP
				if (_RefractTex_TexelSize.y < 0)
					refrtcUV.y = 1 - refrtcUV.y;
#endif
				float2 refrtc = refrtcUV;
				float4 refract = tex2D(_RefractTex, refrtc);
				refract.rg = (refract.rg*2.0 - 1.0) * refract.b;
				//return fixed4(maskColor.r, maskColor.r, maskColor.r, 1);
				//return fixed4(mainColor.a, mainColor.a, mainColor.a, 1);
				//return i.pos / i.pos.w;
				//float2 wcoord = i.srcPos.xy / i.srcPos.w;
				//return fixed4(wcoord, 0.0, 1.0);
				//fixed4 color = tex2D(_ScreenTex, i.srcPos.xy / i.srcPos.w);
				//color.a = 1.0;
				//return color;
				fixed2 uv = i.srcPos.xy / i.srcPos.w;
				float4 noiseColor = tex2D(_NoiseTex, uv + _NoiseSpeed.xy*_Time.xy);
				float4 maskColor = tex2D(_DropMaskTex, i.uv);
				float4 mainColor = tex2D(_MainTex, i.uv + noiseColor.rg * _NoiseSpeed.xy);
				float4 original = tex2D(_ScreenTex, uv + noiseColor.rg * _NoiseSpeed.xy + refract.rg * _SpeedStrength.zw *  maskColor.r) + mainColor * _TintColor;
				original *= i.color;
				original.a = i.color.a * maskColor.r * _WaterDrop;
				return original;
			}
			ENDCG
		}
	}
		Fallback off
}