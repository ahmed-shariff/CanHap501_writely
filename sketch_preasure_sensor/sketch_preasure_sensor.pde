import com.phidget22.*;

VoltageRatioInput voltageRatioInput0;


void setup()
{
  size(480, 120);

	try
	{
			voltageRatioInput0 = new VoltageRatioInput();
			voltageRatioInput0.setIsHubPortDevice(true);
			voltageRatioInput0.setHubPort(0);

			voltageRatioInput0.addSensorChangeListener(new VoltageRatioInputSensorChangeListener() {
							public void onSensorChange(VoltageRatioInputSensorChangeEvent e) {
									System.out.println("SensorValue: " + e.getSensorValue());
									System.out.println("SensorUnit: " + e.getSensorUnit().symbol);
									System.out.println("----------");
							}
					});

			voltageRatioInput0.open(5000);

			voltageRatioInput0.setSensorType(VoltageRatioSensorType.PN_1120);
	}
	catch(PhidgetException e)
	{
			
	}
}

void draw()
{
  if (mousePressed)
	{
    fill(0);
  } else
	{
    fill(255);
  }
  ellipse(mouseX, mouseY, 80, 80);
}

void exit()
{
		try
		{
				voltageRatioInput0.close();
		}
		catch(PhidgetException e)
		{
			
		}
}
