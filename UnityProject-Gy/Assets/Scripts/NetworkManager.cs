﻿using System.Collections;
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

//网络协议，转发到lua执行
public class NetMsg
{
	public int msgType { get; private set; }
	public byte[] msgBytes { get; private set; }
	public NetMsg(int msgType, byte[] msgBytes)
	{
		this.msgType = msgType;
		this.msgBytes = msgBytes;
	}
}

public class NetworkManager : BaseManager
{
	Dictionary<int, IMessageResponse> Dic = new Dictionary<int, IMessageResponse>();
	private void Start()
	{
		Dic.Add(1001, new LoginResponse());
	}
	public void ConnectServer(string address, int port)
	{

	}
	public void SendNetMsg(int msgType, byte[] bytes)
	{
		Dic[msgType].ResponseData(bytes);
	}

	//网络状态发生改变，要告诉Lua
	//粘包分包
	//消息广播到Lua层
}


