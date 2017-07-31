###########################################################################################
#    appudo_external.pro is part of Appudo
#
#    Copyright (C) 2015
#        bc00940f92e19b5d84931da5bbb6bce10b8e341bdd9d98d016513a164e790c05 source@appudo.com
#
#    Licensed under the Apache License, Version 2.0
#
#    See http://www.apache.org/licenses/LICENSE-2.0 for more information
###########################################################################################

TEMPLATE = aux

MACHINE = $$system(uname -m)
CONFIG(release, debug|release) : DESTDIR = $$_PRO_FILE_PWD_/Release.$$MACHINE-dst
CONFIG(debug, debug|release)   : DESTDIR = $$_PRO_FILE_PWD_/Debug.$$MACHINE-dst
CONFIG(force_debug_info)       : DESTDIR = $$_PRO_FILE_PWD_/Profile.$$MACHINE-dst

CONFIG(release, debug|release) : OUTF = Release.$$MACHINE
CONFIG(debug, debug|release)   : OUTF = Debug.$$MACHINE
CONFIG(force_debug_info)       : OUTF = Profile.$$MACHINE

QMAKE_MAKEFILE = $$DESTDIR/Makefile
OBJECTS_DIR = $$DESTDIR/.obj
MOC_DIR = $$DESTDIR/.moc
RCC_DIR = $$DESTDIR/.qrc
UI_DIR = $$DESTDIR/.ui

CONFIG(release, debug|release) : first.commands = cd $$_PRO_FILE_PWD_ && (./compile.sh 0 || exit 1)
CONFIG(debug, debug|release)   : first.commands = cd $$_PRO_FILE_PWD_ && (./compile.sh 1 || exit 1)
CONFIG(force_debug_info)       : first.commands = cd $$_PRO_FILE_PWD_ && (./compile.sh 1 || exit 1)

QMAKE_EXTRA_TARGETS += first

QMAKE_CLEAN += -r $$_PRO_FILE_PWD_/$$OUTF/

HEADERS += \

DISTFILES += \
    clean.sh \
    compile.sh \
    src/SwiftyJSON/json/LclJSONSerialization_Private.swift \
    src/SwiftyJSON/json/SwiftyJSON.swift \
    LICENSE \
    LICENSE.APACHE2 \
    LICENSE.MIT
