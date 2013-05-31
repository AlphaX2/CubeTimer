#include <QTime>
#include <QFile>
#include <QString>
#include <QStringList>
#include <QDebug>

#include "RubikTimer.hpp"


RubikTimer::RubikTimer()
{
	timeValue = QTime();
	bestTimeString = QString();
	averageTimeString = QString();
	lastTimeString = QString();


	// loading the latest data from time save file
	this->loadTimes();
	this->loadSettings();
}


void RubikTimer::restartTimer()
{
	/*
	 * Restart the QTime, this is setting it to 0
	 * method is called from UI on every new start!
	 */
	timeValue.restart();
}


QString RubikTimer::convertMsToString(unsigned long time)
{
	/*
	 * Takes elapsed time from QTime and creates a QString that
	 * can be used on the UI's clock.
	 */

	int ms = time;
	ms /= 10;
	int hsec = ms % 100;
	ms /= 100;
	int sec = ms % 60;
	ms /= 60;
	int min = ms % 60;

	QTime newTime = QTime(0, min, sec, hsec);
	return newTime.toString("mm:ss:z");
}


unsigned long RubikTimer::convertStringToMs(QString string)
{
	/*
	 * Converts a MM:SS:ZZ QString to milliseconds
	 */

	QStringList timeParts = string.split(":");

	unsigned long min = timeParts[0].toLong();
	unsigned long sec = timeParts[1].toLong();
	unsigned long hsec = timeParts[2].toLong();

	min *= 60000;
	sec *= 1000;
	hsec *= 10;

	unsigned long finalTime = min+sec+hsec;

	return finalTime;
}


QString RubikTimer::getNewTimeString()
{
	/*
	 * Called from UI, it's returning every 10ms a
	 * new MM:SS:ZZ based QString which shows the
	 * current elapsed time on UI's clock
	 */

	int elapTime = timeValue.elapsed();
	QString newTimeString = QString();
	newTimeString = this->convertMsToString(elapTime);
	return newTimeString;
}


QString RubikTimer::getNewCountdownString(int countdown)
{
	/*
	 * returns a string for the inspection countdown, have a look
	 * on the QML side too, because there are a QTimer with 1000ms
	 * interval calling this function and also in QML the countdown
	 * is counted down :)
	 */
	QString newCountdownString = this->convertMsToString(countdown);
	return newCountdownString;
}


QString RubikTimer::getScrambleStr()
{
	/* with every iteration 1 from 3 movements is selected this is not perfect
	 * but gives enough chaos and prevent "senseless" movements like U' followed
	 * by U. But it's true this part could be improved! ;)
	 */
	QStringList notationsU = QStringList(QStringList() << "U " << "U' " << "U2 ");
	QStringList notationsD = QStringList(QStringList() << "D " << "D' " << "D2 ");
	QStringList notationsR = QStringList(QStringList() << "R " << "R' " << "R2 ");
	QStringList notationsL = QStringList(QStringList() << "L " << "L' " << "L2 ");
	QStringList notationsF = QStringList(QStringList() << "F " << "F' " << "F2 ");
	QStringList notationsB = QStringList(QStringList() << "B " << "B' " << "B2 ");

	QStringList selection = QStringList();

	int i = 0;

	while(i<30)
	{
		int randInt;
		randInt = (std::rand()%3);
		selection.append(notationsU.at(randInt));
		i += 1;

		randInt = (std::rand()%3);
		selection.append(notationsD.at(randInt));
		i += 1;

		randInt = (std::rand()%3);
		selection.append(notationsR.at(randInt));
		i += 1;

		randInt = (std::rand()%3);
		selection.append(notationsL.at(randInt));
		i += 1;

		randInt = (std::rand()%3);
		selection.append(notationsF.at(randInt));
		i += 1;

		randInt = (std::rand()%3);
		selection.append(notationsB.at(randInt));
		i += 1;

		randInt = (std::rand()%3);
		selection.append(notationsU.at(randInt));
		i += 1;
	}

	return QString(selection.join(" "));
}


bool RubikTimer::checkRecord(QString best, QString last_time)
{
	/*
	 * Checking for last time being faster than current best time
	 */
	unsigned long bestValue = convertStringToMs(best);
	unsigned long lastValue = convertStringToMs(last_time);

	/* bestValue can't be 0, how to? Also in the first game it
	* will be 00:00:00, thats why the ms conversion returns also 0!
	*/
	return ((bestValue > 0) && (bestValue > lastValue));
}


void RubikTimer::saveTimes(QString best, QString last)
{
	/*
	 * Saves the best, average and last time in the save file
	 * average time is calculated by the amount of games played
	 */

	// load latest data -> update averageTime
	this->loadTimes();

	// take the string and transform it to milliseconds
	unsigned long bestSave = convertStringToMs(best);
	unsigned long lastSave = convertStringToMs(last);

	/*
	 * aveTime*gamesPlayed is the total amount of time, there will
	 * be the last time added and divided with gamesPlayed +1
	 */
	aveTime *= gamesPlayed;
	gamesPlayed += 1;
	// take the average time, add last time and divide with all games ever played
	unsigned long aveSave = ((aveTime+lastSave)/gamesPlayed);

	// best save can be 0 just in the first game, so set the last as the best time!
	if(bestSave == 0)
	{
		qDebug() << "First game, means that last time is also best time!";
		bestSave = lastSave;
	}

	QFile file("data/save.txt");
	file.open(QIODevice::WriteOnly | QIODevice::Text);
	QTextStream out(&file);
	out << bestSave << ";" << aveSave << ";" << lastSave << ";" << gamesPlayed;
	file.close();

	// loading changes and updating the UI
	this->loadTimes();
}


