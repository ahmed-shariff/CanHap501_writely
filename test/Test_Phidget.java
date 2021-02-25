import com.phidget22.*;
import java.util.Scanner; //Required for Text Input
import java.io.IOException;

public class Test_Phidget {

	public static void main(String[] args) throws Exception {
		VoltageRatioInput voltageRatioInput0 = new VoltageRatioInput();

		voltageRatioInput0.setIsHubPortDevice(true);
		voltageRatioInput0.setHubPort(0);

		voltageRatioInput0.addSensorChangeListener(new VoltageRatioInputSensorChangeListener() {
			public void onSensorChange(VoltageRatioInputSensorChangeEvent e) {
				System.out.println("SensorValue: " + e.getSensorValue());
				System.out.println("SensorUnit: " + e.getSensorUnit().symbol);
				System.out.println("Press enter to finish");
				System.out.println("----------");
			}
		});

		voltageRatioInput0.open(5000);

		voltageRatioInput0.setSensorType(VoltageRatioSensorType.PN_1120);

		//Wait until Enter has been pressed before exiting
		System.in.read();

		voltageRatioInput0.close();
	}
}
