#include "CustomFunction.h"

#include <QDir>
#include <QDebug>
#include <QUrl>
#include <QStandardPaths>

#include <QCoreApplication>
#include <QFile>
#include <QString>
#include <QTextStream>

#include <iostream>
#include <fstream>

QString gCSUsername = "";
QString rCUsername = "";
QString list[99];
QString list2[99];
QString file = ":/usernameList/username.csv";

QString file2 = ":/smartBatteryCAN/getBatteryInformation.txt";

QString precipitation = "";

bool checkListState[40] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};

CustomFunction::CustomFunction() {
    const QUrl url(file);

    if (url.isLocalFile()) {
        file = QDir::toNativeSeparators(url.toLocalFile());
    } else {
    }

    QFile csvFile(file);

    QStringList lineToken;
    if (csvFile.open(QIODevice::ReadOnly)) {

        int lineindex = 0;                     // file line counter
        QTextStream in(&csvFile);
        in.readLine();// read to text stream

        while (!in.atEnd()) {
            if (in.atEnd())
                break;
            // read one line from textstream(separated by ",")
            QString fileLine = in.readLine();

            lineToken = fileLine.split(",", QString::SkipEmptyParts);
            list[lineindex] = lineToken.at(0);
            lineindex++;
        }
        csvFile.close();
    }
}

void CustomFunction::setGCSUsername(QString name)  {
    gCSUsername = name;
}

void CustomFunction::setRCUsername(QString name)  {
    rCUsername = name;
}

QString CustomFunction::getGCSUsername() const
{
    return gCSUsername;
}

QString CustomFunction::getRCUsername() const
{
    return rCUsername;
}

bool CustomFunction::verifyUsername(QString username)
{
    for (int i = 0; i < list->count(); i++) {
        if (username.toLower() == list[i].toLower()) {
            if (username.toLower() == gCSUsername.toLower() && username.toLower() == rCUsername.toLower()) {
                gCSUsername = list[i];
                rCUsername = list[i];
            }
            else if (username.toLower() == gCSUsername.toLower() && username.toLower() != rCUsername.toLower())
                gCSUsername = list[i];
            else
                rCUsername = list[i];

            return true;
        }
    }

    return false;
}

//unrelated but used for passing the probability of precipitation for now
void CustomFunction::setPrecipitation(QString prob)  {
    precipitation = prob;
}

QString CustomFunction::getPrecipitation() const
{
    return precipitation;
}

void CustomFunction::setCheckStateTrue(int id)  {
    checkListState[id] = 1;
}

void CustomFunction::setCheckStateFalse(int id)  {
    checkListState[id] = 0;
}

bool CustomFunction::getCheckState(int id) const
{
    return checkListState[id];
}

void CustomFunction::resetCheckState()  {
    for (int i = 0; i < 40; i++) {
        checkListState[i] = 0;
    }
}

void read(QString filename)
{
    QFile file(filename);
    if(!file.open(QFile::ReadOnly |
                  QFile::Text))
    {
        qDebug() << " Could not open the file for reading";
        return;
    }

    QTextStream in(&file);
    QString myText = in.readAll();

    file.close();
}

void CustomFunction::getSmartBattery() {
    QString fileDestination = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
    QString filePlace = fileDestination + "/getBatteryInformation.py"; //need to check, maybe different for windows, mac and linux
    qDebug() << fileDestination;

    const QUrl url(file2);

    if (url.isLocalFile()) {
        file2 = QDir::toNativeSeparators(url.toLocalFile());
    } else {
    }

    if (QFile::exists(filePlace))
    {
        qDebug() << "ada file";
    } else {
        qDebug() << "nope";

        read(file2);
        bool status = QFile::copy(file2, filePlace);
        if(status) {
            qDebug() << "Success";
        } else {
            qDebug() << "Failed";
        }

        QFile permisssion(filePlace);
        permisssion.setPermissions(QFile::ReadOwner | QFile::WriteOwner | QFile::ReadUser | QFile::WriteUser | QFile::ReadOther | QFile::WriteOther | QFile::ReadGroup | QFile::WriteGroup);
        permisssion.close();
    }

    //might be able to just use the python file straightaway from qrc
    //the python command below is only for mac and python3.10, need to add support for windows and maybe linux as well
//          windows_com_port = device_name.replace('\\', '').replace('.', '').lower().startswith('com')
//        unix_tty = device_name.startswith('/dev/')
    QString command = "/Library/Frameworks/Python.framework/Versions/3.10/bin/python3 " + filePlace + " --doc " + fileDestination + "/batteryInformation.txt /dev/tty.T10_247"; //need to check, maybe different for windows, mac and linux
    QByteArray ba = command.toLocal8Bit();
    const char *c_str = ba.data();

    system(c_str);
}

