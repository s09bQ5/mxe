# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := sqlite
$(PKG)_WEBSITE  := https://www.sqlite.org/
$(PKG)_DESCR    := SQLite
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3450100
$(PKG)_CHECKSUM := cd9c27841b7a5932c9897651e20b86c701dd740556989b01ca596fcfa3d49a0a
$(PKG)_SUBDIR   := $(PKG)-autoconf-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-autoconf-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://www.sqlite.org/2024/$($(PKG)_FILE)
$(PKG)_DEPS     := cc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.sqlite.org/download.html' | \
    $(SED) -n 's,.*sqlite-autoconf-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-readline \
        CFLAGS="-Os -g -DSQLITE_THREADSAFE=1 -DSQLITE_ENABLE_COLUMN_METADATA"
    $(SED) -i 's:^/\*\+ Begin file \([^ ]\+\) \*\+/:#line 1 "\1":;s:^/\*\+ Continuing where we left off in \([^ ]\+\) \*\+/:#line xxx "\1":' $(1)/sqlite3.c
    grep -n ^#line $(1)/sqlite3.c | $(SED) 's/:#line//;s/"//g;s/\./____/g' | ( \
        fixup="" ; \
        prev="" ; \
        prevdelta=0 ; \
        while read a b c ; do \
            if [ -n "$$prev" ] ; then \
                eval "line_$$prev=$$((a-prevdelta))" ; \
            fi ; \
            case $$b in \
            xxx) \
                 eval "b=\$$line_$$c" ; \
                 fixup="$$fixup$${a}s/ xxx / $$b /;" ; \
            esac ; \
            eval "line_$$c=$$b" ; \
            prevdelta="$$((a+1-b))" ; \
            prev="$$c" ; \
        done ; \
        $(SED) -i "$$fixup" $(1)/sqlite3.c \
    )

    $(MAKE) -C '$(1)' -j 1 install
endef
