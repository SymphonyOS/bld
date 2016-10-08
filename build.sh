#!/bin/sh
export DEBIAN_FRONTEND=noninteractive;

# Add x2go repository
apt-key adv --recv-keys --keyserver keys.gnupg.net E1F958385BFE2B6E;
echo "deb http://packages.x2go.org/debian jessie main" >> /etc/apt/sources.list.d/x2go.list;
echo "deb-src http://packages.x2go.org/debian jessie main" >> /etc/apt/sources.list.d/x2go.list;
apt-get update;
apt-get install x2go-keyring;

# Install Debian packages
apt-get update;
apt-get -y install x2goserver x2goserver-xsession openbox tint2 nitrogen ruby ruby-sinatra ruby-gtk2 libappindicator1 libdbusmenu-glib4 libdbusmenu-gtk4 libindicator7 libnotify-bin volumeicon-alsa pcmanfm lxappearance lxterminal git lightdm gtk-theme-switch gtk2-engines-oxygen gtk3-engines-oxygen chromium leafpad openbox-menu gksu;

# Install extras
cd /tmp;
apt-get -y install libwebkit-dev ruby-dev ;
gem install webkit-gtk;
gem install gtk-webkit-ruby;
gem install parseconfig;

wget http://ftp.us.debian.org/debian/pool/main/y/yad/yad_0.37.0-1_amd64.deb -O /tmp/yad.deb;
dpkg -i /tmp/yad.deb;

# Grab Symphony Sources
git clone https://github.com/SymphonyOS/symphonyos.git;
git clone https://github.com/SymphonyOS/skel.git;

# Install Icons
dpkg -i /tmp/symphonyos/build/paper-icon-theme_1.3_all.deb;

# Install Apps
wget https://atom.io/download/deb -O /tmp/atom.deb;
dpkg -i /tmp/atom.deb;
Install hyper
wget https://github.com/zeit/hyper/releases/download/0.8.1/hyper-0.8.1-amd64.deb -O /tmp/hyper.deb;
dpkg -i /tmp/hyper.deb;

# Place in filesystem
cp -Rf /tmp/skel/.config /etc/skel/.config;
cp -Rf symphonyos/etc/* /etc/.;
cp -Rf symphonyos/usr/* /usr/.;

# Create icons symlink
ln -s /usr/share/icons /usr/local/symphony/mezzo/public/ico;

# Set up testuser with root's ssh key
adduser --disabled-password --gecos "" testuser;
cp -Rf /etc/skel/.config/* /home/testuser/.config/.;
mkdir /home/testuser/.ssh;
cp /root/.ssh/authorized_keys /home/testuser/.ssh/authorized_keys;
chown -Rf testuser.testuser /home/testuser;
adduser testuser sudo;

# Build LiveCD
wget https://github.com/ch1x0r/LinuxRespin/blob/master/debian/new-Sept2016/respin-deb_1.0.0-2_all~sggua.deb?raw=true -O /tmp/respin-deb_1.0.0-2_all~sggua.deb;
cp -f /etc/respin.conf /etc/respin.conf.default;
dpkg -i /tmp/respin-deb_1.0.0-2_all~sggua.deb;
apt-get -yf install;
cp -f /etc/respin.conf.default /etc/respin.conf;
respin dist;


# Share LiveCD ISO via www
apt-get -y install apache2;
mv /home/respin/respin/custom-live.iso /var/www/html/.;
echo "<a href='/custom-live.iso'><h1>DOWNLOAD ISO</h1></a>" > /var/www/html/index.html;
