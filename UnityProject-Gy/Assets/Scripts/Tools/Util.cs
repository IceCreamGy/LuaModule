using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;
using UnityEditor;

//一些工具
public static class Util
{
    /// <summary>
    /// 标准化路径
    /// </summary>
    /// <param name="path"></param>
    /// <returns></returns>
    public static string StandardlizePath(string path)
    {
        string pathReplace = path.Replace(@"\", @"/");
        string pathLower = pathReplace.ToLower();
        return pathLower;
    }

    /// <summary>
    /// 拷贝文件夹
    /// </summary>
    /// <param name="srcDir"></param>
    /// <param name="desDir"></param>
    public static void CopyFiles(string srcDir, string desDir)
    {
        if (!Directory.Exists(srcDir)) return;
        if (Directory.Exists(desDir))
        {
            Directory.Delete(desDir, true);
        }
        DirectoryInfo src_dir_info = new DirectoryInfo(srcDir);
        FileInfo[] src_files = src_dir_info.GetFiles("*.*", SearchOption.AllDirectories);
        int sub_index = src_dir_info.FullName.Length;
        float finish = 0;
        int count = src_files.Length;
        foreach (FileInfo info in src_files)
        {
            EditorUtility.DisplayProgressBar("creat streaming assets", "creating...", (++finish) / count);
            string des_file = desDir + info.FullName.Substring(sub_index);
            FileInfo des_file_info = new FileInfo(des_file);
            string des_file_dir = des_file_info.Directory.FullName;
            if (!Directory.Exists(des_file_dir))
            {
                Directory.CreateDirectory(des_file_dir);
            }

            info.CopyTo(des_file, true);
        }
        EditorUtility.ClearProgressBar();
    }

}