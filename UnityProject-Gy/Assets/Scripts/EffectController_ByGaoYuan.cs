using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EffectController_ByGaoYuan : MonoBehaviour
{
    OperationCheck Check;
    public GameObject ShiftAudio;
    public GameObject TaiYin;
    public ParticleSystem TaiYanLeft, TaiYanRight;
    TrailRenderer[] Trails;
    public GameObject FengHen1, FengHen2, FengHen3, SuDuXian;

    CarPhysics_ByGaoYuan Car;
    // Start is called before the first frame update
    void Start()
    {
        Check = OperationCheck.Instance;
        Trails = TaiYin.GetComponentsInChildren<TrailRenderer>(true);
        Car = GetComponent<CarPhysics_ByGaoYuan>();
        Close_TaiYin();
    }

    private void Update()
    {
        Update_TaiYan();
        Update_CheWeiDeng();
        UpdateFengHen();
    }

    public GameObject WeiDeng;
    /// <summary>
    /// 更新车尾灯
    /// </summary>
    void Update_CheWeiDeng()
    {
        if (WeiDeng != null)
        {
            if (Check.IsShift)
            {
                WeiDeng.SetActive(true);
            }
            else
            {
                WeiDeng.SetActive(false);
            }
        }
    }

    /// <summary>
    /// 更新胎烟
    /// </summary>
    void Update_TaiYan()
    {
        if (TaiYanLeft != null)
        {
            if (Check.IsShift)
            {
                TaiYanLeft.Play();
                TaiYanRight.Play();
            }
            else
            {
                TaiYanLeft.Stop();
                TaiYanRight.Stop();
            }
        }
    }

    /// <summary>
    /// 更新风痕
    /// </summary>
    void UpdateFengHen()
    {
        if (124 < Car.CurrentMoveSpeed && Car.CurrentMoveSpeed <= 143)
        {
            if (FengHen1 != null)
            {
                FengHen1.gameObject.SetActive(true);
                FengHen2.gameObject.SetActive(false);
                FengHen3.gameObject.SetActive(false);
                SuDuXian.gameObject.SetActive(false);
            }
        }
        else if (143 < Car.CurrentMoveSpeed && Car.CurrentMoveSpeed <= 160)
        {
            if (FengHen1 != null)
            {
                FengHen1.gameObject.SetActive(true);
                FengHen2.gameObject.SetActive(true);
                FengHen3.gameObject.SetActive(false);
                SuDuXian.gameObject.SetActive(true);
            }
        }
        else if (160 < Car.CurrentMoveSpeed)
        {
            if (FengHen1 != null)
            {
                FengHen1.gameObject.SetActive(true);
                FengHen2.gameObject.SetActive(true);
                FengHen3.gameObject.SetActive(true);
                SuDuXian.gameObject.SetActive(true);
            }
        }
        else
        {
            if (FengHen1 != null)
            {
                FengHen1.gameObject.SetActive(false);
                FengHen2.gameObject.SetActive(false);
                FengHen3.gameObject.SetActive(false);
                SuDuXian.gameObject.SetActive(false);
            }
        }
    }

	//胎印的开关逻辑，在车辆 CarPhysics_ByGaoYuan 中检测
	//打开：进入漂移时
	//关闭：侧倾角度小于4
	public void Open_TaiYin()
    {
        for (int i = 0; i < Trails.Length; i++)
        {
            Trails[i].emitting = true;
        }
        ShiftAudio.SetActive(true);
    }
    public void Close_TaiYin()
    {
        for (int i = 0; i < Trails.Length; i++)
        {
            Trails[i].emitting = false;
        }
        ShiftAudio.SetActive(false);
    }
}
