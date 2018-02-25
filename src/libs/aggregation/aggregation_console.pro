include(../../qextensionsystemlibrary.pri)

QT -= gui
CONFIG += console
DEFINES += CONSOLE

DEFINES += AGGREGATION_LIBRARY

HEADERS = $$PWD/aggregate.h \
    $$PWD/aggregation_global.h

SOURCES = $$PWD/aggregate.cpp

message("console/libs/aggregation/aggregation.pro -> config: " $$CONFIG)
message("console/libs/aggregation/aggregation.pro -> qt: " $$QT)
message("console/libs/aggregation/aggregation.pro -> defines: " $$DEFINES)
