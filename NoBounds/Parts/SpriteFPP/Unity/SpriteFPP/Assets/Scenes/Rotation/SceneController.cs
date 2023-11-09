using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using System.IO;

public class SceneController : MonoBehaviour
{
    public GameObject linePrefab;
    public GameObject C64linePrefab;
    public GameObject C64lineHeadachePrefab;
    
    public List<GameObject> rotatingObjects = new List<GameObject>();
    public int frameRate = 20;
    public bool StartC64Fx = true;
    public GameObject Projector;
    public List<int> c64RotationPointers = new List<int>();
    public List<bool> C64DataReady = new List<bool>();
    public List<int> rotationSteps = new List<int>();
    public bool movementEnabled = true;
    public List<int> textureHeight = new List<int>();

    public float minY = 0;
    public float maxY = 0;
    public float fxHeight = 0;
    public float minLineWidth = 10000;
    public float maxLineWidth = 0;
    
    public bool PruningEnabled = false;

    public bool statsGenerated = false;

    public List<string> palette = new List<string>();
    public int paletteSize = 0;
    public int framesAnimBytes = 0;
    //public List<int> C64FramesMap = new List<int>();

    public List<string> FaceNames = new List<string>();
    public List<int> FaceHeights = new List<int>();
    public Sprite[] textureLinesSprites;
    public List<int> angleMapping = new List<int>();
    public int headacheFxHeight = 64;
    
    public List<GameObject> C64HeadacheLines = new List<GameObject>();

    void Start()
    {
        int rotatingObjectId = 0;
        foreach (GameObject rotatingObject in rotatingObjects)
        {
            rotationSteps[rotatingObjectId] = rotatingObjects[rotatingObjectId].transform.GetComponent<RotateEuler>().rotationSteps;
            //textureLinesSprites = Resources.LoadAll<Sprite>("gradient_32_multiline");
            textureHeight[rotatingObjectId] = rotatingObjects[rotatingObjectId].transform.GetComponent<RotateEuler>().textureHeight;

            rotatingObjectId++;
        }
        
        rotatingObjectId = 0;
        foreach (GameObject rotatingObject in rotatingObjects)
        {
            for (int x = 0; x < textureHeight[rotatingObjectId]; x++)
            {
                GameObject line = Instantiate(linePrefab, new Vector3(0, 0, 0), Quaternion.identity);
                // line.transform.parent = container.transform;
                line.transform.GetComponent<RotateEulerChild>().targetName = "rotationTarget"+rotatingObject.name;
                line.transform.position = new Vector3(0, rotatingObject.transform.position.y + rotatingObject.transform.GetComponent<RotateEuler>().textureHeight / 2 - x, 0);
                line.name = "line"+rotatingObject.name + x;

                GameObject c64line = Instantiate(C64linePrefab, new Vector3(0, 0, 0), Quaternion.identity);
                c64line.transform.GetComponent<RotateEulerChild>().targetName = "rotationTarget"+rotatingObject.name;
                c64line.transform.position = new Vector3(0, rotatingObject.transform.position.y + rotatingObject.transform.GetComponent<RotateEuler>().textureHeight / 2 - x, 0);
                c64line.name = "c64line"+rotatingObject.name + x;
                
                //c64line.transform.GetComponent<SpriteRenderer>().sprite = rotatingObject.transform.GetComponent<RotateEuler>().textureLinesSprites[x];
            }
            rotatingObjectId++;
        }

        //load faces lines sprites
        textureLinesSprites = new Sprite[80];
        int texturePt = 0;
        foreach(string faceName in FaceNames){
            Sprite[] spriteLines = Resources.LoadAll<Sprite>(faceName);

            foreach(Sprite spriteLine in spriteLines){
                textureLinesSprites[texturePt] = spriteLine;
                texturePt++;
            }
        }

        //adjust the frames index in order to have 0= topmost rotation  
        int middleRotation = GameObject.Find("CentralTexture").transform.GetComponent<RotateEuler>().rotationSteps/2;

      
        for(var x=0;x<middleRotation;x++){
            angleMapping.Add(middleRotation+x);
        }
        for(var x=0;x<middleRotation;x++){
            angleMapping.Add(middleRotation-x);
        }

        //instantiate all the headache lines
        for(var x=0;x<headacheFxHeight;x++){
            GameObject c64lineHeadache = Instantiate(C64lineHeadachePrefab, new Vector3(0, 0, 0), Quaternion.identity);
            c64lineHeadache.transform.position = new Vector3(0,-x+headacheFxHeight/2,0);
            c64lineHeadache.name = "c64lineHeadache"+ x;
            C64HeadacheLines.Add(c64lineHeadache);
        }
        StartCoroutine(onCoroutine());
    }

