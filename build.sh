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
apt-get -y install x2goserver x2goserver-xsession openbox tint2 nitrogen ruby ruby-sinatra ruby-gtk2 volumeicon-alsa pcmanfm lxterminal git lightdm;

# Install extras
cd /tmp;
apt-get -y install libwebkit-dev ruby-dev ;
gem install webkit-gtk;
gem install gtk-webkit-ruby;
gem install parseconfig;

# Grab Symphony Sources
git clone https://github.com/SymphonyOS/symphonyos.git;
git clone https://github.com/SymphonyOS/skel.git;

# Install Icons
dpkg -i /tmp/symphonyos/build/paper-icon-theme_1.3_all.deb;

# Place in filesystem
cp -Rf skel/.config/* /etc/skel/.config/.;
cp -Rf symphonyos/etc/* /etc/.;
cp -Rf symphonyos/usr/* /usr/.;

# Create icons symlink
ln -s /usr/share/icons /usr/local/symphonyos/public/ico;

# Set up testuser with root's ssh key
adduser --disabled-password --gecos "" testuser;
cp -Rf /etc/skel /home/testuser;
mkdir /home/testuser/.ssh;
cp /root/.ssh/authorized_keys /home/testuser/.ssh/authorized_keys;
chown -Rf testuser.testuser /home/testuser;

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
