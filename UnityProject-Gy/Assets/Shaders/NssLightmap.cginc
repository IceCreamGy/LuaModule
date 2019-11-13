// Upgrade NOTE: commented out 'half4 unity_LightmapST', a built-in variable
// Upgrade NOTE: commented out 'sampler2D unity_Lightmap', a built-in variable
// Upgrade NOTE: commented out 'sampler2D unity_LightmapInd', a built-in variable
// Upgrade NOTE: replaced tex2D unity_Lightmap with UNITY_SAMPLE_TEX2D
// Upgrade NOTE: replaced tex2D unity_LightmapInd with UNITY_SAMPLE_TEX2D_SAMPLER

#ifndef NSS_LIGHTMAP_INCLUDED
#define NSS_LIGHTMAP_INCLUDED


#include "UnityCG.cginc"
 
#include "Lighting.cginc"

#ifndef LIGHTMAP_OFF
	// These are prepopulated by Unity 
	// sampler2D unity_Lightmap;
	// half4 unity_LightmapST;
	#ifndef DIRLIGHTMAP_OFF
		// sampler2D unity_LightmapInd;
	#endif
#endif











half3 NssLightmap_Diffuse(half2 uvLM)
{
 #if DISABLE_LIGHTMAPS_DIFFUSE
		 return half3(1,1,1);
  #else
	  #ifndef LIGHTMAP_OFF
			half3 lightmap = DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap,uvLM));
			return lightmap;
		#else
			return half3(1,1,1);
		#endif
  #endif
}


half3 NssLightmap_DiffuseNormal(half3 TS_normal,half2 uvLM)
{
 #if DISABLE_LIGHTMAPS_DIFFUSE
	 return half3(1,1,1);
  #else
	 #ifndef LIGHTMAP_OFF
		#ifndef DIRLIGHTMAP_OFF
			//diffuse
			half3 lightmap = DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap,uvLM));
			half3 scalePerBasisVector = DecodeLightmap(UNITY_SAMPLE_TEX2D_SAMPLER(unity_LightmapInd,unity_Lightmap,uvLM)); 
			UNITY_DIRBASIS
			half3 normalInRnmBasis = saturate (mul (unity_DirBasis, TS_normal));
			lightmap *= dot (normalInRnmBasis, scalePerBasisVector);
		#else
			half3 lightmap = DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap,uvLM));
		#endif
		return lightmap;
	#else
		return half3(1,1,1);
	#endif
  #endif
}



half3 NssLightmap_SpecularNormal(half3 TS_normal,half2 uvLM,half3 TS_viewDir,half glow,half specular , out half3 specularResult)
{
 
	specularResult = half3(0.0,0.0,0.0);
 #ifndef LIGHTMAP_OFF
	#ifndef DIRLIGHTMAP_OFF
		
		//diffuse
		half3 lightmap = DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap,uvLM));
		
		//return half4(lightmap,1);
		
		half3 scalePerBasisVector = DecodeLightmap(UNITY_SAMPLE_TEX2D_SAMPLER(unity_LightmapInd,unity_Lightmap,uvLM)); 
		UNITY_DIRBASIS
		half3 normalInRnmBasis = saturate (mul (unity_DirBasis, TS_normal));
		
		//return half4(scalePerBasisVector,1);
		
		lightmap *= dot (normalInRnmBasis, scalePerBasisVector);
		
		//specular
		half3 TS_lightDir = normalize (scalePerBasisVector.x * unity_DirBasis[0] + scalePerBasisVector.y * unity_DirBasis[1] + scalePerBasisVector.z * unity_DirBasis[2]);
		//TS_viewDir = normalize(TS_viewDir);
		half3 TS_half = normalize (TS_lightDir + TS_viewDir);
		
		//return half4(TS_half,1);
		
		half Dot_NH = max (0, dot (TS_normal, TS_half));
		
		#ifndef DISABLE_LIGHTMAPS_SPECULAR
			specularResult = specular * NssPow (Dot_NH, glow) * lightmap;
		#endif
		
		//return half4(spec,spec,spec,1);
		
		#if DISABLE_LIGHTMAPS_DIFFUSE
		return 1;
		#else
		return lightmap ;
		#endif
  
	#else
		#if DISABLE_LIGHTMAPS_DIFFUSE
		return 1;
		#else
		half3 lightmap = DecodeLightmap(UNITY_SAMPLE_TEX2D(unity_Lightmap,uvLM));
	 
		return lightmap;
		#endif
	#endif
	
#else
	 
	return 1 ;
#endif
}

#endif
