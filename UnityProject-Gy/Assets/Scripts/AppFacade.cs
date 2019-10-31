using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Reflection;
using System;

//外观者模式，对Lua层提供访问接口
public class AppFacade : MonoBehaviour
{
    public static AppFacade instance { private set; get; }
    private Dictionary<Type, BaseManager> managerDic = new Dictionary<Type, BaseManager>();

    //ui根节点
    public Transform Canvas { get; private set; }
    public Transform GoContainer { get; private set; }

    private void Awake()
    {
        instance = this;
        InitManager();

        DontDestroyOnLoad(this.gameObject);

        Canvas = GameObject.Find("Canvas").transform;
        DontDestroyOnLoad(Canvas.gameObject);

        GoContainer = new GameObject("GoContainer").transform;
        GoContainer.transform.SetParent(transform);

        Invoke("InitLua", 0.5f);
    }

    void InitLua()
    {
        GetLuaManager().InitLuaFunction();
    }

    void InitManager()
    {
        managerDic.Add(typeof(LuaManager), gameObject.AddComponent<LuaManager>());
        managerDic.Add(typeof(LoadManager), gameObject.AddComponent<LoadManager>());
    }

    public LuaManager GetLuaManager()
    {
        return managerDic[typeof(LuaManager)] as LuaManager;
    }

    public LoadManager GetLoadManager()
    {
        return managerDic[typeof(LoadManager)] as LoadManager;
    }
}
