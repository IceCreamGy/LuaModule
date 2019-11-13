// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

/*
˵��:�̳�Mobile/Transparent/Vertex Color.shader
Ӧ����:�������͸��,��Ҫ�ǲݸ���Ҷ,ͨ���ԱȽϸ�,ĿǰƯ�ư���plant������
color��Ҫ������������������.�����ڰ�����һЩ��
*/

Shader "TopCar/Env/Plant_VertexColor" 
{
	Properties 
	{
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
	}

	Category 
	{
		Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}
		ZWrite Off
		//Alphatest Greater 0
		Blend SrcAlpha OneMinusSrcAlpha 
		cull off

		subshader
		{
			Lod 30
			Pass 
			{
				Lighting Off
				CGPROGRAM
					
				#pragma vertex vert
				#pragma fragment frag
				#pragma multi_compile_fog

				#include "UnityCG.cginc"
					
					
				struct v2f 
				{
					float4 vertex : POSITION;
					fixed2 texcoord : TEXCOORD0;
					fixed4 color : COLOR;
					UNITY_FOG_COORDS(1)
				};
					
				sampler2D _MainTex;
				fixed4 _MainTex_ST;
				//fixed4 _AddColor;
				fixed4 _Color;
					
				v2f vert (appdata_full v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex);
					o.texcoord = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.color = v.color;
					UNITY_TRANSFER_FOG(o, o.vertex); // pass fog coordinates to pixel shader
					return o;
				}
					
				fixed4 frag (v2f i) : COLOR
				{
					fixed4 col = tex2D(_MainTex, i.texcoord) * i.color  * _Color * fixed4(2,2,2,1);
					UNITY_APPLY_FOG(i.fogCoord, col); // apply fog
					return col;
				}
					
				ENDCG 
			}
		}
		
	}
}