/* --------------------------------------------- UPDATE UPDATE UPDATE ***** FOR EACH STUDY AND PER MACHINE ***** UPDATE UPDATE UPDATE --------------------------------------------- */
final String RESULT_PATH = "/Users/bradleyrey/Documents/UofM/Grad_School/UBC/Project/Code/final_code/CanHap501_writely/data/"; // path where the data will be stored
/* --------------------------------------------- UPDATE UPDATE UPDATE ***** FOR EACH STUDY AND PER MACHINE ***** UPDATE UPDATE UPDATE --------------------------------------------- */

// other constants for file naming convention
final int day = day(); // get the current day (int from 1-31)
final int hour = hour(); // get the current hour (int from 0-24)
final int minute = minute(); // get the current minute (int from 0-59)

final String studyDate = day+"-"+hour+"-"+minute; // put date together to use in final name so that we know which study block was done when


// ==============================Write Main File ===================================
void writeFile(String message){
  println("writing to file");
  boolean newFile = false;
  // if file exists, read already stored content and store in lines array
  String[] lines = null;
  // file name must contain the entire directory - this goes into a folder named for example <pid_0> for participant 0
  // file name is then the studyDate.csv, for example <11-13-24.csv>
  String file_name = RESULT_PATH + "pid_" + currentStudy.getP_id() + "_hc_" + currentStudy.getHaptic_condition() + "/"+studyDate + ".csv"; // file names look like for example 'pid_1/condition_guidance.csv'
  File f = new File(dataPath(file_name));
  // if file exists grab all previous lines
  if (f.exists()) {
    lines = loadStrings(file_name);
  }
  // else new file
  else {
    newFile = true;
  }
  
  // open file and copy old data to the file 
  PrintWriter output = createWriter(file_name);
  if (f.exists() && lines!=null){
    for (int i = 0; i < lines.length; i++)   output.println(lines[i]);
  }
  
  if (newFile) {
    // add header labels
    // p_id - participant id
    // haptic_id - the id for which haptic experience given
    // letter_id - current letter id
    // trial_id - current trial of a given letter
    // start_trial_time - the start time of the start of writing for the letter
    // curr_trial_time - the current time during the trial
    // total_trial_time - curr_trial_time - start_trial_time to get total amount of time taken
    // x_pos - current end effector x position
    // y_pos - current end effector y position
    // speed - current end effector speed
    // acceleration - current end effector acceleration
    // jerk - current end effector jerk
    // x_force - force in the x direction on the end effector
    // y_force - force in the y direction on the end effector
    output.println("p_id,haptic_id,letter_id,trial_id,start_trial_time,curr_trial_time,total_trial_time,x_pos,y_pos,speed,acceleration,jerk,x_force,y_force");
  }
  
  //// append new message
  output.println(message);   
  output.flush();
  output.close();
}
