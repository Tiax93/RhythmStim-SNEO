/****************************************************************************
** Meta object code from reading C++ file 'spikedetectordialog.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.13.1)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include <memory>
#include "../../source/spikedetectordialog.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'spikedetectordialog.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.13.1. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_SpikeDetectorDialog_t {
    QByteArrayData data[12];
    char stringdata0[158];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_SpikeDetectorDialog_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_SpikeDetectorDialog_t qt_meta_stringdata_SpikeDetectorDialog = {
    {
QT_MOC_LITERAL(0, 0, 19), // "SpikeDetectorDialog"
QT_MOC_LITERAL(1, 20, 3), // "run"
QT_MOC_LITERAL(2, 24, 0), // ""
QT_MOC_LITERAL(3, 25, 16), // "runSpikeDetector"
QT_MOC_LITERAL(4, 42, 21), // "runSynthSpikeDetector"
QT_MOC_LITERAL(5, 64, 14), // "applyThreshold"
QT_MOC_LITERAL(6, 79, 16), // "applyBlindWindow"
QT_MOC_LITERAL(7, 96, 16), // "applyChannelList"
QT_MOC_LITERAL(8, 113, 15), // "changeTimescale"
QT_MOC_LITERAL(9, 129, 1), // "i"
QT_MOC_LITERAL(10, 131, 10), // "connectUDP"
QT_MOC_LITERAL(11, 142, 15) // "sendStimTrigger"

    },
    "SpikeDetectorDialog\0run\0\0runSpikeDetector\0"
    "runSynthSpikeDetector\0applyThreshold\0"
    "applyBlindWindow\0applyChannelList\0"
    "changeTimescale\0i\0connectUDP\0"
    "sendStimTrigger"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_SpikeDetectorDialog[] = {

 // content:
       8,       // revision
       0,       // classname
       0,    0, // classinfo
       9,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

 // slots: name, argc, parameters, tag, flags
       1,    0,   59,    2, 0x08 /* Private */,
       3,    0,   60,    2, 0x08 /* Private */,
       4,    0,   61,    2, 0x08 /* Private */,
       5,    0,   62,    2, 0x08 /* Private */,
       6,    0,   63,    2, 0x08 /* Private */,
       7,    0,   64,    2, 0x08 /* Private */,
       8,    1,   65,    2, 0x08 /* Private */,
      10,    0,   68,    2, 0x08 /* Private */,
      11,    0,   69,    2, 0x08 /* Private */,

 // slots: parameters
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void, QMetaType::Int,    9,
    QMetaType::Void,
    QMetaType::Void,

       0        // eod
};

void SpikeDetectorDialog::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        auto *_t = static_cast<SpikeDetectorDialog *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->run(); break;
        case 1: _t->runSpikeDetector(); break;
        case 2: _t->runSynthSpikeDetector(); break;
        case 3: _t->applyThreshold(); break;
        case 4: _t->applyBlindWindow(); break;
        case 5: _t->applyChannelList(); break;
        case 6: _t->changeTimescale((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 7: _t->connectUDP(); break;
        case 8: _t->sendStimTrigger(); break;
        default: ;
        }
    }
}

QT_INIT_METAOBJECT const QMetaObject SpikeDetectorDialog::staticMetaObject = { {
    &QDialog::staticMetaObject,
    qt_meta_stringdata_SpikeDetectorDialog.data,
    qt_meta_data_SpikeDetectorDialog,
    qt_static_metacall,
    nullptr,
    nullptr
} };


const QMetaObject *SpikeDetectorDialog::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *SpikeDetectorDialog::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_SpikeDetectorDialog.stringdata0))
        return static_cast<void*>(this);
    return QDialog::qt_metacast(_clname);
}

int SpikeDetectorDialog::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QDialog::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 9)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 9;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 9)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 9;
    }
    return _id;
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
