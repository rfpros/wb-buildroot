################################################################################
#
# firewalld
#
################################################################################

FIREWALLD_VERSION = v0.8.1
FIREWALLD_SITE = $(call github,firewalld,firewalld,$(FIREWALLD_VERSION))
FIREWALLD_LICENSE = GPL-2.0
FIREWALLD_LICENSE_FILES = COPYING
FIREWALLD_AUTORECONF = YES
FIREWALLD_DEPENDENCIES = \
	host-intltool \
	host-libglib2 \
	host-libxml2 \
	host-libxslt \
	dbus-python \
	dbus-python \
	ebtables \
	gettext \
	gobject-introspection \
	ipset \
	iptables \
	jansson \
	nftables \
	python3 \
	python-decorator \
	python-gobject \
	python-six \
	python-slip-dbus

define FIREWALLD_RUN_AUTOGEN
	cd $(@D) && $(HOST_DIR)/bin/intltoolize --force
endef
FIREWALLD_PRE_CONFIGURE_HOOKS += FIREWALLD_RUN_AUTOGEN

# iptables, ip6tables, ebtables, and ipset *should* be unnecessary
# when the nftables backend is available, because nftables supersedes all of
# them. However we still need to build and install iptables and ip6tables
# because application relying on direct passthrough rules (IE docker) will
# break.
# /etc/sysconfig/firewalld is a Red Hat-ism, only referenced by
# the Red Hat-specific init script which isn't used.
FIREWALLD_CONF_OPTS += \
	--disable-rpmmacros \
	--disable-sysconfig \
	--with-ip6tables-restore=/usr/sbin/ip6tables-restore \
	--with-ip6tables=/usr/sbin/ip6tables \
	--with-iptables-restore=/usr/sbin/iptables-restore \
	--with-iptables=/usr/sbin/iptables \
	--with-nft=/usr/sbin/nft \
	--without-ebtables \
	--without-ebtables-restore \
	--without-ipset \
	--without-xml-catalog


# Firewalld hard codes the python shebangs to the full path of the
# python-interpreter. IE: #!/home/buildroot/output/host/bin/python.
# Force the proper python path.
FIREWALLD_CONF_ENV += PYTHON="/usr/bin/env python$(PYTHON3_VERSION_MAJOR)"

ifeq ($(BR2_PACKAGE_SYSTEMD),y)
FIREWALLD_CONF_OPTS += --with-systemd-unitdir=/usr/lib/systemd/system
else
FIREWALLD_CONF_OPTS += --disable-systemd
endif

define FIREWALLD_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 $(FIREWALLD_PKGDIR)/firewalld.service \
		$(TARGET_DIR)/usr/lib/systemd/system/firewalld.service
endef

define FIREWALLD_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D $(FIREWALLD_PKGDIR)/firewalld.init \
		$(TARGET_DIR)/etc/init.d/S41firewalld
endef

$(eval $(autotools-package))
