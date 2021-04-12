import controlP5.*;
import java.util.*;

/* Definitions **********************************************************************************************************/
float             posEE_YOffset                        = 3;
float             posEE_XOffset                        = 30;

ControlP5 cp5;

Knob PKnob, IKnob, DKnob;
Slider smoothingSlider, looptimeSlider;
Textlabel forceText, infoTextLabel, infoTextX, infoTextY;
boolean EnablePath = false;

/* UI definitions ******************************************************************************************************/
Textlabel[] inputTextLabels;
Toggle enableHapticsToggle, pressureSensorToggle;
RadioButton learningExperienceRadio, hapticExperienceRadio;
String instructions = "Instructions:\nPress and hold the spacebar to write a stroke. You can repeatedly do this for as many strokes as you need to write the character. When done the letter, press the right arrow to move to the next letter.";
boolean showFEE = true;
/* end UI definitions **************************************************************************************************/

/* writely settings ****************************************************************************************************/
String inputText = "lonbers";
int currentLetterIndex = 0;
String currentLetter = "";
boolean newLetter = true; // set to true when no stroke has been made and false when a stroke has been made (ultimately used to set start trial time)
boolean enableHapticsdUpdateColor = false;
boolean enableHapticsFlag = true;
boolean pressureSensordUpdateColor = false;
boolean pressureSensorFlag = true;
List<PVector> drawnPoints = new LinkedList<PVector>();
boolean writing = false;
PVector previous = null;
ClosestPointResult closestPoint = new ClosestPointResult(null, null);
int redC = color(255, 0, 0);
/* end writely settings ************************************************************************************************/

/* variables to store ****************************************************************************************************/
float currXPos = 0.0;
float currYPos = 0.0;
float currXForce = 0.0;
float currYForce = 0.0;
float currSpeed = 0.0;
float currAccel = 0.0;
float currJerk = 0.0;
long startTrialTime = 0;
long currTrialTime = 0;
/* end variables to store ****************************************************************************************************/

/* study generator ****************************************************************************************************/
Study currentStudy = new Study();

/* alphabet settings ****************************************************************************************************/
AlphabetCreator alphabet = new AlphabetCreator();
Alphabet alphabetPoly;
AlphabetMetrics alphabetMetrics;
/* end of alphabet settings ****************************************************************************************************/

/* metrics settings ****************************************************************************************************/
float seconds = 0;
Calculator calculator = new Calculator();
/* metrics end ****************************************************************************************************/

/* Initialization of virtual tool */
float threshold = 0.02;
PVector previousVector = new PVector(0, 0);
/* End of Initialization of virtual tool */


/* end definitions *****************************************************************************************************/


/* setup section *******************************************************************************************************/
void setup() {
  /* screen size definition */
  size(1000, 700);
  calculator.reset();
  /* GUI setup */
  smooth();
  cp5 = new ControlP5(this);

  inputTextLabels = new Textlabel[inputText.length()];
  for (int i = 0; i < inputText.length(); i++)
  {
    inputTextLabels[i] = cp5.addTextlabel("label " + i)
      .setText(String.valueOf(inputText.charAt(i)))
      .setPosition(300 + i * 50, 70)
      .setColorValue(color(0, 0, 0))
      .setFont(createFont("Georgia", 20))
      ;
  }

  cp5.addTextlabel("controlPanel")
    .setText("Control Panel")
    //.setMultiline(true)
    .setPosition(60, 300)
    .setColorValue(color(0, 0, 0))
    .setFont(createFont("Georgia", 20))
    ;

  // enable haptics
  cp5.addTextlabel("enableHapticsLabel")
    .setText("Enable Haptics")
    //.setMultiline(true)
    .setPosition(20, 350)
    .setColorValue(color(0, 0, 0))
    .setFont(createFont("Georgia", 16))
    ;

  enableHapticsToggle = cp5.addToggle("enableHaptics")
    .setPosition(210, 350)
    .setSize(50, 20)
    .setColorBackground(color(200))
    .setColorActive(color(0, 255, 0))
    .setValue(true)
    .setMode(ControlP5.SWITCH)
    ;

  // pressure sensor
  cp5.addTextlabel("pressureSensorLabel")
    .setText("Pressure Sensor")
    //.setMultiline(true)
    .setPosition(20, 400)
    .setColorValue(color(0, 0, 0))
    .setFont(createFont("Georgia", 16))
    ;

  pressureSensorToggle = cp5.addToggle("pressureSensor")
    .setPosition(210, 400)
    .setSize(50, 20)
    .setColorBackground(color(200))
    .setColorActive(color(0, 255, 0))
    .setValue(true)
    .setMode(ControlP5.SWITCH)
    ;

  // learning experience
  cp5.addTextlabel("learningExperienceLabel")
    .setText("Learning Experience")
    //.setMultiline(true)
    .setPosition(20, 450)
    .setColorValue(color(0, 0, 0))
    .setFont(createFont("Georgia", 16))
    ;

  learningExperienceRadio = cp5.addRadioButton("learningExperience")
    .setPosition(20, 480)
    .setSize(40, 20)
    .setColorForeground(color(100))
    .setColorActive(color(0, 255, 100))
    .setColorLabel(color(0))
    .setItemsPerRow(2)
    .setSpacingColumn(70)
    .addItem("Letters", 1)
    //.addItem("Word Sentence", 2)
    ;

  for (Toggle t : learningExperienceRadio.getItems())
  {
    t.getCaptionLabel().setFont(createFont("Georgia", 10));
  }

  learningExperienceRadio.getItem(0).setValue(true);

  // Haptic experience
  cp5.addTextlabel("hapticExperienceLabel")
    .setText("Haptic Experience")
    //.setMultiline(true)
    .setPosition(20, 550)
    .setColorValue(color(0, 0, 0))
    .setFont(createFont("Georgia", 16))
    ;

  hapticExperienceRadio = cp5.addRadioButton("hapticExperience")
    .setPosition(20, 580)
    .setSize(40, 20)
    .setColorForeground(color(100))
    .setColorActive(color(0, 255, 100))
    .setColorLabel(color(0))
    .setItemsPerRow(2)
    .setSpacingColumn(90)
    .addItem("Partial", 1)
    .addItem("Full", 2)
    .addItem("Anti-guidence", 3)
    .addItem("Disturbance", 4)
    ;

  for (Toggle t : hapticExperienceRadio.getItems())
  {
    t.getCaptionLabel().setFont(createFont("Georgia", 9));
  }


  hapticExperienceRadio.getItem(1).setValue(true);
  hapticExperienceRadio.getItem(0).hide();
  hapticExperienceRadio.getItem(3).hide();

  PhysicsSetup();
  s.h_avatar.setSize(1f);
}

