using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using System.IO;
using UnityEngine;
using System;

namespace C_Framework
{

    public partial class ResExporter
    {
        [MenuItem("Export/Windows/Export Lua For Windows")]
        public static void ExportLuaForWindows()
        {
            ExportLua(EditorConst.windows_md5_root);
        }

        [MenuItem("Export/Android/Export Lua For Android")]
        public static void ExportLuaForAndroid()
        {
            ExportLua(EditorConst.andorid_md5_root);
        }

        [MenuItem("Export/IOS/Export Lua For IOS")]
        public static void ExportLuaForIOS()
        {
            ExportLua(EditorConst.ios_md5_root);
        }



        public static void ExportLua(string outpath)
        {
            DirectoryInfo dirInfo = new DirectoryInfo(EditorConst.lua_path_in_editor);
            FileInfo[] lua_files = dirInfo.GetFiles("*.lua", SearchOption.AllDirectories);
            FileInfo[] pb_files = dirInfo.GetFiles("*.pb", SearchOption.AllDirectories);
            List<FileInfo> files = new List<FileInfo>();
            files.AddRange(lua_files);
            files.AddRange(pb_files);
            int count = files.Count;
            float finished = 0;

            foreach (FileInfo file in files)
            {
                int index = file.FullName.IndexOf("LuaCode");
                string copy_file_name = file.FullName.Substring(index);
                string new_file_name = Util.StandardlizePath(Path.Combine(outpath, copy_file_name));
                string dir_name = new_file_name.Substring(0, new_file_name.LastIndexOf('/'));
                if (Directory.Exists(dir_name) == false)
                {
                    Directory.CreateDirectory(dir_name);
                }

                byte[] src_bytes = File.ReadAllBytes(file.FullName);

                File.WriteAllBytes(new_file_name, src_bytes);

                finished++;
                EditorUtility.DisplayProgressBar("convert...", string.Format("{0}/{1}", finished, count), finished / count);
            }
            EditorUtility.ClearProgressBar();
        }
    }

}