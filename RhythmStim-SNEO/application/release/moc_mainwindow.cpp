/****************************************************************************
** Meta object code from reading C++ file 'mainwindow.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.13.1)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include <memory>
#include "../../source/mainwindow.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'mainwindow.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.13.1. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_MainWindow_t {
    QByteArrayData data[103];
    char stringdata0[1668];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_MainWindow_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_MainWindow_t qt_meta_stringdata_MainWindow = {
    {
QT_MOC_LITERAL(0, 0, 10), // "MainWindow"
QT_MOC_LITERAL(1, 11, 12), // "focusChanged"
QT_MOC_LITERAL(2, 24, 0), // ""
QT_MOC_LITERAL(3, 25, 8), // "QWidget*"
QT_MOC_LITERAL(4, 34, 9), // "lostFocus"
QT_MOC_LITERAL(5, 44, 11), // "gainedFocus"
QT_MOC_LITERAL(6, 56, 18), // "notifyFocusChanged"
QT_MOC_LITERAL(7, 75, 18), // "copyStimParameters"
QT_MOC_LITERAL(8, 94, 19), // "pasteStimParameters"
QT_MOC_LITERAL(9, 114, 25), // "setStimSequenceParameters"
QT_MOC_LITERAL(10, 140, 17), // "Rhs2000EvalBoard*"
QT_MOC_LITERAL(11, 158, 9), // "evalBoard"
QT_MOC_LITERAL(12, 168, 11), // "timestep_us"
QT_MOC_LITERAL(13, 180, 14), // "currentstep_uA"
QT_MOC_LITERAL(14, 195, 6), // "stream"
QT_MOC_LITERAL(15, 202, 7), // "channel"
QT_MOC_LITERAL(16, 210, 15), // "StimParameters*"
QT_MOC_LITERAL(17, 226, 10), // "parameters"
QT_MOC_LITERAL(18, 237, 5), // "about"
QT_MOC_LITERAL(19, 243, 21), // "keyboardShortcutsHelp"
QT_MOC_LITERAL(20, 265, 15), // "chipFiltersHelp"
QT_MOC_LITERAL(21, 281, 15), // "comparatorsHelp"
QT_MOC_LITERAL(22, 297, 8), // "dacsHelp"
QT_MOC_LITERAL(23, 306, 18), // "highpassFilterHelp"
QT_MOC_LITERAL(24, 325, 15), // "notchFilterHelp"
QT_MOC_LITERAL(25, 341, 14), // "fastSettleHelp"
QT_MOC_LITERAL(26, 356, 14), // "ioExpanderHelp"
QT_MOC_LITERAL(27, 371, 16), // "openIntanWebsite"
QT_MOC_LITERAL(28, 388, 17), // "runInterfaceBoard"
QT_MOC_LITERAL(29, 406, 20), // "recordInterfaceBoard"
QT_MOC_LITERAL(30, 427, 27), // "triggerRecordInterfaceBoard"
QT_MOC_LITERAL(31, 455, 18), // "stopInterfaceBoard"
QT_MOC_LITERAL(32, 474, 22), // "selectBaseFilenameSlot"
QT_MOC_LITERAL(33, 497, 15), // "changeNumFrames"
QT_MOC_LITERAL(34, 513, 5), // "index"
QT_MOC_LITERAL(35, 519, 12), // "changeYScale"
QT_MOC_LITERAL(36, 532, 17), // "changeYScaleDcAmp"
QT_MOC_LITERAL(37, 550, 15), // "changeYScaleAdc"
QT_MOC_LITERAL(38, 566, 13), // "changeAmpType"
QT_MOC_LITERAL(39, 580, 12), // "changeTScale"
QT_MOC_LITERAL(40, 593, 16), // "changeSampleRate"
QT_MOC_LITERAL(41, 610, 15), // "sampleRateIndex"
QT_MOC_LITERAL(42, 626, 16), // "updateStimParams"
QT_MOC_LITERAL(43, 643, 17), // "changeNotchFilter"
QT_MOC_LITERAL(44, 661, 16), // "notchFilterIndex"
QT_MOC_LITERAL(45, 678, 20), // "enableHighpassFilter"
QT_MOC_LITERAL(46, 699, 6), // "enable"
QT_MOC_LITERAL(47, 706, 29), // "highpassFilterLineEditChanged"
QT_MOC_LITERAL(48, 736, 15), // "changeBandwidth"
QT_MOC_LITERAL(49, 752, 24), // "changeImpedanceFrequency"
QT_MOC_LITERAL(50, 777, 10), // "changePort"
QT_MOC_LITERAL(51, 788, 4), // "port"
QT_MOC_LITERAL(52, 793, 13), // "changeDacGain"
QT_MOC_LITERAL(53, 807, 22), // "changeDacNoiseSuppress"
QT_MOC_LITERAL(54, 830, 9), // "dacEnable"
QT_MOC_LITERAL(55, 840, 13), // "dacSetChannel"
QT_MOC_LITERAL(56, 854, 11), // "dacSelected"
QT_MOC_LITERAL(57, 866, 10), // "dacChannel"
QT_MOC_LITERAL(58, 877, 13), // "renameChannel"
QT_MOC_LITERAL(59, 891, 20), // "sortChannelsByNumber"
QT_MOC_LITERAL(60, 912, 18), // "sortChannelsByName"
QT_MOC_LITERAL(61, 931, 27), // "restoreOriginalChannelOrder"
QT_MOC_LITERAL(62, 959, 19), // "alphabetizeChannels"
QT_MOC_LITERAL(63, 979, 19), // "toggleChannelEnable"
QT_MOC_LITERAL(64, 999, 17), // "enableAllChannels"
QT_MOC_LITERAL(65, 1017, 18), // "disableAllChannels"
QT_MOC_LITERAL(66, 1036, 10), // "spikeScope"
QT_MOC_LITERAL(67, 1047, 13), // "spikeDetector"
QT_MOC_LITERAL(68, 1061, 18), // "newSelectedChannel"
QT_MOC_LITERAL(69, 1080, 14), // "SignalChannel*"
QT_MOC_LITERAL(70, 1095, 10), // "newChannel"
QT_MOC_LITERAL(71, 1106, 9), // "scanPorts"
QT_MOC_LITERAL(72, 1116, 12), // "loadSettings"
QT_MOC_LITERAL(73, 1129, 12), // "saveSettings"
QT_MOC_LITERAL(74, 1142, 16), // "loadStimSettings"
QT_MOC_LITERAL(75, 1159, 16), // "saveStimSettings"
QT_MOC_LITERAL(76, 1176, 14), // "showImpedances"
QT_MOC_LITERAL(77, 1191, 7), // "enabled"
QT_MOC_LITERAL(78, 1199, 14), // "saveImpedances"
QT_MOC_LITERAL(79, 1214, 23), // "runImpedanceMeasurement"
QT_MOC_LITERAL(80, 1238, 23), // "manualCableDelayControl"
QT_MOC_LITERAL(81, 1262, 14), // "plotPointsMode"
QT_MOC_LITERAL(82, 1277, 19), // "setSaveFormatDialog"
QT_MOC_LITERAL(83, 1297, 16), // "setDacThreshold1"
QT_MOC_LITERAL(84, 1314, 9), // "threshold"
QT_MOC_LITERAL(85, 1324, 16), // "setDacThreshold2"
QT_MOC_LITERAL(86, 1341, 16), // "setDacThreshold3"
QT_MOC_LITERAL(87, 1358, 16), // "setDacThreshold4"
QT_MOC_LITERAL(88, 1375, 16), // "setDacThreshold5"
QT_MOC_LITERAL(89, 1392, 16), // "setDacThreshold6"
QT_MOC_LITERAL(90, 1409, 16), // "setDacThreshold7"
QT_MOC_LITERAL(91, 1426, 16), // "setDacThreshold8"
QT_MOC_LITERAL(92, 1443, 18), // "dacThresholdEnable"
QT_MOC_LITERAL(93, 1462, 27), // "referenceSetSelectedChannel"
QT_MOC_LITERAL(94, 1490, 20), // "referenceSetHardware"
QT_MOC_LITERAL(95, 1511, 13), // "referenceHelp"
QT_MOC_LITERAL(96, 1525, 9), // "stimParam"
QT_MOC_LITERAL(97, 1535, 31), // "setDigitalOutSequenceParameters"
QT_MOC_LITERAL(98, 1567, 30), // "setAnalogOutSequenceParameters"
QT_MOC_LITERAL(99, 1598, 17), // "ampSettleSettings"
QT_MOC_LITERAL(100, 1616, 22), // "chargeRecoverySettings"
QT_MOC_LITERAL(101, 1639, 25), // "spikeDetectorDialogOnExit"
QT_MOC_LITERAL(102, 1665, 2) // "ob"

    },
    "MainWindow\0focusChanged\0\0QWidget*\0"
    "lostFocus\0gainedFocus\0notifyFocusChanged\0"
    "copyStimParameters\0pasteStimParameters\0"
    "setStimSequenceParameters\0Rhs2000EvalBoard*\0"
    "evalBoard\0timestep_us\0currentstep_uA\0"
    "stream\0channel\0StimParameters*\0"
    "parameters\0about\0keyboardShortcutsHelp\0"
    "chipFiltersHelp\0comparatorsHelp\0"
    "dacsHelp\0highpassFilterHelp\0notchFilterHelp\0"
    "fastSettleHelp\0ioExpanderHelp\0"
    "openIntanWebsite\0runInterfaceBoard\0"
    "recordInterfaceBoard\0triggerRecordInterfaceBoard\0"
    "stopInterfaceBoard\0selectBaseFilenameSlot\0"
    "changeNumFrames\0index\0changeYScale\0"
    "changeYScaleDcAmp\0changeYScaleAdc\0"
    "changeAmpType\0changeTScale\0changeSampleRate\0"
    "sampleRateIndex\0updateStimParams\0"
    "changeNotchFilter\0notchFilterIndex\0"
    "enableHighpassFilter\0enable\0"
    "highpassFilterLineEditChanged\0"
    "changeBandwidth\0changeImpedanceFrequency\0"
    "changePort\0port\0changeDacGain\0"
    "changeDacNoiseSuppress\0dacEnable\0"
    "dacSetChannel\0dacSelected\0dacChannel\0"
    "renameChannel\0sortChannelsByNumber\0"
    "sortChannelsByName\0restoreOriginalChannelOrder\0"
    "alphabetizeChannels\0toggleChannelEnable\0"
    "enableAllChannels\0disableAllChannels\0"
    "spikeScope\0spikeDetector\0newSelectedChannel\0"
    "SignalChannel*\0newChannel\0scanPorts\0"
    "loadSettings\0saveSettings\0loadStimSettings\0"
    "saveStimSettings\0showImpedances\0enabled\0"
    "saveImpedances\0runImpedanceMeasurement\0"
    "manualCableDelayControl\0plotPointsMode\0"
    "setSaveFormatDialog\0setDacThreshold1\0"
    "threshold\0setDacThreshold2\0setDacThreshold3\0"
    "setDacThreshold4\0setDacThreshold5\0"
    "setDacThreshold6\0setDacThreshold7\0"
    "setDacThreshold8\0dacThresholdEnable\0"
    "referenceSetSelectedChannel\0"
    "referenceSetHardware\0referenceHelp\0"
    "stimParam\0setDigitalOutSequenceParameters\0"
    "setAnalogOutSequenceParameters\0"
    "ampSettleSettings\0chargeRecoverySettings\0"
    "spikeDetectorDialogOnExit\0ob"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_MainWindow[] = {

 // content:
       8,       // revision
       0,       // classname
       0,    0, // classinfo
      78,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       1,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    2,  404,    2, 0x06 /* Public */,

 // slots: name, argc, parameters, tag, flags
       6,    2,  409,    2, 0x0a /* Public */,
       7,    0,  414,    2, 0x0a /* Public */,
       8,    0,  415,    2, 0x0a /* Public */,
       9,    6,  416,    2, 0x0a /* Public */,
      18,    0,  429,    2, 0x08 /* Private */,
      19,    0,  430,    2, 0x08 /* Private */,
      20,    0,  431,    2, 0x08 /* Private */,
      21,    0,  432,    2, 0x08 /* Private */,
      22,    0,  433,    2, 0x08 /* Private */,
      23,    0,  434,    2, 0x08 /* Private */,
      24,    0,  435,    2, 0x08 /* Private */,
      25,    0,  436,    2, 0x08 /* Private */,
      26,    0,  437,    2, 0x08 /* Private */,
      27,    0,  438,    2, 0x08 /* Private */,
      28,    0,  439,    2, 0x08 /* Private */,
      29,    0,  440,    2, 0x08 /* Private */,
      30,    0,  441,    2, 0x08 /* Private */,
      31,    0,  442,    2, 0x08 /* Private */,
      32,    0,  443,    2, 0x08 /* Private */,
      33,    1,  444,    2, 0x08 /* Private */,
      35,    1,  447,    2, 0x08 /* Private */,
      36,    1,  450,    2, 0x08 /* Private */,
      37,    1,  453,    2, 0x08 /* Private */,
      38,    1,  456,    2, 0x08 /* Private */,
      39,    1,  459,    2, 0x08 /* Private */,
      40,    2,  462,    2, 0x08 /* Private */,
      43,    1,  467,    2, 0x08 /* Private */,
      45,    1,  470,    2, 0x08 /* Private */,
      47,    0,  473,    2, 0x08 /* Private */,
      48,    0,  474,    2, 0x08 /* Private */,
      49,    0,  475,    2, 0x08 /* Private */,
      50,    1,  476,    2, 0x08 /* Private */,
      52,    1,  479,    2, 0x08 /* Private */,
      53,    1,  482,    2, 0x08 /* Private */,
      54,    1,  485,    2, 0x08 /* Private */,
      55,    0,  488,    2, 0x08 /* Private */,
      56,    1,  489,    2, 0x08 /* Private */,
      58,    0,  492,    2, 0x08 /* Private */,
      59,    0,  493,    2, 0x08 /* Private */,
      60,    0,  494,    2, 0x08 /* Private */,
      61,    0,  495,    2, 0x08 /* Private */,
      62,    0,  496,    2, 0x08 /* Private */,
      63,    0,  497,    2, 0x08 /* Private */,
      64,    0,  498,    2, 0x08 /* Private */,
      65,    0,  499,    2, 0x08 /* Private */,
      66,    0,  500,    2, 0x08 /* Private */,
      67,    0,  501,    2, 0x08 /* Private */,
      68,    1,  502,    2, 0x08 /* Private */,
      71,    0,  505,    2, 0x08 /* Private */,
      72,    0,  506,    2, 0x08 /* Private */,
      73,    0,  507,    2, 0x08 /* Private */,
      74,    0,  508,    2, 0x08 /* Private */,
      75,    0,  509,    2, 0x08 /* Private */,
      76,    1,  510,    2, 0x08 /* Private */,
      78,    0,  513,    2, 0x08 /* Private */,
      79,    0,  514,    2, 0x08 /* Private */,
      80,    0,  515,    2, 0x08 /* Private */,
      81,    1,  516,    2, 0x08 /* Private */,
      82,    0,  519,    2, 0x08 /* Private */,
      83,    1,  520,    2, 0x08 /* Private */,
      85,    1,  523,    2, 0x08 /* Private */,
      86,    1,  526,    2, 0x08 /* Private */,
      87,    1,  529,    2, 0x08 /* Private */,
      88,    1,  532,    2, 0x08 /* Private */,
      89,    1,  535,    2, 0x08 /* Private */,
      90,    1,  538,    2, 0x08 /* Private */,
      91,    1,  541,    2, 0x08 /* Private */,
      92,    0,  544,    2, 0x08 /* Private */,
      93,    0,  545,    2, 0x08 /* Private */,
      94,    0,  546,    2, 0x08 /* Private */,
      95,    0,  547,    2, 0x08 /* Private */,
      96,    0,  548,    2, 0x08 /* Private */,
      97,    4,  549,    2, 0x08 /* Private */,
      98,    4,  558,    2, 0x08 /* Private */,
      99,    0,  567,    2, 0x08 /* Private */,
     100,    0,  568,    2, 0x08 /* Private */,
     101,    1,  569,    2, 0x08 /* Private */,

 // signals: parameters
    QMetaType::Void, 0x80000000 | 3, 0x80000000 | 3,    4,    5,

 // slots: parameters
    QMetaType::Void, 0x80000000 | 3, 0x80000000 | 3,    4,    5,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void, 0x80000000 | 10, QMetaType::Double, QMetaType::Double, QMetaType::Int, QMetaType::Int, 0x80000000 | 16,   11,   12,   13,   14,   15,   17,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void, QMetaType::Int,   34,
    QMetaType::Void, QMetaType::Int,   34,
    QMetaType::Void, QMetaType::Int,   34,
    QMetaType::Void, QMetaType::Int,   34,
    QMetaType::Void, QMetaType::Int,   34,
    QMetaType::Void, QMetaType::Int,   34,
    QMetaType::Void, QMetaType::Int, QMetaType::Bool,   41,   42,
    QMetaType::Void, QMetaType::Int,   44,
    QMetaType::Void, QMetaType::Bool,   46,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void, QMetaType::Int,   51,
    QMetaType::Void, QMetaType::Int,   34,
    QMetaType::Void, QMetaType::Int,   34,
    QMetaType::Void, QMetaType::Bool,   46,
    QMetaType::Void,
    QMetaType::Void, QMetaType::Int,   57,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void, 0x80000000 | 69,   70,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void, QMetaType::Bool,   77,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void, QMetaType::Bool,   77,
    QMetaType::Void,
    QMetaType::Void, QMetaType::Int,   84,
    QMetaType::Void, QMetaType::Int,   84,
    QMetaType::Void, QMetaType::Int,   84,
    QMetaType::Void, QMetaType::Int,   84,
    QMetaType::Void, QMetaType::Int,   84,
    QMetaType::Void, QMetaType::Int,   84,
    QMetaType::Void, QMetaType::Int,   84,
    QMetaType::Void, QMetaType::Int,   84,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void, 0x80000000 | 10, QMetaType::Double, QMetaType::Int, 0x80000000 | 16,   11,   12,   15,   17,
    QMetaType::Void, 0x80000000 | 10, QMetaType::Double, QMetaType::Int, 0x80000000 | 16,   11,   12,   15,   17,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void, QMetaType::QObjectStar,  102,

       0        // eod
};

