using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ProtobufID
{
    //从服务器端来的
    public const int S_LogOut = 101;
    public const int S_LoginResult = 102;

    //客户端发送的
    public const int UserRegister = 1000;
    public const int UserLogin = 1001;
    public const int UserInfo = 1002;
}
