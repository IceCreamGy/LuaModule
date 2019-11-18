using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using XLua;
using System.IO;
using System.Text;

public interface IMessageResponse
{
    void ResponseData(byte[] data);
}

public enum SocketState
{
    Connect = 101,
    ServerClose = 102,
    Disconnect = 103,
    Error = 104,
}

public class NetworkManager : BaseManager
{
    Dictionary<int, IMessageResponse> Dic = new Dictionary<int, IMessageResponse>();
    private void Start()
    {
        Dic.Add(1000, new RegisterResponse());
        Dic.Add(1001, new LoginResponse());
    }
    public void ConnectServer(string address, int port)
    {

    }
    public void SendNetMsg(int msgType, byte[] bytes)
    {
        Dic[msgType].ResponseData(bytes);
    }

    //网络协议，转发到lua执行
    public void OnReceiveData(int msgID, byte[] msgBytes)
    {
        LuaManager.DispachNetMsg2Lua(msgID, msgBytes);
    }

    //粘包分包
    //网络状态发生改变，要告诉Lua
}