void CustomFunction::removeSmartBattery()  {
    QString pythonFile = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation) + "/getBatteryInformation.py";
    QString textFile = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation) + "/batteryInformation.txt";

    if (QFile::exists(pythonFile))
    {
        QFile::remove(pythonFile);
    }

    if (QFile::exists(textFile))
    {
        QFile::remove(textFile);
    }
}

void CustomFunction::importTxt()
{
//    QString list2[99];
    std::fill_n(list2, 99, "");

    const QUrl url(QString("%1/batteryInformation.txt").arg(QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation)));
    if (url.isLocalFile()) {
        QString("%1/batteryInformation.txt").arg(QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation)) = QDir::toNativeSeparators(url.toLocalFile());
    }

    QFile txtFile(QString("%1/batteryInformation.txt").arg(QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation)));

    QStringList lineToken;
    if (txtFile.open(QIODevice::ReadOnly)) {

        int lineindex = 0;                     // file line counter
        QTextStream in(&txtFile);

        while (!in.atEnd()) {
            if (in.atEnd())
                break;
            // read one line from textstream(separated by "\n")
            QString fileLine = in.readLine();

            // parse the read line into separate pieces(tokens) with "," as the delimiter
            lineToken = fileLine.split("\n", QString::SkipEmptyParts);
            list2[lineindex] = lineToken.at(0);

//            qDebug() << list2[lineindex];
            lineindex++;
//            qDebug() << fileLine;
        }
//        qDebug() << list2;
        txtFile.close();
    }
}

QString CustomFunction::getBatteryInfo(QString variable) const
{
    if (variable == "voltage") {
        if (list2[0] == "") {
            return "null";
        }
        else {
            return list2[0];
        }
    }
    if (variable == "health") {
        if (list2[1] == "") {
            return "null";
        }
        else {
            return list2[1];
        }
    }
    if (variable == "cycle") {
        if (list2[2] == "") {
            return "null";
        }
        else {
            return list2[2];
        }
    }
    if (variable == "serial") {
        if (list2[3] == "") {
            return "null";
        }
        else {
            return list2[3];
        }
    }
    if (variable == "manufacture") {
        if (list2[4] == "") {
            return "null";
        }
        else {
            return list2[4];
        }
    }
    if (variable == "temperature") {
        if (list2[5] == "") {
            return "null";
        }
        else {
            return list2[5];
        }
    }
    if (variable == "totalVoltage") {
        if (list2[6] == "") {
            return "null";
        }
        else {
            return list2[6];
        }
    }
    if (variable == "current") {
        if (list2[7] == "") {
            return "null";
        }
        else {
            return list2[7];
        }
    }
    if (variable == "model") {
        if (list2[8] == "") {
            return "null";
        }
        else {
            return list2[8];
        }
    }
    if (variable == "device") {
        if (list2[9] == "") {
            return "null";
        }
        else {
            return list2[9];
        }
    }

    return "nada";
}

//dumps
//CustomFunction::CustomFunction() {
//    const QUrl url(file);

//    if (url.isLocalFile()) {
//        file = QDir::toNativeSeparators(url.toLocalFile());
//    } else {
//    }

//    QFile csvFile(file);

////    qDebug() << csvFile;
////    qDebug() << file;

//    QStringList lineToken;
//    if (csvFile.open(QIODevice::ReadOnly)) {

//        int lineindex = 0;                     // file line counter
//        QTextStream in(&csvFile);
//        in.readLine();// read to text stream

//        while (!in.atEnd()) {
//            if (in.atEnd())
//                break;
//            // read one line from textstream(separated by "\n")
//            QString fileLine = in.readLine();

//            // parse the read line into separate pieces(tokens) with "," as the delimiter
//            lineToken = fileLine.split(",", QString::SkipEmptyParts);
//            list[lineindex] = lineToken.at(0);
////            const Data data = Data(lineToken.at(1).toDouble(), lineToken.at(2).toDouble(), lineToken.at(3).toDouble());
////            beginInsertRows(QModelIndex(), m_data.count(), m_data.count());
////            m_data.insert(m_data.count(), data);
////            endInsertRows();
//            lineindex++;
//        }
//        csvFile.close();
//    }
////    exportCSV(tempFile);
//}
