Shader "TopCar/Env/SimpleDiffuse"
{
	Properties
	{
        _Color("Main Color", Color) = (1,1,1,1)
        _MainTex("Base (RGB)", 2D) = "white" {}

        [Header(Fog Setting)]_FogFactor("Fog Factor", Range(0,1)) = 1
    }

	SubShader
	{
        Tags{ "RenderType" = "Opaque" }

		Pass
		{
			Name "SimpleDiffuse"
		    CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
            #pragma multi_compile_fog
			#pragma target 2.0

            #include "UnityCG.cginc"

			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				fixed4 color    : COLOR;
				float2 texcoord  : TEXCOORD0;
                UNITY_FOG_COORDS(6)
			};
			
			fixed4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;

            fixed _FogFactor;

			v2f vert(appdata_t IN)
			{
				v2f o;
                o.vertex = UnityObjectToClipPos(IN.vertex);
                o.texcoord = TRANSFORM_TEX(IN.texcoord, _MainTex);
                o.color = IN.color * _Color;

                UNITY_TRANSFER_FOG(o, o.vertex); // pass fog coordinates to pixel shader
				return o;
			}

			fixed4 frag(v2f IN) : SV_Target
			{
				half4 color = tex2D(_MainTex, IN.texcoord);
				color *= IN.color;

                half4 backColor = color;
                UNITY_APPLY_FOG(IN.fogCoord, color); // apply fog
                color = lerp(backColor, color, _FogFactor);
				return color;
			}
		ENDCG
		}
	}
}
