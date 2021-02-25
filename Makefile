
test-phidget:
	cd test && javac -classpath ../code/phidget22.jar Test_Phidget.java && pwd && java -classpath ../code/phidget22.jar Test_Phidget.java
