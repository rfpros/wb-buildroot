################################################################################
#
# modem-manager
#
################################################################################

MODEM_MANAGER_VERSION = 1.16.10
MODEM_MANAGER_SOURCE = ModemManager-$(MODEM_MANAGER_VERSION).tar.xz
MODEM_MANAGER_SITE = http://www.freedesktop.org/software/ModemManager
MODEM_MANAGER_LICENSE = GPL-2.0+ (programs, plugins), LGPL-2.0+ (libmm-glib)
MODEM_MANAGER_LICENSE_FILES = COPYING COPYING.LIB
MODEM_MANAGER_SELINUX_MODULES = modemmanager
MODEM_MANAGER_DEPENDENCIES = host-pkgconf libglib2 $(TARGET_NLS_DEPENDENCIES)
MODEM_MANAGER_INSTALL_STAGING = YES
MODEM_MANAGER_CONF_OPTS = --disable-more-warnings

ifeq ($(BR2_PACKAGE_MODEM_MANAGER_LIBQMI),y)
MODEM_MANAGER_DEPENDENCIES += libqmi
MODEM_MANAGER_CONF_OPTS += --with-qmi
else
MODEM_MANAGER_CONF_OPTS += --without-qmi
endif

ifeq ($(BR2_PACKAGE_LIBGUDEV),y)
MODEM_MANAGER_DEPENDENCIES += libgudev
MODEM_MANAGER_CONF_OPTS += --with-udev
else
MODEM_MANAGER_CONF_OPTS += --without-udev
endif

ifeq ($(BR2_PACKAGE_MODEM_MANAGER_LIBMBIM),y)
MODEM_MANAGER_DEPENDENCIES += libmbim
MODEM_MANAGER_CONF_OPTS += --with-mbim
else
MODEM_MANAGER_CONF_OPTS += --without-mbim
endif

ifeq ($(BR2_PACKAGE_GOBJECT_INTROSPECTION),y)
MODEM_MANAGER_DEPENDENCIES += gobject-introspection
MODEM_MANAGER_CONF_OPTS += --enable-introspection
else
MODEM_MANAGER_CONF_OPTS += --disable-introspection
endif

define MODEM_MANAGER_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D package/modem-manager/S44modem-manager \
		$(TARGET_DIR)/etc/init.d/S44modem-manager
endef

define MODEM_MANAGER_INSTALL_INIT_SYSTEMD
	$(INSTALL) -m 0644 -D $(MODEM_MANAGER_PKGDIR)/50-modem-manager.preset \
		$(TARGET_DIR)/usr/lib/systemd/system-preset/50-modem-manager.preset
endef

$(eval $(autotools-package))
