using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using System;

public class TogglePro : MonoBehaviour
{
    Toggle myToggle;
    [HideInInspector]
    public Text Text_lable;
    public RectTransform Rt;
    public RectTransform RT;
    void Awake()
    {
        myToggle = GetComponent<Toggle>();
        myToggle.onValueChanged.AddListener(OnChange);
        Text_lable = transform.Find("Label").GetComponent<Text>();
        Rt = GetComponent<RectTransform>();
        RT = Rt;
    }

    //方便Lua端获取
    CanvasGroup _Cg;
    //方便开发，大小写不敏感。（瞎鸡儿堆功能，捂脸.jpg）
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
    public CanvasGroup CG
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

    Action OnSelect;    //当选中
    Action CancleSelect;    //当取消选择

    void OnChange(bool state)
    {
        if (state)
        {
            if (OnSelect != null)
                OnSelect();
        }
        else
        {
            if (CancleSelect != null)
                CancleSelect();
        }
    }

    public void AddEvent(Action OnS, Action CancleS)
    {
        OnSelect = OnS;
        CancleSelect = CancleS;
    }
}
