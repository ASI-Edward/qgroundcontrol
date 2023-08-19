/****************************************************************************
 *
 *   (c) 2009-2016 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick                      2.11
import QtQuick.Controls             2.4
import QtQml.Models                 2.1

import QGroundControl               1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.Controls      1.0
import QGroundControl.FlightDisplay 1.0
import QGroundControl.Vehicle       1.0

Item {

    property var model: listModel

    PreFlightCheckModel {
        id:     listModel

        PreFlightCheckGroup {
            name: qsTr("Environment Checklist")

            PreFlightCheckButton {
                name:           qsTr("Wind & weather")
                manualText:     qsTr("Is the weather suitable for flight?" + (_customFunction.getPrecipitation() === "" ? (" Probability of Precipitation data unavailable.") : (" Probability of Precipitation: " + _customFunction.getPrecipitation() + "%")))
                _manualState:   _activeVehicle.checkListState === Vehicle.CheckListPassed ? 2 : (_customFunction.getCheckState(0) === true ? 2 : 0)
                checkId:        0
            }

            PreFlightCheckButton {
                name:           qsTr("Takeoff area")
                manualText:     qsTr("Is the take-off area clear?")
                _manualState:   _activeVehicle.checkListState === Vehicle.CheckListPassed ? 2 : (_customFunction.getCheckState(1) === true ? 2 : 0)
                checkId:        1
            }

            PreFlightCheckButton {
                name:           qsTr("No-Fly Zone")
                manualText:     qsTr("Ensure that the flight route does not coincide with a No-Fly Zone.")
                _manualState:   _activeVehicle.checkListState === Vehicle.CheckListPassed ? 2 : (_customFunction.getCheckState(2) === true ? 2 : 0)
                checkId:        2
            }

            PreFlightCheckButton {
                name:           qsTr("Landing area")
                manualText:     qsTr("Is the pre-set landing area safe for landing?")
                _manualState:   _activeVehicle.checkListState === Vehicle.CheckListPassed ? 2 : (_customFunction.getCheckState(3) === true ? 2 : 0)
                checkId:        3
            }

            PreFlightCheckButton {
                name:           qsTr("No interference")
                manualText:     qsTr("Check the surrounding for radio towers, electrical wires and metallic objects for possible interference.")
                _manualState:   _activeVehicle.checkListState === Vehicle.CheckListPassed ? 2 : (_customFunction.getCheckState(4) === true ? 2 : 0)
                checkId:        4
            }

            PreFlightCheckButton {
                name:           qsTr("Flight area")
                manualText:     qsTr("Ensure that there are no people/obstacles within the flight area.")
                _manualState:   _activeVehicle.checkListState === Vehicle.CheckListPassed ? 2 : (_customFunction.getCheckState(5) === true ? 2 : 0)
                checkId:        5
            }
        }

        PreFlightCheckGroup {
            name: qsTr("Power System Checklist")

            PreFlightCheckButton {
                name:           qsTr("Batteries identification")
                manualText:     qsTr("Identify battery that is going to be used for the operation.")
                _manualState:   _activeVehicle.checkListState === Vehicle.CheckListPassed ? 2 : (_customFunction.getCheckState(6) === true ? 2 : 0)
                checkId:        6
            }

            PreFlightCheckButton {
                name:           qsTr("Battery condition")
                manualText:     qsTr("Is the battery in good condition (visible defects)?")
                _manualState:   _activeVehicle.checkListState === Vehicle.CheckListPassed ? 2 : (_customFunction.getCheckState(7) === true ? 2 : 0)
                checkId:        7
            }

            PreFlightCheckButton {
                name:           qsTr("Battery health")
                manualText:     qsTr("Are the cells in the battery in good health and balanced?")
                _manualState:   _activeVehicle.checkListState === Vehicle.CheckListPassed ? 2 : (_customFunction.getCheckState(8) === true ? 2 : 0)
                checkId:        8
            }

            PreFlightCheckButton {
                name:           qsTr("Batteries power")
                manualText:     qsTr("Are the batteries (RC, GCS, UAV) fully charged/have enough power for operation?")
                _manualState:   _activeVehicle.checkListState === Vehicle.CheckListPassed ? 2 : (_customFunction.getCheckState(9) === true ? 2 : 0)
                checkId:        9
            }

            PreFlightCheckButton {
                name:           qsTr("RC Transmitter and GCS Software")
                manualText:     qsTr("Turn ON RC Transmitter and GCS software.")
                _manualState:   _activeVehicle.checkListState === Vehicle.CheckListPassed ? 2 : (_customFunction.getCheckState(10) === true ? 2 : 0)
                checkId:        10
            }
        }

        PreFlightCheckGroup {
            name: qsTr("UAV Checklist")

            PreFlightCheckButton {
                name:           qsTr("Place UAV")
                manualText:     qsTr("Place the UAV on a level surface (takeoff location).")
                _manualState:   _activeVehicle.checkListState === Vehicle.CheckListPassed ? 2 : (_customFunction.getCheckState(11) === true ? 2 : 0)
                checkId:        11
            }

            PreFlightCheckButton {
                name:           qsTr("Nose direction")
                manualText:     qsTr("Check that the UAV nose is facing forward.")
                _manualState:   _activeVehicle.checkListState === Vehicle.CheckListPassed ? 2 : (_customFunction.getCheckState(12) === true ? 2 : 0)
                checkId:        12
            }

            PreFlightCheckButton {
                name:           qsTr("Unfold UAV")
                manualText:     qsTr("Unfold the UAV.")
                _manualState:   _activeVehicle.checkListState === Vehicle.CheckListPassed ? 2 : (_customFunction.getCheckState(13) === true ? 2 : 0)
                checkId:        13
            }

            PreFlightCheckButton {
                name:           qsTr("UAV condition")
                manualText:     qsTr("UAV (arm, props and frame) in good condition?")
                _manualState:   _activeVehicle.checkListState === Vehicle.CheckListPassed ? 2 : (_customFunction.getCheckState(14) === true ? 2 : 0)
                checkId:        14
            }

            PreFlightCheckButton {
                name:           qsTr("Motors & Propellers")
                manualText:     qsTr("Check that the motors turn easily without any abnormal sounds by manually spinning them.")
                _manualState:   _activeVehicle.checkListState === Vehicle.CheckListPassed ? 2 : (_customFunction.getCheckState(15) === true ? 2 : 0)
                checkId:        15
            }

            PreFlightCheckButton {
                name:           qsTr("UAV Power ON")
                manualText:     qsTr("Power ON the UAV.")
                _manualState:   _activeVehicle.checkListState === Vehicle.CheckListPassed ? 2 : (_customFunction.getCheckState(16) === true ? 2 : 0)
                checkId:        16
            }

            PreFlightCheckButton {
                name:           qsTr("Flight connections")
                manualText:     qsTr("Is the connection between the flight controller, remote control and GCS established?")
                _manualState:   _activeVehicle.checkListState === Vehicle.CheckListPassed ? 2 : (_customFunction.getCheckState(17) === true ? 2 : 0)
                checkId:        17
            }

            PreFlightCheckButton {
                name:           qsTr("Verify flight modes")
                manualText:     qsTr("Verify flight modes. (Stabilize, Alt hold, Loiter).")
                _manualState:   _activeVehicle.checkListState === Vehicle.CheckListPassed ? 2 : (_customFunction.getCheckState(18) === true ? 2 : 0)
                checkId:        18
            }

            PreFlightCheckButton {
                name:           qsTr("Failsafe settings")
                manualText:     qsTr("Failsafe settings (battery, radio etc.) double-checked?")
                _manualState:   _activeVehicle.checkListState === Vehicle.CheckListPassed ? 2 : (_customFunction.getCheckState(19) === true ? 2 : 0)
                checkId:        19
            }

            PreFlightCheckButton {
                name:           qsTr("SD card")
                manualText:     qsTr("Is the SD card (flight controller, camera etc.) installed?")
                _manualState:   _activeVehicle.checkListState === Vehicle.CheckListPassed ? 2 : (_customFunction.getCheckState(20) === true ? 2 : 0)
                checkId:        20
            }

            PreFlightCheckButton {
                name:           qsTr("No pre-arm issue")
                manualText:     qsTr("No pre-arm safety issue?")
                _manualState:   _activeVehicle.checkListState === Vehicle.CheckListPassed ? 2 : (_customFunction.getCheckState(21) === true ? 2 : 0)
                checkId:        21
            }
        }

        PreFlightCheckGroup {
            name: qsTr("Peripheral Checklist")

            PreFlightCheckButton {
                name:           qsTr("GPS antenna direction")
                manualText:     qsTr("GPS antenna heading pointing along the nose of the UAV?")
                _manualState:   _activeVehicle.checkListState === Vehicle.CheckListPassed ? 2 : (_customFunction.getCheckState(22) === true ? 2 : 0)
                checkId:        22
            }

            PreFlightCheckButton {
                name:           qsTr("GPS")
                manualText:     qsTr("GPS HDOP<2 and have GPS 3D Lock?")
                _manualState:   _activeVehicle.checkListState === Vehicle.CheckListPassed ? 2 : (_customFunction.getCheckState(23) === true ? 2 : 0)
                checkId:        23
            }

            PreFlightCheckButton {
                name:           qsTr("Vibration")
                manualText:     qsTr("Vibration low?")
                _manualState:   _activeVehicle.checkListState === Vehicle.CheckListPassed ? 2 : (_customFunction.getCheckState(24) === true ? 2 : 0)
                checkId:        24
            }

            PreFlightCheckButton {
                name:           qsTr("Data and video links")
                manualText:     qsTr("Data and video links are still operational and indication gauges are working properly?")
                _manualState:   _activeVehicle.checkListState === Vehicle.CheckListPassed ? 2 : (_customFunction.getCheckState(25) === true ? 2 : 0)
                checkId:        25
            }

            PreFlightCheckButton {
                name:           qsTr("Motor emergency stop")
                manualText:     qsTr("Is the Motor Emergency Stop ON?")
                _manualState:   _activeVehicle.checkListState === Vehicle.CheckListPassed ? 2 : (_customFunction.getCheckState(26) === true ? 2 : 0)
                checkId:        26
            }

            PreFlightCheckButton {
                name:           qsTr("Payload actuators")
                manualText:     qsTr("Payload actuators (If applicable) working properly?")
                _manualState:   _activeVehicle.checkListState === Vehicle.CheckListPassed ? 2 : (_customFunction.getCheckState(27) === true ? 2 : 0)
                checkId:        27
            }
        }

        PreFlightCheckGroup {
            name: qsTr("Mission Start Checklist")

            PreFlightCheckButton {
                name:           qsTr("Crew Position")
                manualText:     qsTr("Check that the crew are in their designated position.")
                _manualState:   _activeVehicle.checkListState === Vehicle.CheckListPassed ? 2 : (_customFunction.getCheckState(28) === true ? 2 : 0)
                checkId:        28
            }

            PreFlightCheckButton {
                name:           qsTr("Safe distance")
                manualText:     qsTr("Check that the members of the public are at a safe distance away from the operation area.")
                _manualState:   _activeVehicle.checkListState === Vehicle.CheckListPassed ? 2 : (_customFunction.getCheckState(29) === true ? 2 : 0)
                checkId:        29
            }

            PreFlightCheckButton {
                name:           qsTr("Clear airspace")
                manualText:     qsTr("Check that the airspace is clear.")
                _manualState:   _activeVehicle.checkListState === Vehicle.CheckListPassed ? 2 : (_customFunction.getCheckState(30) === true ? 2 : 0)
                checkId:        30
            }

            PreFlightCheckButton {
                name:           qsTr("Mission briefing verification")
                manualText:     qsTr("Is the mission briefing verification done?")
                _manualState:   _activeVehicle.checkListState === Vehicle.CheckListPassed ? 2 : (_customFunction.getCheckState(31) === true ? 2 : 0)
                checkId:        31
            }

            PreFlightCheckButton {
                name:           qsTr("Waypoints")
                manualText:     qsTr("Waypoints uploaded?")
                _manualState:   _activeVehicle.checkListState === Vehicle.CheckListPassed ? 2 : (_customFunction.getCheckState(32) === true ? 2 : 0)
                checkId:        32
            }

            PreFlightCheckButton {
                name:           qsTr("Emergency stop switch")
                manualText:     qsTr("Emergency stop switch in the OFF position?")
                _manualState:   _activeVehicle.checkListState === Vehicle.CheckListPassed ? 2 : (_customFunction.getCheckState(33) === true ? 2 : 0)
                checkId:        33
            }

            PreFlightCheckButton {
                name:           qsTr("Current flight mode")
                manualText:     qsTr("Verify current flight mode.")
                _manualState:   _activeVehicle.checkListState === Vehicle.CheckListPassed ? 2 : (_customFunction.getCheckState(34) === true ? 2 : 0)
                checkId:        34
            }

            PreFlightCheckButton {
                name:           qsTr("Safe to begin")
                manualText:     qsTr("Check with the observer that it is safe to begin operation.")
                _manualState:   _activeVehicle.checkListState === Vehicle.CheckListPassed ? 2 : (_customFunction.getCheckState(35) === true ? 2 : 0)
                checkId:        35
            }

            PreFlightCheckButton {
                name:           qsTr("Arm UAS")
                manualText:     qsTr("Call \"Clear Props\".")
                _manualState:   _activeVehicle.checkListState === Vehicle.CheckListPassed ? 2 : (_customFunction.getCheckState(36) === true ? 2 : 0)
                checkId:        36
            }

            PreFlightCheckButton {
                name:           qsTr("Arm and Joystick")
                manualText:     qsTr("ARM and set joysticks to the middle.")
                _manualState:   _activeVehicle.checkListState === Vehicle.CheckListPassed ? 2 : (_customFunction.getCheckState(37) === true ? 2 : 0)
                checkId:        37
            }

            PreFlightCheckButton {
                name:           qsTr("Motors & Propellers")
                manualText:     qsTr("Check if all the motors are spinning.")
                _manualState:   _activeVehicle.checkListState === Vehicle.CheckListPassed ? 2 : (_customFunction.getCheckState(38) === true ? 2 : 0)
                checkId:        38
            }

            PreFlightCheckButton {
                name:           qsTr("BEGIN operation.")
                manualText:     qsTr("The mission can now be started.")
                _manualState:   _activeVehicle.checkListState === Vehicle.CheckListPassed ? 2 : (_customFunction.getCheckState(39) === true ? 2 : 0)
                checkId:        39
            }
        }
    }
}

