using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using UnityEngine.UI;

public class RotateEuler : MonoBehaviour
{
    public int planeId = 0;
    public bool movementEnabled = true;
    public bool FrameSnapshotEnabled = true;
    public float minY = 0;
    public float maxY = 0;
    public float fxHeight = 0;
    public float minLineWidth = 10000;
    public float maxLineWidth = 0;  

    public int textureWidth = 158;
    public int textureHeight = 32;
    public int zQuantization = 8;
    public int ExpectedMaxZ =0;
    public float ProjectionMagnitude = 1.0f;
    public int canvasHeight = 128;
    public int rotationSteps = 16;
    public float[] rotationAngles;
    public int rotationPt = 0;

    public int rotationRange = 360;
    
    public GameObject target;
    public Vector3 initialPosition;
    public Quaternion initialRotation;
    public List<Vector3>[] framesPositions;
    public List<Dictionary<int, Vector3>> framesLines;
    
    public GameObject fileWriter;
    public bool writeEnabled = true;
    public bool[] loggedFrames;
    //  public int nonContiguousFrames = 0;
    public bool[] contiguousFramesCheckList;
    public GameObject sceneController;
    public GameObject Projector;

    public string textureLineSpritesName;
    public Sprite[] textureLinesSprites;

    public List<Dictionary<int, Vector3>> C64Frames;

    public List<string> linesAtDifferentSize; //which lines needs to be plotted for each Z


    void Start(){

        //Init texture multiline
        textureLinesSprites = new Sprite[textureHeight];
        textureLinesSprites = Resources.LoadAll<Sprite>(textureLineSpritesName);

        //
        target.transform.GetComponent<SpriteRenderer>().enabled = false;
        float angleStep = (float)rotationRange / rotationSteps;
        float a = 0.0f;        
        rotationAngles = new float[rotationSteps];
        for (int x=0;x<rotationSteps;x++){
            rotationAngles[x] = a;
            a+=angleStep;
        }
        StartCoroutine(onCoroutine());
        initialPosition = transform.position;
        initialRotation = transform.rotation;
        loggedFrames = new bool[rotationSteps];
        framesPositions = new List<Vector3>[rotationSteps];

        framesLines = new List<Dictionary<int, Vector3>>();
        contiguousFramesCheckList = new bool[rotationSteps];

        linesAtDifferentSize = new List<string>();

        for (int x = 0; x < rotationSteps; x++)
        {
            framesLines.Add(new Dictionary<int, Vector3>());
            contiguousFramesCheckList[x] = true;
           // linesAtDifferentSize[x] = (new List<int>());
        }
    }

    void SnapshotFrame(){
        Transform line;
        List<Vector3> linePositions = new List<Vector3>();

        for (int x=0;x< textureHeight; x++){
           // line = this.gameObject.transform.GetChild(x);
            line = GameObject.Find("line"+transform.name+x).transform;
            Vector3 worldPosition = line.position; //transform.TransformPoint(line.position);
            linePositions.Add(worldPosition);
        }

        framesPositions[rotationPt] = linePositions;
       
        framesLines[rotationPt] = GetFrameLines(rotationPt);

        loggedFrames[rotationPt] = true;
        bool loggedAllFrames = true; 
        for(int x = 0; x < loggedFrames.Length; x++)
        {
            loggedAllFrames &= loggedFrames[x];
        }

       // Debug.Log("Logged frame" +rotationPt+ " "+ loggedAllFrames);

        if (loggedAllFrames && writeEnabled && sceneController.transform.GetComponent<SceneController>().StartC64Fx)
        {
           // Debug.Log("Writing file...");
          //  GetStats(framesLines, rotationSteps);

          //  fileWriter.transform.GetComponent<FileWriter>().LogToFile(framesLines, linesAtDifferentSize, rotationSteps);
            writeEnabled = false;
            C64Frames = framesLines;
            GameObject.Find("SceneController").transform.GetComponent<SceneController>().C64DataReady[planeId] = true;
            /*
            string txt = "Nr. lines: "+ linesAtDifferentSize .Count+ "\n";
            txt += "Texture: " + textureWidth + "x"+textureHeight+" Max width: "+ maxLineWidth + " min width: "+minLineWidth+"\n";
            txt+= "Frame height: "+Mathf.Ceil(fxHeight) + "\n";
            txt += "Z Quantization: " + zQuantization + "\n";
            txt += "Projection magnitude: " + ProjectionMagnitude + "\n";

            bool contiguousCheck = true;
            for(int x = 0; x < rotationSteps; x++)
            {
                contiguousCheck &= contiguousFramesCheckList[x];
            }
            if (!contiguousCheck)
            {
                txt += "Non continuous frames detected!" + "\n";
            }
            else
            {
                txt += "All frames are contiguous " + "\n";
            }
            
            GameObject.Find("Text").transform.GetComponent<Text>().text = txt;
            */

            transform.GetComponent<SpriteRenderer>().enabled = false;
           
        }
    }

