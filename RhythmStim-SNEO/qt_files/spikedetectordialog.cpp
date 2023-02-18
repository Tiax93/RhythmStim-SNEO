#include <QtGui>
#if QT_VERSION >= QT_VERSION_CHECK(5,0,0)
#include <QtWidgets>
#endif
#include <iostream>

// Spike detector dialog.
// Created by Mattia Tambaro, to be used only with the custom bitfile created by me.

#include "spikedetectordialog.h"
#include "probeplot.h"
#include "spikeplot.h"
#include "mainwindow.h"
#include "signalprocessor.h"
#include "signalchannel.h"
#include "spikescopedialog.h"
#include "waveplot.h"
#include "rhs2000registers.h"

SpikeDetectorDialog::SpikeDetectorDialog(MainWindow *inMain, Rhs2000EvalBoard *inEvalBoard, bool inSynthMode, double inBoardSampleRate, WavePlot* inWavePlot, Rhs2000Registers::StimStepSize inStimStep) :
    QDialog(inMain)
{
    setWindowTitle(tr("Spike Detector"));

    mainWindow = inMain;
    evalBoard = inEvalBoard;
    synthMode = inSynthMode;
    running = false;
    finished = true;
    probePlot = new ProbePlot(this);
    sendSocket = new QUdpSocket();
    recvSocket = new QUdpSocket();
    channelsOrdered = {21,27,13,31,7,1,25,19,20,26,2,8,32,14,28,22,18,30,12,24,16,6,4,10,9,3,5,15,23,11,29,17};
    connected = false;
    boardSampleRate = inBoardSampleRate;
    wavePlot = inWavePlot;
    stimStep = inStimStep;

    lastChannel = -1;
    lastAmpl = -1;


    double thresholdMult = 5.5;
    int blindWindowLength = 10;

    for (int i = 0; i < 32; i++) {
        deactiveChannels[i] = false;
    }

    if (!synthMode) {
        evalBoard->setThresholdMult(thresholdMult);
        evalBoard->setBlindWindowLength(blindWindowLength);
        evalBoard->setDeactiveChannels(deactiveChannels);
    }

    hostAddressComboBox = new QComboBox();
    const QHostAddress &localhost = QHostAddress(QHostAddress::LocalHost);
    for (const QHostAddress &address: QNetworkInterface::allAddresses()) {
        if (address.protocol() == QAbstractSocket::IPv4Protocol && address != localhost)
              hostAddressComboBox->addItem(address.toString());
    }
    hostAddressComboBox->setCurrentIndex(0);
    hostAddressComboBox->setMinimumWidth(100);

    hostPortLineEdit = new QLineEdit();
    hostPortLineEdit->setValidator(new QIntValidator(1024, 65535, this));
    hostPortLineEdit->setMinimumWidth(50);
    hostPortLineEdit->setMaximumWidth(50);
    hostPortLineEdit->setText("9393");

    QHBoxLayout *addressLayout1 = new QHBoxLayout();
    addressLayout1->addWidget(new QLabel(tr("Local  host  IP")));
    addressLayout1->addWidget(hostAddressComboBox);
    addressLayout1->addWidget(new QLabel(tr("Port")));
    addressLayout1->addWidget(hostPortLineEdit);

    destAddressLineEdit = new QLineEdit();
    destAddressLineEdit->setValidator(new QRegExpValidator(QRegExp("^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"), this));
    destAddressLineEdit->setMaximumWidth(97);
    destAddressLineEdit->setText("25.16.52.6");

    destPortLineEdit = new QLineEdit();
    destPortLineEdit->setValidator(new QIntValidator(1024, 65535, this));
    destPortLineEdit->setMaximumWidth(50);
    destPortLineEdit->setText("10000");

    QHBoxLayout *addressLayout2 = new QHBoxLayout();
    addressLayout2->addWidget(new QLabel(tr("Destination IP")));
    addressLayout2->addWidget(destAddressLineEdit);
    addressLayout2->addWidget(new QLabel(tr("Port")));
    addressLayout2->addWidget(destPortLineEdit);

    connectUDPButton = new QPushButton(tr("Connect"));
    connect(connectUDPButton, SIGNAL(clicked()),
            this, SLOT(connectUDP()));

    QVBoxLayout *addressLayout = new QVBoxLayout();
    addressLayout->addLayout(addressLayout1);
    addressLayout->addLayout(addressLayout2);
    addressLayout->addWidget(connectUDPButton);;

    QGroupBox* addressGroupBox = new QGroupBox(tr("Communication setting"));
    addressGroupBox->setLayout(addressLayout);

    thresholdSpinBox = new QDoubleSpinBox();
    thresholdSpinBox->setRange(0, 15);
    thresholdSpinBox->setDecimals(1);
    thresholdSpinBox->setSingleStep(0.5);
    thresholdSpinBox->setValue(thresholdMult);
    thresholdSpinBox->setMaximumWidth(50);
    thresholdSpinBox->setMinimumWidth(50);

    QPushButton* applyThresholdButton = new QPushButton(tr("Apply threshold multiplier"));
    connect(applyThresholdButton, SIGNAL(clicked()),
            this, SLOT(applyThreshold()));

    QHBoxLayout *thresholdLayout = new QHBoxLayout;
    thresholdLayout->addWidget(thresholdSpinBox);
    thresholdLayout->addStretch(1);
    thresholdLayout->addWidget(applyThresholdButton);

    blindWindowSpinBox = new QSpinBox();
    blindWindowSpinBox->setRange(0, 256);
    blindWindowSpinBox->setValue(blindWindowLength);
    blindWindowSpinBox->setMaximumWidth(50);
    blindWindowSpinBox->setMinimumWidth(50);

    QPushButton* blindWindowButton = new QPushButton(tr("Apply blind window length"));
    connect(blindWindowButton, SIGNAL(clicked()),
            this, SLOT(applyBlindWindow()));

    QHBoxLayout *blindWindowLayout = new QHBoxLayout;
    blindWindowLayout->addWidget(blindWindowSpinBox);
    blindWindowLayout->addWidget(new QLabel("ms"));
    blindWindowLayout->addWidget(blindWindowButton);

    QListWidget* deactiveChannelsListWidget = new QListWidget();
    deactiveChannelsListWidget->setSelectionMode(QAbstractItemView::MultiSelection);
    for (int i = 0; i < 32; i++) {
        deactiveChannelsList[i] = new QListWidgetItem(tr("Channel ") + QString::number(i+1), deactiveChannelsListWidget);
        deactiveChannelsList[i]->setSelected(true);
    }
    deactiveChannelsListWidget->setMaximumWidth(100);

    QHBoxLayout *channelsLayout = new QHBoxLayout;
    channelsLayout->addWidget(deactiveChannelsListWidget);
    channelsLayout->addWidget(probePlot);

    QPushButton* applyChannelsListButton = new QPushButton(tr("Apply active channel list"));
    connect(applyChannelsListButton, SIGNAL(clicked()),
            this, SLOT(applyChannelList()));

    QVBoxLayout* parameterLayout = new QVBoxLayout();
    parameterLayout->addWidget(applyChannelsListButton);
    parameterLayout->addLayout(thresholdLayout);
    parameterLayout->addLayout(blindWindowLayout);

    QGroupBox* parameterGroupBox = new QGroupBox(tr("Spike detector setting"));
    parameterGroupBox->setLayout(parameterLayout);

    timeWindow = new QComboBox();
    timeWindow->addItem("20 seconds");
    timeWindow->addItem("10 seconds");
    timeWindow->addItem("5 seconds");
    timeWindow->addItem("2 second");
    timeWindow->setCurrentIndex(0);
    timeWindow->setMinimumWidth(150);
    connect(timeWindow, SIGNAL(currentIndexChanged(int)),
            this, SLOT(changeTimescale(int)));

    startButton = new QPushButton(tr("Start HW spike detection"));
    connect(startButton, SIGNAL(clicked()),
            this, SLOT(run()));
    startButton->setMinimumHeight(50);
    startButton->setMinimumWidth(150);

    QVBoxLayout* displayLayout = new QVBoxLayout();
    displayLayout->addWidget(timeWindow);
    displayLayout->addWidget(startButton);

    QHBoxLayout* settingLayout = new QHBoxLayout();
    settingLayout->addWidget(parameterGroupBox);
    settingLayout->addWidget(addressGroupBox);
    settingLayout->addLayout(displayLayout);

    QVBoxLayout *mainLayout = new QVBoxLayout;
    mainLayout->addLayout(channelsLayout);
    mainLayout->addLayout(settingLayout);

    setLayout(mainLayout);
}

