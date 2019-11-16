using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;
using XLua;

public class UICollectorHelper : MonoBehaviour
{
    public const string BUTTON = "Button";
    public const string TEXT = "Text";
    public const string SLIDER = "Slider";
    public const string UIGROUP = "UIGroup";
    public const string UILIST = "UIList";
    public const string TOGGLE = "Toggle";
    public const string IMAGE = "Image";
    public const string SCROLLRECT = "ScrollRect";
    public const string INPUTFIELD = "InputField";
    public const string IMAGEPRO = "ImagePro";
    public const string MASK = "Mask";
    public const string TOGGLEPRO = "TogglePro";

    private static Dictionary<string, bool> recursion_check_dic = new Dictionary<string, bool>() {
        {BUTTON,true },
        {TEXT,true },
        {SLIDER,true },
        {UIGROUP,true },
        {TOGGLE,true },
        {IMAGE,true },
        {INPUTFIELD,true },
        {IMAGEPRO,true },
        {UILIST,false },
        {MASK,true },
        {SCROLLRECT,true },
        {TOGGLEPRO,false }
    };

    private static Dictionary<string, Type> component_type_dic = new Dictionary<string, Type>()
    {
        {BUTTON,typeof(Button)},
        {TEXT,typeof(Text) },
        {SLIDER,typeof(Slider) },
        {TOGGLE,typeof(Toggle) },
        {IMAGE,typeof(Image) },
        {SCROLLRECT,typeof( ScrollRect) },
        {INPUTFIELD,typeof(InputField) },
        {IMAGEPRO,typeof(ImagePro) },
        {MASK,typeof(Mask) },
        {TOGGLEPRO,typeof(TogglePro) },
    };

    public static bool IsTransNeedRescursion(string prefix)
    {
        if (!recursion_check_dic.ContainsKey(prefix) || recursion_check_dic[prefix])
        {
            return true;
        }
        return false;
    }

    public static MonoBehaviour GetCollectedComponent(string prefix, Transform trans)
    {
        if (component_type_dic.ContainsKey(prefix))
        {
            MonoBehaviour component = trans.GetComponent(component_type_dic[prefix]) as MonoBehaviour;
            return component;
        }
        return null;
    }
}


public class UIComponentCollector : MonoBehaviour
{
    public LuaTable uitable { get; private set; }

    public void Collect()
    {
        uitable = AppFacade.instance.GetLuaManager().CreatLuaTable();
        CollectUIComponent(transform);
    }

    private void OnDestroy()
    {
        uitable.Dispose();
    }

    private void CollectUIComponent(Transform tran)
    {
        uitable.Set<string, RectTransform>("Rt", GetComponent<RectTransform>());

        string transName = tran.name;
        int spit_index = transName.IndexOf('_');
        if (spit_index < 0)
        {
            //不含“_”的节点递归调用导出
            int childCount = tran.childCount;
            for (int i = 0; i < childCount; i++)
            {
                CollectUIComponent(tran.GetChild(i));
            }
        }
        else
        {
            //含“_”字符，且属于定义中的需要导出component的对象，出自身的ui控件对象，存入luatable中
            string prefix = transName.Substring(0, spit_index);
            MonoBehaviour tempComponent = UICollectorHelper.GetCollectedComponent(prefix, tran);
            if (tempComponent != null)
            {
                uitable.Set<string, MonoBehaviour>(transName, tempComponent);
            }

            //如果对象需要递归调用子节点的ui控件，则递归导出
            if (UICollectorHelper.IsTransNeedRescursion(prefix))
            {
                int childCount = tran.childCount;
                for (int i = 0; i < childCount; i++)
                {
                    CollectUIComponent(tran.GetChild(i));
                }
            }
        }
    }
}


