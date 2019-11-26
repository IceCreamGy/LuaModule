using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.EventSystems;
using UnityEngine.Events;
using System;
using UnityEngine;

public class OperationCheck : MonoBehaviour
{
    public static OperationCheck Instance;
    private void Awake()
    {
        Instance = this;
    }

    #region  对外事件
    public Action<bool> LeftChangeAction;
    public Action<bool> RightChangeAction;
    public Action<bool> BreakChangeAction;
    public Action<bool> ShiftChangeAction;
    public Action<float> DragRateChangeAction;
    public Action<float> RotateRateChangeAction;
    #endregion

    #region 策划配置
    [Header("漂移触发距离"), TooltipAttribute("像素单位"), Range(0, 60)]
    public float shiftCheckDistance = 35;
    [Header("漂移触发高度"), TooltipAttribute("像素单位"), Range(0, 90)]
    public float shiftCheckHeight = 60;

    [Header("左右反向")]
    public bool ChangeNormalAngle;
    [Header("配置漂移反向")]
    public bool ChangeShiftAngle;
    #endregion

    #region 程序检测的结果
    //手指最后落点与圆心的连线与垂直线的夹角A对应车辆转向角，A越大 RotateRate越大
    /// <summary>
    /// 玩家输入的旋转比率
    /// </summary>
    public float UserInputRotateRate
    {
        get { return InputRotateRate; }
        set
        {
            InputRotateRate = value;
            if (InputRotateRate > 1)
            {
                InputRotateRate = 1;
            }
            if (InputRotateRate < -1)
            {
                InputRotateRate = -1;
            }
        }
    }
    float InputRotateRate;

    /// <summary>
    /// 是否在左转
    /// </summary>
    public bool IsLeft
    {
        get => isLeft;
        set
        {
            //平跑反向最后计算
            if (ChangeNormalAngle)
            {
                isLeft = !value;
            }
            else
            {
                isLeft = value;
            }

            //漂移反向最后计算       --在漂移中，并且启动了漂移反向
            if (ChangeShiftAngle && isShift)
            {
                isLeft = !isLeft;
            }


            if (145 < angle && angle < 235)
            {
                isLeft = false;     //非检测区域，都是False
            }

            LeftChangeAction(isLeft);
        }
    }
    /// <summary>
    /// 是否在右转
    /// </summary>
    public bool IsRight
    {
        get => isRight;
        set
        {
            //平跑反向最后计算
            if (ChangeNormalAngle)
            {
                isRight = !value;
            }
            else
            {
                isRight = value;
            }

            //漂移反向最后计算      --在漂移中，并且启动了漂移反向
            if (ChangeShiftAngle && isShift)
            {
                isRight = !isRight;
            }

            if (145 < angle && angle < 235)
            {
                isRight = false;     //非检测区域，都是False
            }

            RightChangeAction(isRight);
        }
    }

    /// <summary>
    /// 是否在漂移
    /// </summary>
    public bool IsShift
    {
        get => isShift;
        set
        {
            isShift = value;

            ShiftChangeAction(isShift);
        }
    }

    /// <summary>
    /// 是否刹车减速
    /// </summary>
    public bool IsBreak
    {
        get { return isBreak; }
        set
        {
            isBreak = value;
            BreakChangeAction(isBreak);
        }
    }

    [HideInInspector]
    /// <summary>
    /// 此刻是否拥有操作
    /// </summary>
    public bool HasInput;
    #endregion

    #region 初始化检测所需的 组件
    float angle;
    float Magnitude;//按压位置，距离圆心的距离（0~1 的比例）

    ScrollCircle circle;
    Transform center, dragGo;
    // Start is called before the first frame update
    void Start()
    {
        InitCheckNeedComponent();
    }
    /// <summary>
    /// 初始化 检测需要的组件引用
    /// </summary>
    void InitCheckNeedComponent()
    {
        circle = transform.Find("OperationArea/TouchControlBg").GetComponent<ScrollCircle>();
        center = transform.Find("OperationArea/TouchControlBg").transform;
        dragGo = transform.Find("OperationArea/TouchControlBg/TouchPos").transform;
    }
    #endregion

    #region 计算输入状态
    bool isLeft;
    bool isRight;
    bool isShift;
    bool isBreak;
    Vector3 dir;
    Quaternion targetQuaternion;
    Vector3 ElurAngle;

    //距离中心垂线的偏转角
    [HideInInspector]
    public float OffsetAngle;

    bool isCanShift;
    /// <summary>
    /// 是否可以漂移。两种检测方式：1，拖拽到遥感底部。2，按住漂移键
    /// </summary>
    public bool IsCanShift
    {
        get
        {
            return isCanShift;
        }
        set
        {
            isCanShift = value;
        }
    }
    // Update is called once per frame
    void Update()
    {
        //检测是否拥有输入
        Check_Input();

        //检测拖拽长度
        CheckDragLength();

        //检测拖拽角度
        if (Input.GetKey(KeyCode.A) || Input.GetKey(KeyCode.D))
        {
            UserInputRotateRate = 1;    //键盘输入
            RotateRateChangeAction(UserInputRotateRate);
        }
        else
        {
            CheckDragAngle();   //遥感输入
        }

        //检测当前状态
        CheckState();
    }