void SpikeDetectorDialog::SpikeDetectorDialogOnExit()
{
    if (!synthMode)
        run();
    while (!finished) {
        QThread::msleep(10);
    };
}

void SpikeDetectorDialog::run()
{
    running = !running;
    probePlot->run(running);
    if (!synthMode) {
        if (running) {
            startButton->setText(tr("Stop HW spike detection"));
            QtConcurrent::run(this, &SpikeDetectorDialog::runSpikeDetector);
            finished = false;
            wasRunning = evalBoard->isRunning();
            evalBoard->runSpikeDetector(true);
        } else {
            startButton->setText(tr("Start HW spike detection"));
            evalBoard->runSpikeDetector(false);
        }
    } else {
        if (running) {
            startButton->setText(tr("Stop HW spike detection"));
            QtConcurrent::run(this, &SpikeDetectorDialog::runSynthSpikeDetector);
        } else {
            startButton->setText(tr("Start HW spike detection"));
        }
    }
}

void  SpikeDetectorDialog::runSynthSpikeDetector()
{
    while (running) {
        if (QRandomGenerator::global()->bounded(2000) < 1){
            probePlot->updateStim(16);
            QThread::msleep(blindWindowSpinBox->value());
        }
        if (QRandomGenerator::global()->bounded(10) < 1) {
            quint32 ch = QRandomGenerator::global()->bounded(32)+1;
            if (!deactiveChannels[channelsOrdered.indexOf(ch)])
                probePlot->updateFiring(ch);
        }
        QThread::usleep(500);
    }
}

