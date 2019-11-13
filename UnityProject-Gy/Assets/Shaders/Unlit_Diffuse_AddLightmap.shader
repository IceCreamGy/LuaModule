// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Fragment  shader. Simplest AddLighmap and AddColor textured shader.
// - no lighting
// - have lightmap support
// - have per-material color
Shader "TF/Basic/Unlit_Diffuse_AddLightmap"
 { 
    Properties  
    { 
		_Color ("Add Color", Color) = (0.5,0.5,0.5,1.0)
        _MainTex ("Base_01 (RGB)", 2D) = "white" {} 
        _SubTex ("Fake_LightMap (RGB)", 2D) = "white" {} 
    } 

    SubShader
    {
    	Lod 100 
        Pass  
        { 
            CGPROGRAM 
      
    
            #pragma vertex Vert 
  
            #pragma fragment Frag 
      
            #include "UnityCG.cginc" 
      
  
            sampler2D _MainTex; 
            sampler2D _SubTex;
		    uniform float4 _Color;
          
            struct V2F 
            { 
                float4 pos:POSITION; 
      
                fixed2 txr1:TEXCOORD0; 
                fixed2 txr2:TEXCOORD1; 
          
            }; 
                
          
            V2F Vert(appdata_full v) 
            { 
                  
                V2F output; 
      
                output.pos = UnityObjectToClipPos(v.vertex); 
      
                output.txr1 = v.texcoord;
                output.txr2 = v.texcoord1; 
              
                return output; 
            } 
              
          
            half4 Frag(V2F i):COLOR 
            { 
                fixed4 mainColor = tex2D(_MainTex,i.txr1);
                fixed4 subColor =  tex2D(_SubTex,i.txr2);
                return mainColor * subColor * _Color ;
      
            } 
            ENDCG 
        } 
    } 
    
	//fix π‹µ¿‰÷»æshader
	SubShader 
	{
		Lod 30
	    Pass 
	    {
	        Lighting Off
	        SetTexture [_MainTex] 
	        {
	            Combine texture, texture 
	        }
	    }
	}
	FallBack "Mobile/Vertex Colored"
  
}
