// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Shader created with Shader Forge v1.05 
// Shader Forge (c) Neat Corporation / Joachim Holmer - http://www.acegikmo.com/shaderforge/
// Note: Manually altering this data may prevent you from opening it in Shader Forge
/*SF_DATA;ver:1.05;sub:START;pass:START;ps:flbk:,lico:0,lgpr:1,nrmq:0,limd:1,uamb:True,mssp:True,lmpd:False,lprd:False,rprd:False,enco:False,frtr:True,vitr:True,dbil:False,rmgx:True,rpth:0,hqsc:False,hqlp:False,tesm:0,blpr:5,bsrc:3,bdst:7,culm:2,dpts:2,wrdp:False,dith:0,ufog:False,aust:False,igpj:True,qofs:0,qpre:3,rntp:2,fgom:False,fgoc:False,fgod:False,fgor:False,fgmd:0,fgcr:0.5,fgcg:0.5,fgcb:0.5,fgca:1,fgde:0.01,fgrn:0,fgrf:300,ofsf:0,ofsu:0,f2p0:False;n:type:ShaderForge.SFN_Final,id:6217,x:33149,y:32794,varname:node_6217,prsc:2|emission-614-OUT,alpha-5565-OUT;n:type:ShaderForge.SFN_Tex2d,id:2813,x:31978,y:32633,ptovrint:False,ptlb:Texture,ptin:_Texture,varname:node_2813,prsc:2,tex:268905a2fde0a8046a218a4813ac13ea,ntxv:0,isnm:False|UVIN-1045-OUT;n:type:ShaderForge.SFN_TexCoord,id:8695,x:31398,y:32719,varname:node_8695,prsc:2,uv:0;n:type:ShaderForge.SFN_ValueProperty,id:4756,x:30980,y:32956,ptovrint:False,ptlb:U,ptin:_U,varname:node_4756,prsc:2,glob:False,v1:0;n:type:ShaderForge.SFN_ValueProperty,id:3750,x:30970,y:33041,ptovrint:False,ptlb:V,ptin:_V,varname:node_3750,prsc:2,glob:False,v1:0;n:type:ShaderForge.SFN_Append,id:1755,x:31180,y:32956,varname:node_1755,prsc:2|A-4756-OUT,B-3750-OUT;n:type:ShaderForge.SFN_Add,id:1045,x:31750,y:32744,varname:node_1045,prsc:2|A-8695-UVOUT,B-6925-OUT;n:type:ShaderForge.SFN_Time,id:4516,x:31180,y:32795,varname:node_4516,prsc:2;n:type:ShaderForge.SFN_Multiply,id:6925,x:31398,y:32884,varname:node_6925,prsc:2|A-4516-T,B-1755-OUT;n:type:ShaderForge.SFN_VertexColor,id:4826,x:32372,y:32817,varname:node_4826,prsc:2;n:type:ShaderForge.SFN_Multiply,id:7313,x:32590,y:32962,varname:node_7313,prsc:2|A-2191-R,B-4826-A;n:type:ShaderForge.SFN_Multiply,id:5565,x:32775,y:33115,varname:node_5565,prsc:2|A-7313-OUT,B-3164-G;n:type:ShaderForge.SFN_TexCoord,id:3548,x:31627,y:33103,varname:node_3548,prsc:2,uv:0;n:type:ShaderForge.SFN_ValueProperty,id:5616,x:31261,y:33279,ptovrint:False,ptlb:U2,ptin:_U2,varname:_node_4756_copy,prsc:2,glob:False,v1:0;n:type:ShaderForge.SFN_ValueProperty,id:5499,x:31244,y:33359,ptovrint:False,ptlb:V2,ptin:_V2,varname:_node_3750_copy,prsc:2,glob:False,v1:0;n:type:ShaderForge.SFN_Append,id:406,x:31449,y:33298,varname:node_406,prsc:2|A-5616-OUT,B-5499-OUT;n:type:ShaderForge.SFN_Add,id:7989,x:31823,y:33169,varname:node_7989,prsc:2|A-3548-UVOUT,B-2700-OUT;n:type:ShaderForge.SFN_Time,id:8231,x:31421,y:33161,varname:node_8231,prsc:2;n:type:ShaderForge.SFN_Multiply,id:2700,x:31627,y:33247,varname:node_2700,prsc:2|A-8231-T,B-406-OUT;n:type:ShaderForge.SFN_Multiply,id:8127,x:32574,y:32722,varname:node_8127,prsc:2|A-2710-RGB,B-2813-RGB,C-2222-OUT,D-4826-RGB;n:type:ShaderForge.SFN_Color,id:2710,x:32384,y:32564,ptovrint:False,ptlb:color,ptin:_color,varname:node_2710,prsc:2,glob:False,c1:0.4423118,c2:0.5004511,c3:0.5955882,c4:1;n:type:ShaderForge.SFN_Vector1,id:2222,x:32350,y:32767,varname:node_2222,prsc:2,v1:2;n:type:ShaderForge.SFN_Tex2dAsset,id:9920,x:31771,y:32967,ptovrint:False,ptlb:Texture_tool,ptin:_Texture_tool,varname:node_9920,tex:4ab92e5eeda4d0940b4c16a5413ab4b7,ntxv:0,isnm:False;n:type:ShaderForge.SFN_Tex2d,id:2191,x:32007,y:32862,varname:node_2191,prsc:2,tex:4ab92e5eeda4d0940b4c16a5413ab4b7,ntxv:0,isnm:False|UVIN-1045-OUT,TEX-9920-TEX;n:type:ShaderForge.SFN_Tex2d,id:3164,x:32158,y:33021,varname:node_3164,prsc:2,tex:4ab92e5eeda4d0940b4c16a5413ab4b7,ntxv:0,isnm:False|UVIN-7989-OUT,TEX-9920-TEX;n:type:ShaderForge.SFN_Tex2d,id:2675,x:32271,y:33209,varname:node_2675,prsc:2,tex:4ab92e5eeda4d0940b4c16a5413ab4b7,ntxv:0,isnm:False|UVIN-1801-OUT,TEX-9920-TEX;n:type:ShaderForge.SFN_Add,id:614,x:32873,y:32873,varname:node_614,prsc:2|A-8127-OUT,B-1602-OUT;n:type:ShaderForge.SFN_TexCoord,id:2780,x:31465,y:33500,varname:node_2780,prsc:2,uv:0;n:type:ShaderForge.SFN_Add,id:1801,x:31904,y:33426,varname:node_1801,prsc:2|A-2780-UVOUT,B-7750-OUT;n:type:ShaderForge.SFN_Multiply,id:1602,x:32481,y:33239,varname:node_1602,prsc:2|A-2675-B,B-6087-OUT;n:type:ShaderForge.SFN_Vector1,id:6087,x:32217,y:33381,varname:node_6087,prsc:2,v1:2;n:type:ShaderForge.SFN_Slider,id:5248,x:31320,y:33704,ptovrint:False,ptlb:Noise,ptin:_Noise,varname:node_5248,prsc:2,min:0,cur:0.7606843,max:1;n:type:ShaderForge.SFN_Multiply,id:7750,x:31726,y:33529,varname:node_7750,prsc:2|A-2813-R,B-5248-OUT;proporder:2813-4756-3750-5616-5499-2710-9920-5248;pass:END;sub:END;*/

