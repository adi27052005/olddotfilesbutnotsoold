#!/bin/bash

su
mkdir .config
cd $HOME/.config
git clone https://aur.archlinux.org/paru
cd paru
makepkg -si
cd

# Packages
# paru -S acpi audacity bluez bluez-utils bottom brave-bin breeze-obsidian-cursor-theme cava conky curl dunst emacs envycontrol exa fastfetch fd feh ffmpeg figlet firefox flat-remix-gtk fm6000 fzf gimp gpick guvcview gvfs gvfs-gphoto2 gvfs-mtp gzip htop i3lock imagemagick kdenlive kitty libnotify lolcat lxappearance-gtk3 ly mpd mtpfs mupdf ncdu neovim-nightly-bin neovim-nvim-treesitter ngrok nitrogen nodejs npm ntfs-3g nvidia nvidia-settings nvidia-utils openssh p7zip papirus-icon-theme pinta playerctl ripgrep rustup scrot thunar tldr tlp tmux tor tor-browser tree-sitter ttf-fira-sans ttf-jetbrains-mono ttf-jetbrains-mono-nerd ttf-quicksand-variable unzip usbutils vlc w3m xautolock xbindkeys xclip xf86-video-intel xf86-input-amdgpu xorg xorg-xinit xsel xbacklight ybacklight zenity zip zsh

paru -S mpd mpDris2 playerctl ncmpcpp dosfstools binutils make gcc pkg-config fakeroot base-devel xdg-utils acpi bluez bluez-utils bpytop breeze-obsidian-cursor-theme bspwm chromium curl dotnet-sdk emacs enycontrol eza feh fastfetch figlet flat-remix-gtk git guvcview gvfs gvfs-gphoto2 gvfs-mtp htop i3lock imagemagick kitty libnotify lolcat lxappearance-gtk3 ly mpv mtpfs ncdu neovim-nightly-bin nodejs npm ntfs-3g nvidia nvidia-utils openssh os-prober papirus-icon-theme picom pinta polybar ranger scrot thunar tldr tlp tor tor-browser ttf-fira-sans ttf-jetbrains-mono-nerd unzip upower usbutils wget xautolock xbindkeys xclip xf86-video-libinput xf86-video-amdgpu xf86-video-intel xorg xorg-xinit xorg-xset xbacklight ybacklight zathura zathura-pdf-mupdf zip zsh 
# Oh My ZSH
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

systemctl enable ly
systemctl enable bluetooth
systemctl enable sshd

mv $HOME/dotfiles/.zshrc $HOME/
mv $HOME/dotfiles/Documents $HOME/
mv -r $HOME/dotfiles/* $HOME/.config/

echo '
Section "InputClass"
    Identifier "touchpad"
    Driver "libinput"
    MatchIsTouchpad "on"
    Option "Tapping" "on"
    Option "TappingButtonMap" "lmr"
    Option "NaturalScrolling" "true"
EndSection
' >> /etc/X11/xorg.conf.d/30-touchpad.conf

echo '
adi ALL=NOPASSWD: /sbin/reboot, /sbin/poweroff
' >> /etc/sudoers

cd $HOME/.config/dwm; sudo make clean install
cd $HOME/.config/dmenu; sudo make clean install

chmod +x $HOME/.config/bspwm/bspwmrc
chmod +x $HOME/.config/sxhkd/sxhkdrc

echo '

NOTE: to update pacman mirrors: 

sudo pacman -S pacman-contrib
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
su
rankmirrors -n 6 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist

'