void PhysicsDefinitions()
{
  //RG.init(this);
  /*Alphabet creation start**********************************/
  currentLetterIndex = currentStudy.getCurrTrial();
  createAlphabets();
  /*Alphabet creation start***************************/
}

/* end setup section ***************************************************************************************************/

void enableHaptics(boolean flag)
{
  enableHapticsFlag = flag;
  enableHapticsdUpdateColor = true;
}

void pressureSensor(boolean flag)
{
  pressureSensorFlag = flag;
  pressureSensordUpdateColor = true;
}

/* Keyboard inputs *****************************************************************************************************/

void keyPressed()
{
  if (key == ' ') {
    writing = true;
    if (newLetter) {
      startTrialTime = System.currentTimeMillis();
      newLetter = false;
    }
  } // end of space to write/draw points
  
  // else if they are done writing the letter then move to the next letter in the study
  else if (key == '\n') {
    calculator.reset();
    // iterate trial number
    currentStudy.nextTrial();
    // if we are done the study
    if (currentStudy.isDone()) {
      // do something to signal the end
      drawnPoints.clear();
      doneStudy();
    }
    // else more trials to do
    else {
      // get next letter
      currentLetterIndex = currentStudy.getCurrTrial();
      println("Trial: "+currentStudy.getCurrPos()+"/"+currentStudy.numberOfTrials()+" -- Next Letter: "+currentLetter);
      //  ***************************************************** WE NEED TO SHOW THE NEXT LETTER HERE WHEN THEY ARE ALL CREATED *****************************************************
      drawnPoints.clear();
      newLetter = true;
      createAlphabets();
    }
    
    //// this is still here for current version of the code. will probably remove later
    //if (currentLetterIndex < inputText.length() - 1) {
    //  currentLetterIndex++;
    //  println(currentLetterIndex);
    //  createAlphabets();
    //}
    
  } // end of next letter on enter
  
  // used purely to clear drawn points
  else if (key == 'r') {
    drawnPoints.clear();
  }
}

// void mousePressed() {
//  println("mouse pressed");

//  if (currentLetterIndex < inputText.length() - 1){
//  currentLetterIndex++;
//  createAlphabets();
//  }
// }

void keyReleased()
{
  if (key == ' ')
  {
    writing = false;

    // Adding this so that we know when to break the lines
    PVector vec = new PVector(-1, -1);
    drawnPoints.add(vec);
    previous = vec;
  }
}
/* end of keyboard inputs **********************************************************************************************/

/* draw section ********************************************************************************************************/
void drawLoop() {
  update_animation(s.getAvatarPositionX(), s.getAvatarPositionY());
  updateUI();
}
/* end draw section ****************************************************************************************************/


/* helper functions section, place helper functions here ***************************************************************/