    void Update()
    {
        transform.position = initialPosition;
        transform.rotation = initialRotation;

         transform.RotateAround(target.transform.position, -Vector3.right, rotationAngles[rotationPt]);
        //transform.Rotate( new Vector3(20.0f, 0, 0));

        for(var x=0;x<textureHeight;x++){
            GameObject line = GameObject.Find("line"+transform.name+x);
            line.transform.GetComponent<RotateEulerChild>().UpdatePosition(rotationAngles[rotationPt]);
        }

        if (FrameSnapshotEnabled) { 
            SnapshotFrame();
        }
    }

    IEnumerator onCoroutine()
    {
        while(true){
            //  Debug.Log ("OnCoroutine: "+Time.time);
        if (movementEnabled) { 
            rotationPt = rotationPt+1;
        }

        if (rotationPt == rotationSteps){
            rotationPt = 0;
        }
        float time =  (float)GameObject.Find("SceneController").transform.GetComponent<SceneController>().frameRate;

         yield return new WaitForSeconds(1.0f/time);

        }
     }

    //returns a list of the lines that must be drawn for the frame
    public Dictionary<int, Vector3> GetFrameLines(int frameIndex)
    {
        List<Vector3> frameLinesPositions = framesPositions[frameIndex];
        Dictionary<int, List<int>> yPositions = new Dictionary<int, List<int>>();
        Dictionary<int, Vector3> frameLines = new Dictionary<int, Vector3>();

        List<int> addedLines = new List<int>();
     
        //Detect which lines are displayed - in case of multiple lines at the same Y, the one with the higher Z wins
        //populate the list of the lines based on Y 
        for (int y = 0; y < frameLinesPositions.Count; y++)
        {
            Vector3 pos = frameLinesPositions[y];

            int yPos = Mathf.RoundToInt(pos.y);

           // Debug.Log("Line " + y + " got " + pos.y + " " + yPos);

            if (!yPositions.ContainsKey(yPos))
            {
                yPositions[yPos] = new List<int>();
            }
            yPositions[yPos].Add(y); //add the "row id"  for that position
          
        }

        foreach (KeyValuePair<int, List<int>> dictionaryItem in yPositions.OrderBy(i => i.Key))
        {
            List<int> linesOnSameY = dictionaryItem.Value;
            int y = dictionaryItem.Key;
            int frontLine = linesOnSameY[0];
            GameObject frontLineObject = GameObject.Find("line"+transform.name + frontLine);
            //Vector3 frontLineObjectWorldPosition = transform.TransformPoint(frontLineObject.transform.position);
            Vector3 frontLineObjectWorldPosition = frontLineObject.transform.position;

            //check if there's another line on the same y with higher Z
            for (int x=0; x < linesOnSameY.Count; x++)
            {
                int lineId = linesOnSameY[x];
                //Debug.Log("Searching for line" + lineId);
                GameObject lineObject = GameObject.Find("line" + transform.name + lineId);
                //Vector3 worldPosition = transform.TransformPoint(lineObject.transform.position);
                Vector3 worldPosition = lineObject.transform.position;
                if (worldPosition.z >= frontLineObjectWorldPosition.z)
                {
                    frontLine = lineId;
                }
            }
            //finally assign the frontline for the current y
            // Debug.Log("Iterating " + dictionaryItem.Key + " " + dictionaryItem.Value + "y: "+y+" Frontline " + frontLine);
            frontLineObject = GameObject.Find("line" + transform.name + frontLine);
            //frontLineObjectWorldPosition = transform.TransformPoint(frontLineObject.transform.position);
            frontLineObjectWorldPosition = frontLineObject.transform.position;

            //Create a vector 3 with x as line id (since x will not be used) and z as line width
            //float roundedZ = QuantizeNumber(frontLineObjectWorldPosition.z, zQuantization);
            // float roundedZ = frontLineObjectWorldPosition.z;
           
           // Vector3 projectedPos = Projector.transform.GetComponent<Projection>().GetProjectedVector(frontLineObjectWorldPosition, ProjectionMagnitude, zQuantization, textureWidth);
            Vector3 projectedPos = frontLineObjectWorldPosition;

            projectedPos.x = textureWidth+Projector.transform.GetComponent<Projection>().Remap(
                projectedPos.z, //value
                zQuantization, //quantize value
                -ExpectedMaxZ, //from 
                ExpectedMaxZ, //to 
                -ProjectionMagnitude/2, 
                ProjectionMagnitude/2
            );

        
            Vector3 v = new Vector3(
                frontLine,
                frontLineObjectWorldPosition.y,
                projectedPos.x
                );

            addedLines.Add(frontLine);
            frameLines[y] = v;
        }
        return frameLines;
    }
    /*
    int QuantizeNumber(float value, int quantizeValue)
    {
        return Mathf.RoundToInt(value / quantizeValue) * quantizeValue;
    }
    */

