PKG_NAME = minidlna
PKG_VERS = 1.1.4
PKG_EXT = tar.gz
PKG_DIST_NAME = minidlna-$(PKG_VERS).$(PKG_EXT)
PKG_DIST_SITE = http://sourceforge.net/projects/minidlna/files/minidlna/$(PKG_VERS)/
PKG_DIR = $(PKG_NAME)-$(PKG_VERS)

DEPENDS = cross/zlib cross/libexif cross/libjpeg cross/libid3tag cross/libogg cross/flac cross/libvorbis cross/ffmpeg cross/e2fsprogs cross/sqlite

HOMEPAGE = http://sourceforge.net/projects/minidlna/
COMMENT  = ReadyMedia (formerly known as MiniDLNA) is a simple media server software, with the aim of being fully compliant with DLNA/UPnP-AV clients.
LICENSE  = GNU General Public License version 2.0 (GPLv2)

GNU_CONFIGURE = 1
PRE_CONFIGURE_TARGET = myPreConfigure
CONFIGURE_ARGS = 
INSTALL_TARGET = myInstall

include ../../mk/spksrc.cross-cc.mk


.PHONY: myPreConfigure
myPreConfigure:
	$(RUN) ./autogen.sh

myInstall:
	$(RUN) $(MAKE) install DESTDIR=$(INSTALL_DIR) prefix=$(INSTALL_PREFIX)
	install -m 644 $(WORK_DIR)/$(PKG_DIR)/minidlna.conf $(STAGING_INSTALL_PREFIX)/etc/minidlna.conf
