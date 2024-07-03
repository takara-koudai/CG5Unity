using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class postEffect : MonoBehaviour
{

    public Shader shader;
    private Material material;

    private void Awake()
    {
        material = new Material(shader);
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Graphics.Blit(source, destination, material);
    }

    // Start is called before the first frame update

}
