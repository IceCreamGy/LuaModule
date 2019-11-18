using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BaseManager : MonoBehaviour
{
    public Transform Canvas { get { return AppFacade.instance.Canvas; } }
    public LuaManager LuaManager { get { return AppFacade.instance.GetLuaManager(); } }
}
