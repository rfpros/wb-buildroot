################################################################################
#
# uboot
#
################################################################################

UBOOT_VERSION = $(call qstrip,$(BR2_TARGET_UBOOT_VERSION))
UBOOT_BOARD_NAME = $(call qstrip,$(BR2_TARGET_UBOOT_BOARDNAME))

UBOOT_LICENSE = GPL-2.0+
ifeq ($(BR2_TARGET_UBOOT_LATEST_VERSION),y)
UBOOT_LICENSE_FILES = Licenses/gpl-2.0.txt
endif

UBOOT_INSTALL_IMAGES = YES

ifeq ($(UBOOT_VERSION),custom)
# Handle custom U-Boot tarballs as specified by the configuration
UBOOT_TARBALL = $(call qstrip,$(BR2_TARGET_UBOOT_CUSTOM_TARBALL_LOCATION))
UBOOT_SITE = $(patsubst %/,%,$(dir $(UBOOT_TARBALL)))
UBOOT_SOURCE = $(notdir $(UBOOT_TARBALL))
else ifeq ($(BR2_TARGET_UBOOT_CUSTOM_GIT),y)
UBOOT_SITE = $(call qstrip,$(BR2_TARGET_UBOOT_CUSTOM_REPO_URL))
UBOOT_SITE_METHOD = git
else ifeq ($(BR2_TARGET_UBOOT_CUSTOM_HG),y)
UBOOT_SITE = $(call qstrip,$(BR2_TARGET_UBOOT_CUSTOM_REPO_URL))
UBOOT_SITE_METHOD = hg
else ifeq ($(BR2_TARGET_UBOOT_CUSTOM_SVN),y)
UBOOT_SITE = $(call qstrip,$(BR2_TARGET_UBOOT_CUSTOM_REPO_URL))
UBOOT_SITE_METHOD = svn
else
# Handle stable official U-Boot versions
UBOOT_SITE = ftp://ftp.denx.de/pub/u-boot
UBOOT_SOURCE = u-boot-$(UBOOT_VERSION).tar.bz2
endif

ifeq ($(BR2_TARGET_UBOOT)$(BR2_TARGET_UBOOT_LATEST_VERSION),y)
BR_NO_CHECK_HASH_FOR += $(UBOOT_SOURCE)
endif

ifeq ($(BR2_TARGET_UBOOT_FORMAT_BIN),y)
UBOOT_BINS += u-boot.bin
endif

ifeq ($(BR2_TARGET_UBOOT_FORMAT_ELF),y)
UBOOT_BINS += u-boot
# To make elf usable for debuging on ARC use special target
ifeq ($(BR2_arc),y)
UBOOT_MAKE_TARGET += mdbtrick
endif
endif

# Call 'make all' unconditionally
UBOOT_MAKE_TARGET += all

ifeq ($(BR2_TARGET_UBOOT_FORMAT_KWB),y)
UBOOT_BINS += u-boot.kwb
UBOOT_MAKE_TARGET += u-boot.kwb
endif

ifeq ($(BR2_TARGET_UBOOT_FORMAT_AIS),y)
UBOOT_BINS += u-boot.ais
UBOOT_MAKE_TARGET += u-boot.ais
endif

ifeq ($(BR2_TARGET_UBOOT_FORMAT_NAND_BIN),y)
UBOOT_BINS += u-boot-nand.bin
endif

ifeq ($(BR2_TARGET_UBOOT_FORMAT_DTB_IMG),y)
UBOOT_BINS += u-boot-dtb.img
UBOOT_MAKE_TARGET += u-boot-dtb.img
endif

ifeq ($(BR2_TARGET_UBOOT_FORMAT_DTB_IMX),y)
UBOOT_BINS += u-boot-dtb.imx
UBOOT_MAKE_TARGET += u-boot-dtb.imx
endif

ifeq ($(BR2_TARGET_UBOOT_FORMAT_DTB_BIN),y)
UBOOT_BINS += u-boot-dtb.bin
UBOOT_MAKE_TARGET += u-boot-dtb.bin
endif

ifeq ($(BR2_TARGET_UBOOT_FORMAT_IMG),y)
UBOOT_BINS += u-boot.img
UBOOT_MAKE_TARGET += u-boot.img
endif

