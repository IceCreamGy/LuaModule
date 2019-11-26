using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;

public class Touch_PiaoYi : MonoBehaviour, IPointerDownHandler, IPointerUpHandler
{
    public OperationCheck Check;

    public void OnPointerDown(PointerEventData eventData)
    {
        Check.IsCanShift = true;
    }

    public void OnPointerUp(PointerEventData eventData)
    {
        Check.IsCanShift = false;
    }
}
