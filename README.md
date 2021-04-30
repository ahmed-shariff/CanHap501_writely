### Writely

This repository contains the code for the group project for the [CanHap501](https://wiki.canhaptics.ca) course our team: phantom (@bradleyrrr, @joshibibhushan & @ahmed-shariff)

We were tasked with using the [haply device](https://www.haply.co) (remeber to look here as well: [https://2diy.haply.co](https://2diy.haply.co)) to develop a haptic system. Our goal was to develop a system to train writing with the non dominant hand using the haply device. The blog posts each one of us wrote as part of the course work are listed below:

- Iteration 1:
  - [Bradley's blog post](https://bradleyrrr.github.io/sample/pi1.html)
  - [Bibhushan's blog post](https://joshibibhushan.medium.com/writely-iteration-1-438068380fcc)
  - [Shariff's blog post](https://ahmed-shariff.github.io/2021/03/08/canhap_writely_i1/)

- Iteration 2:
  - [Bradley's blog post](https://bradleyrrr.github.io/sample/pi2.html)
  - [Bibhushan's blog post](https://joshibibhushan.medium.com/writely-iteration-2-d945c0f5e91d)
  - [Shariff's blog post](https://ahmed-shariff.github.io/2021/03/29/canhap_writel_i2/)
  
  
This repository contains all the different things we tried (with the messy history of how we did it). The sketch `sketch_haptics_guidence` contains the version which was used in our studies, which can be downloaded from the [releases](https://github.com/ahmed-shariff/CanHap501_writely/releases/tag/1.0).

In the spirit of avoiding uploading binaries, you can follow the steps in the section [To setup sketch](#to-setup-sketches) to download the files necessary and setup the environments.

##### Directory structure
Each `sketch_<something>` directory contains a different sketch.
The `Test` directory contains test scripts
The `Code` directory has the different `jar` files that will be linked to each sketch by `processing-config` (see below).
Same goes to the `.java` files in the root directory.

##### To setup sketches
Every-time you setup a new sketch, you can run the [processing-config](https://github.com/ahmed-shariff/processing_config) command to configure the sketches dependencies (basically linking to the files listed in `files_list.csv`)


###### Using poetry
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

###### Without poetry
Use the `requirements.txt` file to install the dependencies and run the following:
```bash
processing-config
```

##### To Setup phidget sensor
 Follow instruction from [https://www.phidgets.com/](https://www.phidgets.com/docs/Main_Page)
 
 To make sure the devices are working, check if the test results in errors (You might have to change the deivce parameters in the `test/Test_Phidget.java` file):
 
 ```bash
 make test-phidget
 ```
