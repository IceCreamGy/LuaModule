using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//车轮左右转向，仅仅是更新动画
public class CarWheelControl_ByGaoYuan : MonoBehaviour
{
	OperationCheck Check;
	float ChangeSpeed = 2;

	float TargetEulerY = 50;

	float EulerY;

	Transform ChildCamera;
	private void Start()
	{
		ChildCamera = transform.Find("Camera");
		Check = OperationCheck.Instance;
	}

	void Update()
	{
		if (Check.HasInput)
		{
			if (Check.IsShift)
			{
				if (Check.IsLeft)
				{
					EulerY = Mathf.Lerp(EulerY, TargetEulerY, Time.deltaTime * ChangeSpeed);
				}
				else
				{
					EulerY = Mathf.Lerp(EulerY, -TargetEulerY, Time.deltaTime * ChangeSpeed);
				}
			}
			else
			{
				if (Check.IsLeft)
				{
					EulerY = Mathf.Lerp(EulerY, TargetEulerY * 0.4f, Time.deltaTime * ChangeSpeed);
				}
				else
				{
					EulerY = Mathf.Lerp(EulerY, -TargetEulerY * 0.4f, Time.deltaTime * ChangeSpeed);
				}
			}
		}
		else
		{
			EulerY = Mathf.Lerp(EulerY, 0, Time.deltaTime * 2);
		}

		transform.localRotation = Quaternion.Euler(0, EulerY, 0);
	}
}
