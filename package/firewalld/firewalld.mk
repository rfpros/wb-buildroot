###############################################################################
#
# firewalld .mk file
#
################################################################################

FIREWALLD_VERSION = v0.7.1
FIREWALLD_SOURCE = $(FIREWALLD_VERSION).tar.gz
FIREWALLD_SITE = https://github.com/firewalld/firewalld/archive
FIREWALLD_DEPENDENCIES = libglib2 nftables host-intltool gettext systemd python-decorator dbus-python python-slip-dbus
FIREWALLD_INSTALL_STAGING = YES
FIREWALLD_LIBTOOL_PATCH = YES
FIREWALLD_AUTORECONF= YES

ifeq ($(BR2_PACKAGE_PYTHON),y)
FIREWALLD_DEPENDENCIES  += python-gobject
else
FIREWALLD_DEPENDENCIES  += python3-gobject
endif

define FIREWALLD_RUN_INTLTOOLIZE
	echo $(PATH)
	cd $(@D) && $(HOST_DIR)/usr/bin/intltoolize --force --automake
endef

FIREWALLD_POST_EXTRACT_HOOKS = FIREWALLD_RUN_INTLTOOLIZE

define FIREWALLD_FIX_SHEBANG
	cd $(BUILD_DIR)/firewalld-$(FIREWALLD_VERSION)/src && $(SED) "1s/.*/\#\\!\\/\bin\/\python/" firewalld \
	&& $(SED) "1s/.*/\#\\!\\/\bin\/\python/" firewall-cmd \
	&& $(SED) "1s/.*/\#\\!\\/\bin\/\python/" firewall-applet \
	&& $(SED) "1s/.*/\#\\!\\/\bin\/\python/" firewall-config \
	&& $(SED) "1s/.*/\#\\!\\/\bin\/\python/" firewall-offline-cmd
endef

FIREWALLD_PRE_INSTALL_TARGET_HOOKS = FIREWALLD_FIX_SHEBANG

define FIREWALLD_FIX_CONFIG
	$(SED) "s/ &&.*//g" $(TARGET_DIR)/etc/modprobe.d/firewalld-sysctls.conf
	$(SED) "s/IPv6_rpfilter=yes/IPv6_rpfilter=no/g" $(TARGET_DIR)/etc/firewalld/firewalld.conf
endef

FIREWALLD_POST_INSTALL_TARGET_HOOKS = FIREWALLD_FIX_CONFIG

$(eval $(autotools-package))
