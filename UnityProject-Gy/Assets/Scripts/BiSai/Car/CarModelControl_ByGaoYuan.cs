using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CarModelControl_ByGaoYuan : MonoBehaviour
{
	OperationCheck Check;
	CarPhysics_ByGaoYuan Car;

	[Header("平跑-最大倾斜角度"), Range(8, 12)]
	public float EulerY_Normal = 5;
	[Header("漂移-最大倾斜角度"), Range(50, 65)]
	public float EulerY_Shift = 45;
	[Header("漂移 改变速度"), Range(2, 5)]
	public float ShiftChangeSpeed = 2;
	[Header("回正速度"), Range(2, 3)]
	public float Recover_AngleSpeed = 3;

	float CurrentShiftChangeSpeed = 1;           //当前切换速度的过渡比率

	/// <summary>
	/// 当前倾斜角度
	/// </summary>
	float CurrentEulerY;

	[HideInInspector]
	/// <summary>
	///  //车身向左？
	/// </summary>
	public bool isModelLeft;
	[HideInInspector]
	/// <summary>
	/// //车身向右？
	/// </summary>
	public bool isModelRight;

	private void Start()
	{
		Check = OperationCheck.Instance;
		Car = transform.parent.GetComponent<CarPhysics_ByGaoYuan>();
	}
	private void Update()
	{
		// 检测输入
		UpdateInput();
		// 更新转向
		UpdateCarModelRotate();
		//更新状态标识
		UpdateShowState();
	}

	/// <summary>
	/// 检测输入
	/// </summary>
	void UpdateInput()
	{
		if (Check.HasInput)
		{
			//如果此刻拥有输入
			if (Check.IsLeft)
			{
				//左
				RotateInput_Rate -= Time.deltaTime * 3;
			}
			if (Check.IsRight)
			{
				//右
				RotateInput_Rate += Time.deltaTime * 3;
			}
		}
		else
		{
			//如果此刻没有输入
			RotateInput_Rate = Mathf.Lerp(RotateInput_Rate, 0, 3 * Time.deltaTime);
		}
	}

	/// <summary>
	/// 更新转向
	/// </summary>
	public void UpdateCarModelRotate()
	{
		//有输入
		if (Check.HasInput)
		{
			if (Check.IsShift && Car.HasEnterShift)
			{
				//漂移
				CurrentShiftChangeSpeed = Mathf.Lerp(CurrentShiftChangeSpeed, ShiftChangeSpeed, 1f * Time.deltaTime);
				if (Check.IsLeft)
				{
					CurrentEulerY = Mathf.Lerp(CurrentEulerY, -EulerY_Shift, Mathf.Abs(RotateInput_Rate) * CurrentShiftChangeSpeed * Time.deltaTime);
				}
				if (Check.IsRight)
				{
					CurrentEulerY = Mathf.Lerp(CurrentEulerY, EulerY_Shift, Mathf.Abs(RotateInput_Rate) * CurrentShiftChangeSpeed * Time.deltaTime);
				}
			}
			else
			{
				//平跑
				if (Check.IsLeft || Check.IsRight)
				{
					CurrentShiftChangeSpeed = Mathf.Lerp(CurrentShiftChangeSpeed, ShiftChangeSpeed, 1f * Time.deltaTime);
					if (Check.IsLeft)
					{
						CurrentEulerY = Mathf.Lerp(CurrentEulerY, -EulerY_Normal, Mathf.Abs(RotateInput_Rate) * CurrentShiftChangeSpeed * Time.deltaTime);
					}
					if (Check.IsRight)
					{
						CurrentEulerY = Mathf.Lerp(CurrentEulerY, EulerY_Normal, Mathf.Abs(RotateInput_Rate) * CurrentShiftChangeSpeed * Time.deltaTime);
					}
				}
				else
				{
					Recover();  //非漂移，非左右，那么就是在刹车，此时纠正车头
				}
			}
		}
		else
		{
			//无输入，回正
			Recover();
		}

		transform.localRotation = Quaternion.Euler(0, CurrentEulerY, 0);
	}

	/// <summary>
	/// 检测的临界值
	/// </summary>
	float checkAngle = 0.01f;
	/// <summary>
	/// 更新状态标识
	/// </summary>
	void UpdateShowState()
	{
		if (CurrentEulerY < -checkAngle)
		{
			isModelLeft = true;
			isModelRight = false;
		}
		else if (checkAngle < CurrentEulerY)
		{
			isModelLeft = false;
			isModelRight = true;
		}
		else if (checkAngle < CurrentEulerY || CurrentEulerY < checkAngle)
		{
			isModelLeft = false;
			isModelRight = false;
		}
	}

	/// <summary>
	/// 回正
	/// </summary>
	void Recover()
	{
		CurrentShiftChangeSpeed = Mathf.Lerp(CurrentShiftChangeSpeed, 0, 0.9f * Time.deltaTime);

		CurrentEulerY = Mathf.Lerp(CurrentEulerY, 0, Time.deltaTime * Recover_AngleSpeed);
	}


	//输入过渡
	float rotateSpeedRate;
	/// <summary>
	/// 输入过渡
	/// </summary>
	public float RotateInput_Rate
	{
		get => rotateSpeedRate;
		set
		{
			rotateSpeedRate = value;
			if (rotateSpeedRate > 1)
			{
				rotateSpeedRate = 1;
			}
			if (rotateSpeedRate < -1)
			{
				rotateSpeedRate = -1;
			}
		}
	}
}
