using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ShaderLabUI : MonoBehaviour 
{
    #region Camera
    public CameraRotate camRotate;

    public void Rotate()
    {
        camRotate.enabled = true;
    }

    public void Static()
    {
        camRotate.enabled = false;
    }
    #endregion

}
