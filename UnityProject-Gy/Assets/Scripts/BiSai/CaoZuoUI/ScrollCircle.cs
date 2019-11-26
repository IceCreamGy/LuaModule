using UnityEngine;
using System.Collections;
using UnityEngine.UI;
using UnityEngine.EventSystems;

public class ScrollCircle : ScrollRect
{
    protected float mRadius = 0f;
    /// <summary>
    /// 滑块离中心的位置
    /// </summary>
    public float Magnitude;
    /// <summary>
    /// 滑块位置
    /// </summary>
    public Vector2 contentPosition;
    /// <summary>
    /// 按压状态
    /// </summary>
    public bool pressed;

    RectTransform myRt;
    OperationCheck Check;
    protected override void Start()
    {
        base.Start();
        myRt = GetComponent<RectTransform>();
        mRadius = (transform as RectTransform).sizeDelta.x * 0.5f;
        Check = transform.parent.parent.GetComponent<OperationCheck>();
    }

    public override void OnBeginDrag(PointerEventData eventData)
    {
        base.OnBeginDrag(eventData);
    }

    public override void OnDrag(UnityEngine.EventSystems.PointerEventData eventData)
    {
        base.OnDrag(eventData);
        Check.OnUserDrag(contentPosition);

        pressed = true;
        contentPosition = this.content.anchoredPosition;
     
        if (contentPosition.magnitude > mRadius)
        {
            contentPosition = contentPosition.normalized * mRadius;
            SetContentAnchoredPosition(contentPosition);
        }

        Magnitude = contentPosition.magnitude/ mRadius;
    }

    public override void OnEndDrag(PointerEventData eventData)
    {
        base.OnEndDrag(eventData);
        Check.OnUserUp(contentPosition);

        pressed = false;
        contentPosition = Vector2.zero;
        SetContentAnchoredPosition(contentPosition);
        Magnitude = contentPosition.magnitude;
    }
}