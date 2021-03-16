/**
 * Based on:
 **********************************************************************************************************************
 * @file       sketch_2_Hello_Wall.pde
 * @author     Steve Ding, Colin Gallacher, Antoine Weill--Duflos
 * @version    V1.0.0
 * @date       09-February-2021
 * @brief      PID example with random position of a target
 **********************************************************************************************************************
 * @attention
 *
 *
 **********************************************************************************************************************
 */

/* library imports *****************************************************************************************************/
import processing.serial.*;
import static java.util.concurrent.TimeUnit.*;
import java.util.concurrent.*;
import controlP5.*;
import java.util.*;
/* end library imports *************************************************************************************************/


/* scheduler definition ************************************************************************************************/
private final ScheduledExecutorService scheduler      = Executors.newScheduledThreadPool(1);
/* end scheduler definition ********************************************************************************************/

ControlP5 cp5;

Knob PKnob, IKnob, DKnob;
Slider smoothingSlider, looptimeSlider;
Textlabel forceText, infoTextLabel, infoTextX, infoTextY;
boolean EnablePath = false;

/* device block definitions ********************************************************************************************/
Board             haplyBoard;
Device            widgetOne;
Mechanisms        pantograph;

byte              widgetOneID                         = 5;
int               CW                                  = 0;
int               CCW                                 = 1;
boolean           renderingForce                     = false;
boolean           exitCalled                         = false;
/* end device block definition *****************************************************************************************/



/* framerate definition ************************************************************************************************/
long              baseFrameRate                       = 120;
/* end framerate definition ********************************************************************************************/



/* elements definition *************************************************************************************************/

/* Screen and world setup parameters */
float             pixelsPerMeter                      = 3000.0;
float             radsPerDegree                       = 0.01745;

/* pantagraph link parameters in meters */
float             l                                   = 0.07;
float             L                                   = 0.09;


/* end effector radius in meters */
float             rEE                                 = 0.006;


/* generic data for a 2DOF device */
/* joint space */
PVector           angles                              = new PVector(0, 0);
PVector           torques                             = new PVector(0, 0);
PVector           oldangles                           = new PVector(0, 0);
PVector           diff                                = new PVector(0, 0);


/* task space */
PVector           posEE                               = new PVector(0, 0);
PVector           fEE                                 = new PVector(0, 0);
float             posEE_YOffset                        = 0.03;
float             posEE_XOffset                        = 0.05;

/* device graphical position */
PVector           deviceOrigin                        = new PVector(0, 0);

/* World boundaries reference */
final int         worldPixelWidth                     = 1000;
final int         worldPixelHeight                    = 650;

float x_m, y_m;

// used to compute the time difference between two loops for differentiation
long oldtime = 0;
// for changing update rate
int iter = 0;

/// PID stuff

float P = 0.0;
// for I
float I = 0;
float cumerrorx = 0;
float cumerrory = 0;
// for D
float oldex = 0.0f;
float oldey = 0.0f;
float D = 0;

//for exponential filter on differentiation
float diffx = 0;
float diffy = 0;
float buffx = 0;
float buffy = 0;
float smoothing = 0.80;

float xr = 0;
float yr = 0;

// checking everything run in less than 1ms
long timetaken= 0;

// set loop time in usec (note from Antoine, 500 is about the limit of my computer max CPU usage)
int looptime = 500;


/* graphical elements */
PShape endEffector;
PFont f;
/* end elements definition *********************************************************************************************/

/* UI definitions ******************************************************************************************************/
Textlabel[] inputTextLabels;
Toggle enableHapticsToggle, pressureSensorToggle;
RadioButton learningExperienceRadio, hapticExperienceRadio;
String instructions = "Instructions:\nHere w will include the instructons for the user to use the GUI.";
/* end UI definitions **************************************************************************************************/

/* writely settings ****************************************************************************************************/
String inputText = "balepvumr";
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
FWorld world;
Alphabet alphabet = new Alphabet();
PShape [] outputPShapes;
String activeCharacter;
/* end of alphabet settings ****************************************************************************************************/

