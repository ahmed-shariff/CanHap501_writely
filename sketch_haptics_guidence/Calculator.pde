/*
* This class file is created to calculate mertices.
 *
 * @author Bibhushan
 */

public class Calculator {

  /* initialization ****************************************************************************************************/
  private float seconds=0;
  private float totalSeconds = 0;
  private float totalD = 0;
  private float initialPosX=0;
  private float initialPosY=0;
  private float finalPosX=0;
  private float finalPosY=0;
  private float movementX=0;
  private float movementY=0;
  private float initialSpeed=0; 
  private float finalSpeed=0;
  private float initialAcceleration=0;
  private float finalAcceleration=0;
  private float jerk=0;
  private float score=0;

  private float scoreCoeffD=0.001f;
  private float scoreCoeffC=2f;
  private float scoreCoeffT=0.05f;
  /* metrics end ****************************************************************************************************/

  /**
   * Constructor
   */
  public Calculator() {
  }

  /**
   * Calculates the metrices from the x and y postion of the cursor.
   *
   * @param    newSeconds is the passed seconds during the execuation of the calculation.
   * @param    positionX is the position of the cursor on X axis.
   * @param    positionY is the position of the cursor on Y axis.
   *
   *@author Bibhushan
   */
  public void calculate(float newSeconds, float positionX, float positionY, float currendD, float completePercentage) {
    if (true) {
      if (seconds ==0) {
        initialPosX=round(positionX);
        initialPosY=round(positionY);
      }
      float timeDelta = newSeconds - seconds;
      totalSeconds += timeDelta;
      totalD += currendD;

      score = calculateScore(totalD, completePercentage, totalSeconds);
      
      if (timeDelta == 0)
      {
        timeDelta = 1;
      }
      seconds = newSeconds;
      finalPosX=round(positionX);
      finalPosY=round(positionY);

      //calculation of movement
      movementX=Math.abs(finalPosX-initialPosX);
      movementY=Math.abs(finalPosY-initialPosY);
      
      //calculation of speed
      finalSpeed=(float)(Math.sqrt(movementX*movementX+movementY*movementY) / timeDelta);
      
      //calculation of acceleration
      finalAcceleration=(finalSpeed-initialSpeed)/timeDelta;
      
      //calculation of jerk
      jerk = (finalAcceleration-initialAcceleration)/timeDelta;

      initialPosX=finalPosX;
      initialPosY=finalPosY;
      initialSpeed = finalSpeed;
      initialAcceleration = finalAcceleration;
    }
  }

    private float calculateScore(float totalD, float completePercentage, float totalSeconds)
    {
        println(totalD + "  "+completePercentage + "  "+ totalSeconds);
        return (scoreCoeffC * completePercentage) / (scoreCoeffD * totalD) * (scoreCoeffT * totalSeconds);
    }

  /**
   * Returns the speed of the cursor.
   *
   *
   *@author Bibhushan
   */
  public float speed() {
    return this.finalSpeed;
  }

  /**
   * Returns the acceleration of the cursor.
   *
   *
   *@author Bibhushan
   */
  public float acceleration() {
    return this.finalAcceleration;
  }

  /**
   * Returns the jerk of the cursor.
   *
   *
   *@author Bibhushan
   */
  public float jerk() {
    return this.jerk;
  }

  public float score() {
    return this.score;
  }

  public void reset()
  {
    seconds=0;
    initialPosX=0;
    initialPosY=0;
    finalPosX=0;
    finalPosY=0;
    movementX=0;
    movementY=0;
    initialSpeed=0;
    finalSpeed=0;
    initialAcceleration=0;
    finalAcceleration=0;
    jerk=0;
    totalD=0;
    totalSeconds=0;
    score=0;
  }
}
