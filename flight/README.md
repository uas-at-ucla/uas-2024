
# uas-2024/flight
---
### Prerequisites
+ If you are on a Windows system, you will have to either (1) *dual-boot Linux!!!!* or (2) install [Windows Subsystem for Linux (WSL)](https://learn.microsoft.com/en-us/windows/wsl/install).
+ Ensure you have Python and [Git](https://git-scm.com/downloads) installed.
+ Install the python requirements by navigating to this folder and running `pip3 install -r requirements.txt`.
+ Clone the repository by running `git clone https://github.com/uas-at-ucla/uas-2024` in your terminal.

### PX4 Autopilot
PX4 is the autopilot controller for the drone. Below are the installation links for each OS:
+ [Mac](https://docs.px4.io/main/en/dev_setup/dev_env_mac.html)
  + Mac users with an M1 or chip or above require extra installation steps, see **ARM 64 Processors**
    + Follow the installation steps given in the link above specifically for the jMAVSim Simulation.
+ [Windows](https://docs.px4.io/main/en/dev_setup/dev_env_windows_wsl.html) (Skip the "Flashing" section at the bottom)
+ [Linux](https://docs.px4.io/main/en/dev_setup/building_px4.html) (Only the "Simulation and NuttX (Pixhawk) Targets" section)
  + Linux users using computers with ARM64 processors require extra installation steps, see **ARM 64 Processors**
    + Follow the installation steps given in the link above specifically for the jMAVSim Simulation.

**ARM64 Processors** 

After following the installation steps given by the PX4 documentation:
+ Install [gluegen](https://jogamp.org/chuck/job/gluegen), [jogl](https://jogamp.org/chuck/view/fwd/job/jogl), and [joal](https://jogamp.org/chuck/view/fwd/job/joal).
  + Mac users install `macos-x86_64`
  + Linux users install `linux-arm64`
  + Compatible versions of these libraries are not present during the build process so a replacement is necessary.
+ Within the PX4-Autopilot folder navigate to `Tools/simulation/jmavsim/jMAVSim/lib`
+ Replace all relevant .jar files that contain the same name as the installed libraries with ones found in the `jar` folder of the unzipped files.
  
execute `make px4_sitl jmavsim`
+ If you are getting a `java.lang.reflect.InovcationTargetException` try executing `make clean` then re-executing `make px4_sitl jmavsim`

### QGroundControl
QGroundControl is our Ground Control Station (GCS). You can install it [here](https://docs.qgroundcontrol.com/master/en/getting_started/download_and_install.html).
Note that Windows users should have installed this in the previous step.

### MAVSDK
MAVSDK is the Python library used to communicate with the autopilot system. Install it with:
```bash
pip3 install mavsdk
```

**For M1 MacOS Users**

If you are using MacOS with an ARM64 Processor, a manual installation of MAVSDK-Python is required:
+ First clone the MAVSDK-Python library:
```bash
git clone https://github.com/mavlink/MAVSDK-Python/ --recursive
```
+ Next, determine what version of python you have installed through:
```bash
python3 -V
```
  + For example if it returns `Python 3.11.6`, you are using Python version 3.11.
+ Finally, you must move the physical library folder into your Python library folder:
  + Make sure you're in the directory that contains the recently cloned MAVSDK-Python folder.
```bash
mv MAVSDK-Python/mavsdk /opt/homebrew/lib/python[your-python-version]/site-packages
```

### Test Installation
First, start QGroundControl. Then navigate to the `PX4-Autopilot` directory, and run one of the following commands based on which simulation environment you want to use:
+ Gazebo: `make px4_sitl gz_x500`
+ Gazebo Classic: `make px4_sitl gazebo-classic`
+ jMAVSim (Use this one if none of the above worked): `make px4_sitl jmavsim`

You should see a simulation window appear, as well as the drone appear in QGroundControl.

**MacOS Requirements**

If you are using MacOS with an ARM64 Processor, a physical install of the MAVSDK server is required:
+ Navigate to the [MAVSDK releases](https://github.com/mavlink/MAVSDK/releases).
+ Install the file labeled, `mavsdk_server_macos`
+ Next run a command to make it an executable
```bash
chmod +x mavsdk_server_macos
```
+ Before running any MAVSDK-Python missions you must do the following:
```bash
./mavsdk_server_macos -p 50051
```
 + You must also specify the port in the Python code:
```python
# Change this:
drone = System()
# To this:
drone = System(mavsdk_server_address="localhost", port= 50051)
```

**Running Example Code**

Then, navigate to this directory (`/flight`) and run:
```bash
python example_mission.py
```
The drone should move around in both the simulation window and QGroundControl.