        /*
    public void GetStats(List<Dictionary<int, Vector3>> framesLines, int rotationSteps)
    {
        Debug.Log("Calculating stats..");

        //List<string> lineVectors = new List<string>();
        List<int> widthValues = new List<int>();

        for (var x = 0; x < rotationSteps; x++)
        {
            int previousY=0;
            int ofs = 0;

            Dictionary<int, Vector3> frameLines = framesLines[x];
            foreach (KeyValuePair<int, Vector3> dictionaryItem in frameLines)
            {  
                //get min/max z and min/max y
                Vector3 frameLine = dictionaryItem.Value;
                int lineId = Mathf.RoundToInt(frameLine.x);
                int lineWidth = Mathf.RoundToInt(frameLine.z);
                int lineY = Mathf.RoundToInt(frameLine.y);
                
                string lineSerialized = lineId + "_" + lineWidth;

                if (frameLine.y > sceneController.transform.GetComponent<SceneController>().maxY)
                {
                    sceneController.transform.GetComponent<SceneController>().maxY = lineY; 
                }

                if (frameLine.y < sceneController.transform.GetComponent<SceneController>().minY)
                {
                    sceneController.transform.GetComponent<SceneController>().minY = lineY;
                }

                if (frameLine.z < sceneController.transform.GetComponent<SceneController>().minLineWidth)
                {
                    sceneController.transform.GetComponent<SceneController>().minLineWidth = lineWidth;
                }

                if (frameLine.z > sceneController.transform.GetComponent<SceneController>().maxLineWidth)
                {
                    sceneController.transform.GetComponent<SceneController>().maxLineWidth = lineWidth;
                }

                //populate a list of unique z values
                if (!widthValues.Contains(lineWidth))
                {
                    widthValues.Add(lineWidth);
                }

                //check frame for contiguity errors
                if(lineY != previousY+1 && ofs!=0){
                    //nonContiguousFrames++;
                    contiguousFramesCheckList[x] = true;
                }
                previousY = lineY;

                //Populate the "zoom/shrink" map
                if (!linesAtDifferentSize.Contains(lineSerialized))
                {
                    linesAtDifferentSize.Add(lineSerialized);
                }
                ofs++;
            }
        }
        fxHeight = maxY - minY;
    }
    */

    
}

