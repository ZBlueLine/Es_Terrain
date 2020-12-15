using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TextureTran : MonoBehaviour
{
    // Start is called before the first frame update
    public Texture albedoAtlas;
    public Texture splatID;
    public Texture splatWeight;

    void Start()
    {
        Shader.SetGlobalTexture("SpaltIDTex", splatID);
        Shader.SetGlobalTexture("SpaltWeightTex", splatWeight);
        Shader.SetGlobalTexture("AlbedoAtlas", albedoAtlas);
        //Shader.SetGlobalTexture("NormalAtlas", normalAtlas);
    }
}
