using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class Oepration_ShowUI : MonoBehaviour
{
    OperationCheck Check;

    Image leftLogo, rightLogo, shiftLogo, breakLogo;   //一些状态的图标  shift 漂移，break 刹车减速
    Slider Slider_DragLength, Slide_AngleToCenter;
    Text Text_DragLength, Text_AngleToCenter, Text_RotateSpeed, Text_MoveSpeed,Text_Time;
    // Start is called before the first frame update
    void Start()
    {
        Check = GetComponent<OperationCheck>();

        //添加事件
        AddEvent();
        //初始化组件
        InitStateLogoComponent();
    }
    void AddEvent()
    {
        if (Check != null)
        {
            Check.LeftChangeAction += ChangeLeftLogo;
            Check.RightChangeAction += ChangeRightLogo;
            Check.ShiftChangeAction += ChangeShiftLogo;
            Check.BreakChangeAction += ChangeBreakLogo;
            Check.DragRateChangeAction += ChangeDragRate;
            Check.RotateRateChangeAction += ChangeRotaRate;
        }
        else
        {
            Debug.LogError("未找到计算器：  OperationCheck");
        }
    }
    void InitStateLogoComponent()
    {
        leftLogo = transform.Find("StateLogo/Up/StateLogo_Left").GetComponent<Image>();
        rightLogo = transform.Find("StateLogo/Up/StateLogo_Right").GetComponent<Image>();
        shiftLogo = transform.Find("StateLogo/Up/StateLogo_Shift").GetComponent<Image>();
        breakLogo = transform.Find("StateLogo/Up/StateLogo_Break").GetComponent<Image>();
        Slider_DragLength = transform.Find("StateLogo/Up/StateLogo_LengthToCenter/Slider").GetComponent<Slider>();
        Slide_AngleToCenter = transform.Find("StateLogo/Up/StateLogo_AngleToCenter/Slider").GetComponent<Slider>();
        Text_DragLength = transform.Find("StateLogo/Up/StateLogo_LengthToCenter/Text_Value").GetComponent<Text>();
        Text_AngleToCenter = transform.Find("StateLogo/Up/StateLogo_AngleToCenter/Text_Value").GetComponent<Text>();
        Text_RotateSpeed = transform.Find("StateLogo/Up/StateLogo_RotateSpeed/Text_Value").GetComponent<Text>();
        Text_MoveSpeed = transform.Find("StateLogo/Down/Speed/Text_Value").GetComponent<Text>();
        Text_Time = transform.Find("StateLogo/Up/StateLogo_Time/Text_Value").GetComponent<Text>();
    }    

    public void ChangeLeftLogo(bool isLeft)
    {
        if (isLeft)
        {
            leftLogo.color = Color.green;
        }
        else
        {
            leftLogo.color = Color.white;
        }
    }
    public void ChangeRightLogo(bool isRight)
    {
        if (isRight)
        {
            rightLogo.color = Color.green;
        }
        else
        {
            rightLogo.color = Color.white;
        }
    }
    public void ChangeShiftLogo(bool isShift)
    {
        if (isShift)
        {
            shiftLogo.color = Color.green;
        }
        else
        {
            shiftLogo.color = Color.white;
        }
    }
    public void ChangeBreakLogo(bool isBreak)
    {
        if (isBreak)
        {
            breakLogo.color = Color.green;
        }
        else
        {
            breakLogo.color = Color.white;
        }
    }
    public void ChangeDragRate(float Magnitude)
    {
        Slider_DragLength.value = Magnitude;
        Text_DragLength.text = Magnitude.ToString("0.00");
    }
    public void ChangeRotaRate(float UserInputRotateRate)
    {
        Slide_AngleToCenter.value = UserInputRotateRate;
    }

    private void LateUpdate()
    {
        Text_Time.text = Time.time.ToString("0.0");

        //刷新车辆时速的显示
        UpdateCarShowState();

        //玩家滑动角度
        if (Check != null)
        {
            Text_AngleToCenter.text = Check.OffsetAngle.ToString("0.0");
        }
    }
    public CarPhysics_ByGaoYuan CarA, CarB;
    bool isA = false;
    public void ChangeCar()
    {
        if(CarA==null|| CarB == null)
        {
            Debug.LogError("未找到车辆");
            return;
        }

        if (isA)
        {
            Car = CarB;
            CarA.gameObject.SetActive(false);
            CarB.gameObject.SetActive(true);
        }
        else
        {
            Car = CarA;
            CarA.gameObject.SetActive(true);
            CarB.gameObject.SetActive(false);
        }
        isA = !isA;
    }

    public CarPhysics_ByGaoYuan Car;    //Car仅仅用来 获取车的旋转速度，加以展示。可以不填写
    /// <summary>
    /// 刷新车辆时速的显示
    /// </summary>
    void UpdateCarShowState()
    {
        if (Car != null)
        {
            Text_RotateSpeed.text = Car.CurrentAngleSpeed.ToString("0.00");
            Text_MoveSpeed.text = Car.CurrentMoveSpeed.ToString("0.0");
        }
    }
}
