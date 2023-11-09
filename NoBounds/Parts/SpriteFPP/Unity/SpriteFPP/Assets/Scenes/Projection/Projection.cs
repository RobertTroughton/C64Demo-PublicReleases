using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Projection : MonoBehaviour
{
    public Vector3 planeOrigin;
    public Vector3 planeNormal;
    public GameObject original;
    public GameObject projected;


    // Update is called once per frame
    void Update()
    {
        if(original && projected) { 
            Vector3 projected_pos = Vector3.Project(original.transform.position, planeNormal.normalized);

            Debug.Log(planeNormal.normalized);

            Vector3 final = new Vector3(-projected_pos.x, 0, 0);
            projected.transform.position = final;
        }
    }

    public Vector3 GetProjectedVector(Vector3 originaPos, float ProjectionMagnitude, int quantizeValue, int textureWidth)
    {
        Vector3 projected_pos = Vector3.Project(originaPos, planeNormal.normalized);
        Vector3 final = new Vector3(-QuantizeNumber(projected_pos.x* ProjectionMagnitude, quantizeValue)+textureWidth, 0, 0);
        return final;
    }

    int QuantizeNumber(float value, int quantizeValue)
    {
        return Mathf.RoundToInt(value / quantizeValue) * quantizeValue;
    }

    public int Remap (float value, int quantizeValue, float from1, float to1, float from2, float to2) {
        
        float res = (value - from1) / (to1 - from1) * (to2 - from2) + from2;

        return QuantizeNumber(res, quantizeValue);
    
    }

}
