# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := sqlite
$(PKG)_WEBSITE  := https://www.sqlite.org/
$(PKG)_DESCR    := SQLite
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3420000
$(PKG)_CHECKSUM := 7abcfd161c6e2742ca5c6c0895d1f853c940f203304a0b49da4e1eca5d088ca6
$(PKG)_SUBDIR   := $(PKG)-autoconf-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-autoconf-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://www.sqlite.org/2023/$($(PKG)_FILE)
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
        --enable-threadsafe \
        CFLAGS="-Os -g -DSQLITE_ENABLE_COLUMN_METADATA"
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
