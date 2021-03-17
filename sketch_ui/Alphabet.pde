import geomerative.*;

/*
* Class file to deal with Letters and alphabets
*
* @author Bibhushan
*/

public class Alphabet{
  
  private RShape outerRShape, innerRShape;
  private RPoint[] outerPoints, innerPoints;
  private PShape outerPShape, innerPShape;
  static final String ALPHABET_IMAGE_PATH = "img/alphabets/";

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
  public PShape[] create(String letterName){  
    outerRShape = RG.loadShape(ALPHABET_IMAGE_PATH+"letter_"+letterName+".svg");
    innerRShape = RG.loadShape(ALPHABET_IMAGE_PATH+"letter_"+letterName+"_contour.svg");
    outerRShape.scale(1.2);
    innerRShape.scale(1.2);
    
    //Creating outer shape
    outerPoints = outerRShape.getPoints();
    innerPoints = innerRShape.getPoints();

    outerPShape = createShape();
    outerPShape.beginShape();
    outerPShape.noStroke();
    outerPShape.fill(0, 0, 255);

    for (int i = 0; i < outerPoints.length; i++) {
        //println("(" + outerPoints[i].x + ", " + outerPoints[i].y + ")");
        outerPShape.vertex(outerPoints[i].x, outerPoints[i].y);
    }
    outerPShape.endShape(CLOSE);
    
    //Now creating inner shapes
    innerPShape = createShape();
    innerPShape.beginShape();
    innerPShape.noStroke();
    innerPShape.fill(0, 0, 0);
    
    // Interior part of shape
    for (int j = 0; j < innerPoints.length; j++) {
    //for (int j = contourPoints.length-1; j >=0; j--) {
        //println("Begin Contour !!!");
        //println("(" + innerPoints[j].x + ", " + innerPoints[j].y + ")");
        innerPShape.vertex(innerPoints[j].x, innerPoints[j].y);
    }
    innerPShape.endShape(CLOSE);
    PShape shapes[] ={outerPShape, innerPShape};
    
    return shapes;
  }
}
