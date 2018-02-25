dll {
    DEFINES += QTCREATOR_UTILS_LIB
} else {
    DEFINES += QTCREATOR_UTILS_STATIC_LIB
}

QT += network

CONFIG += exceptions # used by portlist.cpp, textfileformat.cpp, and ssh/*

CONFIG += console
QT -= gui
DEFINES += CONSOLE

#message("console/libs/utils/utils-lib.pri -> config: " $$CONFIG)
#message("console/libs/utils/utils-lib.pri -> qt: " $$QT)

win32: LIBS += -luser32 -lshell32
# PortsGatherer
win32: LIBS += -liphlpapi -lws2_32

SOURCES += \
    $$PWD/hostosinfo.cpp \

HEADERS += \
    $$PWD/hostosinfo.h \
