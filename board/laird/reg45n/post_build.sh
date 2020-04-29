# enable tracing and exit on errors
set -x -e

BR2_LRD_PRODUCT="$(sed -n 's,^BR2_DEFCONFIG=".*/\(.*\)_defconfig"$,\1,p' ${BR2_CONFIG})"

echo "${BR2_LRD_PRODUCT^^} POST BUILD script: starting..."

LIBEDIT=$(readlink $TARGET_DIR/usr/lib/libedit.so)
LIBEDITLRD=${LIBEDIT/libedit./libedit.lrd.}

# generate manifest file
echo "/usr/bin/lru
/usr/sbin/smu_cli
/usr/bin/tcmd.sh
/usr/lib/${LIBEDITLRD}" \
> "${TARGET_DIR}/${BR2_LRD_PRODUCT}.manifest"

ls "${TARGET_DIR}/lib/firmware/ath6k/AR6003/hw2.1.1/athtcmd"* | sed "s,^${TARGET_DIR},," \
	>> "${TARGET_DIR}/${BR2_LRD_PRODUCT}.manifest"

cp "${TARGET_DIR}/usr/lib/${LIBEDIT}" "${TARGET_DIR}/usr/lib/${LIBEDITLRD}"

# move tcmd.sh into package and add to manifest
cp board/laird/reg45n/rootfs-additions/tcmd.sh $TARGET_DIR/usr/bin

# make sure board script is not in target directory and copy it from rootfs-additions
rm -f $TARGET_DIR/reg_tools.sh
cp board/laird/reg45n/rootfs-additions/reg_tools.sh $TARGET_DIR

echo "${BR2_LRD_PRODUCT^^} POST BUILD script: done."
