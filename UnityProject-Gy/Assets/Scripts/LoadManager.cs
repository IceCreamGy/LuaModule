using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using XLua;
using UnityEngine.SceneManagement;

public class LoadManager : BaseManager
{
    //加载UI
    public void LoadUI(string bundleName, Action<GameObject, LuaTable, CanvasGroup> callback, Transform parent)
    {
        GameObject panel = Resources.Load<GameObject>(bundleName);
        panel = GameObject.Instantiate(panel);

        UIComponentCollector uIComponentCollector = panel.GetOrAddComponent<UIComponentCollector>();
        uIComponentCollector.Collect();
        CanvasGroup canvasGroup = panel.GetOrAddComponent<CanvasGroup>();
        canvasGroup.alpha = 1;
        canvasGroup.interactable = true;
        canvasGroup.blocksRaycasts = true;

        RectTransform rectTransform = panel.transform as RectTransform;

        if (parent == null)
        {
            panel.transform.SetParent(Canvas);
            rectTransform.anchorMin = Vector2.zero;
            rectTransform.anchorMax = Vector2.one;
            rectTransform.offsetMax = Vector2.zero;
            rectTransform.offsetMin = Vector2.zero;
        }
        else
        {
            panel.transform.SetParent(parent);
        }

        rectTransform.anchoredPosition3D = new Vector3(rectTransform.anchoredPosition3D.x, rectTransform.anchoredPosition3D.y, 0);
        rectTransform.localScale = Vector3.one;
        rectTransform.localEulerAngles = Vector3.zero;

        callback(panel, uIComponentCollector.uitable, canvasGroup);
    }
    //加载UI
    public void LoadUI(string bundleName, Action<GameObject, LuaTable, CanvasGroup> callback, GameObject parent)
    {
        LoadUI(bundleName, callback, parent.transform);
    }

    //加载Texture
    public void LoadTexture(string path, Action<Texture> callback)
    {
        callback(Resources.Load<Texture>(path));
    }
    //加载Sprite
    public void LoadSprite(string path, Action<Sprite> callback)
    {
        callback(Resources.Load<Sprite>(path));
    }
    //加载GameObject
    public GameObject LoadGameObject(string path)
    {
        return Resources.Load<GameObject>(path);
    }
    //复制GameObject
    public GameObject CopyGameobject(GameObject go)
    {
        return GameObject.Instantiate(go);
    }
    //复制UI，并设置父物体
    public void CopyUI_WithParent(GameObject go, Transform parent, Action<GameObject, LuaTable> callback)
    {
        GameObject tempGO = GameObject.Instantiate(go);
        tempGO.transform.SetParent(parent);
        tempGO.transform.localPosition = new Vector3(tempGO.transform.localPosition.x, tempGO.transform.localPosition.y, 0);
        tempGO.transform.localScale = Vector3.one;
        tempGO.transform.localEulerAngles = Vector3.zero;

        //未来可以加一些预处理
        UIComponentCollector uIComponentCollector = tempGO.GetOrAddComponent<UIComponentCollector>();
        uIComponentCollector.Collect();

        callback(tempGO, uIComponentCollector.uitable);
        //给Grid组件下面实例化子物体，位置由Layout模块自动处理
    }

    public void LoadScene(string sceneName, Action endCallback)
    {
        StartCoroutine(LoadSA(sceneName, endCallback));
    }
    IEnumerator LoadSA(string sceneName, Action myCallback)
    {
        AsyncOperation ao = SceneManager.LoadSceneAsync(sceneName);
        ao.allowSceneActivation = false;
        float time = 0;
        while (ao.isDone == false)
        {
            time += 0.2f;
            if (time > 2.2f)    //仅仅是为了动画播放完
            {
                ao.allowSceneActivation = true;
            }
            yield return new WaitForSeconds(0.2f);
        }

        myCallback();
    }
}
