# alpinedots

### Resources
* **Nerd Fonts:** [Patched Fonts](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts)
* **APK Tools:** [Releases](https://gitlab.alpinelinux.org/alpine/apk-tools/-/releases)

### 1. Preparation & Partitioning
```bash
chmod +x apk.static
sudo cfdisk /dev/sda
mkfs.ext4 /dev/sda2  
mount /dev/sda2 /mnt
```

### 2. Base Installation
```bash
sudo ./apk.static -X "[http://dl-cdn.alpinelinux.org/alpine/latest-stable/main](http://dl-cdn.alpinelinux.org/alpine/latest-stable/main)" \
-U --allow-untrusted --root /mnt --initdb add alpine-base
```

### 3. Chroot Setup
You can use a traditional script or `unshare` for an isolated environment.

**Option A: Standard Chroot Script (`chroot.sh`)**
```bash
#!/bin/sh
mount --rbind /dev /mnt/dev && mount --make-rslave /mnt/dev
mount --rbind /dev/pts /mnt/dev/pts && mount --make-rslave /mnt/dev/pts
mount --rbind /proc /mnt/proc && mount --make-rslave /mnt/proc
mount --rbind /sys /mnt/sys && mount --make-rslave /mnt/sys
chroot /mnt /bin/sh
```
Run with: `sudo /bin/sh ./chroot.sh`

**Option B: Using Unshare**
```bash
unshare --mount --pid --fork --user --map-root-user --mount-proc bash -c '
    mount --rbind /dev /mnt/dev && mount --make-rslave /mnt/dev
    mount --rbind /dev/pts /mnt/dev/pts && mount --make-rslave /mnt/dev/pts
    mount --rbind /proc /mnt/proc && mount --make-rslave /mnt/proc
    mount --rbind /sys /mnt/sys && mount --make-rslave /mnt/sys
    chroot /mnt /bin/sh
'
```

### 4. System Configuration (Inside Chroot)
```bash
echo "nameserver 1.1.1.1" > /etc/resolv.conf
setup-apkrepos # Select (c) for community and (1) for mirror

apk add alpine-base alsa-utils brightnessctl bubblewrap busybox-mdev-openrc \
cfdisk doas dosfstools e2fsprogs file firefox font-awesome font-dejavu \
font-noto-emoji foot grim gsettings-desktop-schemas htop i3blocks \
intel-media-driver iwd jq libudev-zero mesa-dri-gallium mingetty mpv \
nano nnn oath-toolkit-oathtool openresolv seatd slurp socat sway \
wl-clipboard wofi wtype zathura-pdf-mupdf dragon-drop
```

### 5. Bootloader (Systemd-boot)
Mount your EFI partition to `/boot` before running these:
```bash
apk add systemd-boot efibootmgr
mkdir -p /boot/EFI/systemd/
cp /usr/lib/systemd/boot/efi/systemd-bootx64.efi /boot/EFI/systemd/
mkdir -p /boot/loader/entries/
```

**Create `/boot/loader/entries/alpine.conf`:**
```text
title alpine
linux /vmlinuz-lts
initrd /initramfs-lts
options root=/dev/sda2 modules=sd-mod,ext4 quiet
```

### 6. Kernel & Firmware
```bash
# Basic setup
apk add linux-firmware-none linux-lts 

# Device specific: Inspiron 3501
# apk add linux-firmware-ath10k linux-firmware-i915

# Device specific: Inspiron 5559
# apk add linux-firmware-amd linux-firmware-amdgpu linux-firmware-radeon linux-firmware-intel intel-media-driver

apk add ntfs-3g wireless-regdb
```

### 7. Services & Users
```bash
setup-devd mdev

rc-update add fsck sysinit
rc-update del hwdrivers
rc-update add iwd boot
rc-update add seatd boot
rc-update add killprocs shutdown
rc-update add mdev sysinit
rc-update add mount-ro shutdown

# User setup
adduser k -s /bin/ash
passwd k

addgroup k seat
addgroup k video
addgroup k audio
addgroup k wheel
```

