using UnityEngine;

// This class implements simple ghosting type Motion Blur.
// If Extra Blur is selected, the scene will allways be a little blurred,
// as it is scaled to a smaller resolution.
// The effect works by accumulating the previous frames in an accumulation
// texture.
namespace UnityStandardAssets.ImageEffects
{
    [ExecuteInEditMode]
    [AddComponentMenu("Image Effects/Blur/Motion Blur (Color Accumulation)")]
    [RequireComponent(typeof(Camera))]
    public class MotionBlur : PostEffectsBase
    {
        public float blurAmount = 0.8f;
        public bool extraBlur = false;
        public Shader shader;
        private Material motionBlurMaterial = null;
        public Texture2D blurMaskTexture = null;
        public LayerMask excludeLayers = 0;
        public Shader replacementClear = null;

        private RenderTexture accumTexture;
        private GameObject tmpCam = null;
        private Camera _camera;
        private RenderTexture excludeMask;

        new void Start()
        {
            CheckResources();
            if (_camera == null)
                _camera = GetComponent<Camera>();
            base.Start();
        }

        void OnDisable()
        {
            DestroyImmediate(accumTexture);
        }

        public override bool CheckResources()
        {
            CheckSupport(true, true); // depth & hdr needed
            motionBlurMaterial = CheckShaderAndCreateMaterial(shader, motionBlurMaterial);

            if (!isSupported)
                ReportAutoDisable();

            return isSupported;
        }

        Camera GetTmpCam()
        {
            if (tmpCam == null)
            {
                string name = "_" + _camera.name + "_MotionBlurTmpCam";
                GameObject go = GameObject.Find(name);
                if (null == go) // couldn't find, recreate
                    tmpCam = new GameObject(name, typeof(Camera));
                else
                    tmpCam = go;
            }

            tmpCam.hideFlags = HideFlags.DontSave;
            tmpCam.transform.position = _camera.transform.position;
            tmpCam.transform.rotation = _camera.transform.rotation;
            tmpCam.transform.localScale = _camera.transform.localScale;
            tmpCam.GetComponent<Camera>().CopyFrom(_camera);

            tmpCam.GetComponent<Camera>().enabled = false;
            tmpCam.GetComponent<Camera>().depthTextureMode = DepthTextureMode.None;
            tmpCam.GetComponent<Camera>().clearFlags = CameraClearFlags.Nothing;

            return tmpCam.GetComponent<Camera>();
        }

        // Called by camera to apply image effect
        void OnRenderImage(RenderTexture source, RenderTexture destination)
        {
            if (false == CheckResources())
            {
                Graphics.Blit(source, destination);
                return;
            }
            // Create the accumulation texture
            if (accumTexture == null || accumTexture.width != source.width || accumTexture.height != source.height)
            {
                DestroyImmediate(accumTexture);
                accumTexture = new RenderTexture(source.width, source.height, 0);
                accumTexture.hideFlags = HideFlags.HideAndDontSave;
                Graphics.Blit(source, accumTexture);
            }

            if(excludeMask ==  null || excludeMask.width != source.width || excludeMask.height != source.height)
            {
                DestroyImmediate(excludeMask);
                excludeMask = new RenderTexture(source.width, source.height, 0);
                excludeMask.hideFlags = HideFlags.HideAndDontSave;
                excludeMask.Create();
            }
            excludeMask.DiscardContents();

            // If Extra Blur is selected, downscale the texture to 4x4 smaller resolution.
            if (extraBlur)
            {
                RenderTexture blurbuffer = RenderTexture.GetTemporary(source.width / 4, source.height / 4, 0);
                accumTexture.MarkRestoreExpected();
                Graphics.Blit(accumTexture, blurbuffer);
                Graphics.Blit(blurbuffer, accumTexture);
                RenderTexture.ReleaseTemporary(blurbuffer);
            }

            // Clamp the motion blur variable, so it can never leave permanent trails in the image
            blurAmount = Mathf.Clamp(blurAmount, 0.0f, 0.92f);

            // Setup the texture and floating point values in the shader
            motionBlurMaterial.SetTexture("_MainTex", accumTexture);
            motionBlurMaterial.SetTexture("_MaskTex", blurMaskTexture);
            motionBlurMaterial.SetFloat("_AccumOrig", 1.0F - blurAmount);
            motionBlurMaterial.SetTexture("_ExcludeBlurMask", excludeMask);

            // We are accumulating motion over frames without clear/discard
            // by design, so silence any performance warnings from Unity
            accumTexture.MarkRestoreExpected();

            Camera cam = null;
            if (excludeLayers.value != 0)// || dynamicLayers.value)
                cam = GetTmpCam();

            if (cam && excludeLayers.value != 0 && replacementClear && replacementClear.isSupported)
            {
                cam.cullingMask = excludeLayers;
                RenderTexture oldActive = RenderTexture.active;
                RenderTexture.active = excludeMask;
                GL.Clear(true, true, Color.black);
                RenderTexture.active = oldActive;
                cam.targetTexture = excludeMask;
                cam.RenderWithShader(replacementClear, "ExcludeBlurMask");
            }

            // Render the image using the motion blur shader
            Graphics.Blit(source, accumTexture, motionBlurMaterial);
            Graphics.Blit(accumTexture, destination);
        }
    }
}
