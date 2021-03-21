/*
* This class file is created to calculate mertices.
 *
 * @author Bibhushan
 */

public class Calculator {

  /* initialization ****************************************************************************************************/
  private int seconds=0;
  private float initialPosX=0;
  private float initialPosY=0;
  private float finalPosX=0;
  private float finalPosY=0;
  private int movementX=0;
  private int movementY=0;
  private int initialSpeed=0; 
  private int finalSpeed=0;
  private int initialAcceleration=0;
  private int finalAcceleration=0;
  private int jerk=0;
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
  public void calculate(int newSeconds, float positionX, float positionY) {
    if (seconds!=newSeconds) {
      if (seconds ==0) {
        initialPosX=round(positionX);
        initialPosY=round(positionY);
      }
      seconds = newSeconds;
      finalPosX=round(positionX);
      finalPosY=round(positionY);

      //calculation of movement
      movementX=(int)Math.abs(finalPosX-initialPosX);
      movementY=(int)Math.abs(finalPosY-initialPosY);
      
      //calculation of speed
      finalSpeed=(int)Math.sqrt(movementX*movementX+movementY*movementY);
      
      //calculation of acceleration
      finalAcceleration=finalSpeed-initialSpeed;
      
      //calculation of jerk
      jerk = finalAcceleration-initialAcceleration;

      initialPosX=finalPosX;
      initialPosY=finalPosY;
      initialSpeed = finalSpeed;
      initialAcceleration = finalAcceleration;
    }
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
}
