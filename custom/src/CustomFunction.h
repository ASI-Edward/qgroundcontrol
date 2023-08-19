#ifndef CUSTOMFUNCTION_H
#define CUSTOMFUNCTION_H

#include <QAbstractListModel>

//struct Data {
//    Data() {}
//    Data( double lat, double lon, double alt )
//        : lat(lat), lon(lon), alt(alt) {}
//    double lat;
//    double lon;
//    double alt;
//};

class CustomFunction : public QObject
{
    Q_OBJECT

public:
//    enum Roles {
//        LatRole = 0,
//        LonRole = 1,
//        AltRole = 2
//    };

    explicit CustomFunction();

//    int rowCount(const QModelIndex& parent) const override;
//    QVariant data( const QModelIndex& index, int role = Qt::DisplayRole ) const override;
//    QHash<int, QByteArray> roleNames() const override;

public slots:
    QString getGCSUsername() const;
    QString getRCUsername() const;
    void setGCSUsername(QString name);
    void setRCUsername(QString name);
//    void importCSV();
    bool verifyUsername(QString username);
    //temporary(?)
    void setPrecipitation(QString prob);
    QString getPrecipitation() const;
    void setCheckStateTrue(int id);
    void setCheckStateFalse(int id);
    bool getCheckState(int id) const;
    void resetCheckState();
    void getSmartBattery();
    void removeSmartBattery();
    void importTxt();
    QString getBatteryInfo(QString variable) const;

//    void insertData(int row, double lat, double lon, double altRelative);
//    void removeData(int row);
//    void removeAllData();
//    void exportCSV(QString file);
//    void importCSV(QString file);
//    void removeTemp();

private slots:
//    void createTemp(QString file);
//    void restoreTemp(QString file);


private: //members
//    QVector< Data > m_data;
};

#endif // CUSTOMFUNCTION_H
