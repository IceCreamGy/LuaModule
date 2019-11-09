using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using System;

public class TogglePro : MonoBehaviour
{
    Toggle myToggle;
    public Text Text_lable;
    void Awake()
    {
        myToggle = GetComponent<Toggle>();
        myToggle.onValueChanged.AddListener(OnChange);
        Text_lable = transform.Find("Label").GetComponent<Text>();
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
