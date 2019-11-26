using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public class Touch_ShaChe : MonoBehaviour, IPointerDownHandler, IPointerUpHandler
{
    public OperationCheck Check;

    public void OnPointerDown(PointerEventData eventData)
    {
        Check.IsBreak = true;
    }

    public void OnPointerUp(PointerEventData eventData)
    {
        Check.IsBreak = false;
    }
}
