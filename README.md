# alpinedots

apk  add  font-cantarell

fire code from 

https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraCode


 https://gitlab.alpinelinux.org/alpine/apk-tools/-/releases

 chmod +x apk.static

sudo cfdik /dev/sda

mkfs.ext4 /dev/sda2  

mount /dev/sda2 /mnt

sudo ./apk.static  -X "http://dl-cdn.alpinelinux.org/alpine/latest-stable/main" -U --allow-untrusted --root /mnt --initdb add alpine-base

nano chroot.sh
```
mount --rbind /dev /mnt/dev && mount --make-rslave /mnt/dev
mount --rbind /dev/pts /mnt/dev/pts && mount --make-rslave /mnt/dev/pts
mount --rbind /proc /mnt/proc && mount --make-rslave /mnt/proc
mount --rbind /sys /mnt/sys && mount --make-rslave /mnt/sys
chroot  /mnt /bin/sh  
```
sudo /bin/sh ./chroot.sh

echo "nameserver 1.1.1.1"  > /etc/resolv.conf

 setup-apkrepos

 enable community repos(c)
 
 mirror[1]

apk add alsa-utils brightnessctl  cfdisk doas dosfstools e2fsprogs file firefox font-awesome font-dejavu font-dejavu-sans-mono-nerd foot grim gsettings-desktop-schemas htop i3blocks intel-media-driver iwd jq libudev-zero  mesa-dri-gallium mingetty mpv nano nnn  openresolv seatd slurp socat sway  wl-clipboard wofi wtype zathura-pdf-mupdf

optional : coz of diffrent  requirement

 linux-firmware-ath10k linux-firmware-i915 bubblewrap linux-firmware-none linux-lts ntfs-3g wireless-regdb  

 setup-devd
 
 [mdev]

rc-update del hwdrivers


 
