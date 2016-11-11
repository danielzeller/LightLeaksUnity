using UnityEngine;

[ExecuteInEditMode]
public class LightLeaks : MonoBehaviour
{
    [SerializeField] private Shader shader;
    [SerializeField] private bool useScreenBlendmode = false;

    [Range(0, 1f)] public float Instensity = 1f;

    [Range(0, 1f)] public float RedContribution = 1f;

    [Range(0, 1f)] public float YellowContribution = 1f;

    [Range(0, 1f)] public float BlueContribution = 1f;

    [Range(0, 4f)] public float MoveSpeed = 1.5f;

    private Material _material;

    void OnEnable()
    {
        if (shader == null)
        {
            Debug.Log("Shader is not set in the inspector", this);
            enabled = false;
            return;
        }
        _material = new Material(shader);
    }

    void OnDisable()
    {
        DestroyImmediate(_material);
        _material = null;
    }


    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        _material.SetFloat("_Intensity", Instensity);
        _material.SetFloat("_Red", RedContribution);
        _material.SetFloat("_Yellow", YellowContribution);
        _material.SetFloat("_Blue", BlueContribution);
        _material.SetFloat("_MoveSpeed", MoveSpeed);

        if (useScreenBlendmode)
        {
            _material.EnableKeyword("SCREEN_BLENDMODE");
        }
        else
        {
            _material.DisableKeyword("SCREEN_BLENDMODE");
        }

        Graphics.Blit(source, destination, _material, 0);
    }
}