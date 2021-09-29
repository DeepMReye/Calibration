[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](http://www.gnu.org/licenses/gpl-3.0)
[![NatNeuro Paper](https://img.shields.io/badge/DOI-10.XXXX%2FsXXXXX--XXX--XXXX--X-blue)](https://doi.org/XXX/XXX)

![Logo](https://github.com/DeepMReye/DeepMReye/media/deepmreye_logo.png)

# Experimental code to acquire training data for DeepMReye
This is a collection of scripts that allows acquiring training data for DeepMReye.

[Click here for user recommendations](https://deepmreye.slite.com/p/channel/MUgmvViEbaATSrqt3susLZ/notes/kKdOXmLqe).

[Click here for the Frequently-Asked-Questions (FAQ) page](https://deepmreye.slite.com/p/channel/MUgmvViEbaATSrqt3susLZ/notes/sargIAQ6t).

## How to use
1) Install [MATLAB](https://matlab.mathworks.com) and [Psychtoolbox](http://psychtoolbox.org)
2) Clone this repository
```
git clone https://github.com/DeepMReye/Calibration.git
cd Calibration
```
3) Open the script "Start_deepMReye_calib.m"
4) Adjust settings to your needs
5) Paste "Start_deepMReye_calib('test', 1)" into MATLAB command window 
6) Click "enter"

## Content
The experiment comprises 3 conditions presented in the following order.

1) Fixations: The fixation cross will jump to various screen locations.
2) Smooth pursuit: The fixation cross will move smoothly at various speeds on a random-walk trajectory with defined directional sampling.
3) Free viewing of images (recommended only if camera-based eye tracking is available).

The video below shows a shortened example of how the experiment looks. It may look slightly different for you depending on your display settings.

![calibration script](media/ptb_stimulus.gif)

At the top of the hierarchy is the script "Start_deepMReye_calib.m". It contains the screen settings (e.g. resolution, display size etc.) as well the task settings (e.g. how many fixation locations should be tested, how many images would you like to show etc.). These settings are then forwarded to "deepMReye_calib.m", which does the main work.

MRI scanner triggers are being collected and all settings, triggers and experimental time stamps are stored in a log file.

## Camera-based eye tracking
The code supports the camera-based eye tracker [Eyelink 1000 plus](https://www.sr-research.com/eyelink-1000-plus/). Note that camera-based eye tracking is not required to train DeepMReye, but that it can improve model performance especially for free-viewing paradigms.

## This is a template - adjust the code to your needs
The type of training data you need depends on your study objectives - Please adjust these scripts accordingly!
See the paper, user recommendations and FAQ page for details. 

In short, the more similar the viewing behavior is between your training data and the data you are trying to analyze, the better.