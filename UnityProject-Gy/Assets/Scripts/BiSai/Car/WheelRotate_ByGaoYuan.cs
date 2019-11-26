using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class WheelRotate_ByGaoYuan : MonoBehaviour
{
    public float Speed = 30;
    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        transform.Rotate(Speed * Time.deltaTime, 0, 0);
    }
}
