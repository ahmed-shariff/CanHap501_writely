##### Directory structure
Each `sketch_<something>` directory contains a different sketch.
The `Test` directory contains test scripts
The `Code` directory has the different `jar` files that will be linked to each sketch by `processing-config` (see below).
Same goes to the `.java` files in the root directory.

##### To setup sketches

Make sure you have [poetry](https://python-poetry.org)
First run:

```bash
poetry install
```

Then execute:
```bash
poetry shell
```
Which should drop you into the with the python virtual environment setup. Then run the following to configure the projects.
```bash
processing-config
```

Everytime you setup a new sketch, you can run the [processing-config](https://github.com/ahmed-shariff/processing_config) command to configure the sketches dependencies (basically linking to the files listed in `files_list.csv`)


##### To Setup phidget sensor
 Follow instruction from [https://www.phidgets.com/](https://www.phidgets.com/docs/Main_Page)
 
 To make sure the devices are working, check if the test results in errors (You might have to change the deivce parameters in the `test/Test_Phidget.java` file):
 
 ```bash
 make test-phidget
 ```
