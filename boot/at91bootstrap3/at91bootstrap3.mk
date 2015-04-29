#############################################################
#
# at91bootstrap3
#
#############################################################
AT91BOOTSTRAP3_VERSION = 3.4.4
AT91BOOTSTRAP3_SITE = \
	ftp://www.at91.com/pub/at91bootstrap/AT91Bootstrap$(AT91BOOTSTRAP3_VERSION)
AT91BOOTSTRAP3_SOURCE = AT91Bootstrap-v3.4.4.tar.xz

AT91BOOTSTRAP3_INSTALL_IMAGES = YES
AT91BOOTSTRAP3_INSTALL_TARGET = NO

AT91BOOTSTRAP3_DEFCONFIG = \
	$(call qstrip,$(BR2_TARGET_AT91BOOTSTRAP3_DEFCONFIG))
AT91BOOTSTRAP3_CUSTOM_CONFIG_FILE = \
	$(call qstrip,$(BR2_TARGET_AT91BOOTSTRAP3_CUSTOM_CONFIG_FILE))
AT91BOOTSTRAP3_CUSTOM_PATCH_DIR = \
	$(call qstrip,$(BR2_TARGET_AT91BOOTSTRAP3_CUSTOM_PATCH_DIR))

AT91BOOTSTRAP3_MAKE_OPTS = CROSS_COMPILE=$(TARGET_CROSS) DESTDIR=$(BINARIES_DIR)

ifneq ($(AT91BOOTSTRAP3_CUSTOM_PATCH_DIR),)
define AT91BOOTSTRAP3_REMOVE_SPECIFIC_PATCHES
	rm -fv boot/at91bootstrap3/at91bootstrap3-u-boot-relocation-fix.patch
endef
define AT91BOOTSTRAP3_APPLY_CUSTOM_PATCHES
	support/scripts/apply-patches.sh $(@D) $(AT91BOOTSTRAP3_CUSTOM_PATCH_DIR) \
		at91bootstrap3-\*.patch
endef
AT91BOOTSTRAP3_PRE_PATCH_HOOKS += AT91BOOTSTRAP3_REMOVE_SPECIFIC_PATCHES
AT91BOOTSTRAP3_POST_PATCH_HOOKS += AT91BOOTSTRAP3_APPLY_CUSTOM_PATCHES
endif

ifeq ($(BR2_TARGET_AT91BOOTSTRAP3_USE_DEFCONFIG),y)
AT91BOOTSTRAP3_SOURCE_CONFIG = \
	$(@D)/board/*/$(AT91BOOTSTRAP3_DEFCONFIG)_defconfig
else ifeq ($(BR2_TARGET_AT91BOOTSTRAP3_USE_CUSTOM_CONFIG),y)
AT91BOOTSTRAP3_SOURCE_CONFIG = $(AT91BOOTSTRAP3_CUSTOM_CONFIG_FILE)
endif

define AT91BOOTSTRAP3_CONFIGURE_CMDS
	cp $(AT91BOOTSTRAP3_SOURCE_CONFIG) $(@D)/.config
	$(SED) 's/image.bin/uImage/' $(@D)/.config
endef

define AT91BOOTSTRAP3_BUILD_CMDS
	$(MAKE) $(AT91BOOTSTRAP3_MAKE_OPT) -C $(@D)
endef

AT91BOOTSTRAP3_BIN_FILE = $(call qstrip,$(BR2_LRD_PLATFORM))-nandflashboot-uboot.bin
ifeq ($(call qstrip,$(BR2_LRD_PLATFORM)),wb45n)
AT91BOOTSTRAP3_BIN_FILE = at91sam9x5ek-nandflashboot-uboot.bin
endif

define AT91BOOTSTRAP3_INSTALL_IMAGES_CMDS
	$(INSTALL) -m 644 $(@D)/binaries/$(AT91BOOTSTRAP3_BIN_FILE) \
	                  $(BINARIES_DIR)/$(call qstrip,$(BR2_LRD_PLATFORM)).bin
endef

$(eval $(generic-package))

# Checks to give errors that the user can understand
ifeq ($(filter source,$(MAKECMDGOALS)),)
ifeq ($(BR2_TARGET_AT91BOOTSTRAP3_USE_DEFCONFIG),y)
ifeq ($(AT91BOOTSTRAP3_DEFCONFIG),)
$(error No at91bootstrap3 defconfig name specified, check your BR2_TARGET_AT91BOOTSTRAP3_DEFCONFIG setting)
endif
endif

ifeq ($(BR2_TARGET_AT91BOOTSTRAP3_USE_CUSTOM_CONFIG),y)
ifeq ($(AT91BOOTSTRAP3_CUSTOM_CONFIG_FILE),)
$(error No at91bootstrap3 configuration file specified, check your BR2_TARGET_AT91BOOTSTRAP3_CUSTOM_CONFIG_FILE setting)
endif
endif
endif
