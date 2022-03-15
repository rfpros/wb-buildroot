#############################################################
#
# Laird Connectivity USB Ethernet Gadget Helper
#
#############################################################

ifneq ($(BR2_PACKAGE_LRD_NETWORK_MANAGER)$(BR2_PACKAGE_NETWORK_MANAGER),)
define LRD_USBGADGET_INSTALL_NM
	$(INSTALL) -D -m 0600 -t $(TARGET_DIR)/etc/NetworkManager/system-connections/ \
		package/lrd/lrd-usbgadget/shared-usb0.nmconnection
endef
endif

define LRD_USBGADGET_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 -t $(TARGET_DIR)/usr/bin/ \
		package/lrd/lrd-usbgadget/usb-gadget.sh

	$(LRD_USBGADGET_INSTALL_NM)
endef

define LRD_USBGADGET_INSTALL_INIT_CONFIG
	mkdir -p "$(TARGET_DIR)/etc/default"
	echo "USB_GADGET_ETHER_PORTS=$(BR2_PACKAGE_LRD_USBGADGET_ETHERNET_PORTS)"    > $(TARGET_DIR)/etc/default/usb-gadget
	echo "USB_GADGET_ETHER=$(BR2_PACKAGE_LRD_USBGADGET_TYPE_STRING)"               >> $(TARGET_DIR)/etc/default/usb-gadget
	echo "USB_GADGET_ETHER_LOCAL_MAC=\"$(BR2_PACKAGE_LRD_USBGADGET_LOCAL_MAC)\""   >> $(TARGET_DIR)/etc/default/usb-gadget
	echo "USB_GADGET_ETHER_REMOTE_MAC=\"$(BR2_PACKAGE_LRD_USBGADGET_REMOTE_MAC)\"" >> $(TARGET_DIR)/etc/default/usb-gadget
	echo "USB_GADGET_SERIAL_PORTS=$(BR2_PACKAGE_LRD_USBGADGET_SERIAL_PORTS)"       >> $(TARGET_DIR)/etc/default/usb-gadget
endef

define LRD_USBGADGET_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/lrd/lrd-usbgadget/usb-gadget.service \
		$(TARGET_DIR)/usr/lib/systemd/system/usb-gadget.service

	$(LRD_USBGADGET_INSTALL_INIT_CONFIG)
endef

ifeq ($(BR2_PACKAGE_LRD_LEGACY),y)
define LRD_USBGADGET_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/lrd/lrd-usbgadget/S43usb-gadget \
		$(TARGET_DIR)/etc/init.d/opt/S91g_ether

	$(LRD_USBGADGET_INSTALL_INIT_CONFIG)
endef
else
define LRD_USBGADGET_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 -t $(TARGET_DIR)/etc/init.d/ \
		package/lrd/lrd-usbgadget/S43usb-gadget

	$(LRD_USBGADGET_INSTALL_INIT_CONFIG)
endef
endif

$(eval $(generic-package))