Shader "QF/Env/Transparent/WaterpipeFalls" {
    Properties {
        _Texture ("Texture", 2D) = "white" {}
        _U ("U", Float ) = 0
        _V ("V", Float ) = 0
        _U2 ("U2", Float ) = 0
        _V2 ("V2", Float ) = 0
        _color ("color", Color) = (0.4423118,0.5004511,0.5955882,1)
        _Texture_tool ("Texture_tool", 2D) = "white" {}
        _Noise ("Noise", Range(0, 1)) = 0.7606843
        [HideInInspector]_Cutoff ("Alpha cutoff", Range(0,1)) = 0.5
    }
    SubShader {
        Tags {
            "IgnoreProjector"="True"
            "Queue"="Transparent"
            "RenderType"="Transparent"
        }
        Pass {
            Name "ForwardBase"
            Tags {
                "LightMode"="ForwardBase"
            }
            Blend SrcAlpha OneMinusSrcAlpha
            Cull Off
            ZWrite Off
            
            Fog {Mode Off}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #define UNITY_PASS_FORWARDBASE
            #include "UnityCG.cginc"
            //#pragma multi_compile_fwdbase
            #pragma exclude_renderers opengl xbox360 ps3 flash d3d11_9x 
            #pragma target 3.0
            uniform float4 _TimeEditor;
            uniform sampler2D _Texture; uniform float4 _Texture_ST;
            uniform float _U;
            uniform float _V;
            uniform float _U2;
            uniform float _V2;
            uniform float4 _color;
            uniform sampler2D _Texture_tool; uniform float4 _Texture_tool_ST;
            uniform float _Noise;
            struct VertexInput {
                float4 vertex : POSITION;
                float2 texcoord0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };
            struct VertexOutput {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 vertexColor : COLOR;
            };
            VertexOutput vert (VertexInput v) {
                VertexOutput o = (VertexOutput)0;
                o.uv0 = v.texcoord0;
                o.vertexColor = v.vertexColor;
                o.pos = UnityObjectToClipPos(v.vertex);
                return o;
            }
            fixed4 frag(VertexOutput i) : COLOR {
/////// Vectors:
////// Lighting:
////// Emissive:
                float4 node_4516 = _Time + _TimeEditor;
                float2 node_1045 = (i.uv0+(node_4516.g*float2(_U,_V)));
                float4 _Texture_var = tex2D(_Texture,TRANSFORM_TEX(node_1045, _Texture));
                float2 node_1801 = (i.uv0+(_Texture_var.r*_Noise));
                float4 node_2675 = tex2D(_Texture_tool,TRANSFORM_TEX(node_1801, _Texture_tool));
                float3 emissive = ((_color.rgb*_Texture_var.rgb*2.0*i.vertexColor.rgb)+(node_2675.b*2.0));
                float3 finalColor = emissive;
                float4 node_2191 = tex2D(_Texture_tool,TRANSFORM_TEX(node_1045, _Texture_tool));
                float4 node_8231 = _Time + _TimeEditor;
                float2 node_7989 = (i.uv0+(node_8231.g*float2(_U2,_V2)));
                float4 node_3164 = tex2D(_Texture_tool,TRANSFORM_TEX(node_7989, _Texture_tool));
                return fixed4(finalColor,((node_2191.r*i.vertexColor.a)*node_3164.g));
            }
            ENDCG
        }
    }
    Fallback "QF/Env/0_Low/Basic_AlphaBlend_Low"
    CustomEditor "ShaderForgeMaterialInspector"
}
