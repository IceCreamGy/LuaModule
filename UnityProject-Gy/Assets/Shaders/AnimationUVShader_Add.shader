// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "TopCar/Effect/AnimationShader_Add"
{
	Properties
	{
		_Color("Base Color", Color) = (1,1,1,1)
		_MainTex("Base(RGB)", 2D) = "white" {}
		_Speed("播放速度",Float) = 30
		_SizeX("列数", Float) = 12
		_SizeY("行数",Float) = 1
	}

		SubShader
	{
		tags{ "Queue" = "Transparent" "RenderType" = "Transparent" "IgnoreProjector" = "True" }
		Blend SrcAlpha One
		Cull Off
		Pass
	{
		CGPROGRAM
#pragma vertex vert  
#pragma fragment frag  
#include "UnityCG.cginc"  

		float4 _Color;
	sampler2D _MainTex;
	fixed _Speed;
	fixed _SizeX;
	fixed _SizeY;

	struct v2f
	{
		float4 pos:POSITION;
		float4 uv:TEXCOORD0;
	};

	struct appdata {
		float4 vertex : POSITION;
		float4 texcoord : TEXCOORD;
	};

	v2f vert(appdata v)
	{
		v2f o;
		o.pos = UnityObjectToClipPos(v.vertex);
		o.uv = v.texcoord;

		return o;
	}

	float2 AnimationUV(float2 uv) {

		//通过时间更新图片第几行图片  
		float col = floor(_Time.y *_Speed / _SizeX);
		//通过时间更新图片第几列图片  
		float row = floor(_Time.y *_Speed - col*_SizeX);

		//每次更新的量  
		float sourceX = 1.0 / _SizeX;
		float sourceY = 1.0 / _SizeY;

		//所显示图片缩放至应有的大小  
		uv.x *= sourceX;
		uv.y *= sourceY;
		//更换帧  
		uv.x += row * sourceX;
		uv.y = 1 - col*sourceY - uv.y;
		return uv;
	}

	half4 frag(v2f i) :COLOR
	{
		half4 c = tex2D(_MainTex , AnimationUV(i.uv.xy)) * _Color;
		return c;
	}

		ENDCG
	}
	}
}
