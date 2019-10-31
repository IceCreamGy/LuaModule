using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Events;
using UnityEngine.UI;
using System;

public class UIEventHelper
{
    public static void SetButtonClick(Button button, UnityAction func)
    {
        button.onClick.RemoveAllListeners();
        if (func != null)
        {
            button.onClick.AddListener(func);
        }
    }

    public static void SetGoSetActive(GameObject selectGo, string path, bool state)
    {
        selectGo.transform.Find(path).gameObject.SetActive(state);
    }
}