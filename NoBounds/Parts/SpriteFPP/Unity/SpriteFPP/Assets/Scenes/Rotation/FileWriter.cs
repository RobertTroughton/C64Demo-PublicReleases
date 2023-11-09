using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;

public class FileWriter : MonoBehaviour
{
    string path = "Assets/output.txt";


    public void LogToFile(List<Dictionary<int, Vector3>> framesLines, List<string> linesAtDifferentSize, int rotationSteps)
    {
        /***
        string line = "";

        File.Delete(path);
        Debug.Log("Writing..");

        line = "//Frames table";
        File.AppendAllText(path, line + "\n");

        line = "//y,lineId,width";
        File.AppendAllText(path, line + "\n");

        line = ".var FramesList = List()";
        File.AppendAllText(path, line + "\n");

        line = ".var FrameList = List()";
        File.AppendAllText(path, line + "\n");

        for (var x = 0; x < rotationSteps; x++)
        {
            line = "//Frame " + x;
            File.AppendAllText(path, line + "\n");

            line = ".eval FrameList = List()";
            File.AppendAllText(path, line + "\n");
            Dictionary<int, Vector3> frameLines = framesLines[x];

            foreach (KeyValuePair<int, Vector3> dictionaryItem in frameLines)
            {
                Vector3 frameLine = dictionaryItem.Value;

                //line = "pos y: " + dictionaryItem.Key + " id:" + frameLine.x + " width:" +frameLine.z;
                // line = "pos y: " + dictionaryItem.Key + " id:" + frameLine.x + " width:" + frameLine.z;
                line =  ".eval FrameList.add(" + dictionaryItem.Key + "," + frameLine.x + "," + frameLine.z + ")";
                File.AppendAllText(path, line + "\n");
            }
            line += "\n.eval FramesList.add(FrameList)\n";
            File.AppendAllText(path, line + "\n");
        }

        line = "\n\n//Zoom map";
        File.AppendAllText(path, line + "\n");
        for (var x = 0; x < linesAtDifferentSize.Count; x++)
        {
            string lineInfo = linesAtDifferentSize[x];
            File.AppendAllText(path, lineInfo + "\n");
        }

*/
        }
}
// Write to file

    
