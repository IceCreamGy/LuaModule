// Support Dual Paraboloid Mapping

#ifndef DUAL_PARABOLOID_MAP_INCLUDED
#define DUAL_PARABOLOID_MAP_INCLUDED

#ifdef DUAL_PARABOLOID_ON
#   define DECLARE_DUAL_PARABOLOID_CLIP_DEPTH(idx) float _DualClipDepth : TEXCOORD##idx;
#   define DECLARE_DUAL_PARABOLOID_DEPTH(idx) float _DualDepth : TEXCOORD##idx;
#   define TRANSFER_VERTEX_TO_DUAL_PARABOLOID(Out, vertex) VertexToDualParaboloid(Out.pos, Out._DualClipDepth, Out._DualDepth, vertex);

#   define DUAL_PARABOLOID_ATTRIBUTE_SURF float _DualClipDepth; float _DualDepth; float2 dualLmp;
        // DUAL_PARABOLOID_ATTRIBUTE_SURF END
#   define TRANSFER_VERTEX_TO_DUAL_PARABOLOID_SURF(Out, vertex) VertexToDualParaboloid(Out.pos, Out._DualClipDepth, Out._DualDepth, vertex); \
             vertex = mul(Out.pos, UNITY_MATRIX_IT_MV); \
        // TRANSFER_VERTEX_TO_DUAL_PARABOLOID_SURF END

#   define DUAL_PARABOLOID_CLIP_DEPTH(a) clip(a._DualClipDepth);

float3 _DualClipPlanes;
float _DualDir;

void VertexToDualParaboloid(out float4 pos, out float clipDepth, out float depth, float4 vertex)
{
    // transform vertex to DP-space
    pos = mul(UNITY_MATRIX_MV, vertex);
    pos /= pos.w;

    pos.z *= _DualDir;

    // because the origin is at 0 the proj-vector
    // matches the vertex-position
    float fLength = length(pos.xyz);

    // normalize
    pos /= fLength;

    // save for clipping 	
    clipDepth = pos.z;

    // calc "normal" on intersection, by adding the 
    // reflection-vector(0,0,1) and divide through 
    // his z to get the texture coords
    float z = pos.z + 1.0f;
    pos.xy /= z;

    // set z for z-buffering and neutralize w
    //z = (fLength - g_fNear) / (g_fFar - g_fNear);
    pos.z = (fLength - _DualClipPlanes.y) / (_DualClipPlanes.z - _DualClipPlanes.y);
    pos.w = 1.0f;

    // DP-depth
    depth = pos.z;
}

#else
#   define DECLARE_DUAL_PARABOLOID_CLIP_DEPTH(idx)
#   define DECLARE_DUAL_PARABOLOID_DEPTH(idx)
#   define TRANSFER_VERTEX_TO_DUAL_PARABOLOID(Out, vertex)
#   define DUAL_PARABOLOID_ATTRIBUTE_SURF
#   define TRANSFER_VERTEX_TO_DUAL_PARABOLOID_SURF(Out, vertex)
#   define DUAL_PARABOLOID_CLIP_DEPTH(a)
#endif

#define DUAL_PARABOLOID_ATTRIBUTE(idx1, idx2) DECLARE_DUAL_PARABOLOID_CLIP_DEPTH(idx1) DECLARE_DUAL_PARABOLOID_DEPTH(idx2)

#ifdef DUAL_PARABOLOID_MAPPED_ON
#   define DUAL_PARABOLOID_SAMPLE(reflectedDir) DualParaboloidSample(reflectedDir);

float4x4 _DualVMatrix;
uniform sampler2D _EnvironmentFront;
uniform sampler2D _EnvironmentBack;
float _EnvironmentSmoothness;
fixed _EnvironmentAttenuation;

///
/// reflectedDir : 归一化反射向量,normalized
///
fixed4 DualParaboloidSample(fixed3 reflectedDir)
{
    // transform into dual paraboloid basis
    float3 dualViewPos = mul(_DualVMatrix, fixed4(reflectedDir,0));
    fixed4 realtimeEnvColor = fixed4(1, 0, 0, 1);
    dualViewPos.z *= -1;
    if (dualViewPos.z > 0.0f)
    {
        float2 vTexFront;
        vTexFront.x = (dualViewPos.x / (1.0f + dualViewPos.z)) * 0.5f + 0.5f;
        vTexFront.y = ((dualViewPos.y / (1.0f + dualViewPos.z)) * 0.5f + 0.5f);

#ifdef DUAL_MIPMAP
        float4 uv4 = float4(vTexFront, 0, _EnvironmentSmoothness);
        realtimeEnvColor = tex2Dlod(_EnvironmentFront, uv4);
#else
        realtimeEnvColor = tex2D(_EnvironmentFront, vTexFront);
#endif
    }
    else
    {
        float2 vTexBack;
        vTexBack.x = (dualViewPos.x / (1.0f - dualViewPos.z)) * 0.5f + 0.5f;
        vTexBack.y = ((dualViewPos.y / (1.0f - dualViewPos.z)) * 0.5f + 0.5f);

#ifdef DUAL_MIPMAP
        float4 uv4 = float4(vTexBack, 0, _EnvironmentSmoothness);
        realtimeEnvColor = tex2Dlod(_EnvironmentBack, uv4);
#else
        realtimeEnvColor = tex2D(_EnvironmentBack, vTexBack);
#endif
    }
    return realtimeEnvColor * _EnvironmentAttenuation;
}

#else
#   define DUAL_PARABOLOID_SAMPLE
#endif // DUAL_PARABOLOID_MAPPED_ON


#endif // DUAL_PARABOLOID_MAP_INCLUDED