    void Update()
    {

        int rotatingObjectId = 0;
        bool allFramesReady = true;

    
        //headache rotator
        foreach (GameObject rotatingObject in rotatingObjects)
        {
            if (C64DataReady[rotatingObjectId] )
            {
                HeadacheRotator();
            }else{
                allFramesReady = false;
            }
            
            rotatingObjectId++;
        }
        
        /**
        
        //plain rotation on x
        foreach (GameObject rotatingObject in rotatingObjects)
        {
           // Debug.Log("BOCCIO " + rotatingObject);
            
            if (C64DataReady[rotatingObjectId] )
            {
              
                MoveC64Object(rotatingObject, rotatingObjectId);
            }else{
                allFramesReady = false;
            }
            
            rotatingObjectId++;
        }
        */
        

        if(allFramesReady && !statsGenerated){
            GetStats();
            DumpFrameData();
        }
    }

    public int headacheRotatorPt = 0;
    public int lookUpPtr = 0;
    public int basePtr = 0;
    public int currentFacePtr = 0;
    public int baseFacePtr = 0;

    private void HeadacheRotator(){
        Debug.Log("HEADACHE!");

        int rasterLines = 0;
        lookUpPtr = basePtr;
        currentFacePtr = baseFacePtr;

        while(rasterLines < headacheFxHeight){
            GameObject rasterline = GameObject.Find("c64lineHeadache"+rasterLines);
            rasterline.transform.GetComponent<SpriteRenderer>().sprite = textureLinesSprites[lookUpPtr];

            lookUpPtr++;

            if(lookUpPtr>=FaceHeights[currentFacePtr]){
                lookUpPtr = 0;
                currentFacePtr++;

                Debug.Log("Finished Face " + currentFacePtr);

                currentFacePtr = currentFacePtr % 3;
            }

            rasterLines++;
        }

        /*
        for(var rasterLine=0;rasterLine<headacheFxHeight;rasterLine++){

        }*/
    }

    //Rotation on X c64 version
    private void MoveC64Object(GameObject rotatingObject, int rotatingObjectId)
    {
        //Debug.Log("CALCOLO " + rotatingObjectId);

        Dictionary<int, Vector3> frameLines = rotatingObjects[rotatingObjectId].transform.GetComponent<RotateEuler>().C64Frames[c64RotationPointers[rotatingObjectId]];
        //int textureHeight = rotatingObjects[0].transform.GetComponent<RotateEuler>().textureHeight;
        int textureWidth = rotatingObjects[rotatingObjectId].transform.GetComponent<RotateEuler>().textureWidth;

        for (int x = 0; x < textureHeight[rotatingObjectId]; x++)
        {
            string id = "c64line" + rotatingObject.name + x;
            GameObject.Find(id).transform.position = new Vector3(500, 0, 0);
            GameObject.Find(id).GetComponent<SpriteRenderer>().enabled = true;
        }

        int lineId = 0;

        foreach (KeyValuePair<int, Vector3> dictionaryItem in frameLines)
        {
            Vector3 frameLine = dictionaryItem.Value;
            //  string id = "c64line"+frameLine.x;
            string id = "c64line" + rotatingObject.name + lineId;

            float c64LineWidth = frameLine.z;
            float y = dictionaryItem.Key;

            Vector3 position = new Vector3(0, y, 0);

            GameObject c64LineObject = GameObject.Find(id);
            c64LineObject.transform.position = position;
            c64LineObject.transform.GetComponent<SpriteRenderer>().sprite = rotatingObject.transform.GetComponent<RotateEuler>().textureLinesSprites[Mathf.RoundToInt(frameLine.x)%32];

            c64LineObject.transform.localScale = new Vector3(c64LineWidth, 1, 1);
            lineId++;
        }
    }

