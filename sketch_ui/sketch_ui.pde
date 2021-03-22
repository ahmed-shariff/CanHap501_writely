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
String instructions = "Instructions:\nHere w will include the instructons for the user to use the GUI.";
/* end UI definitions **************************************************************************************************/

/* writely settings ****************************************************************************************************/
String inputText = "abalepvumr";
int currentLetterIndex = 0;
boolean enableHapticsdUpdateColor = false;
boolean enableHapticsFlag = true;
boolean pressureSensordUpdateColor = false;
boolean pressureSensorFlag = true;
List<PVector> drawnPoints = new LinkedList<PVector>();
boolean writing = false;
PVector previous = null;
/* end writely settings ************************************************************************************************/

/* alphabet settings ****************************************************************************************************/
Alphabet alphabet = new Alphabet();
FPoly alphabetPoly = new FPoly();
/* end of alphabet settings ****************************************************************************************************/

/* metrics settings ****************************************************************************************************/
int seconds = 0;
Calculator calculator = new Calculator();
/* metrics end ****************************************************************************************************/

/* Initialization of virtual tool */
float threshold = 0.02;
PVector previousVector = new PVector(0, 0);
/* End of Initialization of virtual tool */


/* end definitions *****************************************************************************************************/ 


/* setup section *******************************************************************************************************/
void setup(){
  /* screen size definition */
  size(1000, 700);

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
    .addItem("Word Sentence", 2)
    ;

  for (Toggle t : learningExperienceRadio.getItems())
  {
    t.getCaptionLabel().setFont(createFont("Georgia", 10));
  }

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
		
	PhysicsSetup();
}

void PhysicsDefinitions()
{
	RG.init(this);
	/*Alphabet creation start**********************************/
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
  } else if (key == 'n') {
    println("presss"+key);
    if (currentLetterIndex < inputText.length() - 1) {
      currentLetterIndex++;
      createAlphabets();
    }
    drawnPoints.clear();
  }
}

void mousePressed() {
 println("mouse pressed");
 
 if (currentLetterIndex < inputText.length() - 1){
 currentLetterIndex++;
 createAlphabets();
 }
}

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
void drawLoop(){
	update_animation(s.getToolPositionX(), s.getToolPositionY());
	updateUI();
}
/* end draw section ****************************************************************************************************/


/* helper functions section, place helper functions here ***************************************************************/

void PhysicsSimulations()
{
	if (s.h_avatar.isTouchingBody(alphabetPoly)) {
    println("touching");
    /*PVector xDiff = (posEE.copy()).sub(previousVector);
    previousVector.set(posEE);
    if ((xDiff.mag()) < threshold) { 
      s.h_avatar.setDamping(700);
      fEE.x = random(-1, 1);
      fEE.y = random(-1, 1);
    }*/
    s.h_avatar.setDamping(950);
  } else {
    println(" NOT touching");
    s.h_avatar.setDamping(4);
  }  
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

  noFill();
  stroke(color(255, 0, 0));
  strokeWeight(1.5);
  rect(270, 120, 700, 520); // haply space
  rect(15, 290, 250, 350); // control panel
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


  //push current transformation matrixto stack
  // pushMatrix();

  // Not rendering the joints of haply

  /*User writing metrics details*/
  rect(270, 600, 700, 40);
  text("Pos x: "+round(xE), 290, 625);
  text("Pos y: "+round(yE), 400, 625);

  seconds = millis()/1000;
  calculator.calculate(seconds, xE, yE);

  text("Curr. speed: "+calculator.speed(), 510, 625);
  text("Acceleration: "+calculator.acceleration(), 680, 625);
  text("Jerk: "+calculator.jerk(), 830, 625);
  /*metrics end*/
  
  // popMatrix(); // Reset the transformation matrix

  textFont(f, 16);                  // STEP 3 Specify font to be used
  fill(0);                         // STEP 4 Specify font color 

  updateWritely(xE, yE);



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
  world.remove(alphabetPoly);
  alphabetPoly = alphabet.create(inputText.charAt(currentLetterIndex));
  alphabetPoly.setFill(255, 0, 0);
  alphabetPoly.setNoStroke();
  alphabetPoly.setDensity(0);
  //alphabetPoly.setDensity(4);
  //confused should setSensor true or false
  alphabetPoly.setSensor(true);
  //alphabetPoly.setNoStroke();
  alphabetPoly.setStatic(true);
}
