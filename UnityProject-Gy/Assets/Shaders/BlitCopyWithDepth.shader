Shader "Hidden/BlitCopyWithDepth" {
	Properties 
    { 
        _MainTex ("Texture", 2D) = "" {}
        _SrcDepthTex("Texture", 2D) = "white" {}
    }
	SubShader { 
		Pass {
 			ZTest Always Cull Off ZWrite On

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 2.0

			#include "UnityCG.cginc"

			sampler2D _MainTex;
			uniform float4 _MainTex_ST;

            sampler2D_float _SrcDepthTex;

			struct appdata_t {
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				float2 texcoord : TEXCOORD0;
                float2 depthUV : TEXCOORD1;
			};

			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.texcoord = TRANSFORM_TEX(v.texcoord.xy, _MainTex);
                o.depthUV = v.texcoord;
				return o;
			}

            // important part: outputs depth from _SrcDepthTex to depth buffer
			fixed4 frag (v2f i, out float outDepth : SV_Depth) : SV_Target
			{
                outDepth = SAMPLE_DEPTH_TEXTURE(_SrcDepthTex, i.depthUV);
				return tex2D(_MainTex, i.texcoord);
			}
			ENDCG
		}
	}
	Fallback "Hidden/BlitCopy"
}
