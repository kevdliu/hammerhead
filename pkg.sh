#!/bin/sh

VER=$1

if [ -z "$VER" ]; then
    echo "No version provided"
    exit 0
fi

# download boot image
echo "Downloading boot image"
cd ~/img-tools
wget -N http://kernels.franco-lnx.net/Nexus5/4.4/boot-r$VER.img
chmod 777 boot-r$VER.img

# unpack boot image
echo "Unpacking boot image"
./unpackimg.sh boot-r$VER.img

# replace zimage-dtb
echo "Replacing kernel"
cp -f ../ff/arch/arm/boot/zImage-dtb split_img/boot-r$VER.img-zImage

# replace fstab.hammerhead
echo "Replacing fstab"
cp -f ../ff/fstab.hammerhead.f2fs ramdisk/fstab.hammerhead

# repack boot image
echo "Repacking boot image"
./repackimg.sh

# copy new boot image
echo "Copying new boot image"
cp -f image-new.img ../ff/arch/arm/boot/ff-f2fs-r$VER.img

# make zip file
echo "Making zip file"
cd ../ff/zip
rm -f *.zip
cp -f ../arch/arm/boot/ff-f2fs-r$VER.img boot.img
zip -r -9 ff-f2fs-r$VER.zip *
mv ff-f2fs-r$VER.zip ../arch/arm/boot/ff-f2fs-r$VER.zip
rm boot.img

# clean up
echo "Cleaning up"
cd -
./cleanup.sh
rm -f boot-r$VER.img
