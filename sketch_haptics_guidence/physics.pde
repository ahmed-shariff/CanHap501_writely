/* library imports *****************************************************************************************************/ 
import processing.serial.*;
import static java.util.concurrent.TimeUnit.*;
import java.util.concurrent.*;
/* end library imports *************************************************************************************************/  



/* scheduler definition ************************************************************************************************/ 
private final ScheduledExecutorService scheduler      = Executors.newScheduledThreadPool(1);
/* end scheduler definition ********************************************************************************************/ 



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
float             pixelsPerCentimeter                 = 20.0;

/* generic data for a 2DOF device */
/* joint space */
PVector           angles                              = new PVector(0, 0);
PVector           torques                             = new PVector(0, 0);

/* task space */
PVector           posEE                               = new PVector(0, 0);
PVector           fEE                                 = new PVector(0, 0); 

/* World boundaries */
FWorld            world;
float             worldWidth                          = 15;  
float             worldHeight                         = 10; 

float             edgeTopLeftX                        = 0.0; 
float             edgeTopLeftY                        = 0.0; 
float             edgeBottomRightX                    = worldWidth; 
float             edgeBottomRightY                    = worldHeight;

float             gravityAcceleration                 = 980; //cm/s2
/* Initialization of virtual tool */
HVirtualCoupling  s;

/* text font */
PFont             f;

/* end elements definition *********************************************************************************************/  



/* setup section *******************************************************************************************************/
void PhysicsSetup(){
		/* put setup code here, run once: */
    
		/* set font type and size */
		f                   = createFont("Arial", 16, true);

  
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
		haplyBoard          = new Board(this, "/dev/cu.usbmodem143201", 0);
		widgetOne           = new Device(widgetOneID, haplyBoard);
		pantograph          = new Pantograph();
  
		widgetOne.set_mechanism(pantograph);

		widgetOne.add_actuator(1, CCW, 2);
		widgetOne.add_actuator(2, CW, 1);
 
		widgetOne.add_encoder(1, CCW, 241, 10752, 2);
		widgetOne.add_encoder(2, CW, -61, 10752, 1);
  
  
		widgetOne.device_set_parameters();
  
  
		/* 2D physics scaling and world creation */
		hAPI_Fisica.init(this);
		//RG.init(this);
		hAPI_Fisica.setScale(pixelsPerCentimeter); 
		world               = new FWorld();

		// Calling definitions from the main file.
		PhysicsDefinitions();  
		/* Setup the Virtual Coupling Contact Rendering Technique */
		s                   = new HVirtualCoupling((0.75)); 
		s.h_avatar.setDensity(4); 
		s.h_avatar.setFill(255,0,0); 
		s.h_avatar.setSensor(true);

		s.init(world, edgeTopLeftX+worldWidth/2, edgeTopLeftY+2); 
  
		/* World conditions setup */
		// world.setGravity((0.0), gravityAcceleration); //1000 cm/(s^2)
		// world.setEdges((edgeTopLeftX), (edgeTopLeftY), (edgeBottomRightX), (edgeBottomRightY)); 
		// world.setEdgesRestitution(.4);
		// world.setEdgesFriction(0.5);
 
		world.draw();  
  
		/* setup framerate speed */
		frameRate(baseFrameRate);
    
		/* setup simulation thread to run at 1kHz */
		SimulationThread st = new SimulationThread();
		scheduler.scheduleAtFixedRate(st, 1, 1, MILLISECONDS);
}
/* end setup section ***************************************************************************************************/



/* draw section ********************************************************************************************************/
void draw(){
		/* put graphical code here, runs repeatedly at defined framerate in setup, else default at 60fps: */
		if(renderingForce == false){
				background(255);
				textFont(f, 22);
 
				drawLoop();
  
				world.draw();
		}
}
/* end draw section ****************************************************************************************************/



/* simulation section **************************************************************************************************/
class SimulationThread implements Runnable{
  
		public void run(){
				/* put haptic simulation code here, runs repeatedly at 1kHz as defined in setup */

				if (renderingForce)
						return;
				
				renderingForce = true;
    
				if(haplyBoard.data_available()){
						/* GET END-EFFECTOR STATE (TASK SPACE) */
						widgetOne.device_read_data();
    
						angles.set(widgetOne.get_device_angles()); 
						posEE.set(widgetOne.get_device_position(angles.array()));
						posEE.set(posEE.copy().mult(200));  
				}
    
				s.setToolPosition(-(posEE).x + posEE_XOffset, (posEE).y + posEE_YOffset);
				/// s.setToolPosition(edgeTopLeftX+worldWidth/2-(posEE).x, edgeTopLeftY+(posEE).y-7);
				s.updateCouplingForce();
 
 
				fEE.set(-s.getVirtualCouplingForceX(), s.getVirtualCouplingForceY());
				fEE.div(100000); //dynes to newtons

				PhysicsSimulations();
				
				torques.set(widgetOne.set_device_torques(fEE.array()));
				widgetOne.device_write_torques();
    
				world.step(1.0f/1000.0f);
  
				renderingForce = false;
		}
}
/* end simulation section **********************************************************************************************/



/* helper functions section, place helper functions here ***************************************************************/


void PhysicsExit()
{
		exitCalled = true;
		println("Executing exit");
		
		// rying to make sure that the device's torques are set to 0
		widgetOne.device_set_parameters();
		widgetOne.set_device_torques(new float[]{0, 0});
		widgetOne.device_write_torques();
}
/* end helper functions section ****************************************************************************************/