void  SpikeDetectorDialog::runSpikeDetector()
{
    quint32 DT, DT100;
    quint16 ID, MT, VAL;
    long spikesToRead;
    int i;
    unsigned char* spikeInfo = evalBoard->getSpikesInfo();
    while (running) {
        spikesToRead = evalBoard->readSpike();
        //if (spikesToRead%8 != 0)
        //    std::cout << "ahia" << endl;
        for (i=0; i<spikesToRead; i+=8) {
            VAL = ((quint16)spikeInfo[i+1] << 8)
                + ((quint16)spikeInfo[i+0]);
            ID = ((quint16)spikeInfo[i+3]);
            MT = ((quint16)spikeInfo[i+2]);
            DT = ((quint32)spikeInfo[i+5] << 24)
               + ((quint32)spikeInfo[i+4] << 16)
               + ((quint32)spikeInfo[i+7] << 8)
               + ((quint32)spikeInfo[i+6]);

            if (ID < 32) { // && !deactiveChannels[ID]) {
                DT100 = (DT-lastDT[ID])*4;
                lastDT[ID] = DT;
                //std::cout << "Spike on channel " << channelsOrdered[ID] << " of " << VAL/* * 0.195*/ << " at " << DT << " (RMS mult: " << float(MT)/2 << ")" << endl;
                if (sendSocket->state() == QUdpSocket::ConnectedState) {
                    datagram[0] = qToBigEndian(quint32(0));
                    datagram[1] = qToBigEndian(quint32(DT100));
                    datagram[2] = qToBigEndian(qint32(VAL));
                    datagram[3] = qToBigEndian(channelsOrdered[ID]);
                    sendSocket->writeDatagram((char*)datagram, 16, destAddress, destPort);
                }

                probePlot->updateFiring(channelsOrdered[ID]);
            }
            else
                std::cout << "Received spike with channel out of range " << ID << endl;
        }

        if (mainWindow->isRecording() && spikesToRead > 0) {
            saveFileName = *mainWindow->getSaveFileName();
            if (prevFileName != saveFileName) {
                prevFileName = saveFileName;
                hwDetectorFileName = saveFileName.left(saveFileName.size()-4) + "_HW_detections.rhs";
            }
            QFile fileStim(hwDetectorFileName);
            fileStim.open(QIODevice::WriteOnly | QIODevice::Append);
            QDataStream out(&fileStim);
            if (out.writeRawData((char*)spikeInfo, spikesToRead) != spikesToRead)
                std::cerr << "Error on write spikes to disk" << endl;
            //cout << spikesToRead << " data written" << endl;
        } else
            QThread::msleep(1);

        if (evalBoard->isRunning())
            wasRunning = true;
        else if (wasRunning)
            run();
    }
    finished = true;
}

