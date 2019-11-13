// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "TopCar/Env/ParticlesAdditive" {
 Properties {
     _TintColor ("Tint Color", Color) = (0.5,0.5,0.5,0.5)
     _MainTex ("Particle Texture", 2D) = "white" {}
     _MarskTex("Mask Texture", 2D) = "white" {}
     _InvFade ("Soft Particles Factor", Range(0.01,3.0)) = 1.0
     _Speed("Speed (XY)", Vector) = (-1.0, 0.0, 0.0, 0.0)
 }
 
 Category {
     Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
     Blend SrcAlpha One
     AlphaTest Greater .01
     ColorMask RGB
     Cull Off Lighting Off ZWrite Off ZTest On Fog { Color (0,0,0,0) }
     BindChannels {
         Bind "Color", color
         Bind "Vertex", vertex
         Bind "TexCoord", texcoord
     }
     
     // ---- Fragment program cards
     SubShader {
         Pass {
         
             CGPROGRAM
             #pragma multi_compile_fwdbase
             #pragma vertex vert
             #pragma fragment frag
             #pragma fragmentoption ARB_precision_hint_fastest
             #pragma multi_compile_particles
             #pragma target 3.0	
             #pragma glsl
 
             #include "UnityCG.cginc"
 
             sampler2D _MainTex;
             sampler2D _MarskTex;
             fixed4 _TintColor;
             half4 _Speed;
             
             struct appdata_t {
                 float4 vertex : POSITION;
                 fixed4 color : COLOR;
                 float2 texcoord : TEXCOORD0;
             };
 
             struct v2f {
                 float4 vertex : POSITION;
                 fixed4 color : COLOR;
                 float2 texcoord : TEXCOORD0;
                 #ifdef SOFTPARTICLES_ON
                 float4 projPos : TEXCOORD1;
                 #endif
                 float2 texOrgCoord : TEXCOORD2;
             };
             
             float4 _MainTex_ST;
 
             v2f vert (appdata_t v)
             {
                 v2f o;
                 o.vertex = UnityObjectToClipPos(v.vertex);
                 #ifdef SOFTPARTICLES_ON
                 o.projPos = ComputeScreenPos (o.vertex);
                 COMPUTE_EYEDEPTH(o.projPos.z);
                 #endif
                 o.color = v.color;
                 o.texcoord = TRANSFORM_TEX(v.texcoord,_MainTex);
                 o.texOrgCoord = v.texcoord;
                 return o;
             }
 
             sampler2D _CameraDepthTexture;
             float _InvFade;
             
             fixed4 frag (v2f i) : COLOR
             {
                 #ifdef SOFTPARTICLES_ON
                 float sceneZ = LinearEyeDepth (UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos))));
                 float partZ = i.projPos.z;
                 float fade = saturate (_InvFade * (sceneZ-partZ));
                 i.color.a *= fade;
                 #endif
               
                 //return fixed4(1,1,1,1);
                 //return i.color;
                 //ignore _MarskTex's uv flip
                 float2 uv = i.texcoord.xy + frac(_Time.yy * _Speed.xy);
                 return 2 * i.color * _TintColor * tex2D(_MainTex, uv) * tex2D(_MarskTex, i.texOrgCoord).r;
             }
             ENDCG 
         }
     }     
     
     // ---- Dual texture cards
     SubShader {
         Pass {
             SetTexture [_MainTex] {
                 constantColor [_TintColor]
                 combine constant * primary
             }
             SetTexture [_MainTex] {
                 combine texture * previous DOUBLE
             }
         }
     }
     
     // ---- Single texture cards (does not do color tint)
     SubShader {
         Pass {
                SetTexture [_MainTex] {
                    combine texture * primary
                }
            }
        }
    }
 }