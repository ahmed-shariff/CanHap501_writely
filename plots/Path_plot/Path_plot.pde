int p_id = 0;
int haptic_condition = 0;
String fileName = "11-12-53";
String path = "/Users/bradleyrey/Documents/UofM/Grad_School/UBC/Project/Code/final_Code/CanHap501_writely/data/pid_";

String letter = ""; // if you want a specific letter to trace
int letterTrial = -1; // if a specific letter then denote the specific trial of that letter

int overallTrial = 0; // if you just want an overall trial

boolean animate = false; // true, the drawing pauses before drawing; false, all are drawn at once
int waitTime = 200; // amount of time to wait before next point to draw when animating

FloatList xPositions = new FloatList(); // foat list that contains x positions to be plotted
FloatList yPositions = new FloatList(); // foat list that contains y positions to be plotted
FloatList xForces = new FloatList(); // foat list that contains x forces to be plotted
FloatList yForces = new FloatList(); // foat list that contains y forces to be plotted
long startTime = -1; // the start time of the trial (used if animating)
float currXPos = -1; // current x position
float currYPos = -1; // current y position
float currXForce = 0; // current x force
float currYForce = 0; // current y force

int totalDataPoints = 0; // total number of data points that will be plotted

float minColorVal; // this is the lowest force valye used in the entire letter
float maxColorVal; // this is the highest force value used in the entire letter
int arrowLength = 2; // idk, the arrow code is partially from the internet. This value looks nice lol
int arrowConstant = 8; // length of the two lines in the arrow

int OldXMax = 25;
int OldXMin = 40;
int OldYMin = 10;
int OldYMax = 25;
int NewXMax = 0;
int NewXMin = 1000;
int NewYMin = 0;
int NewYMax = 1000;


Table table;

void setup() {
  size(1000, 1000);
  colorMode(HSB, 100);
  if (animate) {
   frameRate(2); 
  }
  loadData(); // load the specific data to draw
  getColorRange(); // get the color range to use for forces
}

void draw() {
  background(100);
  // if animating then we delay which has to be done in the draw function and can't be done outside
  //if (animate) {
  //  // iterate through values to get min and max force colors
  //  for (int i=0; i<totalDataPoints; i++) {
  //    currXPos = xPositions.remove(0);
  //    currYPos = yPositions.remove(0);
  //    currXForce = xForces.remove(0);
  //    currYForce = yForces.remove(0);
  //    drawArrow(currXPos, currYPos, arrowLength, atan(currYForce/currXForce), getVector(currXForce, currYForce));
  //    //delay(200);
  //    // to delay we take the current time and check if we have waited the wait time
  //    //long time = System.currentTimeMillis();
  //    //long totalWaitTime = (time+waitTime);
  //    //// while still less than time+waitTime then do nothing
  //    //while (System.currentTimeMillis() < totalWaitTime) {
  //    //  println("waiting");
  //    //}
  //  }
  //} else {
    drawData(); // draw the data
    noLoop(); // don't continually loop the draw method
  //}
  
}

void drawArrow(float cx, float cy, int len, float angle, float vector) {
  strokeWeight(1);
  stroke(getColor(vector)); // get color based on the min/max vorces and current vector force
  pushMatrix();
  translate(cx, cy);
  rotate(angle); // angle is already in radians, no need to convert
  // draw two parts of the arrow
  line(len, 0, len - arrowConstant, -arrowConstant);
  line(len, 0, len - arrowConstant, arrowConstant);
  popMatrix();
}

void loadData () {
  // load the csv into a table
  table = loadTable(path+p_id+"_hc_"+haptic_condition+"/"+fileName+".csv", "header");

  // cycle through data
  for (TableRow row : table.rows()) {
    // if drawing an overall trial
    if (overallTrial > -1) {
      // if we are the current trial
      if (row.getInt("trial_id") == overallTrial) {
        xPositions.append(convertRangeX(row.getFloat("x_pos")));
        yPositions.append(convertRangeY(row.getFloat("y_pos")));
        xForces.append(row.getFloat("x_force"));
        yForces.append(row.getFloat("y_force"));
        totalDataPoints ++;
      }
    }
    // else drawing a specific letter's trial
    else {
      // nothing here yet. Fairly trivial to write when I have time
    }
  } // end cycle through data
} // end loadData

void drawData () {
  // no animate so draw all at once
  // iterate through values to get min and max force colors
  for (int i=0; i<totalDataPoints; i++) {
    currXPos = xPositions.remove(0);
    currYPos = yPositions.remove(0);
    currXForce = xForces.remove(0);
    currYForce = yForces.remove(0);
    drawArrow(currXPos, currYPos, arrowLength, atan(currYForce/currXForce), getVector(currXForce, currYForce));
  }
} // end drawData

void getColorRange () {
  // goes through all points to plot and determines the min and max force applied.
  for (int i=0; i<totalDataPoints; i++) {
    float tempForce = getVector(xForces.get(i), yForces.get(i));
    if (i == 0) {
      minColorVal = tempForce;
      maxColorVal = tempForce;
    }
    // else test
    else {
      if (tempForce < minColorVal) {
        minColorVal = tempForce;
      } else if (tempForce > maxColorVal) {
        maxColorVal = tempForce;
      }
    }
  }
} // end getColorRange

// gets vector(hypoteneuse) from x and y values
float getVector (float x, float y) {
  return (sqrt(pow(x, 2)+pow(y, 2)));
} // end getVector

// get color that will be used for the arrow stroke
color getColor (float vector) {
  float saturation = convertColorRange(vector);
  color returnColor = color(100, saturation, 100);
  return returnColor;
}

// convert from the haptic sketch x range to this drawing sketch range
float convertRangeX(float f) {
  int OldXRange = (OldXMax - OldXMin);
  int NewXRange = (NewXMax - NewXMin);
  return (((f - OldXMin) * NewXRange) / OldXRange) + NewXMin;
} // end convertRange

// convert from the haptic sketch y range to this drawing sketch range
float convertRangeY(float f) {
  int OldYRange = (OldYMax - OldYMin); 
  int NewYRange = (NewYMax - NewYMin);
  return (((f - OldYMin) * NewYRange) / OldYRange) + NewYMin;
} // end convertRange

// convert the color range so that we can take a vector and see where it falls within the min/max range
// returns a float [0-100]
float convertColorRange (float f) {
  float OldRange = (maxColorVal - minColorVal); 
  float NewRange = (100.0 - 0.0);
  return (((f - minColorVal) * NewRange) / OldRange) + 0.0;
} // convertColorRange
