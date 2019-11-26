using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

[Serializable]
public class MoveData
{
	public float StartSpeedKMH;
	public float TopSpeedKMH;
	public float NeedTime;
}

/// <summary>
/// 汽车移动数据计算。（换挡、降速等）
/// </summary>
public class CarMove : MonoBehaviour
{
	OperationCheck Check;
	int CurrentLevel;   //当前挡位
	[HideInInspector]
	public float currentMoveSpeed;  //当前移动速度
	float changeRate = 1;   //当前切换比率

	[Header("挡位")]
	public MoveData[] SpeedLevel;

	MoveData currentLevelData;
	// Start is called before the first frame update
	void Start()
	{
		Check = OperationCheck.Instance;
		CurrentLevel = -1;
		AddLevel();
	}
	/// <summary>
	/// 升挡位
	/// </summary>
	void AddLevel()
	{
		CurrentLevel++;
		CurrentLevel = Mathf.Clamp(CurrentLevel, 0, SpeedLevel.Length - 1);
		currentLevelData = SpeedLevel[CurrentLevel];
		currentMoveSpeed = currentLevelData.StartSpeedKMH;
		changeRate = (currentLevelData.TopSpeedKMH - currentLevelData.StartSpeedKMH) / currentLevelData.NeedTime;
	}
	/// <summary>
	/// 降挡位
	/// </summary>
	void ReduceLevel()
	{
		CurrentLevel--;
		if (CurrentLevel < 0)
		{
			CurrentLevel = 0;
		}
		currentLevelData = SpeedLevel[CurrentLevel];
	}

	void DaoChe()
	{

	}

	// Update is called once per frame
	void Update()
	{
		if (currentMoveSpeed >= currentLevelData.TopSpeedKMH && CurrentLevel < SpeedLevel.Length - 1)
		{
			AddLevel();
		}
		if (currentMoveSpeed < currentLevelData.StartSpeedKMH)
		{
			ReduceLevel();
		}
		if (!Check.IsBreak)
		{
			//前进
			if (currentMoveSpeed < currentLevelData.TopSpeedKMH + 1)
			{
				currentMoveSpeed += changeRate * Time.deltaTime;
			}
		}
		else
		{
			//刹车
			if (currentMoveSpeed > -SpeedLevel[0].TopSpeedKMH)
			{
				currentMoveSpeed -= SpeedLevel[0].TopSpeedKMH * Time.deltaTime;
			}
		}
	}
}
