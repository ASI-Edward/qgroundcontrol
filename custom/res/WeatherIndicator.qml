/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick          2.11
import QtQuick.Layouts  1.11
import QtQuick.Controls 2.15

import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.Palette               1.0

//-------------------------------------------------------------------------
//-- Weather Indicator
Item {
    id:             _root
    width:          (weatherValuesColumn.x + weatherValuesColumn.width) * 1.1
    anchors.top:    parent.top
    anchors.bottom: parent.bottom

    property bool showIndicator: true

    property var _activeVehicle: QGroundControl.multiVehicleManager.activeVehicle

    //weather stuff
    property var parameters: undefined
    property var parameters2: undefined

    property double latitude: _activeVehicle.coordinate.latitude
    property double longitude: _activeVehicle.coordinate.longitude

    property string location: _root.parameters ? _root.parameters['name'] : ""
    property string temperature: _root.parameters ? _root.parameters['main']['temp'] : "undefined"
    property string nextHour: (parseInt(currentTime.toLocaleTimeString(locale, "h")) + 1)
    property string currentHour: parseInt(currentTime.toLocaleTimeString(locale, "h"))
    property string precip: _root.parameters2['days']['0']['hours'][currentTime.toLocaleTimeString(locale, "h")]['precipprob']
    property date currentTime: new Date()

    Component.onCompleted: {
        currentTime = new Date()
        nextHour = (parseInt(currentTime.toLocaleTimeString(locale, "h")) + 1)

        getJson(latitude, longitude)
//        while (!_root.parameters) {
//            if (_root.parameters)
                getJson2(location)
//        }
        _customFunction.setPrecipitation(precip)
    }

    function getJson(latitude, longitude) {
        var xmlhttp = new XMLHttpRequest()
        var url = "https://api.openweathermap.org/data/2.5/weather?lat=" + latitude
                + "&lon=" + longitude + "&appid=fc4ed625a3e7208cdcc77affbd50957e&units=metric"

        xmlhttp.onreadystatechange = function () {
            if (xmlhttp.readyState === XMLHttpRequest.DONE
                    && xmlhttp.status == 200) {
                _root.parameters = JSON.parse(xmlhttp.responseText)
            }
        }
        xmlhttp.open("GET", url, true)
        xmlhttp.send()
    }

    function getJson2(location) {
        var xmlhttp = new XMLHttpRequest()
        var url = "https://weather.visualcrossing.com/VisualCrossingWebServices/rest/services/timeline/" + location
                    + "?unitGroup=metric&key=2VGU44H3QFJD7JVAGUVFW7Y4B&contentType=json"

        xmlhttp.onreadystatechange = function () {
            if (xmlhttp.readyState === XMLHttpRequest.DONE
                    && xmlhttp.status == 200) {
                _root.parameters2 = JSON.parse(xmlhttp.responseText)
            }
        }
        xmlhttp.open("GET", url, true)
        xmlhttp.send()
    }

    function getDirection(windDirectionDegree) {
        var index = Math.round(windDirectionDegree / 22.5) + 1
        switch(index) {
        case 1:
            return "N"
        case 2:
            return "NNE"
        case 3:
            return "NE"
        case 4:
            return "ENE"
        case 5:
            return "E"
        case 6:
            return "ESE"
        case 7:
            return "SE"
        case 8:
            return "SSE"
        case 9:
            return "S"
        case 10:
            return "SSW"
        case 11:
            return "SW"
        case 12:
            return "WSW"
        case 13:
            return "W"
        case 14:
            return "WNW"
        case 15:
            return "NW"
        case 16:
            return "NNW"
        case 17:
            return "N"
        default:
            break
        }
    }

    function cloudIcon() {
        if (!_root.parameters2) {
            getJson(latitude, longitude)
            getJson2(location)
        }

        _customFunction.setPrecipitation(precip)

        if (temperature == 'undefined')
            return "/InstrumentValueIcons/cloud-exclamation.svg"
        else
            return "/InstrumentValueIcons/cloud.svg"
    }

    function cloudIconColour() {
        if (!_root.parameters2) {
            getJson(latitude, longitude)
            getJson2(location)
            _customFunction.setPrecipitation(precip)
        }

        _customFunction.setPrecipitation(precip)

        if (temperature == 'undefined')
            return qgcPal.colorRed
        else if (_root.parameters2['days']['0']['hours'][currentTime.toLocaleTimeString(locale, "h")]['precipprob'] > 60)
            return qgcPal.colorRed
        else if (_root.parameters2['days']['0']['hours'][currentTime.toLocaleTimeString(locale, "h")]['precipprob'] > 30)
            return qgcPal.colorOrange
        else
            return qgcPal.buttonText
    }

    Component {
        id: weatherInfo

        Rectangle {
            width:  weatherCol.width   + ScreenTools.defaultFontPixelWidth  * 3
            height: weatherCol.height  + ScreenTools.defaultFontPixelHeight * 2
            radius: ScreenTools.defaultFontPixelHeight * 0.5
            color:  qgcPal.window
            border.color:   qgcPal.text

            Component.onCompleted:  {
                console.log('weather components loaded.')
                //actually no need getJSON since it was done already, but it is called to check in case it is the next hour already while using the application
                if (_root.parameters2['days']['0']['hours'][currentTime.toLocaleTimeString(locale, "h")] !== currentHour) {
                    getJson(latitude, longitude)
                    getJson2(location)
                    _customFunction.setPrecipitation(precip)
                }
//                console.log(latitude)
//                console.log(longitude)
//                console.log(location)
//                console.log(_root.parameters2['address'])
//                console.log(currentTime.toLocaleTimeString(locale, "h"))
//                console.log(nextHour)
//                console.log(currentTime.toLocaleTimeString(locale, "h") + 1)
//                console.log(_customFunction.getPrecipitation())
            }

            Column {
                id:                 weatherCol
                spacing:            ScreenTools.defaultFontPixelHeight * 0.5
                width:              Math.max(weatherGrid.width, weatherLabel.width)
                anchors.margins:    ScreenTools.defaultFontPixelHeight
                anchors.centerIn:   parent

                QGCLabel {
                    id:             weatherLabel
                    text:           temperature == 'undefined' ? qsTr("No internet connection available, could not retrieve weather information") : qsTr("Weather Information")
                    font.family:    ScreenTools.demiboldFontFamily
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                GridLayout {
                    id:                 weatherGrid
                    visible:            (_activeVehicle) && temperature !== 'undefined'
                    anchors.margins:    ScreenTools.defaultFontPixelHeight
                    columnSpacing:      ScreenTools.defaultFontPixelWidth
                    columns: 2

                    //insert flight information here
                    QGCLabel { text: qsTr("Weather Condition:") }
                    QGCLabel { text: qsTr(_root.parameters2['currentConditions']['conditions'] !== "" ? _root.parameters2['currentConditions']['conditions'] : "Unavailable for this location")}
                    QGCLabel { text: qsTr("Temperature:") }
                    QGCLabel { text: qsTr(_root.parameters2['currentConditions']['temp'] !== "" ? _root.parameters2['currentConditions']['temp'] + "°C" : "Unavailable for this location")}
                    QGCLabel { text: qsTr("Probability of Precipitation:") }
                    QGCLabel { text: qsTr(_root.parameters2['days']['0']['hours'][currentTime.toLocaleTimeString(locale, "h")]['precipprob'] !== ""  ? _root.parameters2['days']['0']['hours'][currentTime.toLocaleTimeString(locale, "h")]['precipprob'] + "%" : "Unavailable for this location")}
                    QGCLabel { text: qsTr("Humidity:") }
                    QGCLabel { text: qsTr(_root.parameters2['currentConditions']['humidity'] !== ""  ? _root.parameters2['currentConditions']['humidity'] + "%" : "Unavailable for this location")}
                    QGCLabel { text: qsTr("Visibility:") }
                    QGCLabel { text: qsTr(_root.parameters2['currentConditions']['visibility'] !== "" ? _root.parameters2['currentConditions']['visibility'] + " km" : "Unavailable for this location")}
                    QGCLabel { text: qsTr("Wind Speed:") }
                    QGCLabel { text: qsTr(_root.parameters2['currentConditions']['windspeed'].toString() !== "" ? _root.parameters2['currentConditions']['windspeed'].toString() + " km/h" : "Unavailable for this location")}
                    QGCLabel { text: qsTr("Wind Direction:") }
                    QGCLabel { text: qsTr(_root.parameters2['currentConditions']['winddir'].toString() !== "" ? getDirection(_root.parameters2['currentConditions']['winddir']) : "Unavailable for this location")}
                    QGCLabel { text: qsTr("Wind Gust:") }
                    QGCLabel { text: qsTr(_root.parameters2['days']['0']['hours'][currentTime.toLocaleTimeString(locale, "h")]['windgust'] !== "" ? _root.parameters2['days']['0']['hours'][currentTime.toLocaleTimeString(locale, "h")]['windgust'] + " km/h" : "Unavailable for this location")}
                    QGCLabel { text: qsTr("UV Index:") }
                    QGCLabel { text: qsTr(_root.parameters2['currentConditions']['uvindex'].toString() !== "" ? _root.parameters2['currentConditions']['uvindex'].toString() : "Unavailable for this location")}
                }

                QGCLabel {
                    id:             weatherLabel2
                    text:           temperature == 'undefined' ? qsTr("") : qsTr("Next Hour Forecast")
                    font.family:    ScreenTools.demiboldFontFamily
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                GridLayout {
                    id:                 weatherGrid2
                    visible:            (_activeVehicle) && temperature !== 'undefined'
                    anchors.margins:    ScreenTools.defaultFontPixelHeight
                    columnSpacing:      ScreenTools.defaultFontPixelWidth
//                    anchors.horizontalCenter: parent.horizontalCenter
                    columns: 2

                    //insert flight information here
                    QGCLabel { text: qsTr("Temperature:") }
                    QGCLabel { text: qsTr(_root.parameters2['days']['0']['hours'][nextHour.toString()]['temp'] !== "" ? _root.parameters2['days']['0']['hours'][nextHour.toString()]['temp'] + "°C" : "Unavailable for this location")}
                    QGCLabel { text: qsTr("Probability of Precipitation:") }
                    QGCLabel { text: qsTr(_root.parameters2['days']['0']['hours'][nextHour.toString()]['precipprob'] !== ""  ? _root.parameters2['days']['0']['hours'][nextHour.toString()]['precipprob'] + "%" : "Unavailable for this location")}
                    QGCLabel { text: qsTr("Humidity:") }
                    QGCLabel { text: qsTr(_root.parameters2['days']['0']['hours'][nextHour.toString()]['humidity'] !== ""  ? _root.parameters2['days']['0']['hours'][nextHour.toString()]['humidity'] + "%" : "Unavailable for this location")}
                    QGCLabel { text: qsTr("Visibility:") }
                    QGCLabel { text: qsTr(_root.parameters2['days']['0']['hours'][nextHour.toString()]['visibility'] !== "" ? _root.parameters2['days']['0']['hours'][nextHour.toString()]['visibility'] + " km" : "Unavailable for this location")}
                    QGCLabel { text: qsTr("Wind Speed:") }
                    QGCLabel { text: qsTr(_root.parameters2['days']['0']['hours'][nextHour.toString()]['windspeed'].toString() !== "" ? _root.parameters2['days']['0']['hours'][nextHour.toString()]['windspeed'].toString() + " km/h" : "Unavailable for this location")}
                    QGCLabel { text: qsTr("Wind Direction:") }
                    QGCLabel { text: qsTr(_root.parameters2['days']['0']['hours'][nextHour.toString()]['winddir'].toString() !== "" ? getDirection(_root.parameters2['days']['0']['hours'][nextHour.toString()]['winddir']) : "Unavailable for this location")}
                    QGCLabel { text: qsTr("Wind Gust:") }
                    QGCLabel { text: qsTr(_root.parameters2['days']['0']['hours'][nextHour.toString()]['windgust'] !== "" ? _root.parameters2['days']['0']['hours'][nextHour.toString()]['windgust'] + " km/h" : "Unavailable for this location")}
                    QGCLabel { text: qsTr("UV Index:") }
                    QGCLabel { text: qsTr(_root.parameters2['days']['0']['hours'][nextHour.toString()]['uvindex'].toString() !== "" ? _root.parameters2['days']['0']['hours'][nextHour.toString()]['uvindex'].toString() : "Unavailable for this location")}
                }
            }
        }
    }

    QGCColoredImage {
        id:                 weatherIcon
        width:              height
        anchors.top:        parent.top
        anchors.bottom:     parent.bottom
        source:             cloudIcon()
        fillMode:           Image.PreserveAspectFit
        sourceSize.height:  height
        color:              cloudIconColour()
    }

    Column {
        id:                     weatherValuesColumn
        anchors.verticalCenter: parent.verticalCenter
        anchors.left:           weatherIcon.right
    }

    MouseArea {
        anchors.fill:   parent
        onClicked: {
            mainWindow.showIndicatorPopup(_root, weatherInfo)
        }
    }
}
