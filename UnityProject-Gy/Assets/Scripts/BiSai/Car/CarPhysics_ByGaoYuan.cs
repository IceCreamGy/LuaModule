using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CarPhysics_ByGaoYuan : MonoBehaviour
{
	#region 策划配置相关
	[Header("起飘速度"), Range(20, 60)]
	public float Shift_MinSpeed = 50;
	[Header("漂移移动速度"), Range(0.0f, 100)]
	public float MoveSpeed_Shift = 70;
	[Header(" 漂移时，速度衰减的快慢"), Range(0.5f, 5f)]
	public float MoveSpeed_Damping = 1.7f;
	[Header(" 平跑时的目标角速度"), Range(2, 8)]
	public float NormalAngleSpeed = 4.5f;
	[Header(" 漂移时的目标角速度"), Range(10, 17)]
	public float ShiftAngleSpeed = 25f;
	[Header(" 漂移时，角速度改变的快慢"), Range(1f, 5f)]
	public float ShiftChangeSpeed = 1f;      //漂移时，角速度的改变速度（插值运算的快慢）

	[Header("角度回正速度"), Range(0.2f, 0.6f)]
	public float Angle_RecoverSpeed = 0.35f;
	#endregion

	#region 移动相关
	[HideInInspector]
	public float CurrentMoveSpeed;
	//当前衰减速度
	float currentSpeedDamping;

	float forwardSpeedRate;
	/// <summary>
	/// 前进比率
	/// </summary>
	public float ForwardSpeed_InputRate
	{
		get
		{
			return forwardSpeedRate;
		}
		set
		{
			forwardSpeedRate = value;
			if (forwardSpeedRate > 1)
			{
				forwardSpeedRate = 1;
			}
			if (forwardSpeedRate < -1)
			{
				forwardSpeedRate = -1;
			}
		}
	}
	CarMove moveData;
	#endregion

	#region 转速相关
	/// <summary>
	/// 目标角速度
	/// </summary>
	float TargetAngleSpeed;
	float rotate_Lerp;
	/// <summary>
	/// 旋转输入的过渡
	/// </summary>
	float Rotate_Lerp
	{
		get => rotate_Lerp;
		set
		{
			rotate_Lerp = value;
			if (rotate_Lerp > 1)
			{
				rotate_Lerp = 1;
			}
			if (rotate_Lerp < -1)
			{
				rotate_Lerp = -1;
			}
		}
	}
	/// <summary>
	/// 当前旋转的操作比率
	/// </summary>
	float Input_RotateRate;     //玩家松手 ，输入的旋转比率清零，但是计算的旋转比率要做平滑
	[HideInInspector]
	/// <summary>
	/// 当前的角速度
	/// </summary>
	public float CurrentAngleSpeed;
	/// <summary>
	/// 当前切换速度的过渡比率
	/// </summary>
	float CurrentShiftChangeSpeed = 0;
	/// <summary>
	/// 当前的角速度
	/// </summary>
	Vector3 CarAngularVelocity;
	[HideInInspector]
	/// <summary>
	/// 车辆真实的进入漂移。漂移键，起飘速度 都满足
	/// </summary>
	public bool HasEnterShift;
	#endregion

	#region 组件模块
	//玩家输入检测模块 (程序用)
	public OperationCheck Check;
	Rigidbody rigid;
	Transform Model;
	CarModelControl_ByGaoYuan ModelCtrl;
	EffectController_ByGaoYuan EffectCtr;
	#endregion

	private void Awake()
	{
		Application.targetFrameRate = 45;
	}
	private void Start()
	{
		Check = OperationCheck.Instance;
		rigid = GetComponent<Rigidbody>();
		EffectCtr = GetComponent<EffectController_ByGaoYuan>();
		Model = transform.Find("Car_Model");
		ModelCtrl = Model.GetComponent<CarModelControl_ByGaoYuan>();
		TargetAngleSpeed = 0;
		moveData = GetComponent<CarMove>();
	}
	private void Update()
	{
		UpdateInput();
		UpdateEffect();
	}
	private void FixedUpdate()
	{
		//计算转向
		UpdateCarRotate();
		//计算漂移速度衰减
		UpdateCarThrottle();
	}

	/// <summary>
	/// 更新输入
	/// </summary>
	void UpdateInput()
	{
		//前后处理
		if (Check.IsBreak)
		{
			ForwardSpeed_InputRate -= Time.deltaTime * 8;
		}
		else
		{
			ForwardSpeed_InputRate += Time.deltaTime * 3.3f;     //这里略去了，挡位计算
		}

		//左右处理
		if (Check.IsLeft)
		{
			Rotate_Lerp -= Time.deltaTime * 5;
			//Input_RotateRate = Check.UserInputRotateRate;
			Input_RotateRate = Mathf.Lerp(Input_RotateRate, Check.UserInputRotateRate, 5 * Time.deltaTime);
		}
		else if (Check.IsRight)
		{
			Rotate_Lerp += Time.deltaTime * 5;
			//Input_RotateRate = Check.UserInputRotateRate;
			Input_RotateRate = Mathf.Lerp(Input_RotateRate, Check.UserInputRotateRate, 5 * Time.deltaTime);
		}
		else if (!Check.IsLeft && !Check.IsRight)
		{
			Rotate_Lerp = Mathf.Lerp(Rotate_Lerp, 0, Angle_RecoverSpeed * Time.deltaTime);
			Input_RotateRate = Mathf.Lerp(Input_RotateRate, 0, Angle_RecoverSpeed * Time.deltaTime);
		}
	}
	/// <summary>
	/// 计算漂移速度衰减
	/// </summary>
	public void UpdateCarThrottle()
	{
		if (Check.IsBreak == false)
		{
			//加速前进
			if (Check.IsShift)
			{
				currentSpeedDamping = Mathf.Lerp(currentSpeedDamping, MoveSpeed_Damping, Time.deltaTime * 1);
				moveData.currentMoveSpeed = Mathf.Lerp(moveData.currentMoveSpeed, MoveSpeed_Shift, Time.deltaTime * currentSpeedDamping);
				CurrentMoveSpeed = moveData.currentMoveSpeed;
			}
			else
			{
				CurrentMoveSpeed = moveData.currentMoveSpeed;
			}
		}
		else
		{
			//倒车
			CurrentMoveSpeed = moveData.currentMoveSpeed;
		}

		//我承认，这个缩放系数10 有问题，瞎写的，凑效果。海军，救命啊。
		rigid.velocity = transform.forward * CurrentMoveSpeed * Mathf.Abs(ForwardSpeed_InputRate) * Time.deltaTime * 10;
	}
	/// <summary>
	/// 计算转向
	/// </summary>
	public void UpdateCarRotate()
	{
		if (Check.HasInput)
		{
			//如果此刻拥有输入

			if (Check.IsShift && CurrentMoveSpeed > Shift_MinSpeed)
			{
				HasEnterShift = true;
				//漂移时，计算目标旋转角
				if (Check.IsLeft == ModelCtrl.isModelLeft || Check.IsRight == ModelCtrl.isModelRight)
				{
					//非拉车头，通过模型的转向角判断
					CurrentShiftChangeSpeed = Mathf.Lerp(CurrentShiftChangeSpeed, ShiftChangeSpeed, 1 * Time.deltaTime);     //摩擦力的模拟
					TargetAngleSpeed = Mathf.Lerp(TargetAngleSpeed, ShiftAngleSpeed, CurrentShiftChangeSpeed * Time.deltaTime);    //漂移角度的计算
				}
				else
				{
					//拉车头时，暂定角速度 原角速度的0.3
					CurrentShiftChangeSpeed = Mathf.Lerp(CurrentShiftChangeSpeed, ShiftChangeSpeed, 1 * Time.deltaTime);     //摩擦力的模拟
					TargetAngleSpeed = Mathf.Lerp(TargetAngleSpeed, ShiftAngleSpeed * 1.3f, CurrentShiftChangeSpeed * Time.deltaTime);    //漂移角度的计算
				}
			}
			else
			{
				HasEnterShift = false;
				//平跑时
				TargetAngleSpeed = Mathf.Lerp(TargetAngleSpeed, NormalAngleSpeed, 10 * Time.deltaTime);
			}
		}
		else
		{
			HasEnterShift = false;
			//如果此刻没有输入
			Recover();
		}

		//计算旋转速度
		CurrentAngleSpeed = TargetAngleSpeed * Rotate_Lerp * Input_RotateRate * 11;   //乘以11，是为了转换为每秒旋转的度数

		CarAngularVelocity = transform.up * CurrentAngleSpeed * Time.deltaTime * 10 / 11;     //旋转角速度
		rigid.angularVelocity = CarAngularVelocity;
	}
	/// <summary>
	/// 回正角度
	/// </summary>
	void Recover()
	{
		//以下是用于辅助计算的数值
		TargetAngleSpeed = Mathf.Lerp(TargetAngleSpeed, 0, Angle_RecoverSpeed * Time.deltaTime);
		CurrentShiftChangeSpeed = Mathf.Lerp(CurrentShiftChangeSpeed, 0, Angle_RecoverSpeed * Time.deltaTime);
	}

	//更新特效
	public void UpdateEffect()
	{
		if (HasEnterShift)
		{
			EffectCtr.Open_TaiYin();
		}
		else
		{
			if (Mathf.Abs(Model.localRotation.eulerAngles.y) < 5.5f)
			{
				EffectCtr.Close_TaiYin();
			}
			if (Mathf.Abs(Model.localRotation.eulerAngles.y - 355) < 5.5f)
			{
				EffectCtr.Close_TaiYin();
			}
		}
	}
}
