using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ProtoBuf;

public class LoginResponse : IMessageResponse
{
    public void ResponseData(byte[] data)
    {
        LoginData loginData = BinarySerializeOpt.ProtoDeSerialize<LoginData>(data);

        string savedName = PlayerPrefs.GetString(DataConst.PlayerName);
        string savedPassword = PlayerPrefs.GetString(DataConst.PlayerPassword);

        LoginResult result = new LoginResult();
        if (!string.IsNullOrEmpty(savedName) && loginData.name == savedName)
        {
            //用户存在
            if (loginData.password == savedPassword)
            {
                //登陆成功
                result.result = true;
                result.reason = "ojbk";
            }
            else
            {
                //密码错误
                result.result = false;
                result.reason = "密码错误";
            }
        }
        else
        {
            //用户不存在
            result.result = false;
            result.reason = "用户不存在";
        }

        byte[] buffer = BinarySerializeOpt.ProtoSerialize(result);

        AppFacade.instance.GetNetworkManager().OnReceiveData(102, buffer);

        //Debug.Log("name " + loadedPhone.name);
        //Debug.Log("password " + loadedPhone.password);
    }
}

[ProtoContract]
public class LoginData
{
    [ProtoMember(1)]
    public string name;
    [ProtoMember(2)]
    public string password;
}

[ProtoContract]
public class LoginResult
{
    [ProtoMember(1)]
    public bool result;
    [ProtoMember(2)]
    public string reason;
}