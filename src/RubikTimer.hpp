#ifndef RUBIKTIMER_HPP_
#define RUBIKTIMER_HPP_

#include <QString>
#include <QObject>
#include <QTime>


class RubikTimer : public QObject {
    Q_OBJECT

    Q_PROPERTY(QString bestTimeString READ getBestTime NOTIFY bestChanged)
    Q_PROPERTY(QString averageTimeString READ getAverageTime NOTIFY averageChanged)
    Q_PROPERTY(QString lastTimeString READ getLastTime NOTIFY lastChanged)

    Q_PROPERTY(bool stopwatchMode READ getStopwatchMode NOTIFY stopwatchChanged)
    Q_PROPERTY(bool inspectionMode READ getInspectionMode NOTIFY inspectionChanged)
    Q_PROPERTY(int inspectionTime READ getInspectionTime NOTIFY inspectionTimeChanged)

public:
    RubikTimer();

    QString getBestTime();
    QString getAverageTime();
    QString getLastTime();

    bool getStopwatchMode();
    bool getInspectionMode();
    int getInspectionTime();

    // make them invokable for using from QML
    Q_INVOKABLE void saveTimes(QString best, QString last);
    Q_INVOKABLE void loadTimes();

    Q_INVOKABLE QString getScrambleStr();
    Q_INVOKABLE void restartTimer();
    Q_INVOKABLE QString getNewTimeString();
    Q_INVOKABLE QString getNewCountdownString(int);

    Q_INVOKABLE bool checkRecord(QString best, QString last);

    Q_INVOKABLE void saveSettings(bool stopwatch, bool inspection, int sec);
    Q_INVOKABLE void loadSettings();
    Q_INVOKABLE void resetData();
    Q_INVOKABLE void resetRecord();

    virtual ~RubikTimer();

signals:
	void bestChanged();
	void averageChanged();
	void lastChanged();

	void stopwatchChanged();
	void inspectionChanged();
	void inspectionTimeChanged();

private:
    QTime timeValue;

	QString bestTimeString;
	QString averageTimeString;
	QString lastTimeString;

	bool stopwatchMode;
	bool inspectionMode;
	int inspectionTime;

	unsigned long aveTime;
	unsigned long gamesPlayed;

    QString convertMsToString(unsigned long time);
    unsigned long convertStringToMs(QString);
    unsigned long getAverageCount();

};

#endif /* RUBIKTIMER_HPP_ */
