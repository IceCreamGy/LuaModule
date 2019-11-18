using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ProtoBuf;

public class RegisterResponse : IMessageResponse
{
    public void ResponseData(byte[] data)
    {
        RegisterData register = BinarySerializeOpt.ProtoDeSerialize<RegisterData>(data);
        //Debug.Log("请求注册：" + register.name + register.password);
        PlayerPrefs.SetString(DataConst.PlayerName, register.name);
        PlayerPrefs.SetString(DataConst.PlayerPassword, register.password);
    }
}


[ProtoContract]
public class RegisterData
{
    [ProtoMember(1)]
    public string name;
    [ProtoMember(2)]
    public string password;
}