// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Hidden/ColorGrading" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "" {}			
		_Color("Main Color", Color) = (1,1,1,1)
	}

CGINCLUDE
#include "UnityCG.cginc"

struct v2f {
	float4 pos : POSITION;
	float2 uv  : TEXCOORD0;
};

sampler2D _MainTex;
sampler2D _LutTex;
fixed4 _Color;

uniform half4 _MainTex_TexelSize;
/*
_vPixelSize :
	x : 1 / texWidth
	y : 1 / cellWidth
	z : r / 2
	w : g / 2
*/
uniform half4 _vPixelSize;

v2f vert( appdata_img v ) 
{
	v2f o;
	o.pos = UnityObjectToClipPos(v.vertex);
	o.uv.xy = v.texcoord.xy;
	return o;
}

//将b通道分为了cellCount阶
//在相同的b值下线性rg，作颜色空间转换
//r水平渐变->左黑右白，g垂直渐变->上黑下白
half4 frag(v2f i) : COLOR 
{
	const half cellSize = 16.0;
	const half cellCount = 32.0;
	half4 color = saturate(tex2D(_MainTex, i.uv.xy));
	color.g = 1.0 - color.g; //g垂直渐变，但上黑，下白，需要翻转坐标
	//选择cell
	half lutUVb = floor(color.b * (cellCount - 1.0) + 0.5) * (cellSize * _vPixelSize.x);
	//将颜色(线性颜色坐标<不考虑gamma校正>)映射到单个cell内的纹理坐标(由纹理指定的颜色空间)
    half2 lutUVrg = color.rg 
					* half2(_vPixelSize.x * (cellSize - 2.0), _vPixelSize.y * (cellSize - 1.0))
					+ half2(_vPixelSize.z, _vPixelSize.w);
	
	color.rgb = tex2D(_LutTex, half2(lutUVrg.r + lutUVb, lutUVrg.g)).rgb;
	return color;
}
ENDCG 

Subshader 
{
	Pass 
	{
	  ZTest Off
	  Cull Off
	  ZWrite Off
	  Fog { Mode off }      

      CGPROGRAM
      #pragma vertex vert
      #pragma fragment frag
	  //#pragma target 3.0
      ENDCG
  	}

	
}
Fallback Off
}
