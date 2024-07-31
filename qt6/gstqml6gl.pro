TEMPLATE = lib

TARGET = gstqml6

QT += core gui qml quick gui-private

INCLUDEPATH += /usr/local/Cellar/qt/6.7.0_1/lib/QtGui.framework/Versions/A/Headers/6.7.0/QtGui/private

macx {
    # Define necessary macros for macOS
    DEFINES += HAVE_QT_MAC

    # Link against macOS frameworks for OpenGL and Cocoa
    LIBS += -framework Cocoa -framework OpenGL
}

ios {
    # Define necessary macros for iOS
    DEFINES += HAVE_QT_IOS

    # Link against iOS frameworks for OpenGL ES
    LIBS += -framework OpenGLES -framework QuartzCore
}

QT_CONFIG -= no-pkg-config
CONFIG += link_pkgconfig debug
PKGCONFIG += gstreamer-1.0 gstreamer-video-1.0 gstreamer-gl-1.0
CONFIG += plugin

SHADERS += \
    vertex.vert \
    RGBA.frag \
    YUV_TRIPLANAR.frag

HEADERS += \
    gstqml6glmixer.h \
    gstqml6gloverlay.h \
    gstqml6glsink.h \
    gstqml6glsrc.h \
    gstqsg6material.h \
    gstqt6elements.h \
    gstqt6gl.h \
    gstqt6glutility.h \
    qt6glitem.h \
    qt6glrenderer.h \
    qt6glwindow.h

SOURCES += \
    gstplugin.cc \
    gstqml6glmixer.cc \
    gstqml6gloverlay.cc \
    gstqml6glsink.cc \
    gstqml6glsrc.cc \
    gstqsg6material.cc \
    gstqt6element.cc \
    gstqt6glutility.cc \
    qt6glitem.cc \
    qt6glrenderer.cc \
    qt6glwindow.cc

QMAKE_EXTRA_COMPILERS += \
    shader_compile

shader_compile.commands = qsb --glsl=100 es,120,330 --batchable --output $$OUT_PWD/$$QMAKE_FILE_IN $$QMAKE_FILE_IN
shader_compile.input = *.vert *.frag
shader_compile.output = *.qsb
