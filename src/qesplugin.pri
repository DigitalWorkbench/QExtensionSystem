depfile = $$replace(_PRO_FILE_PWD_, ([^/]+$), \\1/\\1_dependencies.pri)
exists($$depfile) {
    include($$depfile)
    isEmpty(QTC_PLUGIN_NAME): \
        error("$$basename(depfile) does not define QTC_PLUGIN_NAME.")
} else {
    isEmpty(QTC_PLUGIN_NAME): \
        error("QTC_PLUGIN_NAME is empty. Maybe you meant to create $$basename(depfile)?")
}
TARGET = $$QTC_PLUGIN_NAME

message("target: " $$TARGET)
message("plugin deps: " $$QTC_PLUGIN_DEPENDS)
message("test deps: " $$QTC_TEST_DEPENDS)
message("recommends deps: " $$QTC_PLUGIN_RECOMMENDS)

plugin_deps = $$QTC_PLUGIN_DEPENDS
plugin_test_deps = $$QTC_TEST_DEPENDS
plugin_recmds = $$QTC_PLUGIN_RECOMMENDS

message(including qextensionsystem)
include(../qextensionsystem.pri)
message(included qextensionsystem)

defineReplace(dependencyName) {
    message(definedependency name)
    dependencies_file =
    for(dir, QTC_PLUGIN_DIRS) {
        exists($$dir/$$1/$${1}_dependencies.pri) {
            dependencies_file = $$dir/$$1/$${1}_dependencies.pri
            break()
        }
    }
    message("deps file: " dependencies_file)
    isEmpty(dependencies_file): \
        error("Plugin dependency $$dep not found")
    include($$dependencies_file)
    return($$QTC_PLUGIN_NAME)
}

message("defined function")

# for substitution in the .json
dependencyList =
for(dep, plugin_deps) {
    dependencyList += "        { \"Name\" : \"$$dependencyName($$dep)\", \"Version\" : \"$$QEXTENSIONSYSTEM_VERSION\" }"
}
for(dep, plugin_recmds) {
    dependencyList += "        { \"Name\" : \"$$dependencyName($$dep)\", \"Version\" : \"$$QEXTENSIONSYSTEM_VERSION\", \"Type\" : \"optional\" }"
}
for(dep, plugin_test_deps) {
    dependencyList += "        { \"Name\" : \"$$dependencyName($$dep)\", \"Version\" : \"$$QEXTENSIONSYSTEM_VERSION\", \"Type\" : \"test\" }"
}
dependencyList = $$join(dependencyList, ",$$escape_expand(\\n)")

dependencyList = "\"Dependencies\" : [$$escape_expand(\\n)$$dependencyList$$escape_expand(\\n)    ]"

message("dep list: " $$dependencyList)

# use gui precompiled header for plugins by default
#isEmpty(PRECOMPILED_HEADER):PRECOMPILED_HEADER = $$PWD/shared/qtcreator_gui_pch.h

isEmpty(USE_USER_DESTDIR) {
    DESTDIR = $$IDE_PLUGIN_PATH
} else {
    win32 {
        DESTDIRAPPNAME = "qes"
        DESTDIRBASE = "$$(LOCALAPPDATA)"
        isEmpty(DESTDIRBASE):DESTDIRBASE="$$(USERPROFILE)\Local Settings\Application Data"
    } else:macx {
        DESTDIRAPPNAME = "Qt Creator"
        DESTDIRBASE = "$$(HOME)/Library/Application Support"
    } else:unix {
        DESTDIRAPPNAME = "qes"
        DESTDIRBASE = "$$(XDG_DATA_HOME)"
        isEmpty(DESTDIRBASE):DESTDIRBASE = "$$(HOME)/.local/share/data"
        else:DESTDIRBASE = "$$DESTDIRBASE/data"
    }
    DESTDIR = "$$DESTDIRBASE/QES/$$DESTDIRAPPNAME/plugins/$$QEXTENSIONSYSTEM_VERSION"
}
LIBS += -L$$DESTDIR
INCLUDEPATH += $$OUT_PWD

message(use user destdir)

# copy the plugin spec
isEmpty(TARGET) {
    error("qtcreatorplugin.pri: You must provide a TARGET")
}


PLUGINJSON = $$_PRO_FILE_PWD_/$${TARGET}.json
PLUGINJSON_IN = $${PLUGINJSON}.in
exists($$PLUGINJSON_IN) {
    DISTFILES += $$PLUGINJSON_IN
    QMAKE_SUBSTITUTES += $$PLUGINJSON_IN
    PLUGINJSON = $$OUT_PWD/$${TARGET}.json
} else {
    # need to support that for external plugins
    DISTFILES += $$PLUGINJSON
}
message("plugin json file: "  "$$PLUGINJSON".in)

osx: QMAKE_LFLAGS_SONAME = -Wl,-install_name,@rpath/PlugIns/
include(rpath.pri)

message(included rpath)

contains(QT_CONFIG, reduce_exports):CONFIG += hide_symbols

TEMPLATE = lib
CONFIG += plugin plugin_with_soname
linux*:QMAKE_LFLAGS += $$QMAKE_LFLAGS_NOUNDEF

!macx {
    target.path = $$INSTALL_PLUGIN_PATH
    INSTALLS += target
}

MIMETYPES = $$_PRO_FILE_PWD_/$${TARGET}.mimetypes.xml
exists($$MIMETYPES):DISTFILES += $$MIMETYPES

TARGET = $$qtLibraryName($$TARGET)
message("final target: " $$TARGET)

