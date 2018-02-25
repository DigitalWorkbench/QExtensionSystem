DEFINES += EXTENSIONSYSTEM_LIBRARY
include(../../qextensionsystemlibrary.pri)

#message("console/libs/extensionsystem/extensionsystem.pro -> config: " $$CONFIG)
#message("console/libs/extensionsystem/extensionsystem.pro -> qt: " $$QT)
#message("console/libs/extensionsystem/extensionsystem.pro -> defines: " $$DEFINES)

unix:LIBS += $$QMAKE_LIBS_DYNLOAD

!isEmpty(vcproj) {
    DEFINES += IDE_TEST_DIR=\"$$IDE_SOURCE_TREE\"
} else {
    DEFINES += IDE_TEST_DIR=\\\"$$IDE_SOURCE_TREE\\\"
}


HEADERS += \
    invoker.h \
    iplugin.h \
    iplugin_p.h \
    extensionsystem_global.h \
    pluginmanager.h \
    pluginmanager_p.h \
    pluginspec.h \
    pluginspec_p.h \
    optionsparser.h \
    plugincollection.h

SOURCES += \
    invoker.cpp \
    iplugin.cpp \
    pluginmanager.cpp \
    pluginspec.cpp \
    optionsparser.cpp \
    plugincollection.cpp

CONFIG(console) {
} else {

HEADERS += pluginerrorview.h \
    plugindetailsview.h \
    pluginview.h \
    pluginerroroverview.h

SOURCES += pluginerrorview.cpp \
    plugindetailsview.cpp \
    pluginview.cpp \
    pluginerroroverview.cpp

FORMS += \
    pluginerrorview.ui \
    plugindetailsview.ui \
    pluginerroroverview.ui
}

RESOURCES += pluginview.qrc



