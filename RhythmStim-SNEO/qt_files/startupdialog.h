//  ------------------------------------------------------------------------
//
//  This file is part of the Intan Technologies RHS2000 Interface
//  Version 1.01
//  Copyright (C) 2013-2017 Intan Technologies
//
//  ------------------------------------------------------------------------
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Lesser General Public License as published
//  by the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Lesser General Public License for more details.
//
//  You should have received a copy of the GNU Lesser General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.

#ifndef STARTUPDIALOG_H
#define STARTUPDIALOG_H

#include <QDialog>

class QComboBox;
class QDialogButtonBox;

class StartUpDialog : public QDialog
{
    Q_OBJECT
public:
    explicit StartUpDialog(int* sampleRateIndex_, int* stimStepIndex_, QWidget *parent = 0);

signals:

public slots:
    void accept();

private:
    int *sampleRateIndex;
    int *stimStepIndex;
    QComboBox *sampleRateComboBox;
    QComboBox *stimStepComboBox;

    QDialogButtonBox *buttonBox;
};

#endif // STARTUPDIALOG_H
