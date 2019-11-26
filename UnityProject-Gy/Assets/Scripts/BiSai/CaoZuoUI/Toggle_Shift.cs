using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Toggle_Shift : MonoBehaviour
{
    public OperationCheck Check;
    Toggle myToggle;
    private void Start()
    {
        myToggle = GetComponent<Toggle>();
        Check.ChangeShiftAngle = myToggle.isOn;
    }

    public void TryTellCtrChange()
    {
        Check.ChangeShiftAngle = myToggle.isOn;
    }
}
