using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotateEulerChild : MonoBehaviour
{
    public Vector3 initialPosition;
    public Quaternion initialRotation;
    public GameObject target;

    public string targetName = null;
 
    void Start(){
        initialPosition = transform.position;
        initialRotation = transform.rotation;
       // target = GameObject.Find(targetName);
    }

    public void UpdatePosition(float angle){
        transform.position = initialPosition;
        transform.rotation = initialRotation;
        target = GameObject.Find(targetName);
        transform.RotateAround(target.transform.position, Vector3.right, angle);
    }
}
