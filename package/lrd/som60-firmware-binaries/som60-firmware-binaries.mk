ifeq ($(BR2_LRD_DEVEL_BUILD),y)
else
SOM60_FIRMWARE_BINARIES_VERSION = 0.0.0.0
SOM60_FIRMWARE_BINARIES_SOURCE =
SOM60_FIRMWARE_BINARIES_LICENSE = GPL-2.0
SOM60_FIRMWARE_BINARIES_LICENSE_FILES = COPYING
SOM60_FIRMWARE_BINARIES_EXTRA_DOWNLOADS = laird-som60-radio-firmware-$(SOM60_FIRMWARE_BINARIES_VERSION).tar.bz2

ifeq ($(MSD_BINARIES_SOURCE_LOCATION),laird_internal)
  SOM60_FIRMWARE_BINARIES_SITE = http://devops.lairdtech.com/share/builds/linux/firmware/$(SOM60_FIRMWARE_BINARIES_VERSION)
else
  SOM60_FIRMWARE_BINARIES_SITE = https://github.com/LairdCP/wb-package-archive/releases/download/LRD-REL-$(SOM60_FIRMWARE_BINARIES_VERSION)
endif

define SOM60_FIRMWARE_BINARIES_SOM60_INSTALL_TARGET
	tar -xjf $($(PKG)_DL_DIR)/laird-som60-radio-firmware-$(SOM60_FIRMWARE_BINARIES_VERSION).tar.bz2 -C $(TARGET_DIR) --keep-directory-symlink --no-overwrite-dir --touch
endef

define SOM60_FIRMWARE_BINARIES_INSTALL_TARGET_CMDS
	$(SOM60_FIRMWARE_BINARIES_SOM60_INSTALL_TARGET)
endef

endif

$(eval $(generic-package))
