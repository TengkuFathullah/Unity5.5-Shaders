using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;

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

    #region UI
    public RectTransform ToolsPanel;
    bool isEnable;
    public void TogglePanel()
    {
        if (!isEnable)
            ToolsPanel.DOAnchorPosX(-196, 0.5f);
        else
            ToolsPanel.DOAnchorPosX(0, 0.5f);

        isEnable = !isEnable;
    }
    #endregion

}
