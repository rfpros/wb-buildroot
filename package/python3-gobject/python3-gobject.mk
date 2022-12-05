################################################################################
#
# python3-gobject
#
################################################################################

PYTHON3_GOBJECT_VERSION_MAJOR = 3.36
PYTHON3_GOBJECT_VERSION = $(PYTHON3_GOBJECT_VERSION_MAJOR).0
PYTHON3_GOBJECT_SOURCE = pygobject-$(PYTHON3_GOBJECT_VERSION).tar.xz
PYTHON3_GOBJECT_SITE = https://ftp.gnome.org/pub/gnome/sources/pygobject/$(PYTHON3_GOBJECT_VERSION_MAJOR)
PYTHON3_GOBJECT_LICENSE = LGPL-2.1+
PYTHON3_GOBJECT_LICENSE_FILES = COPYING
PYTHON3_GOBJECT_DEPENDENCIES = host-pkgconf libglib2 gobject-introspection python3
PYTHON3_GOBJECT_CONF_OPTS += -Dpycairo=false -Dtests=false
PYTHON3_GOBJECT_INSTALL_STAGING = YES

# A sysconfigdata_name must be manually specified or the resulting .so
# will have a x86_64 prefix, which causes "import gi" to fail.
# A pythonpath must be specified or the host python path will be used resulting
# in a "not a valid python" error.
PYTHON3_GOBJECT_CONF_ENV += \
	_PYTHON_SYSCONFIGDATA_NAME=$(PKG_PYTHON_SYSCONFIGDATA_NAME) \
	PYTHONPATH=$(PYTHON3_PATH)

$(eval $(meson-package))
