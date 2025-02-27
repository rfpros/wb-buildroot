################################################################################
#
# ofono
#
################################################################################

OFONO_VERSION = 1.34
OFONO_SOURCE = ofono-$(OFONO_VERSION).tar.xz
OFONO_SITE = $(BR2_KERNEL_MIRROR)/linux/network/ofono
OFONO_LICENSE = GPL-2.0
OFONO_LICENSE_FILES = COPYING
OFONO_DEPENDENCIES = \
	host-pkgconf \
	dbus \
	ell \
	libcap-ng \
	libglib2 \
	mobile-broadband-provider-info

OFONO_CONF_OPTS = \
	--enable-external-ell \
	--disable-test \
	--with-dbusconfdir=/etc \
	$(if $(BR2_INIT_SYSTEMD),--with-systemdunitdir=/usr/lib/systemd/system)

OFONO_AUTORECONF = YES

# N.B. Qualcomm QMI modem support requires O_CLOEXEC; so
# make sure that it is defined.
OFONO_CONF_ENV += CFLAGS="$(TARGET_CFLAGS) -D_GNU_SOURCE"

define OFONO_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D package/ofono/S46ofono $(TARGET_DIR)/etc/init.d/S46ofono
endef

ifeq ($(BR2_PACKAGE_HAS_UDEV),y)
OFONO_CONF_OPTS += --enable-udev
OFONO_DEPENDENCIES += udev
else
OFONO_CONF_OPTS += --disable-udev
endif

ifeq ($(BR2_PACKAGE_BLUEZ_UTILS),y)
OFONO_CONF_OPTS += --enable-bluetooth
OFONO_DEPENDENCIES += bluez_utils
else ifeq ($(BR2_PACKAGE_BLUEZ5_UTILS),y)
OFONO_CONF_OPTS += --enable-bluetooth
OFONO_DEPENDENCIES += bluez5_utils
else
OFONO_CONF_OPTS += --disable-bluetooth
endif

# Use writeable data directory on secured builds (IG, encrypted toolkit)
ifneq ($(BR2_PACKAGE_LRD_ENCRYPTED_STORAGE_TOOLKIT)$(BR2_PACKAGE_GGSUPPORT),)
OFONO_CONF_OPTS += --localstatedir=/data/public
endif

$(eval $(autotools-package))
