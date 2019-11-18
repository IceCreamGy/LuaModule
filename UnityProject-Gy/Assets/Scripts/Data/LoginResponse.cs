using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ProtoBuf;

public class LoginResponse : IMessageResponse
{
	public void ResponseData(byte[] data)
	{
		LoginData loadedPhone = BinarySerializeOpt.ProtoDeSerialize<LoginData>(data);
		Debug.Log("name " + loadedPhone.name);
        Debug.Log("age " + loadedPhone.age);
        Debug.Log("phone " + loadedPhone.phone);
		Debug.Log("password " + loadedPhone.password);
	}
}

[ProtoContract]
public class LoginData
{
	[ProtoMember(1)]
	public string name;
    [ProtoMember(2)]
    public int age;
    [ProtoMember(3)]
	public string phone;
	[ProtoMember(4)]
	public string password;
}