ifeq ($(BR2_TARGET_UBOOT_FORMAT_ITB),y)
UBOOT_BINS += u-boot.itb
UBOOT_MAKE_TARGET += u-boot.itb
endif

ifeq ($(BR2_TARGET_UBOOT_FORMAT_IMX),y)
UBOOT_BINS += u-boot.imx
UBOOT_MAKE_TARGET += u-boot.imx
endif

ifeq ($(BR2_TARGET_UBOOT_FORMAT_SB),y)
UBOOT_BINS += u-boot.sb
UBOOT_MAKE_TARGET += u-boot.sb
# mxsimage needs OpenSSL
UBOOT_DEPENDENCIES += host-elftosb host-openssl
endif

ifeq ($(BR2_TARGET_UBOOT_FORMAT_SD),y)
# BootStream (.sb) is generated by U-Boot, we convert it to SD format
UBOOT_BINS += u-boot.sd
UBOOT_MAKE_TARGET += u-boot.sb
UBOOT_DEPENDENCIES += host-elftosb host-openssl
endif

ifeq ($(BR2_TARGET_UBOOT_FORMAT_NAND),y)
UBOOT_BINS += u-boot.nand
UBOOT_MAKE_TARGET += u-boot.sb
UBOOT_DEPENDENCIES += host-elftosb host-openssl
endif

ifeq ($(BR2_TARGET_UBOOT_FORMAT_CUSTOM),y)
UBOOT_BINS += $(call qstrip,$(BR2_TARGET_UBOOT_FORMAT_CUSTOM_NAME))
endif

ifeq ($(BR2_TARGET_UBOOT_OMAP_IFT),y)
UBOOT_BINS += u-boot.bin
UBOOT_BIN_IFT = u-boot.bin.ift
endif

# The kernel calls AArch64 'arm64', but U-Boot calls it just 'arm', so
# we have to special case it. Similar for i386/x86_64 -> x86
ifeq ($(KERNEL_ARCH),arm64)
UBOOT_ARCH = arm
else ifneq ($(filter $(KERNEL_ARCH),i386 x86_64),)
UBOOT_ARCH = x86
else
UBOOT_ARCH = $(KERNEL_ARCH)
endif

UBOOT_MAKE_OPTS += \
	CROSS_COMPILE="$(TARGET_CROSS)" \
	ARCH=$(UBOOT_ARCH) \
	HOSTCC="$(HOSTCC) $(subst -I/,-isystem /,$(subst -I /,-isystem /,$(HOST_CFLAGS)))" \
	HOSTLDFLAGS="$(HOST_LDFLAGS)"

ifeq ($(BR2_TARGET_UBOOT_NEEDS_ATF_BL31),y)
UBOOT_DEPENDENCIES += arm-trusted-firmware
ifeq ($(BR2_TARGET_UBOOT_NEEDS_ATF_BL31_ELF),y)
UBOOT_MAKE_OPTS += BL31=$(BINARIES_DIR)/bl31.elf
else
UBOOT_MAKE_OPTS += BL31=$(BINARIES_DIR)/bl31.bin
endif
endif

ifeq ($(BR2_TARGET_UBOOT_NEEDS_DTC),y)
UBOOT_DEPENDENCIES += host-dtc
endif

ifeq ($(BR2_TARGET_UBOOT_NEEDS_PYLIBFDT),y)
UBOOT_DEPENDENCIES += host-python host-swig
endif

ifeq ($(BR2_TARGET_UBOOT_NEEDS_OPENSSL),y)
UBOOT_DEPENDENCIES += host-openssl
endif

ifeq ($(BR2_TARGET_UBOOT_NEEDS_LZOP),y)
UBOOT_DEPENDENCIES += host-lzop
endif

# prior to u-boot 2013.10 the license info was in COPYING. Copy it so
# legal-info finds it
define UBOOT_COPY_OLD_LICENSE_FILE
	if [ -f $(@D)/COPYING ]; then \
		$(INSTALL) -m 0644 -D $(@D)/COPYING $(@D)/Licenses/gpl-2.0.txt; \
	fi
endef

