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
							}
					});

      charachters.put('o', new ArrayList<PVector>() {
							{
									add(new PVector(3.5f, 2.9f));
									add(new PVector(4.5f, 3.1f));
                  add(new PVector(5.2f, 3.7f));
                  add(new PVector(5.5f, 4.5f));
                  add(new PVector(5.67f, 5.4f));

                  add(new PVector(5.5f, 6.3f));
									add(new PVector(5.2f, 7.1f));
                  add(new PVector(4.5f, 7.7f));
                  add(new PVector(3.5f, 7.9f));

                  add(new PVector(2.5f, 7.7f));
									add(new PVector(1.8f, 7.1f));
                  add(new PVector(1.5f, 6.3f));
                  add(new PVector(1.33f, 5.4f));

                  add(new PVector(1.5f, 4.5f));
									add(new PVector(1.8f, 3.7f));
                  add(new PVector(2.5f, 3.1f));
                  add(new PVector(3.5f, 2.9f));
							}
					});

      charachters.put('t', new ArrayList<PVector>() {
							{
									add(new PVector(3f, 1.2f));
									add(new PVector(3f, 7.2f));
                  add(new PVector(3.1f, 8f));
                  add(new PVector(3.6f, 8.35f));
                  add(new PVector(4.2f, 8.4f));
                  add(new PVector(5.3f, 8.4f));
                  add(null);
                  add(new PVector(1.8f, 3.15f));
                  add(new PVector(5.3f, 3.15f));
							}
					});

      charachters.put('r', new ArrayList<PVector>() {
							{
									add(new PVector(3f, 3f));
                  add(new PVector(3f, 8.5f));
									add(new PVector(3f, 4.8f));
                  add(new PVector(3.6f, 3.9f));
                  add(new PVector(4.25f, 3.35f));
                  add(new PVector(5f, 3.1f));
                  add(new PVector(6f, 3.15f));
							}
					});

      charachters.put('s', new ArrayList<PVector>() {
							{
									add(new PVector(5.8f, 3.3f));
                  add(new PVector(5f, 3.1f));
									add(new PVector(4f, 3.02f));
                  add(new PVector(3f, 3.1f));
                  add(new PVector(3f, 3.1f));
                  add(new PVector(2.15f, 3.7f));
                  add(new PVector(2.05f, 4.6f));

                  add(new PVector(2.5f, 5.2f));
                  add(new PVector(3.1f, 5.55f));
                  add(new PVector(4f, 5.9f));
                  add(new PVector(4.8f, 6.1f));
                  add(new PVector(5.45f, 6.6f));
                  add(new PVector(5.65f, 7.1f));

                  add(new PVector(5.45f, 7.85f));
                  add(new PVector(5f, 8.25f));
                  add(new PVector(4.3f, 8.5f));
                  add(new PVector(3.8f, 8.6f));
                  add(new PVector(2.95f, 8.5f));
                  add(new PVector(2.1f, 8.3f));
							}
					});

      charachters.put('e', new ArrayList<PVector>() {
							{
                  add(new PVector(1.33f, 5.4f));
                  
                  add(new PVector(5.67f, 5.4f));
                  add(new PVector(5.5f, 4.5f));
                  add(new PVector(5.2f, 3.7f));
                  add(new PVector(4.5f, 3.1f));
                  add(new PVector(3.5f, 2.9f));

                  add(new PVector(2.5f, 3.1f));
                  add(new PVector(1.8f, 3.7f));
                  add(new PVector(1.5f, 4.5f));
									add(new PVector(1.33f, 5.4f));
                  add(new PVector(1.5f, 6.3f));
                  add(new PVector(1.8f, 7.1f));
                  add(new PVector(2.5f, 7.7f));
                  
                  add(new PVector(3.5f, 7.9f));
                  add(new PVector(4.5f, 7.7f));
                  add(new PVector(5.2f, 7.1f));
                  // add(new PVector(5.5f, 6.3f));
									// 
							}
					});

      charachters.put('b', new ArrayList<PVector>() {
							{
                  add(new PVector(1.5f, 0f));
                  add(new PVector(1.5f, 8f));
                  add(new PVector(1.5f, 5f));
                  
                  add(new PVector(1.6f, 4.5f));
									add(new PVector(1.85f, 3.7f));
                  add(new PVector(2.55f, 3.1f));
                  add(new PVector(3.5f, 2.9f));
                  
                  add(new PVector(3.5f, 2.9f));
									add(new PVector(4.5f, 3.1f));
                  add(new PVector(5.2f, 3.7f));
                  add(new PVector(5.5f, 4.5f));
                  add(new PVector(5.67f, 5.4f));

                  add(new PVector(5.5f, 6.3f));
									add(new PVector(5.2f, 7.1f));
                  add(new PVector(4.5f, 7.7f));
                  add(new PVector(3.5f, 7.9f));

                  add(new PVector(2.55f, 7.7f));
									add(new PVector(1.85f, 7.1f));
                  add(new PVector(1.6f, 6.3f));
                  add(new PVector(1.5f, 5.4f));
							}
					});

      charachters.put('n', new ArrayList<PVector>() {
							{
                  add(new PVector(1.5f, 3f));
                  add(new PVector(1.5f, 8.5f));

                  add(new PVector(1.5f, 4.5f));
                  add(new PVector(2.5f, 3.5f));
                  add(new PVector(3.4f, 3.1f));
                  add(new PVector(4.3f, 3.2f));
                  add(new PVector(5.1f, 3.7f));
                  add(new PVector(5.8f, 4.7f));
                  add(new PVector(5.8f, 8.6f));
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
      alphabetScale = 1.5;
    }else{
      //if Small Letter
			positionAlphabetX = 24;
      positionAlphabetY = 10;
      alphabetScale = 1.8;
    }
    
    return new Alphabet(points, positionAlphabetX, positionAlphabetY, alphabetScale);
  }
}
