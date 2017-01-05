using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SceneController : MonoBehaviour
{
    public Shader[] shaders;
    public GameObject[] models;

    GameObject targetObject;

    void Start()
    {
        targetObject = models[0];
    }

    int currentShaderIndex 
    {
        get
        {
            return PlayerPrefs.GetInt("shader_index", 0);
        }
        set
        {
            PlayerPrefs.SetInt("shader_index", value);
        }
    }

    public void SwitchShader()
    {
        currentShaderIndex++;

        Renderer[] renders = targetObject.GetComponentsInChildren<Renderer>();

        foreach(Renderer render in renders)
        {
            render.material.shader = shaders[currentShaderIndex];
        }
    }
	
}
