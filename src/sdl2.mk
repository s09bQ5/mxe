# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := sdl2
$(PKG)_WEBSITE  := https://www.libsdl.org/
$(PKG)_DESCR    := SDL2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.26.5
$(PKG)_CHECKSUM := ad8fea3da1be64c83c45b1d363a6b4ba8fd60f5bde3b23ec73855709ec5eabf7
$(PKG)_SUBDIR   := SDL2-$($(PKG)_VERSION)
$(PKG)_FILE     := SDL2-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://www.libsdl.org/release/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_BUILD
    cd '$(1)' && aclocal -I acinclude && autoconf && $(SHELL) ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --enable-threads \
        --enable-directx \
        --disable-libsamplerate \
        --disable-libsamplerate-shared
    $(SED) -i 's,defined(__MINGW64_VERSION_MAJOR),defined(__MINGW64_VERSION_MAJOR) \&\& defined(_WIN64),' '$(1)/include/SDL_cpuinfo.h'
    $(SED) -i 's,-XCClinker,,' '$(1)/sdl2.pc'
    $(SED) -i 's,-XCClinker,,' '$(1)/sdl2-config'
    $(MAKE) -C '$(1)' -j '$(JOBS)' SHELL=$(SHELL)
    $(MAKE) -C '$(1)' -j 1 install SHELL=$(SHELL)
    ln -sf '$(PREFIX)/$(TARGET)/bin/sdl2-config' '$(PREFIX)/bin/$(TARGET)-sdl2-config'

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-sdl2.exe' \
        `'$(TARGET)-pkg-config' sdl2 --cflags --libs`

endef
