
#!/bin/bash -x

set -e

HOMEDIR="/home/hsuchan"

# Update system
pacman -Syyu --noconfirm
mhwd-kernel -i linux420

# Install packages
pacman -S chromium code delve docker feh fuse3 go libreoffice-fresh --noconfirm

# Disable PC speaker
rmmod pcspkr 2>/dev/null
printf "blacklist pcspkr\n" > /etc/modprobe.d/nobeep.conf

# Mount VMWare shared folder
mkdir /shared
sed -i 's/^#user_allow_other$/user_allow_other/' /etc/fuse.conf
printf ".host:/Shared /shared fuse.vmhgfs-fuse allow_other 0 0\n" >> /etc/fstab

# Configure docker
usermod -aG docker hsuchan
systemctl enable docker

# Configure golang
mkdir ${HOMEDIR}/go/{bin,pkg,src}
chown hsuchan:hsuchan ${HOMEDIR}/go/{bin,pkg,src}

# Download wallpaper
curl -sL https://bit.ly/2isXdSj -o ${HOMEDIR}/Pictures/wallpaper.png
printf "\n# Custom settings
exec_always --no-startup-id feh --bg-scale ${HOMEDIR}/Pictures/wallpaper.png\n" >> ${HOMEDIR}/.i3/config

# Profile
sed -i 's/^export EDITOR=\/usr\/bin\/nano$/export EDITOR=\/usr\/bin\/vi/' ${HOMEDIR}/.profile
sed -i 's/^export BROWSER=\/usr\/bin\/palemoon$/export BROWSER=\/usr\/bin\/chromium/' ${HOMEDIR}/.profile
printf "export GOPATH=\$HOME/go
feh --bg-scale ${HOMEDIR}/Pictures/wallpaper.png\n" >> ${HOMEDIR}/.profile

# Cleanup
rm setup.sh
rm -rf .git
telinit 0