    IEnumerator onCoroutine()
    {
        while (true)
        {
            int rotatingObjectId = 0;
            foreach (GameObject rotatingObject in rotatingObjects)
            {
                if (movementEnabled && C64DataReady[rotatingObjectId])
                {
                    c64RotationPointers[rotatingObjectId] = c64RotationPointers[rotatingObjectId] + 1;
                }

                if (c64RotationPointers[rotatingObjectId] == rotationSteps[rotatingObjectId])
                {
                    c64RotationPointers[rotatingObjectId] = 0;
                }

                rotatingObjectId++;
            }
                //  Debug.Log ("OnCoroutine: "+Time.time);
           
            yield return new WaitForSeconds(1.0f / frameRate);
        }
    }

    private void GetStats(){
        int rotatingObjectId = 0;
        foreach (GameObject rotatingObject in rotatingObjects)
        {
            List<Dictionary<int, Vector3>> C64Frames = rotatingObjects[rotatingObjectId].transform.GetComponent<RotateEuler>().C64Frames;
            List<int> widthValues = new List<int>();

            for (var x = 0; x < rotatingObject.transform.GetComponent<RotateEuler>().rotationSteps; x++)
            {            
                int previousY=0;
                int ofs = 0;

                Dictionary<int, Vector3> frameLines = C64Frames[x];
                foreach (KeyValuePair<int, Vector3> dictionaryItem in frameLines)
                {  
                    //get min/max z and min/max y
                    Vector3 frameLine = dictionaryItem.Value;
                    int lineId = Mathf.RoundToInt(frameLine.x);
                    int lineWidth = Mathf.RoundToInt(frameLine.z);
                    int lineY = Mathf.RoundToInt(frameLine.y);
                    
                    string lineSerialized = lineId + "_" + lineWidth;

                    if (frameLine.y > maxY)
                    {
                        maxY = lineY; 
                    }

                    if (frameLine.y < minY)
                    {
                       minY = lineY;
                    }

                    if (frameLine.z < minLineWidth)
                    {
                        minLineWidth = lineWidth;
                    }

                    if (frameLine.z > maxLineWidth)
                    {
                        maxLineWidth = lineWidth;
                    }
                }
//rimetti qua
            }
            
            rotatingObjectId++;
        }
        statsGenerated = true;

        fxHeight =Mathf.Ceil(maxY-minY);
        string txt = "";
      //  string txt = "Nr. lines: "+ linesAtDifferentSize .Count+ "\n";
        txt += "Max width: "+ maxLineWidth + " min width: "+minLineWidth+"\n";
        txt+= "Frame height: "+fxHeight + "\n";

     //   txt += "Z Quantization: " + zQuantization + "\n";
      //  txt += "Projection magnitude: " + ProjectionMagnitude + "\n";

        GameObject.Find("Text").transform.GetComponent<Text>().text = txt;

    }

