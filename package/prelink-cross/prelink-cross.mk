################################################################################
#
# host-prelink-cross
#
################################################################################

HOST_PRELINK_CROSS_VERSION = a853a5d715d84eec93aa68e8f2df26b7d860f5b2
HOST_PRELINK_CROSS_SITE = https://git.yoctoproject.org/git/prelink-cross
HOST_PRELINK_CROSS_SITE_METHOD = git
HOST_PRELINK_CROSS_LICENSE = GPL-2.0
HOST_PRELINK_CROSS_LICENSE_FILES = COPYING
# Sources from git, no configure script present
HOST_PRELINK_CROSS_AUTORECONF = YES
HOST_PRELINK_CROSS_DEPENDENCIES = host-elfutils host-libiberty

$(eval $(host-autotools-package))
