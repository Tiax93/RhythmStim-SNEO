//----------------------------------------------------------------------------------
// main.cpp
//
// Intan Technologies RHS2000 Interface
// Version 1.07
//
// Copyright (c) 2013-2020 Intan Technologies LLC
//
// This software is provided 'as-is', without any express or implied warranty.
// In no event will the authors be held liable for any damages arising from the
// use of this software.
//
// Permission is granted to anyone to use this software for any applications that
// use Intan Technologies integrated circuits, and to alter it and redistribute it
// freely.
//
// See http://www.intantech.com for documentation and product information.
//----------------------------------------------------------------------------------

#include <QApplication>
#include <QMessageBox>
#include <QSplashScreen>
#include <QStyleFactory>
#include <QDesktopWidget>

#include "startupdialog.h"
#include "mainwindow.h"


int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QSplashScreen *splash = new QSplashScreen();
    splash->setPixmap(QPixmap(":/images/splash.png"));

#ifdef __APPLE__
    app.setStyle(QStyleFactory::create("Fusion"));
    splash->setWindowFlags(Qt::WindowStaysOnBottomHint); // move splash screen to back in Mac OS, otherwise it covers startup dialog window
#elif __linux__
    splash->setWindowFlags(Qt::WindowStaysOnBottomHint); // not sure if we need this for Linux, but let's be safe
#endif

    splash->show();
    splash->showMessage(QObject::tr("Starting Intan Technologies Stimulation / Recording Controller v1.07..."), Qt::AlignCenter | Qt::AlignBottom, Qt::black);

    int sampleRateIndex, stimStepIndex;
    StartUpDialog *startUpDialog = new StartUpDialog(&sampleRateIndex, &stimStepIndex);
    startUpDialog->exec();

    MainWindow mainWin(sampleRateIndex, stimStepIndex);
    QObject::connect(&app, SIGNAL(focusChanged(QWidget*,QWidget*)), &mainWin, SLOT(notifyFocusChanged(QWidget*,QWidget*)));

    QDesktopWidget widget;
    QRect screenGeometry = widget.screenGeometry();
    //set to middle of screen
    mainWin.move((screenGeometry.width() - mainWin.width()) / 4, (screenGeometry.height() - mainWin.height()) / 3);

    mainWin.show();

    splash->finish(&mainWin);
    delete splash;
    delete startUpDialog;
    return app.exec();
}

