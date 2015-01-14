using UnityEngine;
using System.Collections;

public class loadText2d : MonoBehaviour {
	private Texture2D txt;
	Texture2D[] array;
	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	
	}

	void OnGUI()
	{
		// 加载贴图
		if (GUI.Button(new Rect(10, 50, 90, 90), "加载一张图片"))
		{
			txt = Resources.Load<Texture2D>("Icons/avatar_icon1");
		}
		if (GUI.Button(new Rect(10, 150, 90,90), "加载所有图片"))
		{
			array = Resources.LoadAll<Texture2D>("Icons");
		}
		// 绘制贴图
		if (null != txt)
		{
			GUI.DrawTexture(new Rect(150, 50, 90, 90), txt);
		}
		if (null != array)
		{
			for (int i = 0; i < array.Length; i++)
			{
				GUI.DrawTexture(new Rect(150 + i * 95, 150, 90, 90), array[i], ScaleMode.ScaleToFit, true, 0);
			}
		}
	}
}
