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
		Debug.Log("level " + loadedPhone.level);
		Debug.Log("diamond " + loadedPhone.diamond);
	}
}

[ProtoContract]
public class LoginData
{
	[ProtoMember(1)]
	public string name;
	[ProtoMember(2)]
	public int level;
	[ProtoMember(3)]
	public int diamond;
}