# This file is part of MXE. See LICENSE.md for licensing information.


PKG             := opencvwrapper
$(PKG)_WEBSITE  := https://opencv.org/
$(PKG)_DESCR    := OpenCV C-wrapper for USDX
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1
$(PKG)_SUBDIR   := opencvwrapper-src
$(PKG)_SOURCE_TREE := $(TOP_DIR)
$(PKG)_DEPS     := cc opencv

# Build the USDX OpenCV wrapper as a DLL linked to OpenCV 4.x.
define $(PKG)_BUILD
    '$(TARGET)-g++' -shared -o '$(PREFIX)/$(TARGET)/bin/opencvwrapper.dll' \
    '$(TOP_DIR)/src/opencvwrapper/opencv-wrapper.cpp' \
        -O2 -DNDEBUG \
        `$(TARGET)-pkg-config opencv4 --cflags --libs`
endef