void RubikTimer::loadTimes()
{
	/*
	 This method is loading the time data from data/save.txt file
	 */

	QFile file("data/save.txt");
	if (file.open(QIODevice::ReadOnly | QIODevice::Text))
	{
		QTextStream in(&file);
		while (!in.atEnd())
		{
			QString line = in.readLine();
			QStringList result;
			result = line.split(";");

			// convert the saved data (QString) to long and make an UI usable (Q)String
			bestTimeString = this->convertMsToString(result[0].toLong());
			averageTimeString = this->convertMsToString(result[1].toLong());
			lastTimeString = this->convertMsToString(result[2].toLong());
			gamesPlayed = result[3].toLong();
			aveTime = result[1].toLong();
		}
	}
	else
	{
		/* first start -> give something to be shown,
		 * in all other cases it should read the file
		 * correctly. Maybe a "read error" dialog could
		 * be implemented here in future versions.
		 */

		bestTimeString = "00:00:00";
		averageTimeString = "00:00:00";
		lastTimeString = "00:00:00";
		gamesPlayed = 0;
		aveTime = 0;
	}

	// emit the changed signals -> updates UI
	emit bestChanged();
	emit averageChanged();
	emit lastChanged();
}


QString RubikTimer::getBestTime()
{
	/*
	 * READ method for the QProperty
	 */
	return bestTimeString;
}


QString RubikTimer::getAverageTime()
{
	/*
	 * READ method for the QProperty
	 */
	return averageTimeString;
}


QString RubikTimer::getLastTime()
{
	/*
	 * READ method for the QProperty
	 */
	return lastTimeString;
}


bool RubikTimer::getStopwatchMode()
{
	/*
	 * READ method for the QProperty
	 */
	return stopwatchMode;
}


bool RubikTimer::getInspectionMode()
{
	/*
	 * READ method for the QProperty
	 */
	return inspectionMode;
}


int RubikTimer::getInspectionTime()
{
	/*
	 * READ method for the QProperty
	 */
	return inspectionTime;
}


void RubikTimer::loadSettings()
{
	/*
	 * Load the settings, that had been set via settings menu
	 */
	qDebug() << "LOAD_SETTINGS!!!";

	QFile file("data/settings.txt");
	if (file.open(QIODevice::ReadOnly | QIODevice::Text))
	{
		QTextStream in(&file);
		while(!in.atEnd())
		{
			qDebug() << "READING FILE!";

			QString line = in.readLine();

			qDebug() << line;

			QStringList result = line.split(";");

			qDebug() << result;

			// true|false is saved as 0/1 so toInt() is used to create a bool from QString
			stopwatchMode = result[0].toInt();
			inspectionMode = result[1].toInt();
			inspectionTime = result[2].toInt();

			qDebug() << result[0];
			qDebug() << result[1];
			qDebug() << result[2];
		}
	}
	else
	{
		stopwatchMode = 0;
		inspectionMode = 0;
		inspectionTime = 0;
	}

	qDebug() << "emit signals";
	emit stopwatchChanged();
	emit inspectionChanged();
	emit inspectionTimeChanged();
}


void RubikTimer::saveSettings(bool stopwatch, bool inspection, int sec)
{
	/*
	 * Saves the options the user have set via settings menu
	 */
	qDebug() << "SAVE_SETTINGS!!!";

	QFile file("data/settings.txt");
	if(file.open(QIODevice::WriteOnly | QIODevice::Text))
	{
		QTextStream out(&file);
		out << stopwatch << ";" << inspection << ";" << sec;
		file.close();
	}

	// load changed data
	this->loadSettings();
}


void RubikTimer::resetData()
{
	/*
	 * The method is reseting all saved times and settings!
	 */

	QFile saveFile("data/save.txt");
	QFile settingsFile("data/settings.txt");
	if(saveFile.open(QIODevice::WriteOnly | QIODevice::Text))
	{
		QTextStream out(&saveFile);
		//data: best				average				last				games played
		out << "00:00:00" << ";" << "00:00:00" << ";" << "00:00:00" << ";" << "0";
		saveFile.close();
	}
	if(settingsFile.open(QIODevice::WriteOnly | QIODevice::Text))
	{
		QTextStream out(&settingsFile);
		//data: stopwatch/inspection/seconds for inspection
		out << "0" << ";" << "0;" << "0";
		settingsFile.close();
	}

	// load changed data
	this->loadTimes();
	this->loadSettings();
}


void RubikTimer::resetRecord()
{
	/*
	 * This function resets only the record, so you can reset it, if you maybe stopped a wrong time
	 */

	QFile file("data/save.txt");
	if(file.open(QIODevice::WriteOnly | QIODevice::Text))
	{

		qDebug() << averageTimeString;
		qDebug() << lastTimeString;
		qDebug() << gamesPlayed;

		QTextStream out(&file);
		out << "00:00:00" << ";" << averageTimeString << ";" << lastTimeString << ";" << gamesPlayed;
		file.close();

		bestTimeString = "00:00:00";
		emit bestChanged();
	}
}


RubikTimer::~RubikTimer(void)
{
}
