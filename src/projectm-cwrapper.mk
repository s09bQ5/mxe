# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := projectm-cwrapper
$(PKG)_WEBSITE  := https://github.com/UltraStar-Deluxe/usdx
$(PKG)_DESCR    := projectM C wrapper
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1
$(PKG)_CHECKSUM :=
$(PKG)_DEPS     := cc projectm

# Local sources live in src/projectm-cwrapper

define $(PKG)_BUILD
    '$(TARGET)-g++' -shared \
        -I'$(TOP_DIR)/src/projectm-cwrapper' -I'$(PREFIX)/$(TARGET)/include' -I'$(PREFIX)/$(TARGET)/include/libprojectM' \
        -L'$(PREFIX)/$(TARGET)/bin' -L'$(PREFIX)/$(TARGET)/lib' \
        -o projectM-cwrapper.dll \
        '$(TOP_DIR)/src/projectm-cwrapper/projectM-cwrapper.cpp' \
        -l:libprojectM-0.dll -lopengl32

    $(INSTALL) -d '$(PREFIX)/$(TARGET)/bin'
    $(INSTALL) -m755 projectM-cwrapper.dll '$(PREFIX)/$(TARGET)/bin/'
endef
