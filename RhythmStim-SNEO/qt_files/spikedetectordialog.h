#ifndef SPIKEDETECTORDIALOG_H
#define SPIKEDETECTORDIALOG_H

#include <QDialog>
#include <QtConcurrent/QtConcurrent>
#include <QNetworkInterface> //---
#include <QUdpSocket> //---

#include "rhs2000evalboard.h"
#include "probeplot.h"
#include "mainwindow.h"

using namespace std;

class QHostAddress;
class QPushButton;
class QListWidget;
class QListWidgetItem;
class QDoubleSpinBox;
class SpikePlot;
class SignalProcessor;
class SignalSources;
class SignalChannel;

class SpikeDetectorDialog : public QDialog
{
    Q_OBJECT
public:
    explicit SpikeDetectorDialog(MainWindow *inMain, Rhs2000EvalBoard *inEvalBoard, bool inSynthMode, double boardSampleRate, WavePlot* wavePlot, Rhs2000Registers::StimStepSize inStimStep);
    void SpikeDetectorDialogOnExit();

public slots:

private slots:
    void run();
    void runSpikeDetector();
    void runSynthSpikeDetector();
    void applyThreshold();
    void applyBlindWindow();
    void applyChannelList();
    void changeTimescale(int i);
    void connectUDP();
    void sendStimTrigger();

private:
    void runSpikeDetetctor(bool recording, QString hwDetectorFileName);

    QComboBox* hostAddressComboBox;
    QLineEdit* hostPortLineEdit;
    QLineEdit* destAddressLineEdit;
    QLineEdit* destPortLineEdit;
    QComboBox* timeWindow;
    QPushButton* startButton;
    QPushButton* connectUDPButton;
    QDoubleSpinBox* thresholdSpinBox;
    QSpinBox* blindWindowSpinBox;
    QListWidgetItem *deactiveChannelsList[32];

    MainWindow* mainWindow;
    Rhs2000EvalBoard* evalBoard;
    bool synthMode;
    bool running;
    bool finished;
    bool wasRunning;
    ProbePlot* probePlot;
    double boardSampleRate;
    WavePlot* wavePlot;
    Rhs2000Registers::StimStepSize stimStep;

    QVector<quint32> channelsOrdered;
    bool deactiveChannels[32];
    quint32 lastDT[32];
    QString hwDetectorFileName;
    QString saveFileName;
    QString prevFileName;

    bool connected;
    QHostAddress destAddress;
    short destPort;
    QHostAddress sender;
    quint16 senderPort;
    QUdpSocket* sendSocket;
    QUdpSocket* recvSocket;
    int datagram[4];
    char recvDatagram[16];

    int lastChannel;
    int lastAmpl;
};

#endif // SPIKEDETECTORDIALOG_H
