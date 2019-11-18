using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ProtoBuf;

[ProtoContract]
public class Phone
{
    [ProtoMember(1)]
    public string name;
    [ProtoMember(2)]
    public int price;
}

public class Try_MyProtobuf : MonoBehaviour
{
    Phone myPhone = new Phone();

    void Start()
    {
        string path = Application.streamingAssetsPath + "/phone.bytes";

        myPhone.name = "Apple";
        myPhone.price = 7200;
        BinarySerializeOpt.ProtoSerialize(path, myPhone);

        Phone loadedPhone = BinarySerializeOpt.ProtoDeSerialize<Phone>(path);
        Debug.Log("loadedPhone.name     " + loadedPhone.name);
        Debug.Log("loadedPhone.price     " + loadedPhone.price);
    }
}
