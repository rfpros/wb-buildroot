# Creates a package of required firmware and board support files for the
# Sterling series radios.


WIRELESS_FIRMWARE_VERSION = 6.0.0.162
WIRELESS_FIRMWARE_LICENSE = GPL-2.0
WIRELESS_FIRMWARE_LICENSE_FILES = COPYING
WIRELESS_FIRMWARE_SITE = $(TOPDIR)/package/lrd-closed-source/externals/firmware
WIRELESS_FIRMWARE_SITE_METHOD = local

ST_OUT := $(BASE_DIR)/images

LAIRD_RELEASE_STRING ?= $(WIRELESS_FIRMWARE_VERSION)

MAKE_STERLING_FAM_PROD_FW_PKG := $(MAKE) -C $(TOPDIR)/package/lrd-closed-source/wireless-firmware -f sterling-family-prod-fw-pkg.mk FW_REPO_DIR=$(BUILD_DIR)/wireless-firmware-$(LAIRD_RELEASE_STRING) TAR_DIR=$(TARGET_DIR)
MAKE_LWB_FAM_PROD_FW_PKG := $(MAKE) -C $(TOPDIR)/package/lrd-closed-source/wireless-firmware -f lwb-family-prod-fw-pkg.mk BUD_DIR=$(BUILD_DIR) TAR_DIR=$(TARGET_DIR) BA_DIR=$(BASE_DIR)
MAKE_ATH6K_FAM_PROD_FW_PKG := $(MAKE) -C $(TOPDIR)/package/lrd-closed-source/wireless-firmware -f ath6k-family-prod-fw-pkg.mk BUD_DIR=$(BUILD_DIR) TAR_DIR=$(TARGET_DIR) BA_DIR=$(BASE_DIR)

480_0079_PARAMS := FW_PKG_LSR_PN=480-0079 BRCMFMAC_CHIP_ID=43430 CHIP_NAME=4343w REGION=fcc  OUT_FILE=$(ST_OUT)/480-0079-$(LAIRD_RELEASE_STRING).zip
480_0080_PARAMS := FW_PKG_LSR_PN=480-0080 BRCMFMAC_CHIP_ID=43430 CHIP_NAME=4343w REGION=etsi OUT_FILE=$(ST_OUT)/480-0080-$(LAIRD_RELEASE_STRING).zip
480_0116_PARAMS := FW_PKG_LSR_PN=480-0116 BRCMFMAC_CHIP_ID=43430 CHIP_NAME=4343w REGION=jp   OUT_FILE=$(ST_OUT)/480-0116-$(LAIRD_RELEASE_STRING).zip
480_0081_PARAMS := FW_PKG_LSR_PN=480-0081 BRCMFMAC_CHIP_ID=4339  CHIP_NAME=4339  REGION=fcc  OUT_FILE=$(ST_OUT)/480-0081-$(LAIRD_RELEASE_STRING).zip
480_0082_PARAMS := FW_PKG_LSR_PN=480-0082 BRCMFMAC_CHIP_ID=4339  CHIP_NAME=4339  REGION=etsi OUT_FILE=$(ST_OUT)/480-0082-$(LAIRD_RELEASE_STRING).zip
480_0094_PARAMS := FW_PKG_LSR_PN=480-0094 BRCMFMAC_CHIP_ID=4339  CHIP_NAME=4339  REGION=ic   OUT_FILE=$(ST_OUT)/480-0094-$(LAIRD_RELEASE_STRING).zip
480_0095_PARAMS := FW_PKG_LSR_PN=480-0095 BRCMFMAC_CHIP_ID=4339  CHIP_NAME=4339  REGION=jp   OUT_FILE=$(ST_OUT)/480-0095-$(LAIRD_RELEASE_STRING).zip

LWB_PARAMS      := RELEASE_STRING=$(LAIRD_RELEASE_STRING) lwb-mfg
LWB5_PARAMS     := RELEASE_STRING=$(LAIRD_RELEASE_STRING) lwb5-mfg
WL_PARAMS		:= RELEASE_STRING=$(LAIRD_RELEASE_STRING) wl T_DIR=$(TOPDIR)

ATH6K_6003_PARAMS := RELEASE_STRING=$(LAIRD_RELEASE_STRING) ath6k-6003
ATH6K_6004_PARAMS := RELEASE_STRING=$(LAIRD_RELEASE_STRING) ath6k-6004

define WIRELESS_FIRMWARE_CONFIGURE_TARGET_CMDS

endef

define WIRELESS_FIRMWARE_BUILD_TARGET_CMDS

endef

define WIRELESS_FIRMWARE_INSTALL_TARGET_CMDS
	$(MAKE_STERLING_FAM_PROD_FW_PKG) $(480_0079_PARAMS)
	$(MAKE_STERLING_FAM_PROD_FW_PKG) $(480_0080_PARAMS)
	$(MAKE_STERLING_FAM_PROD_FW_PKG) $(480_0116_PARAMS)
	$(MAKE_STERLING_FAM_PROD_FW_PKG) $(480_0081_PARAMS)
	$(MAKE_STERLING_FAM_PROD_FW_PKG) $(480_0082_PARAMS)
	$(MAKE_STERLING_FAM_PROD_FW_PKG) $(480_0094_PARAMS)
	$(MAKE_STERLING_FAM_PROD_FW_PKG) $(480_0095_PARAMS)
	$(MAKE_LWB_FAM_PROD_FW_PKG) $(LWB_PARAMS)
	$(MAKE_LWB_FAM_PROD_FW_PKG) $(LWB5_PARAMS)
	$(MAKE_LWB_FAM_PROD_FW_PKG) $(WL_PARAMS)
	$(MAKE_ATH6K_FAM_PROD_FW_PKG) $(ATH6K_6003_PARAMS)
	$(MAKE_ATH6K_FAM_PROD_FW_PKG) $(ATH6K_6004_PARAMS)
endef

$(eval $(generic-package))
