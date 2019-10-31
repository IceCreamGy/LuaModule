using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems;
using System;
using DG.Tweening;

public class ImagePro : Image, IPointerClickHandler
{
    //方便Lua端获取
    public Image mImage;
    public RectTransform Rt;
    protected override void Awake()
    {
        mImage = GetComponent<Image>();
        Rt = GetComponent<RectTransform>();
    }

    //方便Lua端获取
    CanvasGroup _Cg;
    public CanvasGroup Cg
    {
        get
        {
            if (_Cg == null)    //尝试获取
            {
                _Cg = gameObject.GetComponent<CanvasGroup>();
            }
            if (_Cg == null)    //获取不到，就添加
            {
                _Cg = gameObject.AddComponent<CanvasGroup>();
            }
            return _Cg;
        }
    }

    //在Lua层调用，添加事件
    public void AddClickListener(Action ac)
    {
        OnClick = ac;
    }

    //改变图片
    public void SetImage(string path)
    {
        //新旧AssetBundle包的改变
        //引用计数减少
        AppFacade.instance.GetLoadManager().LoadSprite(path, (Sprite spParam) =>
        {
            mImage.sprite = spParam;
        });
    }

    Action OnClick;
    //点击时触发事件
    public void OnPointerClick(PointerEventData eventData)
    {
        if (OnClick != null)
            OnClick();
    }

    //void OnDestroy()
    //{
    //    //引用计数减少
    //}
}
