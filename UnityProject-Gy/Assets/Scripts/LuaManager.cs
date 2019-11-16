using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text;
using UnityEngine;
using XLua;

public class LuaManager : BaseManager
{
    LuaEnv env = null;

    Action Lua_Init = null;
    Action Lua_Update = null;
    Action Lua_LateUpdate = null;
    Action<int, byte[]> Lua_Dispatch = null;

    float timer = 0;

    private void Awake()
    {
        //初始化lua环境，加载目录
        env = new LuaEnv();
        env.AddLoader((ref string filename) =>
        {
            //string LuaDirectory = Application.streamingAssetsPath + "/luacode";
            string LuaDirectory = "../LuaCode";
            string filePath = string.Format("{0}/{1}{2}", LuaDirectory, filename, ".lua");

            return File.ReadAllBytes(filePath);
        });      
    }

    /// <summary>
    /// 进入Lua 逻辑，一般在资源更新完后调用。
    /// </summary>
    public void InitLuaFunction()
    {
        env.DoString("require 'main'");
        Lua_Init = env.Global.Get<Action>("init");
        if (Lua_Init != null)
        {
            Lua_Init();
        }
        Lua_Update = env.Global.Get<Action>("update");
        Lua_LateUpdate = env.Global.Get<Action>("late_update");
        Lua_Dispatch = env.Global.Get<Action<int, byte[]>>("Dispatch");
    }

    public void DispachNetMsg2Lua(NetMsg msg)
    {
        Lua_Dispatch(msg.msgType, msg.msgBytes);
    }

    private void Update()
    {
        if (Lua_Update != null)
        {
            Lua_Update();
        }
    }

    private void LateUpdate()
    {
        if (Lua_LateUpdate != null)
        {
            Lua_LateUpdate();
        }
    }


    private void OnDestroy()
    {
        //监听移除

    }

    public LuaTable CreatLuaTable()
    {
        return env.NewTable();
    }

    public string GetPBString(string fileName)
    {
        string PbDirectory = "../LuaCode";
        return File.ReadAllText(string.Format("{0}/{1}", PbDirectory, fileName));
    }
}