/* metrics settings ****************************************************************************************************/
int seconds = 0;
Calculator calculator = new Calculator();
/* metrics end ****************************************************************************************************/

/* setup section *******************************************************************************************************/
void setup() {
  /* put setup code here, run once: */

  inputText = inputText.toUpperCase();

  /* screen size definition */
  size(1000, 720);

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

  /* device setup */

  /**  
   		 * The board declaration needs to be changed depending on which USB serial port the Haply board is connected.
   		 * In the base example, a connection is setup to the first detected serial device, this parameter can be changed
   		 * to explicitly state the serial port will look like the following for different OS:
   		 *
   		 *      windows:      haplyBoard = new Board(this, "COM10", 0);
   		 *      linux:        haplyBoard = new Board(this, "/dev/ttyUSB0", 0);
   		 *      mac:          haplyBoard = new Board(this, "/dev/cu.usbmodem1411", 0);
   		 */
  haplyBoard          = new Board(this, Serial.list()[0], 0);
  widgetOne           = new Device(widgetOneID, haplyBoard);
  pantograph          = new Pantograph();

  widgetOne.set_mechanism(pantograph);

  widgetOne.add_actuator(1, CCW, 2);
  widgetOne.add_actuator(2, CW, 1);

  widgetOne.add_encoder(1, CCW, 241, 10752, 2);
  widgetOne.add_encoder(2, CW, -61, 10752, 1);

  widgetOne.device_set_parameters();


  /*Fisica start*/
  hAPI_Fisica.init(this);
  //Fisica.setScale(10);
  RG.init(this);
  //RG.setPolygonizer(RG.ADAPTATIVE);
  world = new FWorld();
  // world.setEdges(this, color(0));  
  /*end of Fisica*/


  /* visual elements setup */
  background(0);
  deviceOrigin.add(worldPixelWidth/2, 0);

  /* create pantagraph graphics */
  create_pantagraph();

  /* setup framerate speed */
  frameRate(baseFrameRate);
  f = createFont("Arial", 16, true); // STEP 2 Create Font

  /* setup simulation thread to run at 1kHz */
  thread("SimulationThread");
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
  } else if (key == 'n')
  {
    if (currentLetterIndex < inputText.length() - 1)
      currentLetterIndex++;

    drawnPoints.clear();
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
void draw() {
  /* put graphical code here, runs repeatedly at defined framerate in setup, else default at 60fps: */
  if (renderingForce == false) {
    background(255); 
    update_animation(posEE.x + posEE_XOffset, posEE.y + posEE_YOffset);
    //updateUI();

    //Fisica draw shapes
    //shape(outputPShapes[0]);
    //shape(outputPShapes[1]);
    //world.draw(this);
    //Fisica shape end
  }
}
/* end draw section ****************************************************************************************************/

int noforce = 0;
long timetook = 0;
long looptiming = 0;
float dist_X, dist_Y;

/* simulation section for PID controlls ********************************************************************************/
public void SimulationThread() {
  while (1==1) {
    if (exitCalled)
      break;
    long starttime = System.nanoTime();
    long timesincelastloop=starttime-timetaken;
    iter+= 1;
    // we check the loop is running at the desired speed (with 10% tolerance)
    if (timesincelastloop >= looptime*1000*1.1) {
      float freq = 1.0/timesincelastloop*1000000.0;
      // println("caution, freq droped to: "+freq + " kHz");
    } else if (iter >= 1000) {
      float freq = 1000.0/(starttime-looptiming)*1000000.0;
      // println("loop running at "  + freq + " kHz");
      iter=0;
      looptiming=starttime;
    }

    timetaken=starttime;

    renderingForce = true;

    if (haplyBoard.data_available()) {
      /* GET END-EFFECTOR STATE (TASK SPACE) */
      widgetOne.device_read_data();

      noforce = 0;
      angles.set(widgetOne.get_device_angles());

      posEE.set(widgetOne.get_device_position(angles.array()));

      posEE.set(device_to_graphics(posEE)); 
      x_m = xr*300; 
      y_m = yr*300+350;//mouseY;

      // Torques from difference in endeffector and setpoint, set gain, calculate force
      float xE = pixelsPerMeter * posEE.x + posEE_XOffset;
      float yE = pixelsPerMeter * posEE.y + posEE_YOffset; // adins some space above for the UI
      long timedif = System.nanoTime()-oldtime;

      dist_X = x_m-xE;
      cumerrorx += dist_X*timedif*0.000000001;
      dist_Y = y_m-yE;
      cumerrory += dist_Y*timedif*0.000000001;
      //println(dist_Y*k + " " +dist_Y*k);
      // println(timedif);
      if (timedif > 0) {
        buffx = (dist_X-oldex)/timedif*1000*1000;
        buffy = (dist_Y-oldey)/timedif*1000*1000;            

        diffx = smoothing*diffx + (1.0-smoothing)*buffx;
        diffy = smoothing*diffy + (1.0-smoothing)*buffy;
        oldex = dist_X;
        oldey = dist_Y;
        oldtime=System.nanoTime();
      }

      // Forces are constrained to avoid moving too fast

      fEE.x = constrain(P*dist_X, -4, 4) + constrain(I*cumerrorx, -4, 4) + constrain(D*diffx, -8, 8);


      fEE.y = constrain(P*dist_Y, -4, 4) + constrain(I*cumerrory, -4, 4) + constrain(D*diffy, -8, 8); 


      if (noforce==1)
      {
        fEE.x=0.0;
        fEE.y=0.0;
      }
      widgetOne.set_device_torques(graphics_to_device(fEE).array());
      //println(f_y);
      /* end haptic wall force calculation */
    }



    widgetOne.device_write_torques();


    renderingForce = false;
    long timetook=System.nanoTime()-timetaken;
    if (timetook >= 1000000) {
      //println("Caution, process loop took: " + timetook/1000000.0 + "ms");
    } else {
      while (System.nanoTime()-starttime < looptime*1000) {
        //println("Waiting");
      }
    }
  }
}

/* end simulation section **********************************************************************************************/


/* helper functions section, place helper functions here ***************************************************************/

void exit() {
  exitCalled = true;
  println("Executing exit");

  // rying to make sure that the device's torques are set to 0
  widgetOne.device_set_parameters();
  widgetOne.set_device_torques(new float[]{0, 0});
  widgetOne.device_write_torques();
  super.exit();
}

void create_pantagraph() {
  float lAni = pixelsPerMeter * l;
  float LAni = pixelsPerMeter * L;
  float rEEAni = pixelsPerMeter * rEE;

  endEffector = createShape(ELLIPSE, deviceOrigin.x, deviceOrigin.y, 2*rEEAni, 2*rEEAni);
  endEffector.setStroke(color(0));
  strokeWeight(5);
}


void update_animation(float xE, float yE) {
  background(255);

  //Updated code to show letter using Fisica

  activeCharacter = String.valueOf(inputText.charAt(currentLetterIndex));
  outputPShapes = alphabet.create(activeCharacter.toLowerCase());
  shape(outputPShapes[0]);
  shape(outputPShapes[1]);
  world.draw(this);
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
   
   		// Highlight current text
   		float[] highlightPosition = inputTextLabels[currentLetterIndex].getPosition();
   		circle(highlightPosition[0] + 10, highlightPosition[1] + 14, 30);
   */

  //push current transformation matrixto stack
  pushMatrix();

  // Calculating the current position of the end effector
  xE = pixelsPerMeter * xE;
  yE = pixelsPerMeter * yE;

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

  // Set transformation matrix o the location of the end effector and draw the end effector graphic
  translate(xE, yE);
  shape(endEffector);
  popMatrix(); // Reset the transformation matrix

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
    PVector vec = new PVector(xE + deviceOrigin.x, yE + deviceOrigin.y);
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


PVector device_to_graphics(PVector deviceFrame) {
  return deviceFrame.set(-deviceFrame.x, deviceFrame.y);
}


PVector graphics_to_device(PVector graphicsFrame) {
  return graphicsFrame.set(-graphicsFrame.x, graphicsFrame.y);
}

/* end helper functions section ****************************************************************************************/
