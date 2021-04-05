/*
* The study class
 * This class creates the study trials to follow
 * @author Bradley
 */

import java.util.Random;

public class Study {
  // study constants
  final private int numLetters = 6; // assuming 6 letters right now; 2 for each of low, medium, high complexity
  final private int numTrialsPerLetter = 10; // assuming each letter is done 10 times in a participants block
  final private int totalTrials = numLetters * numTrialsPerLetter; // total number of trials in a participant's single block (currently 60)
  final private String [] letterIDs = {"a", "b", "c", "d", "e", "f"}; // letter ids to be stored and used to bring forward the next letter ---- CHANGE BASED ON LETTERS WE CHOOSE
  private String [] trialArray = new String[totalTrials]; // array to hold all the letters that will be done
  private int currTrialPos = 0;

  /* --------------------------------------------- UPDATE UPDATE UPDATE ***** FOR EACH STUDY AND PER PARTICIPANT ***** UPDATE UPDATE UPDATE --------------------------------------------- */
  final public int p_id = 0; // given p_id
  final int haptic_condition = 0; // given condition (haptic feedback type) for the participant
  /* --------------------------------------------- UPDATE UPDATE UPDATE ***** FOR EACH STUDY AND PER PARTICIPANT ***** UPDATE UPDATE UPDATE --------------------------------------------- */

  // constructor
  public Study () {
    generateStudy();
  }

  void generateStudy () {
    int currPos = 0;
    // for the number of letters
    for (int i=0; i<numLetters; i++) {
      // for the number of repetitions
      for (int j=0; j<numTrialsPerLetter; j++) {
        // append the trial to studyOrder which holds all trials
        trialArray[currPos] = letterIDs[i];
        currPos ++;
      }
    }
    // shuffle the trials
    shuffleArray (trialArray);
  }

  // copied from online. Shuffles the array contents
  void shuffleArray(String[] array) {

    Random rng = new Random();

    // i is the number of items remaining to be shuffled.
    for (int i = array.length; i > 1; i--) {

      // Pick a random element to swap with the i-th element.
      int j = rng.nextInt(i);  // 0 <= j <= i-1 (0-based array)

      // Swap array elements.
      String tmp = array[j];
      array[j] = array[i-1];
      array[i-1] = tmp;
    }
  }

  // print for debugging purposes
  public void printStudy() {
    printArray(trialArray);
  }

  // get current position in StudyOrder array
  public int getCurrPos () {
    return currTrialPos;
  }

  // get current trial letter
  public String getCurrTrial () {
    return trialArray[currTrialPos];
  }

  // returns true if study done else false
  public boolean isDone () {
    return currTrialPos == totalTrials;
  }

  // iterates to the next trial
  public void nextTrial () {
    currTrialPos ++;
  }
  
  // iterates to the next trial
  public int getP_id () {
    return p_id;
  }
  
  // iterates to the next trial
  public int getHaptic_condition () {
    return haptic_condition;
  }
  
  // iterates to the next trial
  public int numberOfTrials () {
    return totalTrials;
  }
}
