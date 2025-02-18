/****************************************************************************
 *
 * (c) 2009-2019 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 * @file
 *   @author Gus Grubba <gus@auterion.com>
 */

import QtQuick          2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts  1.11

import QGroundControl               1.0
import QGroundControl.Controls      1.0
import QGroundControl.Palette       1.0
import QGroundControl.ScreenTools   1.0

import Custom.Widgets 1.0

Item {
    property var parentToolInsets                       // These insets tell you what screen real estate is available for positioning the controls in your overlay
    property var totalToolInsets:   _totalToolInsets    // The insets updated for the custom overlay additions
    property var mapControl

    readonly property string noGPS:         qsTr("NO GPS")
    readonly property real   indicatorValueWidth:   ScreenTools.defaultFontPixelWidth * 7

    property var    _activeVehicle:         QGroundControl.multiVehicleManager.activeVehicle
    property real   _indicatorDiameter:     ScreenTools.defaultFontPixelWidth * 18
    property real   _indicatorsHeight:      ScreenTools.defaultFontPixelHeight
    property var    _sepColor:              qgcPal.globalTheme === QGCPalette.Light ? Qt.rgba(0,0,0,0.5) : Qt.rgba(1,1,1,0.5)
    property color  _indicatorsColor:       qgcPal.text
    property bool   _isVehicleGps:          _activeVehicle ? _activeVehicle.gps.count.rawValue > 1 && _activeVehicle.gps.hdop.rawValue < 1.4 : false
    property string _altitude:              _activeVehicle ? (isNaN(_activeVehicle.altitudeRelative.value) ? "0.0" : _activeVehicle.altitudeRelative.value.toFixed(1)) + ' ' + _activeVehicle.altitudeRelative.units : "0.0"
    property string _distanceStr:           isNaN(_distance) ? "0" : _distance.toFixed(0) + ' ' + QGroundControl.unitsConversion.appSettingsHorizontalDistanceUnitsString
    property real   _heading:               _activeVehicle   ? _activeVehicle.heading.rawValue : 0
    property real   _distance:              _activeVehicle ? _activeVehicle.distanceToHome.rawValue : 0
    property string _messageTitle:          ""
    property string _messageText:           ""
    property real   _toolsMargin:           ScreenTools.defaultFontPixelWidth * 0.75

    visible:                    true

    function secondsToHHMMSS(timeS) {
        var sec_num = parseInt(timeS, 10);
        var hours   = Math.floor(sec_num / 3600);
        var minutes = Math.floor((sec_num - (hours * 3600)) / 60);
        var seconds = sec_num - (hours * 3600) - (minutes * 60);
        if (hours   < 10) {hours   = "0"+hours;}
        if (minutes < 10) {minutes = "0"+minutes;}
        if (seconds < 10) {seconds = "0"+seconds;}
        return hours+':'+minutes+':'+seconds;
    }

    QGCToolInsets {
        id:                     _totalToolInsets
        topEdgeCenterInset:     compassArrowIndicator.y + compassArrowIndicator.height
        rightEdgeBottomInset:   parent.width - compassBackground.x
    }

    Rectangle {
        id:                     vehicleMessageView
        width:                  mainWindow.width * 0.3
        height:                 mainWindow.height * 0.5
        anchors.bottom:         parent.bottom
        anchors.right:          parent.right
        anchors.bottomMargin:   5
        anchors.rightMargin:    5
        radius:                 ScreenTools.defaultFontPixelHeight / 2
        color:                  qgcPal.window
        border.color:           qgcPal.text

        Connections {
            target: _activeVehicle
            onNewFormattedMessage :{
                function formatMessage(message) {
                    message = message.replace(new RegExp("<#E>", "g"), "color: " + qgcPal.warningText + "; font: " + (ScreenTools.defaultFontPointSize.toFixed(0) - 1) + "pt monospace;");
                    message = message.replace(new RegExp("<#I>", "g"), "color: " + qgcPal.warningText + "; font: " + (ScreenTools.defaultFontPointSize.toFixed(0) - 1) + "pt monospace;");
                    message = message.replace(new RegExp("<#N>", "g"), "color: " + qgcPal.text + "; font: " + (ScreenTools.defaultFontPointSize.toFixed(0) - 1) + "pt monospace;");
                    return message;
                }
                messageText.append(formatMessage(formattedMessage))
                //-- Hack to scroll down
                messageFlick.flick(0,-5000)
            }
        }

        QGCLabel {
            anchors.centerIn:   parent
            text:               qsTr("No Messages")
            visible:            messageText.length === 0
        }

        //-- Clear Messages
        QGCColoredImage {
            anchors.bottom:     parent.bottom
            anchors.right:      parent.right
            anchors.margins:    ScreenTools.defaultFontPixelHeight * 0.5
            height:             ScreenTools.isMobile ? ScreenTools.defaultFontPixelHeight * 1.5 : ScreenTools.defaultFontPixelHeight
            width:              height
            sourceSize.height:   height
            source:             "/res/TrashDelete.svg"
            fillMode:           Image.PreserveAspectFit
            mipmap:             true
            smooth:             true
            color:              qgcPal.text
            visible:            messageText.length !== 0
            MouseArea {
                anchors.fill:   parent
                onClicked: {
                    if (_activeVehicle) {
                        _activeVehicle.clearMessages()
                        messageText.text = ""
                        messageFlick.flick(0,-5000)
                    }
                }
            }
        }

        QGCFlickable {
            id:                 messageFlick
            anchors.margins:    ScreenTools.defaultFontPixelHeight
            anchors.fill:       parent
            contentHeight:      messageText.height
            contentWidth:       messageText.width
            pixelAligned:       true

            TextEdit {
                id:             messageText
                readOnly:       true
                textFormat:     TextEdit.RichText
                color:          qgcPal.text
            }
        }
    }



    Rectangle {
        id:                     attitudeWindow
        width:                  mainWindow.width * 0.3
        height:                 (mainWindow.height * 0.5) - ScreenTools.toolbarHeight - 15
        color:                  qgcPal.window
        anchors.bottom:         vehicleMessageView.top
        anchors.right:          parent.right
        anchors.rightMargin:    5
        anchors.bottomMargin:   5
        radius:                 ScreenTools.defaultFontPixelHeight / 2
        border.color:           qgcPal.text

        Rectangle {
            id:                     compassBackground
            anchors.bottom:         attitudeIndicator.bottom
            anchors.right:          attitudeIndicator.left
            anchors.rightMargin:    -attitudeIndicator.width / 2
            width:                  -anchors.rightMargin + compassBezel.width + (_toolsMargin * 2)
            height:                 attitudeIndicator.height * 0.75
            radius:                 2
            color:                  qgcPal.window
            visible:                false

            Rectangle {
                id:                     compassBezel
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin:     _toolsMargin
                anchors.left:           parent.left
                width:                  height
                height:                 parent.height - (northLabelBackground.height / 2) - (headingLabelBackground.height / 2)
                radius:                 height / 2
                border.color:           qgcPal.text
                border.width:           1
                color:                  Qt.rgba(0,0,0,0)
            }

            Rectangle {
                id:                         northLabelBackground
                anchors.top:                compassBezel.top
                anchors.topMargin:          -height / 2
                anchors.horizontalCenter:   compassBezel.horizontalCenter
                width:                      northLabel.contentWidth * 1.5
                height:                     northLabel.contentHeight * 1.5
                radius:                     ScreenTools.defaultFontPixelWidth  * 0.25
                color:                      qgcPal.windowShade

                QGCLabel {
                    id:                 northLabel
                    anchors.centerIn:   parent
                    text:               "N"
                    color:              qgcPal.text
                    font.pointSize:     ScreenTools.smallFontPointSize
                }
            }

            Image {
                id:                 headingNeedle
                anchors.centerIn:   compassBezel
                height:             compassBezel.height * 0.75
                width:              height
                source:             "/custom/img/compass_needle.svg"
                fillMode:           Image.PreserveAspectFit
                sourceSize.height:  height
                transform: [
                    Rotation {
                        origin.x:   headingNeedle.width  / 2
                        origin.y:   headingNeedle.height / 2
                        angle:      _heading
                    }]
            }

            Rectangle {
                id:                         headingLabelBackground
                anchors.top:                compassBezel.bottom
                anchors.topMargin:          -height / 2
                anchors.horizontalCenter:   compassBezel.horizontalCenter
                width:                      headingLabel.contentWidth * 1.5
                height:                     headingLabel.contentHeight * 1.5
                radius:                     ScreenTools.defaultFontPixelWidth  * 0.25
                color:                      qgcPal.windowShade

                QGCLabel {
                    id:                 headingLabel
                    anchors.centerIn:   parent
                    text:               _heading
                    color:              qgcPal.text
                    font.pointSize:     ScreenTools.smallFontPointSize
                }
            }
        }

        Rectangle {
            id:                         attitudeIndicator
            anchors.bottomMargin:       _toolsMargin
            anchors.rightMargin:        _toolsMargin
            anchors.verticalCenter:     attitudeWindow.verticalCenter
            anchors.horizontalCenter:   attitudeWindow.horizontalCenter
            anchors.top:                compassArrowIndicator.bottom
            height:                     ScreenTools.defaultFontPixelHeight * 12
            width:                      height
            radius:                     height * 0.5
            // border.color:               "white"
            // border.width:               3
            color:                      qgcPal.windowShade

            CustomAttitudeWidget {
                size:               parent.height * 0.98
                vehicle:            _activeVehicle
                showHeading:        false
                anchors.centerIn:   parent
                // anchors.bottom:     vehicleMessageView.top
            }
        }

        //-------------------------------------------------------------------------
        //-- Heading Indicator
        Rectangle {
            id:                         compassBar
            height:                     ScreenTools.defaultFontPixelHeight * 1.8
            width:                      ScreenTools.defaultFontPixelWidth  * 50
            color:                      "#00d0b0"
            radius:                     8
            clip:                       true
            anchors.top:                headingIndicator.bottom
            anchors.topMargin:          -headingIndicator.height / 2
            anchors.horizontalCenter:   parent.horizontalCenter
            Repeater {
                model: 720
                QGCLabel {
                    function _normalize(degrees) {
                        var a = degrees % 360
                        if (a < 0) a += 360
                        return a
                    }
                    property int _startAngle: modelData + 180 + _heading
                    property int _angle: _normalize(_startAngle)
                    anchors.verticalCenter: parent.verticalCenter
                    x:              visible ? ((modelData * (compassBar.width / 360)) - (width * 0.5)) : 0
                    visible:        _angle % 45 == 0
                    color:          "#000000"
                    font.pointSize: ScreenTools.smallFontPointSize
                    text: {
                        switch(_angle) {
                        case 0:     return "N"
                        case 45:    return "NE"
                        case 90:    return "E"
                        case 135:   return "SE"
                        case 180:   return "S"
                        case 225:   return "SW"
                        case 270:   return "W"
                        case 315:   return "NW"
                        }
                        return ""
                    }
                }
            }
        }
        Rectangle {
            id:                         headingIndicator
            height:                     ScreenTools.defaultFontPixelHeight
            width:                      ScreenTools.defaultFontPixelWidth * 4
            radius:                     _toolsMargin
            color:                      qgcPal.windowShadeDark
            anchors.top:                parent.top
            anchors.topMargin:          _toolsMargin
            anchors.horizontalCenter:   parent.horizontalCenter
            QGCLabel {
                text:                   _heading
                color:                  qgcPal.text
                font.pointSize:         ScreenTools.smallFontPointSize
                anchors.centerIn:       parent
            }
        }
        Image {
            id:                         compassArrowIndicator
            height:                     _indicatorsHeight
            width:                      height
            source:                     "/custom/img/compass_pointer.svg"
            fillMode:                   Image.PreserveAspectFit
            sourceSize.height:          height
            anchors.top:                compassBar.bottom
            anchors.topMargin:          -height / 2
            anchors.horizontalCenter:   parent.horizontalCenter
        }
    }


}