    private int GetOrCreateInPalette(int lineId, int lineWidth){
        string key = lineId+"_"+lineWidth;
        if(!palette.Contains(key)){
            palette.Add(key);
        }
        return palette.IndexOf(key);  
    }
    private void DumpFrameData(){
        int rotatingObjectId = 0;

        string path_palette = "Assets/palette.asm";
        string path_framelist = "Assets/frames_list.asm";
        
        File.Delete(path_palette);
        File.Delete(path_framelist);
        
        Debug.Log("Writing..");

        //Frames list variables
        string txtLine = ".var LineIndexList = List() ";
        File.AppendAllText(path_framelist, txtLine + "\n");
        txtLine = ".var LineYList = List() ";
        File.AppendAllText(path_framelist, txtLine + "\n");

        txtLine = ".var FramesIndexList = List() ";
        File.AppendAllText(path_framelist, txtLine + "\n");

        txtLine = ".var FramesYList = List() ";
        File.AppendAllText(path_framelist, txtLine + "\n");

        //Palette variables
        txtLine = ".var PaletteLineIdList = List()";
        File.AppendAllText(path_palette, txtLine + "\n");

        txtLine = ".var PaletteWidthList = List()";
        File.AppendAllText(path_palette, txtLine + "\n");


        foreach (GameObject rotatingObject in rotatingObjects)
        {
            List<Dictionary<int, Vector3>> framesLines = rotatingObjects[rotatingObjectId].transform.GetComponent<RotateEuler>().framesLines;

            txtLine = "//Object "+rotatingObjects[rotatingObjectId].name;
            File.AppendAllText(path_framelist, txtLine + "\n");

            for (var x = 0; x < rotatingObjects[rotatingObjectId].transform.GetComponent<RotateEuler>().rotationSteps; x++)
            {
                Dictionary<int, Vector3> frameLines = framesLines[x];
                List<int> widthValues = new List<int>();

                txtLine = "//Frame "+x;
                File.AppendAllText(path_framelist, txtLine + "\n");
                txtLine = ".eval LineIndexList = List() ";
                File.AppendAllText(path_framelist, txtLine + "\n");
                txtLine = ".eval LineYList = List() ";
                File.AppendAllText(path_framelist, txtLine + "\n");

                

                string lineIndexList = ".eval LineIndexList.add(";
                string lineYList = ".eval LineYList.add(";
                
                foreach (KeyValuePair<int, Vector3> dictionaryItem in frameLines)
                {
                    Vector3 frameLine = dictionaryItem.Value;

                    //line = "pos y: " + dictionaryItem.Key + " id:" + frameLine.x + " width:" +frameLine.z;
                    // line = "pos y: " + dictionaryItem.Key + " id:" + frameLine.x + " width:" + frameLine.z;
                    //line =  ".eval FrameList.add(" + dictionaryItem.Key + "," + frameLine.x + "," + frameLine.z + ")";
                    
                    int y = dictionaryItem.Key;
                    int id = Mathf.RoundToInt(frameLine.x);
                    int width = Mathf.RoundToInt(frameLine.z);
                    
                    int paletteIndex = GetOrCreateInPalette(id, width);                    
                    //File.AppendAllText(path, line + "\n");
                    lineIndexList += paletteIndex + ",";
                    lineYList += y + ",";
                    

                    framesAnimBytes++;
                }
                lineIndexList = lineIndexList.Substring(0, lineIndexList.Length - 1);
                lineYList = lineYList.Substring(0, lineYList.Length - 1);
                lineIndexList += ")";
                lineYList += ")";

                File.AppendAllText(path_framelist, lineIndexList + "\n");
                File.AppendAllText(path_framelist, lineYList + "\n");

                txtLine = ".eval FramesIndexList.add(LineIndexList)";
                File.AppendAllText(path_framelist, txtLine + "\n");

                txtLine = ".eval FramesYList.add(LineYList)";
                File.AppendAllText(path_framelist, txtLine + "\n");


            }

            rotatingObjectId++;
        }

        paletteSize = palette.Count;

        GameObject.Find("Text").transform.GetComponent<Text>().text += "Palette size: "+paletteSize+" \n";

        string line = "//Palette ("+paletteSize+" lines)";
        File.AppendAllText(path_palette, line + "\n");
        foreach(string p_line in palette){

            string[] exploded = p_line.Split("_");
            string line_id = exploded[0];
            string line_width = exploded[1];

            txtLine = ".eval PaletteLineIdList.add(" + line_id + ")";
            File.AppendAllText(path_palette, txtLine + "\n");
            txtLine = ".eval PaletteWidthList.add(" + line_width + ")";
            File.AppendAllText(path_palette, txtLine + "\n");
        }

        
    }
}