    //检测是否拥有输入
    void Check_Input()
    {
        if (Input.GetKey(KeyCode.A) || Input.GetKey(KeyCode.D))
        {
            HasInput = true;
        }
        else
        {
            HasInput = circle.pressed;
        }
    }

    /// <summary>
    /// 检测拖拽长度
    /// </summary>
    void CheckDragLength()
    {
        Magnitude = circle.Magnitude;
        DragRateChangeAction(Magnitude);
    }

    /// <summary>
    /// 检测拖拽角度
    /// </summary>
    void CheckDragAngle()
    {
        dir = dragGo.position - center.position;
        targetQuaternion = Quaternion.LookRotation(transform.forward, dir);
        ElurAngle = targetQuaternion.eulerAngles;
        angle = 360 - ElurAngle.z;

        if (circle.pressed)
        {
            OffsetAngle = Mathf.Abs(angle - 180);      //旋转到一半就是最大转向角
        }
        else
        {
            OffsetAngle = 0;
        }

        //旋转的比率    
        if (IsShift)
        {
            //漂移时，根据角度
            UserInputRotateRate = OffsetAngle / 180 * 1.8f; 
        }
        else
        {
            //平跑时，根据距离
            UserInputRotateRate = Magnitude;
        }
                                         
        RotateRateChangeAction(UserInputRotateRate);
    }

    /// <summary>
    /// 计算输入状态
    /// </summary>
    void CheckState()
    {
        if (Input.GetKey(KeyCode.A) || Input.GetKey(KeyCode.D))
        {
            CheckRotate_ByKeyboard();
        }
        else
        {
            CheckRotate_ByYaoGan();
        }

        CheckShift();
    }

    /// <summary>
    /// 通过键盘计算
    /// </summary>
    void CheckRotate_ByKeyboard()
    {
        if (Input.GetKey(KeyCode.A) && Input.GetKey(KeyCode.D))
        {
            //同时按下，取消旋转输入
            IsLeft = false;
            IsRight = false;
        }
        else
        {
            //通过键盘输入，为了方便操作，再次把漂移方向反向。
            //达到的结果比如：平跑左转 W ，漂移左转 W + 漂移输入即可
            if (Input.GetKey(KeyCode.A))
            {
                //向左
                if (!IsShift)
                {
                    IsLeft = true;
                    IsRight = false;
                }
                else
                {
                    IsLeft = false;
                    IsRight = true;
                }
            }
            if (Input.GetKey(KeyCode.D))
            {
                //向右
                if (!IsShift)
                {
                    IsLeft = false;
                    IsRight = true;
                }
                else
                {
                    IsLeft = true;
                    IsRight = false;
                }

            }
        }
    }

    /// <summary>
    /// 用遥感计算
    /// </summary>
	void CheckRotate_ByYaoGan()
    {
        if (circle.pressed)
        {
            //飘移区域 145~235  ，不检测转向 
            if (145 < angle && angle < 235)
            {
                IsLeft = false;
                IsRight = false;
            }
            else
            {
                //非漂移区域，检测转向
                if (circle.contentPosition.x < 0)
                {
                    IsLeft = true;
                    IsRight = false;
                }
                else
                {
                    IsLeft = false;
                    IsRight = true;
                }
            }
        }
        else
        {
            ResetState();
        }
    }
    void CheckShift()
    {
        if (IsCanShift)     //可以漂移
        {
            if (IsLeft || IsRight)      //并且拥有左右输入
            {
                IsShift = true;     //才判定为漂移
            }
            else
            {
                IsShift = false;
            }
        }
        else
        {
            IsShift = false;
        }
    }

    /// <summary>
    /// 置灰所有状态
    /// </summary>
    void ResetState()
    {
        if (ChangeNormalAngle)
        {
            //因为取反了，所以反向重置
            IsLeft = true;
            IsRight = true;
        }
        else
        {
            IsLeft = false;
            IsRight = false;
        }

        isShift = false;
    }
    #endregion

    #region 漂移的判断逻辑
    float DragDistance;  //像素
    Vector2 NowPos, EndPos;

    public void OnUserDrag(Vector2 touchPos)
    {
        NowPos = touchPos;
        DragDistance = touchPos.magnitude;

        if (DragDistance > shiftCheckDistance)     //检测拖拽距离
        {
            if (NowPos.y < -shiftCheckHeight)    //检测结束点 Y 是否在结束区域
            {
                if (-85 < NowPos.x && NowPos.x < 85)   //检测结束点 X 是否在结束区域
                {
                    IsCanShift = true;
                }
            }
        }

        if (145 < angle && angle < 235)
        {
            IsShift = false;
            //在漂移检测区域，不可触发漂移。
            //取消漂移状态的判定。结果供相机、特效、音效 计算。
        }
    }
    public void OnUserUp(Vector2 touchPos)
    {
        EndPos = touchPos;
        IsCanShift = false;     //只有当松手，才结束漂移状态  ??待定
    }

    #endregion
}
