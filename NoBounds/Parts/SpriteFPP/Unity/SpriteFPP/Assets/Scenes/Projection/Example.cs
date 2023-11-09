using System.Collections;
using System.Collections.Generic;
using UnityEngine;

// Vector3.ProjectOnPlane - example

// Generate a random plane in xy. Show the position of a random
// vector and a connection to the plane. The example shows nothing
// in the Game view but uses Update(). The script reference example
// uses Gizmos to show the positions and axes in the Scene.

public class Example : MonoBehaviour
{
    public Vector3 vector, planeNormal;
    public Vector3 response;
    private float radians;
    public float degrees;
    private float timer = 12345.0f;

    // Generate the values for all the examples.
    // Change the example every two seconds.
    void Update()
    {
        if (timer > 0.5f)
        {
            // Generate a position inside xy space.
           // vector = new Vector3(Random.Range(-1.0f, 1.0f), Random.Range(-1.0f, 1.0f), 0.0f);

            // Compute a normal from the plane through the origin.
           // degrees = Random.Range(-45.0f, 45.0f);
            radians = degrees * Mathf.Deg2Rad;
            planeNormal = new Vector3(Mathf.Cos(radians), Mathf.Sin(radians), 0.0f);

            // Obtain the ProjectOnPlane result.
            response = Vector3.ProjectOnPlane(vector, planeNormal);

            // Reset the timer.
            timer = 0.0f;
        }
        timer += Time.deltaTime;
    }

    // Show a Scene view example.
    void OnDrawGizmosSelected()
    {
        // Left/right and up/down axes.
        Gizmos.color = Color.white;
        Gizmos.DrawLine(transform.position - new Vector3(2.25f, 0, 0), transform.position + new Vector3(2.25f, 0, 0));
        Gizmos.DrawLine(transform.position - new Vector3(0, 1.75f, 0), transform.position + new Vector3(0, 1.75f, 0));

        // Display the plane.
        Gizmos.color = Color.green;
        Vector3 angle = new Vector3(-1.75f * Mathf.Sin(radians), 1.75f * Mathf.Cos(radians), 0.0f);
        Gizmos.DrawLine(transform.position - angle, transform.position + angle);

        // Show a connection between vector and response.
        Gizmos.color = Color.yellow;
        Gizmos.DrawLine(vector, response);

        // Now show the input position.
        Gizmos.color = Color.red;
        Gizmos.DrawSphere(vector, 0.05f);

        // And finally the resulting position.
        Gizmos.color = Color.black;
        
        Gizmos.DrawSphere(response, 0.05f);
        GameObject.Find("test").transform.position = response;
    }
}