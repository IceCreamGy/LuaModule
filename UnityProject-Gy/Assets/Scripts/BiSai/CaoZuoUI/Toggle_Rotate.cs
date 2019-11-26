using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Toggle_Rotate : MonoBehaviour
{
    public OperationCheck Check;
    Toggle myToggle;
    private void Start()
    {
        myToggle = GetComponent<Toggle>();
    }

    public void TryTellCtrChange()
    {
        Check.ChangeNormalAngle = myToggle.isOn;
    }
}
