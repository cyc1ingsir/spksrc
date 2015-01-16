SPK_NAME = minidlna
SPK_VERS = 1.1.4
SPK_REV = 1
SPK_ICON = src/minidlna.png
DSM_UI_DIR = app


DEPENDS = cross/zlib cross/libexif cross/libjpeg cross/libid3tag cross/libogg cross/flac cross/libvorbis cross/ffmpeg cross/e2fsprogs cross/sqlite cross/busybox cross/$(SPK_NAME)

MAINTAINER = cyc1ingsir
DESCRIPTION = ReadyMedia -formerly known as MiniDLNA- is a simple media server software, with the aim of being fully compliant with DLNA/UPnP-AV clients.
RELOAD_UI = yes
DISPLAY_NAME = miniDLNA

HOMEPAGE = http://sourceforge.net/projects/minidlna/
LICENSE  = GNU General Public License version 2.0 (GPLv2)

CHANGELOG = "initial package"

WIZARDS_DIR = src/wizard/

INSTALLER_SCRIPT = src/installer.sh
SSS_SCRIPT       = src/dsm-control.sh
ADDITIONAL_SCRIPTS =

INSTALL_PREFIX = /usr/local/$(SPK_NAME)

POST_STRIP_TARGET = minidlna_extra_install

BUSYBOX_CONFIG = usrmng
ENV += BUSYBOX_CONFIG="$(BUSYBOX_CONFIG)"

include ../../mk/spksrc.spk.mk

.PHONY: minidlna_extra_install
minidlna_extra_install:
	install -m 755 -d $(STAGING_DIR)/var
	install -m 755 -d $(STAGING_DIR)/app
	install -m 755 -d $(STAGING_DIR)/etc
	install -m 755 -d $(STAGING_DIR)/app/images
	install -m 644 src/import-environment $(STAGING_DIR)/bin/
	for size in 16 24 32 48 ; \
	do \
	    convert $(SPK_ICON) -thumbnail $${size}x$${size} \
	            $(STAGING_DIR)/app/images/$(SPK_NAME)-$${size}.png ; \
	done