void SpikeDetectorDialog::applyThreshold()
{
    if (!synthMode)
        evalBoard->setThresholdMult(thresholdSpinBox->value());
}

void SpikeDetectorDialog::applyBlindWindow()
{
    if (!synthMode)
        evalBoard->setBlindWindowLength(blindWindowSpinBox->value());
}

void SpikeDetectorDialog::applyChannelList()
{
    for (int i=0; i<32; i++) {
        if (deactiveChannelsList[i]->isSelected()) {
            deactiveChannels[channelsOrdered.indexOf(i+1)] = false;
        } else {
            deactiveChannels[channelsOrdered.indexOf(i+1)] = true;
        }
    }
    if (!synthMode)
        evalBoard->setDeactiveChannels(deactiveChannels);
}

void SpikeDetectorDialog::changeTimescale(int i)
{
    probePlot->setTimescale(i);
}

void SpikeDetectorDialog::connectUDP()
{
    if (!connected) {
        connectUDPButton->setText(tr("Disconnect"));

        QHostAddress hostAddr = QHostAddress(hostAddressComboBox->currentText());
        short hostPort = hostPortLineEdit->text().toShort();
        destAddress = QHostAddress(destAddressLineEdit->text());
        destPort = destPortLineEdit->text().toShort();

        if (recvSocket->bind(hostAddr, hostPort))
            cout << "Receiving stimuli on ";
        else
            cout << "Can't receive stimuli on ";
        cout << hostAddr.toString().toUtf8().constData() << ":" << hostPort << endl;
        connect(recvSocket, SIGNAL(readyRead()), this, SLOT(sendStimTrigger()));

        if (sendSocket->bind(hostAddr, 0))
            cout << "Sending spikes from " << hostAddr.toString().toUtf8().constData() << " to "
                 << destAddress.toString().toUtf8().constData() << ":" << destPort << endl;
        else
            cout << "Can't send from " << hostAddr.toString().toUtf8().constData() << endl;
    } else {
        connectUDPButton->setText(tr("Connect"));
        if (sendSocket->state() != QAbstractSocket::UnconnectedState)
            sendSocket->close();
        if (recvSocket->state() != QAbstractSocket::UnconnectedState)
            recvSocket->close();
    }
    connected = !connected;
}

