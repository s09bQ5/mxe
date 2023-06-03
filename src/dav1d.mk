# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := dav1d
$(PKG)_WEBSITE  := https://code.videolan.org/videolan/dav1d/
$(PKG)_DESCR    := dav1d
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.0
$(PKG)_CHECKSUM := 231bed8bc1bb28a41d88da6b4c2c118de84b92e5f1d67caffa1b7f81aaea8c6e
$(PKG)_SUBDIR   := dav1d-$($(PKG)_VERSION)
$(PKG)_FILE     := dav1d-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://ftp.videolan.org/pub/videolan/dav1d/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := cc meson-wrapper $(BUILD)~nasm

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://code.videolan.org/videolan/dav1d/-/tags' | \
    $(SED) -n "s,.*<a [^>]\+>v\?\([0-9]\+\.[0-9.]\+\)<.*,\1,p" | \
    head -1
endef

define $(PKG)_BUILD
    '$(MXE_MESON_WRAPPER)' $(MXE_MESON_OPTS) \
        -Denable_tests=false \
        '$(BUILD_DIR)' '$(SOURCE_DIR)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)'
    '$(MXE_NINJA)' -C '$(BUILD_DIR)' -j '$(JOBS)' install
endef
