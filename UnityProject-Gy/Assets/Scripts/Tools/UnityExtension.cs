using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public static class UnityExtension 
{
    /// <summary>
    /// 得到或者添加 GameObject
    /// </summary>
    /// <typeparam name="T"></typeparam>
    /// <param name="go"></param>
    /// <returns></returns>
    public static T GetOrAddComponent<T>(this GameObject go) where T : Component
    {
        T component = go.GetComponent<T>();
        if (component == null)
        {
            component = go.AddComponent<T>();
        }
        return component;
    }
}
