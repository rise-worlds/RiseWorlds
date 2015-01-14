using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

namespace Assets.Scripts
{
	public class modelMove : MonoBehaviour
	{
		public float speed = 2;
		void Start()
		{

		}
		void Update()
		{
			Vector3 oldPostion = transform.position;
			if (Input.GetKey(KeyCode.W))
			{
				transform.Translate(Vector3.forward * Time.deltaTime * speed, Space.World);
				animation.Play("run");
			}
			if (Input.GetKey(KeyCode.S))
			{
				transform.Translate(Vector3.back * Time.deltaTime * speed, Space.World);
				animation.Play("run");
			}
			if (Input.GetKey(KeyCode.A))
			{
				transform.Translate(Vector3.left * Time.deltaTime * speed, Space.World);
				animation.Play("run");
			}
			if (Input.GetKey(KeyCode.D))
			{
				transform.Translate(Vector3.right * Time.deltaTime * speed, Space.World);
				animation.Play("run");
			}
			transform.LookAt(transform.position + transform.position - oldPostion);
		}
	}
}
