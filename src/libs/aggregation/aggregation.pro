include(../../qextensionsystemlibrary.pri)

#message("console/libs/aggregation/aggregation.pro -> config: " $$CONFIG)
#message("console/libs/aggregation/aggregation.pro -> qt: " $$QT)
#message("console/libs/aggregation/aggregation.pro -> defines: " $$DEFINES)
#message("console/libs/aggregation/aggregation.pro -> prefix: " $$PREFIX)

DEFINES += AGGREGATION_LIBRARY

HEADERS = aggregate.h \
    aggregation_global.h

SOURCES = aggregate.cpp

