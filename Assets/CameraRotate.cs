using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraRotate : MonoBehaviour
{
	Camera cam;

	void Awake()
	{
		cam = GetComponent<Camera>();
	}

	void Update()
	{
        transform.RotateAround(Vector3.zero, Vector3.up, 1f);
	}
}
