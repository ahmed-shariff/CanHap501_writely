import geomerative.*;

/*
* Class file to deal with Letters and alphabets
*
* @author Bibhushan
*/

public class Alphabet{
  
  private RShape outerRShape;
  private RPoint[] outerPoints;
  static final String ALPHABET_FONT_PATH = "fonts/";
  FPoly outerFShape;
  float positionAlphabetX=0;
  float positionAlphabetY=0;
  float alphabetScale=0;

 /**
  * Constructor
  */  
  public Alphabet(){
    
  }
  
  
  /**
   * Returns a PShape for a given letter
   *
   * @param    letter to be converted
   * @return   PShape Array of size 2, where array at index [0] consists of outer boundries shape and array at index [1] consists of inner boundries shapes.
   *
   *@author Bibhushan
   */ 
  public FPoly create(char activeChar){
    outerFShape=new FPoly();
    outerRShape = new RShape();
    //outerRShape = RG.loadShape(ALPHABET_IMAGE_PATH+"letter_"+letterName+".svg");
    RFont outerRFont = new RFont(ALPHABET_FONT_PATH+"arialbd.ttf");
    outerRShape = outerRFont.toShape(activeChar);
    //innerRShape = RG.loadShape(ALPHABET_IMAGE_PATH+"letter_"+letterName+"_contour.svg");
    //outerRShape = RG.polygonize(outerRShape);
    
    if(Character.isUpperCase(activeChar)){
      //if Capital letter
      positionAlphabetX = 20;
      positionAlphabetY = 26;
      alphabetScale = 0.5;
    }else{
      //if Small Letter
      positionAlphabetX = 25;
      positionAlphabetY = 26;
      alphabetScale = 0.5;
    }
    
    outerRShape.scale(alphabetScale);
   // RG.shape(outerRShape, 300, 800); 
    //RG.centerIn(outerRShape,g,500);
    //Creating outer shape
    outerPoints = outerRShape.getPoints();
    
    println("length of the array:"+outerPoints.length);
    for (int i = 0; i < outerPoints.length; i++) {
        println("(" + (int)outerPoints[i].x + ", " + (int)outerPoints[i].y + ")");
        outerFShape.vertex(positionAlphabetX+outerPoints[i].x, positionAlphabetY+outerPoints[i].y);
    }
    //outerFShape.vertex(outerPoints[0].x, outerPoints[0].y);
    world.add(outerFShape);    
    return outerFShape;
  }
}
