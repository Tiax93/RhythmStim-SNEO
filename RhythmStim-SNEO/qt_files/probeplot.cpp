#include <QtGui>
#if QT_VERSION >= QT_VERSION_CHECK(5,0,0)
#include <QtWidgets>
#endif
#include <qmath.h>
#include <iostream>
#include <chrono>
#include <QRandomGenerator>

#include "probeplot.h"

// probe plot
// Created by Mattia Tambaro, to be used only with the custom bitfile created by me.

ProbePlot::ProbePlot(QWidget *parent) :
    QWidget(parent)
{
    width = 500;
    height = 548;

    setMinimumSize(width, height);
    setMaximumSize(width, height);

    setBackgroundRole(QPalette::Window);
    setAutoFillBackground(true);
    setSizePolicy(QSizePolicy::Preferred, QSizePolicy::Preferred);

    pixmap = QPixmap(size());
    pixmap.fill();
    drawAxis();

    timer = new QTimer(this);
    connect(timer, SIGNAL(timeout()), this, SLOT(draw()));

    setTimescale(0);
}

void ProbePlot::run(bool run)
{
    if (run) {
        timer->start(40);
        drawAxis();
        for (int c = 0; c < 32; c++) {
            spikes[c] = 0;
            stim[c] = 0;
        }
    } else
        timer->stop();
}

void ProbePlot::draw()
{
    QPainter painter(&pixmap);
    pixmap.scroll(-dx,0,dx,0,width-dx,height);
    painter.setPen(Qt::NoPen);
    painter.setBrush(Qt::white);
    //painter.drawRect(width-dx,0,dx,height);
    painter.drawPixmap(width-dx,0,cleanPixmap);

    painter.setPen(Qt::black);
    for (int c = 0; c < 32; c++) {
        if (spikes[c] > 0) {
            //spikes[c]--;
            spikes[c] = 0;
            painter.drawLine(width-1,c*17+1,width-1,c*17+17);
        }
        if (stim[c] > 0) {
            stim[c]--;
            painter.setPen(Qt::red);
            painter.drawLine(width-1,1,width-1,height-1);
            painter.setPen(Qt::blue);
            painter.drawLine(width-1,c*17+1,width-1,c*17+17);
            painter.setPen(Qt::black);
        }
    }

    update();
}

void ProbePlot::updateFiring(int ID)
{
    spikes[ID-1]++;
}

void ProbePlot::updateStim(int ch)
{
    stim[ch]++;
}

void ProbePlot::drawAxis()
{
    pixmap.fill();
    QPainter painter(&pixmap);
    painter.initFrom(this);

    painter.setPen(Qt::lightGray);
    painter.translate(0,18);
    for (int c = 0; c < 31; c++) {
        painter.drawLine(0,c*17,width-1,c*17);
    }

    update();
}

void ProbePlot::setTimescale(int t)
{
    switch (t) {
    case 0: // 20 seconds
        dx = 1;
        break;
    case 1: // 10 seconds
        dx = 2;
        break;
    case 2: // 5 seconds
        dx = 4;
        break;
    case 3: // 2 second
        dx = 10;
        break;
    }
    cleanPixmap = QPixmap(dx, height);
    cleanPixmap.fill();
    QPainter painter(&cleanPixmap);
    painter.setPen(Qt::lightGray);
    painter.translate(-1,18);
    for (int c = 0; c < 31*17; c+=17)
        painter.drawLine(0,c,dx,c);
    drawAxis();
}

void ProbePlot::paintEvent(QPaintEvent *)
{
    QStylePainter stylePainter(this);
    stylePainter.drawPixmap(0, 0, pixmap);
}

void ProbePlot::closeEvent(QCloseEvent *event)
{
    // Perform any clean-up here before application closes.
    event->accept();
}
