##### Directory structure
Each `sketch_<something>` directory contains a different sketch.
The `Test` directory contains test scripts
The `Code` directory has the different `jar` files that will be linked to each sketch by `processing-config` (see below).
Same goes to the `.java` files in the root directory.

##### To setup sketches

First run:

```bash
pip install -r requirements.txt
```

Then execute:
```bash
processing-config
```

##### To Setup phidget sensor
 Follow instruction from [https://www.phidgets.com/docs/Main_Page](https://www.phidgets.com/)
 
 To make sure the devices are working, check if the test results in errors (You might have to change the deivce parameters in the `test/Test_Phidget.java` file):
 
 ```bash
 make test-phidget
 ```
