using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class SceneController : MonoBehaviour
{
    string TargetScene;
    void Start()
    {
        if (SceneManager.GetActiveScene().name == "MainScene")
        {
            TargetScene = "Scene_TryRotate";
        }
        else
        {
            TargetScene = "MainScene";
        }
        transform.Find("Button-ChangeScene").GetComponent<Button>().onClick.AddListener(OnClick_ChangeSceneButton);
    }

    void OnClick_ChangeSceneButton()
    {
        SceneManager.LoadScene(TargetScene);
    }
}
