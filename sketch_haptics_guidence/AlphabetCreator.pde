/*
* Class file to create alphabets
*
* @author Bibhushan
* @author Shariff
*/

public class AlphabetCreator {
  
  float positionAlphabetX=0;
  float positionAlphabetY=0;
  float alphabetScale=0;

	Hashtable<Character, ArrayList<PVector>> charachters = new Hashtable<Character, ArrayList<PVector>>();
	
 /**
  * Constructor
  */  
  public AlphabetCreator(){
			charachters.put('l', new ArrayList<PVector>() {
							{
									add(new PVector(0, 10));
									add(new PVector(0, 0));
									add(new PVector(5, 0));
									add(new PVector(7, 6));
							}
					});
  }

	  /**
   * Returns a PShape for a given letter
   *
   * @param    letter to be converted
   * @return   PShape Array of size 2, where array at index [0] consists of outer boundries shape and array at index [1] consists of inner boundries shapes.
   *
   *@author Bibhushan
   */ 
  public Alphabet create(char activeChar){
		//outerFShape = new FLine();
		ArrayList<PVector> points = charachters.get(activeChar);
    if(Character.isUpperCase(activeChar)){
      //if Capital letter
      positionAlphabetX = 20;
      positionAlphabetY = 26;
      alphabetScale = 1;
    }else{
      //if Small Letter
			positionAlphabetX = 28;
      positionAlphabetY = 13;
      alphabetScale = 1;
    }
    
    return new Alphabet(points, positionAlphabetX, positionAlphabetY, alphabetScale);
  }
}