void SpikeDetectorDialog::sendStimTrigger()
{
    double timestep_us = 1.0e6 / boardSampleRate;
    double currentstep_uA = Rhs2000Registers::stimStepSizeToDouble(stimStep) / 1.0e-6;

    while (recvSocket->pendingDatagramSize() > 15) {
        recvSocket->readDatagram(recvDatagram, 16, &sender, &senderPort);

        int ch = uint(recvDatagram[3])+
                (uint(recvDatagram[2])<<8)+
                (uint(recvDatagram[1])<<16)+
                (uint(recvDatagram[0])<<24);
        int rcvdChannel = channelsOrdered.indexOf(ch);

        int ampl = uint(recvDatagram[7])+
                  (uint(recvDatagram[6])<<8)+
                  (uint(recvDatagram[5])<<16)+
                  (uint(recvDatagram[4])<<24);

        if (!synthMode) {

            //--- added to try stim parameter manipulation
            SignalChannel* selectedChannel = wavePlot->selectedChannel(rcvdChannel);
            StimParameters* parameters = selectedChannel->stimParameters;
            int stream = selectedChannel->commandStream;
            int channel = selectedChannel->chipChannel;

            cout << "Stimulation ";
            if (lastChannel != rcvdChannel) {
                if (lastChannel >= 0) {
                    SignalChannel* lastSelectedChannel = wavePlot->selectedChannel(lastChannel);
                    StimParameters* lastParameters = lastSelectedChannel->stimParameters;
                    lastParameters->enabled = false;
                    int lastStream = lastSelectedChannel->commandStream;
                    int lastChannel = lastSelectedChannel->chipChannel;
                    evalBoard->configureStimTrigger(lastStream, lastChannel, (int) lastParameters->triggerSource,
                                                    lastParameters->enabled,
                                                    (lastParameters->triggerEdgeOrLevel == StimParameters::Edge),
                                                    (lastParameters->triggerHighOrLow == StimParameters::Low));
                }

                parameters->enabled = true;
                parameters->triggerSource = StimParameters::UDPEvent;
                parameters->firstPhaseAmplitude = ampl;
                parameters->secondPhaseAmplitude = ampl;

                evalBoard->setStimCmdMode(false);
                mainWindow->setStimSequenceParameters(evalBoard, timestep_us, currentstep_uA, stream, channel, parameters);
                evalBoard->setStimCmdMode(true);

                lastChannel = rcvdChannel;
                lastAmpl = -1;

                cout << "on channel " << ch << " (HW ch " << rcvdChannel << ")";
            }

            if (lastAmpl != ampl) {
                Rhs2000Registers chipRegisters(boardSampleRate, stimStep);
                int commandSequenceLength;
                vector<unsigned int> commandList;

                int firstPhaseAmplitude = (int)(ampl / currentstep_uA + 0.5);
                int secondPhaseAmplitude = (int)(ampl / currentstep_uA + 0.5);
                int posMag = (parameters->stimPolarity == StimParameters::PositiveFirst) ? firstPhaseAmplitude : secondPhaseAmplitude;
                int negMag = (parameters->stimPolarity == StimParameters::NegativeFirst) ? firstPhaseAmplitude : secondPhaseAmplitude;

                evalBoard->setStimCmdMode(false);
                evalBoard->enableAuxCommandsOnOneStream(stream);
                commandSequenceLength = chipRegisters.createCommandListSetStimMagnitudes(commandList, channel, posMag, 0, negMag, 0);
                evalBoard->uploadCommandList(commandList, Rhs2000EvalBoard::AuxCmd1);
                evalBoard->selectAuxCommandLength(Rhs2000EvalBoard::AuxCmd1, 0, commandSequenceLength - 1);
                evalBoard->setStimCmdMode(true);

                lastAmpl = ampl;

                cout << " of amplitude " << ampl;
            }
            cout << endl;

            if (evalBoard->isRunning()) {
                probePlot->updateStim(rcvdChannel);

                mainWindow->setManualStimTrigger(0, true);
                mainWindow->setManualStimTrigger(0, false);
            }
        } else {
            cout << "Received stimulation of " << ampl << " to channel " << ch << " (HW ch " << rcvdChannel << ")" << endl;
        }
    }
}
