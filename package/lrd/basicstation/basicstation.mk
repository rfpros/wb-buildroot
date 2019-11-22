################################################################################
#
# Semtech Basic Station
#
################################################################################
BASICSTATION_VERSION = c29b8502f8c715daecec6666835da6e981dc820a
BASICSTATION_SITE = https://github.com/lorabasics/basicstation.git
BASICSTATION_SITE_METHOD = git
BASICSTATION_DEPENDENCIES = mbedtls libloragw

define  BASICSTATION_BUILD_CMDS
	CC="$(TARGET_CC)" AR="$(TARGET_AR)" ARCH=arm-laird-linux-gnueabi BUILD_DIR=$(@D) BR_LDFLAGS="-L $(STAGING_DIR)/usr/lib -L $(STAGING_DIR)/lib -lm -lpthread -lmbedtls -lmbedx509 -lmbedcrypto" LGW_PATH="$(STAGING_DIR)/usr/lib/libloragw" MBEDTLS_PATH="$(STAGING_DIR)/usr" $(MAKE) -C $(@D)
endef

define BASICSTATION_INSTALL_TARGET_CMDS
mkdir -p $(TARGET_DIR)/opt/lora/basicstation
$(INSTALL) -m 0755 $(@D)/build-laird-std/bin/station $(TARGET_DIR)/opt/lora/basicstation/station
$(INSTALL) -m 0644 $(@D)/examples/laird/station.conf $(TARGET_DIR)/opt/lora/basicstation/station.conf
endef

$(eval $(generic-package))

