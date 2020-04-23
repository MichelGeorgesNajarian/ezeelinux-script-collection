#!/bin/bash

# Ubuntu (GNOME) 20.04 generic setup script.
# By Joe Collins. (www.ezeelinux.com GNU/General Public License version 2.0)
# Modified by MichelGeorgesNajarian

# Must have Gdebi!:

dpkg -l | grep -qw gdebi || sudo apt-get install -yyq gdebi

# First, let's install a bunch of software:

sudo apt install -yy openssh-server sshfs net-tools gedit-plugin-text-size \
simplescreenrecorder libreoffice ubuntu-restricted-extras parole vlc gthumb \
gnome-tweaks chrome-gnome-shell spell synaptic gufw brasero git mc \
rhythmbox-plugin-cdrecorder gparted youtube-dl pavucontrol handbrake audacity \
timeshift htop grsync lame asunder soundconverter \
maven python3 openjdk-11-jre-headless make valgrind gcc g++ npm nodejs


# Install all local .deb packages, if available:

if [ -d "/home/$USER/Downloads/Packages" ]; then
	echo "Installing local .deb packages..."
	pushd /home/$USER/Downloads/Packages
	for FILE in ./*.deb
    do
        sudo gdebi -n "$FILE"
    done
	popd
else
	echo $'\n'$"WARNING! There's no ~/Downloads/Packages directory."
	echo "Local .deb packages can't be automatically installed."
	sleep 5 # The script pauses so this message can be read. 
fi

# Remove undesirable packages:

sudo apt purge deja-dup shotwell -yy

# Purge Firefox, install Google Chrome:

sudo apt purge firefox -yy
sudo apt purge firefox-locale-en -yy
if [ -d "/home/$USER/.mozilla" ]; then
	rm -rf /home/$USER/.mozilla
fi
if [ -d "/home/$USER/.cache/mozilla" ]; then
	rm -rf /home/$USER/.cache/mozilla
fi
sudo apt install apt-transport-https curl

curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -

echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list

sudo apt update

sudo apt install -y brave-browser

# Enabling Numlock from startup
sudo apt-get install numlockx
sudo sed -i 's|^exit 0.*$|# Numlock enable\n[ -x /usr/bin/numlockx ] \&\& numlockx on\n\nexit 0|' /etc/rc.local
/usr/bin/numlockx on

# My VSCode settings
wget https://raw.githubusercontent.com/MichelGeorgesNajarian/MyConfigFiles/master/VSCode/settings.json
mv settings.json ~/.config/Code/User/settings.json

# Git config
git config --global user.name MichelGeorgesNajarian
git config --global user.email miichel.georges@mgnajarian.com

# Sound "pop and click" fix. Set sound card to stay powered on all the time:

sudo bash -c "echo 'options snd-hda-intel power_save=0 power_save_controller=N' \
>> /etc/modprobe.d/alsa-base.conf"

# Brasero-Ubuntu 18.04 Bug fix
# (This is a hold-over and may not be needed but doesn't hurt to run anyway.)

# Set permissions thusly to enable audio CD writing in Ubuntu 18.04:

sudo chmod 4711 /usr/bin/cdrdao
sudo chmod 4711 /usr/bin/wodim
sudo chmod 0755 /usr/bin/growisofs

# Gotta reboot now:

echo $'\n'$"*** All done! Please reboot now. ***"
exit

