// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "TopCar/Car/CarEmission" {
	Properties{
		_EmissionTex("Emission Texture", 2D) = "black" {}
	}
	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		LOD 200
		Pass
		{
			CGPROGRAM
			// Physically based Standard lighting model, and enable shadows on all light types
			//#pragma surface surf Standard fullforwardshadows
			#pragma vertex vert
			#pragma fragment frag

			// Use shader model 3.0 target, to get nicer looking lighting
			#pragma target 3.0

			sampler2D _EmissionTex;

			struct vertexInput {
				float4 vertex : POSITION;
				fixed3 normal : NORMAL;
				float2 texcoord : TEXCOORD0;
			};

			struct vertexOutput {
				float4 pos : SV_POSITION;
				float2 tex : TEXCOORD0;
			};


			vertexOutput vert(vertexInput v)
			{
				vertexOutput o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.tex = v.texcoord;
				//TRANSFER_VERTEX_TO_FRAGMENT(o);			   
				return o;
			}

			fixed4 frag(vertexOutput input) : COLOR
			{
				fixed4 emissionClr = tex2D(_EmissionTex, input.tex.xy);
				return emissionClr;
			}
			ENDCG
		}
	}
	FallBack "Diffuse"
}
