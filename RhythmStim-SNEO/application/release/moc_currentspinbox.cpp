/****************************************************************************
** Meta object code from reading C++ file 'currentspinbox.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.13.1)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include <memory>
#include "../../source/currentspinbox.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'currentspinbox.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.13.1. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_CurrentSpinBox_t {
    QByteArrayData data[12];
    char stringdata0[131];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_CurrentSpinBox_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_CurrentSpinBox_t qt_meta_stringdata_CurrentSpinBox = {
    {
QT_MOC_LITERAL(0, 0, 14), // "CurrentSpinBox"
QT_MOC_LITERAL(1, 15, 15), // "editingFinished"
QT_MOC_LITERAL(2, 31, 0), // ""
QT_MOC_LITERAL(3, 32, 12), // "valueChanged"
QT_MOC_LITERAL(4, 45, 16), // "trueValueChanged"
QT_MOC_LITERAL(5, 62, 8), // "setValue"
QT_MOC_LITERAL(6, 71, 3), // "val"
QT_MOC_LITERAL(7, 75, 9), // "loadValue"
QT_MOC_LITERAL(8, 85, 5), // "round"
QT_MOC_LITERAL(9, 91, 10), // "scaleUnits"
QT_MOC_LITERAL(10, 102, 6), // "val_uA"
QT_MOC_LITERAL(11, 109, 21) // "sendSignalValueMicroA"

    },
    "CurrentSpinBox\0editingFinished\0\0"
    "valueChanged\0trueValueChanged\0setValue\0"
    "val\0loadValue\0round\0scaleUnits\0val_uA\0"
    "sendSignalValueMicroA"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_CurrentSpinBox[] = {

 // content:
       8,       // revision
       0,       // classname
       0,    0, // classinfo
       8,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       3,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    0,   54,    2, 0x06 /* Public */,
       3,    1,   55,    2, 0x06 /* Public */,
       4,    1,   58,    2, 0x06 /* Public */,

 // slots: name, argc, parameters, tag, flags
       5,    1,   61,    2, 0x0a /* Public */,
       7,    1,   64,    2, 0x0a /* Public */,
       8,    0,   67,    2, 0x0a /* Public */,
       9,    1,   68,    2, 0x08 /* Private */,
      11,    1,   71,    2, 0x08 /* Private */,

 // signals: parameters
    QMetaType::Void,
    QMetaType::Void, QMetaType::Double,    2,
    QMetaType::Void, QMetaType::Double,    2,

 // slots: parameters
    QMetaType::Void, QMetaType::Double,    6,
    QMetaType::Void, QMetaType::Double,    6,
    QMetaType::Void,
    QMetaType::Void, QMetaType::Double,   10,
    QMetaType::Void, QMetaType::Double,    6,

       0        // eod
};

void CurrentSpinBox::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        auto *_t = static_cast<CurrentSpinBox *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->editingFinished(); break;
        case 1: _t->valueChanged((*reinterpret_cast< double(*)>(_a[1]))); break;
        case 2: _t->trueValueChanged((*reinterpret_cast< double(*)>(_a[1]))); break;
        case 3: _t->setValue((*reinterpret_cast< double(*)>(_a[1]))); break;
        case 4: _t->loadValue((*reinterpret_cast< double(*)>(_a[1]))); break;
        case 5: _t->round(); break;
        case 6: _t->scaleUnits((*reinterpret_cast< double(*)>(_a[1]))); break;
        case 7: _t->sendSignalValueMicroA((*reinterpret_cast< double(*)>(_a[1]))); break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        {
            using _t = void (CurrentSpinBox::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&CurrentSpinBox::editingFinished)) {
                *result = 0;
                return;
            }
        }
        {
            using _t = void (CurrentSpinBox::*)(double );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&CurrentSpinBox::valueChanged)) {
                *result = 1;
                return;
            }
        }
        {
            using _t = void (CurrentSpinBox::*)(double );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&CurrentSpinBox::trueValueChanged)) {
                *result = 2;
                return;
            }
        }
    }
}

QT_INIT_METAOBJECT const QMetaObject CurrentSpinBox::staticMetaObject = { {
    &QWidget::staticMetaObject,
    qt_meta_stringdata_CurrentSpinBox.data,
    qt_meta_data_CurrentSpinBox,
    qt_static_metacall,
    nullptr,
    nullptr
} };


const QMetaObject *CurrentSpinBox::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *CurrentSpinBox::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_CurrentSpinBox.stringdata0))
        return static_cast<void*>(this);
    return QWidget::qt_metacast(_clname);
}

int CurrentSpinBox::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QWidget::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 8)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 8;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 8)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 8;
    }
    return _id;
}

// SIGNAL 0
void CurrentSpinBox::editingFinished()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void CurrentSpinBox::valueChanged(double _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 1, _a);
}

// SIGNAL 2
void CurrentSpinBox::trueValueChanged(double _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 2, _a);
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