UBOOT_POST_EXTRACT_HOOKS += UBOOT_COPY_OLD_LICENSE_FILE
UBOOT_POST_RSYNC_HOOKS += UBOOT_COPY_OLD_LICENSE_FILE

ifneq ($(ARCH_XTENSA_OVERLAY_FILE),)
define UBOOT_XTENSA_OVERLAY_EXTRACT
	$(call arch-xtensa-overlay-extract,$(@D),u-boot)
endef
UBOOT_POST_EXTRACT_HOOKS += UBOOT_XTENSA_OVERLAY_EXTRACT
UBOOT_EXTRA_DOWNLOADS += $(ARCH_XTENSA_OVERLAY_URL)
endif

# Analogous code exists in linux/linux.mk. Basically, the generic
# package infrastructure handles downloading and applying remote
# patches. Local patches are handled depending on whether they are
# directories or files.
UBOOT_PATCHES = $(call qstrip,$(BR2_TARGET_UBOOT_PATCH))
UBOOT_PATCH = $(filter ftp://% http://% https://%,$(UBOOT_PATCHES))

define UBOOT_APPLY_LOCAL_PATCHES
	for p in $(filter-out ftp://% http://% https://%,$(UBOOT_PATCHES)) ; do \
		if test -d $$p ; then \
			$(APPLY_PATCHES) $(@D) $$p \*.patch || exit 1 ; \
		else \
			$(APPLY_PATCHES) $(@D) `dirname $$p` `basename $$p` || exit 1; \
		fi \
	done
endef
UBOOT_POST_PATCH_HOOKS += UBOOT_APPLY_LOCAL_PATCHES

# This is equivalent to upstream commit
# http://git.denx.de/?p=u-boot.git;a=commitdiff;h=e0d20dc1521e74b82dbd69be53a048847798a90a. It
# fixes a build failure when libfdt-devel is installed system-wide.
# This only works when scripts/dtc/libfdt exists (E.G. versions containing
# http://git.denx.de/?p=u-boot.git;a=commitdiff;h=c0e032e0090d6541549b19cc47e06ccd1f302893)
define UBOOT_FIXUP_LIBFDT_INCLUDE
	if [ -d $(@D)/scripts/dtc/libfdt ]; then \
		$(SED) 's%-I$$(srctree)/lib/libfdt%-I$$(srctree)/scripts/dtc/libfdt%' $(@D)/tools/Makefile; \
	fi
endef
UBOOT_POST_PATCH_HOOKS += UBOOT_FIXUP_LIBFDT_INCLUDE

ifeq ($(BR2_TARGET_UBOOT_BUILD_SYSTEM_LEGACY),y)
define UBOOT_CONFIGURE_CMDS
	$(TARGET_CONFIGURE_OPTS) \
		$(MAKE) -C $(@D) $(UBOOT_MAKE_OPTS) \
		$(UBOOT_BOARD_NAME)_config
endef
else ifeq ($(BR2_TARGET_UBOOT_BUILD_SYSTEM_KCONFIG),y)
ifeq ($(BR2_TARGET_UBOOT_USE_DEFCONFIG),y)
UBOOT_KCONFIG_DEFCONFIG = $(call qstrip,$(BR2_TARGET_UBOOT_BOARD_DEFCONFIG))_defconfig
else ifeq ($(BR2_TARGET_UBOOT_USE_CUSTOM_CONFIG),y)
UBOOT_KCONFIG_FILE = $(call qstrip,$(BR2_TARGET_UBOOT_CUSTOM_CONFIG_FILE))
endif # BR2_TARGET_UBOOT_USE_DEFCONFIG

UBOOT_KCONFIG_FRAGMENT_FILES = $(call qstrip,$(BR2_TARGET_UBOOT_CONFIG_FRAGMENT_FILES))
UBOOT_KCONFIG_EDITORS = menuconfig xconfig gconfig nconfig

# UBOOT_MAKE_OPTS overrides HOSTCC / HOSTLDFLAGS to allow the build to
# find our host-openssl. However, this triggers a bug in the kconfig
# build script that causes it to build with /usr/include/ncurses.h
# (which is typically wchar) but link with
# $(HOST_DIR)/lib/libncurses.so (which is not).  We don't actually
# need any host-package for kconfig, so remove the HOSTCC/HOSTLDFLAGS
# override again. In addition, host-ccache is not ready at kconfig
# time, so use HOSTCC_NOCCACHE.
UBOOT_KCONFIG_OPTS = $(UBOOT_MAKE_OPTS) HOSTCC="$(HOSTCC_NOCCACHE)" HOSTLDFLAGS=""
define UBOOT_HELP_CMDS
	@echo '  uboot-menuconfig       - Run U-Boot menuconfig'
	@echo '  uboot-savedefconfig    - Run U-Boot savedefconfig'
	@echo '  uboot-update-defconfig - Save the U-Boot configuration to the path specified'
	@echo '                             by BR2_TARGET_UBOOT_CUSTOM_CONFIG_FILE'
endef
endif # BR2_TARGET_UBOOT_BUILD_SYSTEM_LEGACY

UBOOT_CUSTOM_DTS_PATH = $(call qstrip,$(BR2_TARGET_UBOOT_CUSTOM_DTS_PATH))

define UBOOT_BUILD_CMDS
	$(if $(UBOOT_CUSTOM_DTS_PATH),
		cp -f $(UBOOT_CUSTOM_DTS_PATH) $(@D)/arch/$(UBOOT_ARCH)/dts/
	)
	$(TARGET_CONFIGURE_OPTS) \
		$(MAKE) -C $(@D) $(UBOOT_MAKE_OPTS) \
		$(UBOOT_MAKE_TARGET)
	$(if $(BR2_TARGET_UBOOT_FORMAT_SD),
		$(@D)/tools/mxsboot sd $(@D)/u-boot.sb $(@D)/u-boot.sd)
	$(if $(BR2_TARGET_UBOOT_FORMAT_NAND),
		$(@D)/tools/mxsboot \
			-w $(BR2_TARGET_UBOOT_FORMAT_NAND_PAGE_SIZE) \
			-o $(BR2_TARGET_UBOOT_FORMAT_NAND_OOB_SIZE) \
			-e $(BR2_TARGET_UBOOT_FORMAT_NAND_ERASE_SIZE) \
			nand $(@D)/u-boot.sb $(@D)/u-boot.nand)
endef

define UBOOT_BUILD_OMAP_IFT
	$(HOST_DIR)/bin/gpsign -f $(@D)/u-boot.bin \
		-c $(call qstrip,$(BR2_TARGET_UBOOT_OMAP_IFT_CONFIG))
endef

ifneq ($(BR2_TARGET_UBOOT_ENVIMAGE),)
define UBOOT_GENERATE_ENV_IMAGE
	cat $(call qstrip,$(BR2_TARGET_UBOOT_ENVIMAGE_SOURCE)) \
		>$(@D)/buildroot-env.txt
	$(HOST_DIR)/bin/mkenvimage -s $(BR2_TARGET_UBOOT_ENVIMAGE_SIZE) \
		$(if $(BR2_TARGET_UBOOT_ENVIMAGE_REDUNDANT),-r) \
		$(if $(filter "BIG",$(BR2_ENDIAN)),-b) \
		-o $(BINARIES_DIR)/uboot-env.bin \
		$(@D)/buildroot-env.txt
endef
endif

define UBOOT_INSTALL_IMAGES_CMDS
	$(foreach f,$(UBOOT_BINS), \
			cp -dpf $(@D)/$(f) $(BINARIES_DIR)/
	)
	$(if $(BR2_TARGET_UBOOT_FORMAT_NAND),
		cp -dpf $(@D)/u-boot.sb $(BINARIES_DIR))
	$(if $(BR2_TARGET_UBOOT_SPL),
		$(foreach f,$(call qstrip,$(BR2_TARGET_UBOOT_SPL_NAME)), \
			cp -dpf $(@D)/$(f) $(BINARIES_DIR)/
		)
	)
	$(UBOOT_GENERATE_ENV_IMAGE)
	$(if $(BR2_TARGET_UBOOT_BOOT_SCRIPT),
		$(MKIMAGE) -C none -A $(MKIMAGE_ARCH) -T script \
			-d $(call qstrip,$(BR2_TARGET_UBOOT_BOOT_SCRIPT_SOURCE)) \
			$(BINARIES_DIR)/boot.scr)
endef

ifeq ($(BR2_TARGET_UBOOT_ZYNQMP),y)

UBOOT_ZYNQMP_PMUFW = $(call qstrip,$(BR2_TARGET_UBOOT_ZYNQMP_PMUFW))

ifneq ($(findstring ://,$(UBOOT_ZYNQMP_PMUFW)),)
UBOOT_EXTRA_DOWNLOADS += $(UBOOT_ZYNQMP_PMUFW)
BR_NO_CHECK_HASH_FOR += $(notdir $(UBOOT_ZYNQMP_PMUFW))
UBOOT_ZYNQMP_PMUFW_PATH = $(UBOOT_DL_DIR)/$(notdir $(UBOOT_ZYNQMP_PMUFW))
else ifneq ($(UBOOT_ZYNQMP_PMUFW),)
UBOOT_ZYNQMP_PMUFW_PATH = $(shell readlink -f $(UBOOT_ZYNQMP_PMUFW))
endif

define UBOOT_ZYNQMP_KCONFIG_PMUFW
	$(call KCONFIG_SET_OPT,CONFIG_PMUFW_INIT_FILE,"$(UBOOT_ZYNQMP_PMUFW_PATH)", \
	       $(@D)/.config)
endef

UBOOT_ZYNQMP_PSU_INIT = $(call qstrip,$(BR2_TARGET_UBOOT_ZYNQMP_PSU_INIT_FILE))
UBOOT_ZYNQMP_PSU_INIT_PATH = $(shell readlink -f $(UBOOT_ZYNQMP_PSU_INIT))

ifneq ($(UBOOT_ZYNQMP_PSU_INIT),)
define UBOOT_ZYNQMP_KCONFIG_PSU_INIT
	$(call KCONFIG_SET_OPT,CONFIG_XILINX_PS_INIT_FILE,"$(UBOOT_ZYNQMP_PSU_INIT_PATH)", \
		$(@D)/.config)
endef
endif

endif # BR2_TARGET_UBOOT_ZYNQMP

define UBOOT_INSTALL_OMAP_IFT_IMAGE
	cp -dpf $(@D)/$(UBOOT_BIN_IFT) $(BINARIES_DIR)/
endef

ifeq ($(BR2_TARGET_UBOOT_OMAP_IFT),y)
ifeq ($(BR_BUILDING),y)
ifeq ($(call qstrip,$(BR2_TARGET_UBOOT_OMAP_IFT_CONFIG)),)
$(error No gpsign config file. Check your BR2_TARGET_UBOOT_OMAP_IFT_CONFIG setting)
endif
ifeq ($(wildcard $(call qstrip,$(BR2_TARGET_UBOOT_OMAP_IFT_CONFIG))),)
$(error gpsign config file $(BR2_TARGET_UBOOT_OMAP_IFT_CONFIG) not found. Check your BR2_TARGET_UBOOT_OMAP_IFT_CONFIG setting)
endif
endif
UBOOT_DEPENDENCIES += host-omap-u-boot-utils
UBOOT_POST_BUILD_HOOKS += UBOOT_BUILD_OMAP_IFT
UBOOT_POST_INSTALL_IMAGES_HOOKS += UBOOT_INSTALL_OMAP_IFT_IMAGE
endif

ifeq ($(BR2_TARGET_UBOOT_ZYNQ_IMAGE),y)
define UBOOT_GENERATE_ZYNQ_IMAGE
	$(HOST_DIR)/bin/python2 \
		$(HOST_DIR)/bin/zynq-boot-bin.py \
		-u $(@D)/$(firstword $(call qstrip,$(BR2_TARGET_UBOOT_SPL_NAME))) \
		-o $(BINARIES_DIR)/BOOT.BIN
endef
UBOOT_DEPENDENCIES += host-zynq-boot-bin
UBOOT_POST_INSTALL_IMAGES_HOOKS += UBOOT_GENERATE_ZYNQ_IMAGE
endif

ifeq ($(BR2_TARGET_UBOOT_ALTERA_SOCFPGA_IMAGE_CRC),y)
ifeq ($(BR2_TARGET_UBOOT_SPL),y)
UBOOT_CRC_ALTERA_SOCFPGA_INPUT_IMAGES = $(call qstrip,$(BR2_TARGET_UBOOT_SPL_NAME))
UBOOT_CRC_ALTERA_SOCFPGA_HEADER_VERSION = 0
else
UBOOT_CRC_ALTERA_SOCFPGA_INPUT_IMAGES = u-boot-dtb.bin
UBOOT_CRC_ALTERA_SOCFPGA_HEADER_VERSION = 1
endif
define UBOOT_CRC_ALTERA_SOCFPGA_IMAGE
	$(foreach f,$(UBOOT_CRC_ALTERA_SOCFPGA_INPUT_IMAGES), \
		$(HOST_DIR)/bin/mkpimage \
			-v $(UBOOT_CRC_ALTERA_SOCFPGA_HEADER_VERSION) \
			-o $(BINARIES_DIR)/$(notdir $(call qstrip,$(f))).crc \
			$(@D)/$(call qstrip,$(f))
	)
endef
UBOOT_DEPENDENCIES += host-mkpimage
UBOOT_POST_INSTALL_IMAGES_HOOKS += UBOOT_CRC_ALTERA_SOCFPGA_IMAGE
endif

define UBOOT_LRD_ENCRYPT_OPTS
	$(if $(BR2_PACKAGE_LRD_ENCRYPTED_STORAGE_TOOLKIT),
		$(call KCONFIG_ENABLE_OPT,CONFIG_FIT_SIGNATURE,$(@D)/.config)
		$(call KCONFIG_ENABLE_OPT,CONFIG_FIT_ENABLE_SHA256_SUPPORT,$(@D)/.config)
		$(call KCONFIG_ENABLE_OPT,CONFIG_SPL_FIT_SIGNATURE,$(@D)/.config)
		$(call KCONFIG_ENABLE_OPT,CONFIG_FIT_IMAGE_POST_PROCESS,$(@D)/.config)
		$(call KCONFIG_ENABLE_OPT,CONFIG_SPL_FIT_IMAGE_POST_PROCESS,$(@D)/.config))
endef

define UBOOT_KCONFIG_FIXUP_CMDS
	$(UBOOT_ZYNQMP_KCONFIG_PMUFW)
	$(UBOOT_ZYNQMP_KCONFIG_PSU_INIT)
	$(UBOOT_LRD_ENCRYPT_OPTS)
endef

ifeq ($(BR2_TARGET_UBOOT_ENVIMAGE),y)
ifeq ($(BR_BUILDING),y)
ifeq ($(call qstrip,$(BR2_TARGET_UBOOT_ENVIMAGE_SOURCE)),)
$(error Please define a source file for Uboot environment (BR2_TARGET_UBOOT_ENVIMAGE_SOURCE setting))
endif
ifeq ($(call qstrip,$(BR2_TARGET_UBOOT_ENVIMAGE_SIZE)),)
$(error Please provide Uboot environment size (BR2_TARGET_UBOOT_ENVIMAGE_SIZE setting))
endif
endif
UBOOT_DEPENDENCIES += host-uboot-tools
endif

ifeq ($(BR2_TARGET_UBOOT_BOOT_SCRIPT),y)
ifeq ($(BR_BUILDING),y)
ifeq ($(call qstrip,$(BR2_TARGET_UBOOT_BOOT_SCRIPT_SOURCE)),)
$(error Please define a source file for Uboot boot script (BR2_TARGET_UBOOT_BOOT_SCRIPT_SOURCE setting))
endif
endif
UBOOT_DEPENDENCIES += host-uboot-tools
endif

ifeq ($(BR2_TARGET_UBOOT)$(BR_BUILDING),yy)

#
# Check U-Boot board name (for legacy) or the defconfig/custom config
# file options (for kconfig)
#
ifeq ($(BR2_TARGET_UBOOT_BUILD_SYSTEM_LEGACY),y)
ifeq ($(UBOOT_BOARD_NAME),)
$(error No U-Boot board name set. Check your BR2_TARGET_UBOOT_BOARDNAME setting)
endif # UBOOT_BOARD_NAME
else ifeq ($(BR2_TARGET_UBOOT_BUILD_SYSTEM_KCONFIG),y)
ifeq ($(BR2_TARGET_UBOOT_USE_DEFCONFIG),y)
ifeq ($(call qstrip,$(BR2_TARGET_UBOOT_BOARD_DEFCONFIG)),)
$(error No board defconfig name specified, check your BR2_TARGET_UBOOT_BOARD_DEFCONFIG setting)
endif # qstrip BR2_TARGET_UBOOT_BOARD_DEFCONFIG
endif # BR2_TARGET_UBOOT_USE_DEFCONFIG
ifeq ($(BR2_TARGET_UBOOT_USE_CUSTOM_CONFIG),y)
ifeq ($(call qstrip,$(BR2_TARGET_UBOOT_CUSTOM_CONFIG_FILE)),)
$(error No board configuration file specified, check your BR2_TARGET_UBOOT_CUSTOM_CONFIG_FILE setting)
endif # qstrip BR2_TARGET_UBOOT_CUSTOM_CONFIG_FILE
endif # BR2_TARGET_UBOOT_USE_CUSTOM_CONFIG
endif # BR2_TARGET_UBOOT_BUILD_SYSTEM_LEGACY

#
# Check custom version option
#
ifeq ($(BR2_TARGET_UBOOT_CUSTOM_VERSION),y)
ifeq ($(call qstrip,$(BR2_TARGET_UBOOT_CUSTOM_VERSION_VALUE)),)
$(error No custom U-Boot version specified. Check your BR2_TARGET_UBOOT_CUSTOM_VERSION_VALUE setting)
endif # qstrip BR2_TARGET_UBOOT_CUSTOM_VERSION_VALUE
endif # BR2_TARGET_UBOOT_CUSTOM_VERSION

#
# Check custom tarball option
#
ifeq ($(BR2_TARGET_UBOOT_CUSTOM_TARBALL),y)
ifeq ($(call qstrip,$(BR2_TARGET_UBOOT_CUSTOM_TARBALL_LOCATION)),)
$(error No custom U-Boot tarball specified. Check your BR2_TARGET_UBOOT_CUSTOM_TARBALL_LOCATION setting)
endif # qstrip BR2_TARGET_UBOOT_CUSTOM_TARBALL_LOCATION
endif # BR2_TARGET_UBOOT_CUSTOM_TARBALL

#
# Check Git/Mercurial repo options
#
ifeq ($(BR2_TARGET_UBOOT_CUSTOM_GIT)$(BR2_TARGET_UBOOT_CUSTOM_HG),y)
ifeq ($(call qstrip,$(BR2_TARGET_UBOOT_CUSTOM_REPO_URL)),)
$(error No custom U-Boot repository URL specified. Check your BR2_TARGET_UBOOT_CUSTOM_REPO_URL setting)
endif # qstrip BR2_TARGET_UBOOT_CUSTOM_CUSTOM_REPO_URL
ifeq ($(call qstrip,$(BR2_TARGET_UBOOT_CUSTOM_REPO_VERSION)),)
$(error No custom U-Boot repository URL specified. Check your BR2_TARGET_UBOOT_CUSTOM_REPO_VERSION setting)
endif # qstrip BR2_TARGET_UBOOT_CUSTOM_CUSTOM_REPO_VERSION
endif # BR2_TARGET_UBOOT_CUSTOM_GIT || BR2_TARGET_UBOOT_CUSTOM_HG

endif # BR2_TARGET_UBOOT && BR_BUILDING

ifeq ($(BR2_TARGET_UBOOT_BUILD_SYSTEM_LEGACY),y)
UBOOT_DEPENDENCIES += \
	$(BR2_BISON_HOST_DEPENDENCY) \
	$(BR2_FLEX_HOST_DEPENDENCY)
$(eval $(generic-package))
else ifeq ($(BR2_TARGET_UBOOT_BUILD_SYSTEM_KCONFIG),y)
UBOOT_MAKE_ENV = $(TARGET_MAKE_ENV)
UBOOT_KCONFIG_DEPENDENCIES = \
	$(BR2_BISON_HOST_DEPENDENCY) \
	$(BR2_FLEX_HOST_DEPENDENCY)
$(eval $(kconfig-package))
endif # BR2_TARGET_UBOOT_BUILD_SYSTEM_LEGACY
