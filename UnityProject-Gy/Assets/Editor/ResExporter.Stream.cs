using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using System.IO;

public partial class ResExporter
{
    [MenuItem("Export/Windows/Export Streaming For Windows")]
    public static void ExportStreamForWindows()
    {
        ExportStream(EditorConst.windows_md5_root, EditorConst.streaming_path);
    }

    [MenuItem("Export/Android/Export Streaming For Android")]
    public static void ExportStreamForAndroid()
    {
        ExportStream(EditorConst.andorid_md5_root, EditorConst.streaming_path);
    }

    [MenuItem("Export/IOS/Export Streaming For IOS")]
    public static void ExportStreamForIOS()
    {
        ExportStream(EditorConst.ios_md5_root, EditorConst.streaming_path);
    }

    public static void ExportStream(string srcPath, string desPath)
    {
        Util.CopyFiles(srcPath, desPath);
        AssetDatabase.Refresh();
    }
}