using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraManager_ByGaoYuan : MonoBehaviour
{
    OperationCheck Check;
    [Header("相机角度改变速率")]
    public float AngleChangeSpeed = 3;
    [Header("相机位置改变速率")]
    public float PosChangeSpeed = 6;
    [Header("Z轴 侧倾度")]
    public float TargetEulerZ = 9;
    [Header("Y轴 侧倾度")]
    public float TargetEulerY = 13;
	[Header("角度回正速度")]
	public float AngleRecoverSpeed = 3;

	float EulerY;
    float EulerZ;

    Vector3 NormalPos = new Vector3(0, 2.99f, -7.61f);  //平跑时的相机 Local位置
    Vector3 ShiftPos = new Vector3(0, 2.67f, -6.09f);   //漂移时的相机 Local位置

    Vector3 TargetPos;

    Transform ChildCamera;
    float currentRate;

    private void Start()
    {
        Check = OperationCheck.Instance;
        ChildCamera = transform.Find("Camera");
        TargetPos = NormalPos;
    }
    // Update is called once per frame
    void LateUpdate()
    {
        //计算操作的幅度
        CheckRate();
        //计算角度
        ComputeAngle();
        //计算位置，并应用
        ComputePos();
  
        //应用角度
        transform.localRotation = Quaternion.Euler(0, EulerY, 0);
        ChildCamera.localRotation = Quaternion.Euler(ChildCamera.localRotation.eulerAngles.x, ChildCamera.localRotation.eulerAngles.y, EulerZ);        
    }

    /// <summary>
    /// 计算操作的幅度
    /// </summary>
    void CheckRate()
    {
        if (Check.UserInputRotateRate < 0.8f)
        {
            //仅当侧倾衰减时，才平滑过渡。（计算玩家操作比例）
            currentRate = Mathf.Lerp(currentRate, Check.UserInputRotateRate, Time.deltaTime * 1);
        }
        else
        {
            currentRate = Check.UserInputRotateRate;
        }
    }

    /// <summary>
    /// 计算角度
    /// </summary>
    void ComputeAngle()
    {
        if (Check.HasInput)
        {
            //有操作时
            if (Check.IsShift)
            {
                if (Check.IsLeft)
                {
                    EulerZ = Mathf.Lerp(EulerZ, TargetEulerZ, Time.deltaTime * AngleChangeSpeed);
                    EulerY = Mathf.Lerp(EulerY, -TargetEulerY, Time.deltaTime * AngleChangeSpeed);
                }
                if (Check.IsRight)
                {
                    EulerZ = Mathf.Lerp(EulerZ, -TargetEulerZ, Time.deltaTime * AngleChangeSpeed);
                    EulerY = Mathf.Lerp(EulerY, TargetEulerY, Time.deltaTime * AngleChangeSpeed);
                }
            }
            else
            {
                if (Check.IsLeft)
                {
                    EulerZ = Mathf.Lerp(EulerZ, TargetEulerZ * 0.15f, Time.deltaTime * AngleChangeSpeed);
                    EulerY = Mathf.Lerp(EulerY, TargetEulerY * 0.4f, Time.deltaTime * AngleChangeSpeed);
                }
                if (Check.IsRight)
                {
                    EulerZ = Mathf.Lerp(EulerZ, -TargetEulerZ * 0.15f, Time.deltaTime * AngleChangeSpeed);
                    EulerY = Mathf.Lerp(EulerY, -TargetEulerY * 0.4f, Time.deltaTime * AngleChangeSpeed);
                }
            }
            if (!Check.IsLeft && !Check.IsRight)
            {
                Recover();
            }
        }
        else
        {
            Recover();
        }

        EulerZ *= currentRate; //加上操纵的幅度
    }

    /// <summary>
    /// 计算位置，并应用
    /// </summary>
    void ComputePos()
    {
        if (Check.IsShift)
        {
            TargetPos = ShiftPos;
            //刹车相机位置改变快
            ChildCamera.localPosition = Vector3.Lerp(ChildCamera.localPosition, TargetPos, Time.deltaTime * PosChangeSpeed);
        }
        else
        {
            TargetPos = NormalPos;
            //重新提速，相机位置改变慢，为刹车的0.6倍
            ChildCamera.localPosition = Vector3.Lerp(ChildCamera.localPosition, TargetPos, Time.deltaTime * PosChangeSpeed * 0.45f);
        }
    }

    /// <summary>
    /// 回正
    /// </summary>
    void Recover()
    {
        //没有操作时
        EulerZ = Mathf.Lerp(EulerZ, 0, Time.deltaTime * AngleRecoverSpeed);
        EulerY = Mathf.Lerp(EulerY, 0, Time.deltaTime * AngleRecoverSpeed);
    }
}