void PhysicsSimulations()
{
  if (!enableHapticsToggle.getState())
  {
    return;
  }

  if (alphabetPoly.isTouchedByBody(s.h_avatar)) {
    // closestPoint = calcualteClosestPoint(xE, yE);
    float screenXE = s.getAvatarPositionX() * pixelsPerCentimeter;
    float screenYE = s.getAvatarPositionY() * pixelsPerCentimeter;
    closestPoint = alphabetPoly.closestPoint(screenXE, screenYE);

    if (ramp && rampStartTime == 0)
      rampStartTime = millis();


    if (closestPoint.useThis)
    {
      //         .addItem("Partial", 1)
      // .addItem("Full", 2)
      // .addItem("Anti-guidence", 3)
      // .addItem("Disturbance", 4)

      if (hapticExperienceRadio.getState(1)) {
        applyFullGuidence(perpendicularRampedForced(closestPoint));
      } else if (hapticExperienceRadio.getState(2))
        applyAntiGuidence(perpendicularRampedForced(closestPoint));
    }
    // println("touching");
    /*PVector xDiff = (posEE.copy()).sub(previousVector);
     previousVector.set(posEE);
     if ((xDiff.mag()) < threshold) { 
     s.h_avatar.setDamping(700);
     fEE.x = random(-1, 1);
     fEE.y = random(-1, 1);
     }*/
  } else {
    //println(" NOT touching");
    s.h_avatar.setDamping(0);
    ramp = true;
    rampStartTime = 0;
  }
}

float currentRampTime = 0;
float rampStartTime = 0;
boolean ramp = false;


PVector perpendicularRampedForced(ClosestPointResult c)
{
  PVector force = c.perpendicularVector.copy().limit(10f).mult(0.5f);
  if (ramp)
  {
    PVector initialForce = force.copy();
    currentRampTime = millis() - rampStartTime;
    force = (force.mult(currentRampTime * 0.003));
    if (force.mag() >= initialForce.mag()) {//} || currentRampTime > 1.5f){
      ramp = false;
      rampStartTime = 0;
    }
  }
  return force;
}

void applyFullGuidence(PVector force)
{
  // y needs to be negated when going from screen to world
  float modifier = log((force.mag() * 5) + 1);
  force.mult(modifier);
  fEE.add(force.x, -force.y);
  fEE.limit(4);
  s.h_avatar.setDamping(600);
}


long timeSineCrossingCenter = 0;
long crossedTime = 0;
PVector lastCrossedVactor;
boolean crossCenter = true;
void applyAntiGuidence(PVector force)
{
	timeSineCrossingCenter = millis() - crossedTime;

  PVector oppositeVector = force.copy().normalize().mult(3.5);
  force = oppositeVector.sub(force);

	if (lastCrossedVactor == null)
	{
			lastCrossedVactor = force.copy();
	}

	if (PVector.dot(force, lastCrossedVactor) < 0 && crossCenter) // crossed the center line
	{
			lastCrossedVactor = force.copy();
			crossedTime = millis();
			crossCenter = false;
	}

	if (timeSineCrossingCenter < 2000)
	{
			if (!crossCenter && PVector.dot(force, lastCrossedVactor) >= 0) // if the force is not in the direction we want to be
			{
					force = PVector.mult(force, -1);
			}
	}
	else
	{
			crossCenter = true;
	}
	
	// y needs to be negated when going from screen to world
	fEE.add(force.x, - force.y);
	fEE.limit(3.5);
	
  s.h_avatar.setDamping(600);
}

void exit() {
  PhysicsExit();
  super.exit();
}


