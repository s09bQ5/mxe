# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := sdl2_image
$(PKG)_WEBSITE  := https://www.libsdl.org/
$(PKG)_DESCR    := SDL2_image
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.6.3
$(PKG)_CHECKSUM := 931c9be5bf1d7c8fae9b7dc157828b7eee874e23c7f24b44ba7eff6b4836312c
$(PKG)_SUBDIR   := SDL2_image-$($(PKG)_VERSION)
$(PKG)_FILE     := SDL2_image-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://www.libsdl.org/projects/SDL_image/release/$($(PKG)_FILE)
$(PKG)_DEPS     := cc jpeg libpng libwebp sdl2 tiff

define $(PKG)_BUILD
    $(SED) -i 's,^\(Requires:.*\),\1\nRequires.private: libtiff-4 libpng libwebp,' '$(1)/SDL2_image.pc.in'
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --with-sdl-prefix='$(PREFIX)/$(TARGET)' \
        --disable-sdltest \
        --disable-jpg-shared \
        --disable-webp-shared \
        --disable-png-shared \
        --disable-tif-shared \
        --disable-stb-image
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
