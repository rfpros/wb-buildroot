###############################################################################
#
# laird_openssl_fips (openssl 1.0.2) binaries
#
# this package is selected through buildroot/packages/openssl
#
################################################################################

LAIRD_OPENSSL_FIPS_BINARIES_CVE_PRODUCT = libopenssl
LAIRD_OPENSSL_FIPS_BINARIES_CVE_VERSION = 1.0.2u
LAIRD_OPENSSL_FIPS_BINARIES_INSTALL_STAGING = YES

LAIRD_OPENSSL_FIPS_BINARIES_PROVIDES = openssl
LAIRD_OPENSSL_FIPS_BINARIES_CPE_ID_VENDOR = $(LAIRD_OPENSSL_FIPS_BINARIES_PROVIDES)
LAIRD_OPENSSL_FIPS_BINARIES_CPE_ID_PRODUCT = $(LAIRD_OPENSSL_FIPS_BINARIES_PROVIDES)

LAIRD_OPENSSL_FIPS_BINARIES_IGNORE_CVES += CVE-2020-1968
LAIRD_OPENSSL_FIPS_BINARIES_IGNORE_CVES += CVE-2020-1971
LAIRD_OPENSSL_FIPS_BINARIES_IGNORE_CVES += CVE-2021-23840
LAIRD_OPENSSL_FIPS_BINARIES_IGNORE_CVES += CVE-2021-23841
LAIRD_OPENSSL_FIPS_BINARIES_IGNORE_CVES += CVE-2021-23839
LAIRD_OPENSSL_FIPS_BINARIES_IGNORE_CVES += CVE-2021-3712
LAIRD_OPENSSL_FIPS_BINARIES_IGNORE_CVES += CVE-2022-1292
LAIRD_OPENSSL_FIPS_BINARIES_IGNORE_CVES += CVE-2022-2068

LAIRD_OPENSSL_FIPS_BINARIES_VERSION = $(call qstrip,$(BR2_PACKAGE_LAIRD_OPENSSL_FIPS_BINARIES_VERSION_VALUE))

LAIRD_OPENSSL_FIPS_BINARIES_SOURCE =
LAIRD_OPENSSL_FIPS_BINARIES_LICENSE = OpenSSL or SSLeay
LAIRD_OPENSSL_FIPS_BINARIES_EXTRA_DOWNLOADS = laird_openssl_fips$(call qstrip,$(BR2_PACKAGE_LRD_RADIO_STACK_ARCH))-$(LAIRD_OPENSSL_FIPS_BINARIES_VERSION).tar.bz2

ifeq ($(MSD_BINARIES_SOURCE_LOCATION),laird_internal)
  LAIRD_OPENSSL_FIPS_BINARIES_SITE = https://files.devops.rfpros.com/builds/linux/laird_openssl_fips/$(LAIRD_OPENSSL_FIPS_BINARIES_VERSION)
else
  LAIRD_OPENSSL_FIPS_BINARIES_SITE = https://github.com/LairdCP/wb-package-archive/releases/download/LRD-REL-$(LAIRD_OPENSSL_FIPS_BINARIES_VERSION)
endif

ifeq ($(BR2_PACKAGE_LIBOPENSSL_BIN),)
define LAIRD_OPENSSL_FIPS_BINARIES_REMOVE_BIN
	$(RM) -f $(TARGET_DIR)/usr/bin/openssl
	$(RM) -f $(TARGET_DIR)/etc/ssl/misc/{CA.*,c_*}
endef
endif

define LAIRD_OPENSSL_FIPS_BINARIES_INSTALL_STAGING_CMDS
	tar -xjvf $($(PKG)_DL_DIR)/$(LAIRD_OPENSSL_FIPS_BINARIES_EXTRA_DOWNLOADS) -C $(STAGING_DIR) --keep-directory-symlink --no-overwrite-dir --touch --strip-components=1 staging
endef

define LAIRD_OPENSSL_FIPS_BINARIES_INSTALL_TARGET_CMDS
	tar -xjvf $($(PKG)_DL_DIR)/$(LAIRD_OPENSSL_FIPS_BINARIES_EXTRA_DOWNLOADS) -C $(TARGET_DIR) --keep-directory-symlink --no-overwrite-dir --touch --strip-components=1 target
	$(LAIRD_OPENSSL_FIPS_BINARIES_REMOVE_BIN)
endef

$(eval $(generic-package))