void update_animation(float xE, float yE) {
  background(255);

  //Updated code to show letter using Fisica
  world.draw();
  //Fisica end 

  color baseColor = color(255, 0, 0);
  noFill();
  stroke(baseColor);
  strokeWeight(1.5);
  rect(270, 120, 700, 520); // haply space
  rect(15, 290, 250, 390); // control panel
  rect(15, 25, 250, 260); // instructions

  PFont f = createFont("Arial", 16);
  textFont(f, 16);
  text(instructions, 30, 50, 200, 500);

  // The text to write in
  /*textFont(f, 300);
   fill(color(200));
   text(String.valueOf(inputText.charAt(currentLetterIndex)), 500, 420);
   */
  // Highlight current text
  float[] highlightPosition = inputTextLabels[currentLetterIndex].getPosition();
  circle(highlightPosition[0] + 10, highlightPosition[1] + 14, 30);

  if (closestPoint.useThis)
  {
    stroke(color(100, 100, 0));
    strokeWeight(2);
    circle(closestPoint.c.x, closestPoint.c.y, 40);
  }

  if (showFEE)
  {
    float x = 350;
    float y = 220;
    circle(x, y, 150);
    line(x, y, x + fEE.x * pixelsPerCentimeter, y - fEE.y * pixelsPerCentimeter);
  }

  alphabetMetrics = alphabetPoly.getMetrics();

  seconds = millis()/1000;
  // seconds = millis()/100;
  calculator.calculate(seconds, xE * pixelsPerCentimeter, yE * pixelsPerCentimeter, alphabetMetrics.currentD, alphabetMetrics.completedPercentage);

  stroke(baseColor);

  //push current transformation matrixto stack
  // pushMatrix();

  // Not rendering the joints of haply

  /*User writing metrics details*/
  rect(270, 600, 700, 80);
  text("Pos x: "+round(xE), 290, 625);
  text("Pos y: "+round(yE), 400, 625);
  text("score: " + calculator.score(), 500, 625);

  text("Curr. speed: "+calculator.speed(), 310, 665);
  text("Acceleration: "+calculator.acceleration(), 580, 665);
  text("Jerk: "+calculator.jerk(), 830, 665);
  /*metrics end*/
  
  /* recording start */
  // if writing and check that we have new data to store otherwise don't bother storing a repeated measure
  if (writing && (calculator.speed() != currSpeed || calculator.acceleration() != currAccel || 
  calculator.jerk() != currJerk || round(s.getAvatarPositionX()) != currXPos || 
  round(s.getAvatarPositionY()) != currYPos || fEE.x != currXForce || fEE.y != currYForce)) {
    // p_id>  haptic_id>  letter_id>  trial_id>  start_trial_time!!  curr_trial_time>  total_trial_time>  x_pos>  y_pos>  speed>  acceleration>  jerk>  x_force  y_force
    currTrialTime = System.currentTimeMillis();
    String dataToStore = ""+currentStudy.getP_id()+','+currentStudy.getHaptic_condition()+','+
    currentLetterIndex+','+currentStudy.getCurrPos()+','+startTrialTime+','+currTrialTime+','+
    (currTrialTime-startTrialTime)+','+s.getAvatarPositionX()+","+s.getAvatarPositionY()+","+
    calculator.speed()+','+calculator.acceleration()+','+calculator.jerk()+","+fEE.x+","+fEE.y+"";
    writeFile(dataToStore);
  }
  /*recording end*/
  
  // set new current variables
  currXPos = round(s.getAvatarPositionX());
  currYPos = round (s.getAvatarPositionY());
  currXForce = fEE.x;
  currYForce = fEE.y;
  currSpeed = calculator.speed();
  currAccel = calculator.acceleration();
  currJerk = calculator.jerk();

  // popMatrix(); // Reset the transformation matrix

  textFont(f, 16);                  // STEP 3 Specify font to be used
  fill(0);                         // STEP 4 Specify font color 

  updateWritely(xE * pixelsPerCentimeter, yE * pixelsPerCentimeter);

  // When rendering the target position
  // x_m = xr*300+500; 
  // //println(x_m + " " + mouseX);")
  // y_m = yr*300+350;//mouseY;
  // pushMatrix();
  // translate(x_m, y_m);
  // shape(target);
  // popMatrix();
}

void updateUI()
{
  if (enableHapticsdUpdateColor)
  {
    if (enableHapticsFlag)
      enableHapticsToggle.setColorActive(color(0, 255, 0)); //green
    else
      enableHapticsToggle.setColorActive(color(255, 0, 0)); //red
  }

  if (pressureSensordUpdateColor)
  {
    if (pressureSensorFlag)
      pressureSensorToggle.setColorActive(color(0, 255, 0)); //green
    else
      pressureSensorToggle.setColorActive(color(255, 0, 0)); //red
  }
}

void updateWritely(float xE, float yE) {
  stroke(0, 0, 0);

  if (writing)
  {
    PVector vec = new PVector(xE, yE);
    if (previous == null || (vec.x != previous.x && vec.y != previous.y))
    {
      drawnPoints.add(vec);
      previous = vec;
    }
  }

  PVector p1, p2;
  for (int i = 1; i < drawnPoints.size(); i++)
  {
    p1 = drawnPoints.get(i);
    p2 = drawnPoints.get(i - 1);
    if (p1.x != -1 && p2.x != -1)
    {
      //println(drawnPoints.get(i-1).x+ "  " + drawnPoints.get(i-1).y+ "  " + p.x+ "  " + p.y);
      line(p2.x, p2.y, p1.x, p1.y);
    }
  }
}

void createAlphabets() {
  //Updated code to show letter using Fisica
  //world.removeBody(alphabetPoly);
  println ("inside create Alphabets!!!");
  if (alphabetPoly != null)
    alphabetPoly.removeFromWorld();
  alphabetPoly = alphabet.create(inputText.charAt(currentLetterIndex));
}

// do something to signal the end of the study
void doneStudy () {
  instructions = "Done study, thanks!";
}
