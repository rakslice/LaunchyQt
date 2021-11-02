TEMPLATE = app

win32:TARGET = Launchy
unix:!macx:TARGET = launchy
macx:TARGET = Launchy

QT += network widgets

CONFIG += debug_and_release
# CONFIG += qt release

SOURCES = main.cpp \
          AppBase.cpp \
          LaunchyWidget.cpp \
          GlobalVar.cpp \
          OptionDialog.cpp \
          Catalog.cpp \
          CatalogBuilder.cpp \
          PluginHandler.cpp \
          IconDelegate.cpp \
          IconExtractor.cpp \
          IconProviderBase.cpp \
          FileBrowserDelegate.cpp \
          FileBrowser.cpp \
          DropListWidget.cpp \
          Fader.cpp \
          CharListWidget.cpp \
          CharLineEdit.cpp \
          CommandHistory.cpp \
          InputDataList.cpp \
          FileSearch.cpp \
          AnimationLabel.cpp \
          SettingsManager.cpp \
          Logger.cpp \
          OptionItem.cpp \
          Directory.cpp \
          UpdateChecker.cpp \
          TranslationManager.cpp

HEADERS = AppBase.h \
          GlobalVar.h \
          LaunchyWidget.h \
          Catalog.h \
          CatalogBuilder.h \
          PluginHandler.h \
          OptionDialog.h \
          IconDelegate.h \
          IconExtractor.h \
          IconProviderBase.h \
          FileBrowserDelegate.h \
          FileBrowser.h \
          DropListWidget.h \
          CharListWidget.h \
          CharLineEdit.h \
          Fader.h \
          CommandHistory.h \
          InputDataList.h \
          FileSearch.h \
          AnimationLabel.h \
          SettingsManager.h \
          Logger.h \
          OptionItem.h \
          Directory.h \
          UpdateChecker.h \
          TranslationManager.h

FORMS = OptionDialog.ui

RESOURCES += launchy.qrc

include(../../deps/SingleApplication/singleapplication.pri)
DEFINES += QAPPLICATION_CLASS=QApplication
include(../../deps/QHotkey/QHotkey.pri)

PRECOMPILED_HEADER   = Precompiled.h
HEADERS             += Precompiled.h
CONFIG              += precompile_header

INCLUDEPATH += ../
#DEPENDPATH += ../LaunchyLib

CONFIG(debug, debug|release):DESTDIR = ../debug/
CONFIG(release, debug|release):DESTDIR = ../release/

OBJECTS_DIR = build
MOC_DIR = GeneratedFiles

win32 {
    QT += winextras
    ICON = Launchy.ico
    # if(!debug_and_release|build_pass):CONFIG(debug, debug|release):CONFIG += console
    SOURCES += Windows/AppWin.cpp \
               Windows/LaunchyWidgetWin.cpp \
               Windows/UtilWin.cpp \
               Windows/IconProviderWin.cpp \
               Windows/CrashDumper.cpp
    HEADERS += Windows/AppWin.h \
               Windows/IconProviderWin.h \
               Windows/LaunchyWidgetWin.h \
               Windows/UtilWin.h \
               Windows/CrashDumper.h
    CONFIG  += embed_manifest_exe
    RC_FILE += Windows/launchy.rc
       LIBS += $$DESTDIR/Launchy.lib \
               $$DESTDIR/PluginPy.lib \
               gdi32.lib \
               userenv.lib \
               netapi32.lib \
               shell32.lib

#               user32.lib
#               ole32.lib
#               comctl32.lib
#               advapi32.lib

    DEFINES += VC_EXTRALEAN \
               WIN32_LEAN_AND_MEAN \
               WIN32 \
               _UNICODE \
               UNICODE

    QMAKE_CXXFLAGS_RELEASE += /Zi
    QMAKE_LFLAGS_RELEASE += /DEBUG
}

unix:!macx {
    QT += x11extras
    ICON = Launchy.ico
    SOURCES += Linux/AppLinux.cpp \
               Linux/LaunchyWidgetLinux.cpp \
               Linux/IconProviderLinux.cpp

    HEADERS += Linux/AppLinux.h \
               Linux/LaunchyWidgetLinux.h \
               Linux/IconProviderLinux.h
    LIBS += -L$$OUT_PWD/src/lib/ $$DESTDIR/libLaunchy.so $$DESTDIR/libPluginPy.so

    PREFIX   = /usr
    DEFINES += SKINS_PATH=\\\"$$PREFIX/share/launchy/skins/\\\" \
        PLUGINS_PATH=\\\"$$PREFIX/lib/launchy/plugins/\\\" \
        PLATFORMS_PATH=\\\"$$PREFIX/lib/launchy/\\\"
    target.path   = $$PREFIX/bin/
    skins.path    = $$PREFIX/share/launchy/skins/
    skins.files   = ../skins/*
    icon.path     = $$PREFIX/share/pixmaps
    icon.files    = ../misc/Launchy_Icon/launchy_icon.png
    desktop.path  = $$PREFIX/share/applications/
    desktop.files = ../dist/linux/launchy.desktop
    INSTALLS += target \
                skins \
                icon \
                desktop
}

macx {
    ICON = ../misc/Launchy_Icon/launchy_icon_mac.icns
    SOURCES += mac/platform_mac.cpp \
               mac/platform_mac_hotkey.cpp
    HEADERS += mac/platform_mac.h \
               mac/platform_mac_hotkey.h \
               platform_base_hotkey.h \
               platform_base_hottrigger.h
    if(!debug_and_release|build_pass) {
        CONFIG(debug, debug|release):DESTDIR = ../debug/
        CONFIG(release, debug|release):DESTDIR = ../release/
    }
    INCLUDEPATH += /opt/local/include/
    LIBS += -framework \
        Carbon
    CONFIG(debug, debug|release):skins.path = ../debug/Launchy.app/Contents/Resources/skins/
    CONFIG(release, debug|release):skins.path = ../release/Launchy.app/Contents/Resources/skins/
    skins.files =
    skins.extra = rsync -arvz ../skins/   ../release/Launchy.app/Contents/Resources/skins/   --exclude=\".svn\"
    CONFIG(debug, debug|release):translations.path = ../debug/Launchy.app/Contents/MacOS/tr/
    CONFIG(release, debug|release):translations.path = ../release/Launchy.app/Contents/MacOS/tr/
    translations.files = ../translations/*.qm
    translations.extra = lupdate \
        src.pro \
        ; \
        lrelease \
        src.pro
    dmg.path = ../release/
    dmg.files =
    dmg.extra = cd \
        ../mac \
        ; \
        bash \
        deploy; \
        cd \
        ../src
    INSTALLS += skins \
        translations \
        dmg
}

TRANSLATIONS = ../../translations/launchy_zh_CN.ts \
               ../../translations/launchy_zh_TW.ts \
               ../../translations/launchy_fr.ts \
               ../../translations/launchy_nl.ts \
               ../../translations/launchy_es.ts \
               ../../translations/launchy_de.ts \
               ../../translations/launchy_ja.ts \
               ../../translations/launchy_ru.ts \
               ../../translations/launchy_it.ts \
               ../../translations/launchy_pt.ts