void MainWindow::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        auto *_t = static_cast<MainWindow *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->focusChanged((*reinterpret_cast< QWidget*(*)>(_a[1])),(*reinterpret_cast< QWidget*(*)>(_a[2]))); break;
        case 1: _t->notifyFocusChanged((*reinterpret_cast< QWidget*(*)>(_a[1])),(*reinterpret_cast< QWidget*(*)>(_a[2]))); break;
        case 2: _t->copyStimParameters(); break;
        case 3: _t->pasteStimParameters(); break;
        case 4: _t->setStimSequenceParameters((*reinterpret_cast< Rhs2000EvalBoard*(*)>(_a[1])),(*reinterpret_cast< double(*)>(_a[2])),(*reinterpret_cast< double(*)>(_a[3])),(*reinterpret_cast< int(*)>(_a[4])),(*reinterpret_cast< int(*)>(_a[5])),(*reinterpret_cast< StimParameters*(*)>(_a[6]))); break;
        case 5: _t->about(); break;
        case 6: _t->keyboardShortcutsHelp(); break;
        case 7: _t->chipFiltersHelp(); break;
        case 8: _t->comparatorsHelp(); break;
        case 9: _t->dacsHelp(); break;
        case 10: _t->highpassFilterHelp(); break;
        case 11: _t->notchFilterHelp(); break;
        case 12: _t->fastSettleHelp(); break;
        case 13: _t->ioExpanderHelp(); break;
        case 14: _t->openIntanWebsite(); break;
        case 15: _t->runInterfaceBoard(); break;
        case 16: _t->recordInterfaceBoard(); break;
        case 17: _t->triggerRecordInterfaceBoard(); break;
        case 18: _t->stopInterfaceBoard(); break;
        case 19: _t->selectBaseFilenameSlot(); break;
        case 20: _t->changeNumFrames((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 21: _t->changeYScale((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 22: _t->changeYScaleDcAmp((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 23: _t->changeYScaleAdc((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 24: _t->changeAmpType((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 25: _t->changeTScale((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 26: _t->changeSampleRate((*reinterpret_cast< int(*)>(_a[1])),(*reinterpret_cast< bool(*)>(_a[2]))); break;
        case 27: _t->changeNotchFilter((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 28: _t->enableHighpassFilter((*reinterpret_cast< bool(*)>(_a[1]))); break;
        case 29: _t->highpassFilterLineEditChanged(); break;
        case 30: _t->changeBandwidth(); break;
        case 31: _t->changeImpedanceFrequency(); break;
        case 32: _t->changePort((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 33: _t->changeDacGain((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 34: _t->changeDacNoiseSuppress((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 35: _t->dacEnable((*reinterpret_cast< bool(*)>(_a[1]))); break;
        case 36: _t->dacSetChannel(); break;
        case 37: _t->dacSelected((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 38: _t->renameChannel(); break;
        case 39: _t->sortChannelsByNumber(); break;
        case 40: _t->sortChannelsByName(); break;
        case 41: _t->restoreOriginalChannelOrder(); break;
        case 42: _t->alphabetizeChannels(); break;
        case 43: _t->toggleChannelEnable(); break;
        case 44: _t->enableAllChannels(); break;
        case 45: _t->disableAllChannels(); break;
        case 46: _t->spikeScope(); break;
        case 47: _t->spikeDetector(); break;
        case 48: _t->newSelectedChannel((*reinterpret_cast< SignalChannel*(*)>(_a[1]))); break;
        case 49: _t->scanPorts(); break;
        case 50: _t->loadSettings(); break;
        case 51: _t->saveSettings(); break;
        case 52: _t->loadStimSettings(); break;
        case 53: _t->saveStimSettings(); break;
        case 54: _t->showImpedances((*reinterpret_cast< bool(*)>(_a[1]))); break;
        case 55: _t->saveImpedances(); break;
        case 56: _t->runImpedanceMeasurement(); break;
        case 57: _t->manualCableDelayControl(); break;
        case 58: _t->plotPointsMode((*reinterpret_cast< bool(*)>(_a[1]))); break;
        case 59: _t->setSaveFormatDialog(); break;
        case 60: _t->setDacThreshold1((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 61: _t->setDacThreshold2((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 62: _t->setDacThreshold3((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 63: _t->setDacThreshold4((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 64: _t->setDacThreshold5((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 65: _t->setDacThreshold6((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 66: _t->setDacThreshold7((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 67: _t->setDacThreshold8((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 68: _t->dacThresholdEnable(); break;
        case 69: _t->referenceSetSelectedChannel(); break;
        case 70: _t->referenceSetHardware(); break;
        case 71: _t->referenceHelp(); break;
        case 72: _t->stimParam(); break;
        case 73: _t->setDigitalOutSequenceParameters((*reinterpret_cast< Rhs2000EvalBoard*(*)>(_a[1])),(*reinterpret_cast< double(*)>(_a[2])),(*reinterpret_cast< int(*)>(_a[3])),(*reinterpret_cast< StimParameters*(*)>(_a[4]))); break;
        case 74: _t->setAnalogOutSequenceParameters((*reinterpret_cast< Rhs2000EvalBoard*(*)>(_a[1])),(*reinterpret_cast< double(*)>(_a[2])),(*reinterpret_cast< int(*)>(_a[3])),(*reinterpret_cast< StimParameters*(*)>(_a[4]))); break;
        case 75: _t->ampSettleSettings(); break;
        case 76: _t->chargeRecoverySettings(); break;
        case 77: _t->spikeDetectorDialogOnExit((*reinterpret_cast< QObject*(*)>(_a[1]))); break;
        default: ;
        }
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        switch (_id) {
        default: *reinterpret_cast<int*>(_a[0]) = -1; break;
        case 0:
            switch (*reinterpret_cast<int*>(_a[1])) {
            default: *reinterpret_cast<int*>(_a[0]) = -1; break;
            case 1:
            case 0:
                *reinterpret_cast<int*>(_a[0]) = qRegisterMetaType< QWidget* >(); break;
            }
            break;
        case 1:
            switch (*reinterpret_cast<int*>(_a[1])) {
            default: *reinterpret_cast<int*>(_a[0]) = -1; break;
            case 1:
            case 0:
                *reinterpret_cast<int*>(_a[0]) = qRegisterMetaType< QWidget* >(); break;
            }
            break;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        {
            using _t = void (MainWindow::*)(QWidget * , QWidget * );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&MainWindow::focusChanged)) {
                *result = 0;
                return;
            }
        }
    }
}

QT_INIT_METAOBJECT const QMetaObject MainWindow::staticMetaObject = { {
    &QMainWindow::staticMetaObject,
    qt_meta_stringdata_MainWindow.data,
    qt_meta_data_MainWindow,
    qt_static_metacall,
    nullptr,
    nullptr
} };


const QMetaObject *MainWindow::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *MainWindow::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_MainWindow.stringdata0))
        return static_cast<void*>(this);
    return QMainWindow::qt_metacast(_clname);
}

int MainWindow::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QMainWindow::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 78)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 78;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 78)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 78;
    }
    return _id;
}

// SIGNAL 0
void MainWindow::focusChanged(QWidget * _t1, QWidget * _t2)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))), const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t2))) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
