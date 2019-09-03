
export BR2_LRD_PRODUCT=reg45n
export BR2_LRD_PLATFORM=msd45n

echo "REG45n POST BUILD script: starting..."

# enable tracing and exit on errors
set -x -e

# generate manifest file
echo "/usr/bin/athtestcmd" > "$TARGET_DIR/$BR2_LRD_PRODUCT.manifest"
echo "/usr/sbin/smu_cli" >> "$TARGET_DIR/$BR2_LRD_PRODUCT.manifest"

for f in $TARGET_DIR/lib/firmware/ath6k/AR6003/hw2.1.1/athtcmd*; do
	echo "/lib/firmware/ath6k/AR6003/hw2.1.1/"$(basename $f) >> $TARGET_DIR/$BR2_LRD_PRODUCT.manifest
done

# move tcmd.sh into package and add to manifest
cp board/laird/reg45n/rootfs-additions/tcmd.sh $TARGET_DIR/usr/bin
echo "/usr/bin/tcmd.sh" >> "$TARGET_DIR/$BR2_LRD_PRODUCT.manifest"

# make sure board script is not in target directory and copy it from rootfs-additions
rm -f $TARGET_DIR/reg_tools.sh
cp board/laird/reg45n/rootfs-additions/reg_tools.sh $TARGET_DIR

echo "REG45n POST BUILD script: done."
