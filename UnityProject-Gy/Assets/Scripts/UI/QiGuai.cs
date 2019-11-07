using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using DG.Tweening;
using UnityEngine.UI;
using DG.Tweening;

public class QiGuai : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        RectTransform rt = GetComponent<RectTransform>();
        rt.sizeDelta = new Vector2(0, 0);
        Tweener tw = rt.DOSizeDelta(Vector2.one, 1);
        tw.OnComplete(Hello);
        tw.SetEase(Ease.OutBack);

        rt.rotation = Quaternion.Euler(0,45,0);
        rt.DORotate(Vector3.zero, 0);
    }

    void Hello()
    {

    }

    // Update is called once per frame
    void Update()
    {

    }
}
