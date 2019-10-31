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

    Action lua_init = null;
    Action lua_update = null;
    Action lua_late_update = null;

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
        lua_init = env.Global.Get<Action>("init");
        if (lua_init != null)
        {
            lua_init();
        }
        lua_update = env.Global.Get<Action>("update");
        lua_late_update = env.Global.Get<Action>("late_update");
    }

    private void Update()
    {
        if (lua_update != null)
        {
            lua_update();
        }
    }

    private void LateUpdate()
    {
        if (lua_late_update != null)
        {
            lua_late_update();
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
}
