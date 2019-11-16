using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ProtoBuf;
using System.IO;

public class BinarySerializeOpt : MonoBehaviour
{
    #region 本地文件
    //序列化到本地
    public static bool ProtoSerialize(string path, System.Object obj)
    {
        try
        {
            using (Stream file = File.Create(path))
            {
                Serializer.Serialize(file, obj);
                return true;
            }
        }
        catch (System.Exception e)
        {
            Debug.Log(e);
            throw;
        }
    }
    //从本地反序列化
    public static T ProtoDeSerialize<T>(string path) where T : class
    {
        try
        {
            using (Stream file = File.OpenRead(path))
            {
                return Serializer.Deserialize<T>(file);
            }
        }
        catch (System.Exception e)
        {
            Debug.Log(e);
            return null;
            throw;
        }

    }
    #endregion

    #region 网络文件
    public static byte[] ProtoSerialize(System.Object obj)
    {
        try
        {
            using (MemoryStream ms = new MemoryStream())
            {
                Serializer.Serialize(ms, obj);
                byte[] result = new byte[ms.Length];
                ms.Position = 0;
                ms.Read(result, 0, result.Length);
                return result;
            }
        }
        catch (System.Exception)
        {

            throw;
        }
    }

    public static T ProtoDeSerialize<T>(byte[] msg) where T : class
    {
        try
        {
            using (MemoryStream ms = new MemoryStream())
            {
                ms.Write(msg, 0, msg.Length);
                ms.Position = 0;
                return Serializer.Deserialize<T>(ms);
            }
        }
        catch (System.Exception e)
        {
            Debug.Log(e);
            return null;
            throw;
        }

    }
    #endregion
}
