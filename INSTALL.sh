KATKO_INSTALL_DIR="/var/www"
KATKO_BASE_DIR="$KATKO_INSTALL_DIR/katkola"
KATKO_SFTP_BASEDIR="/sftponly"
KATKO_SFTP_BASEDIR_ESC="\/sftponly"


#Create the directory for Kätkölä-users' chrooted dirs.
mkdir -p "$KATKO_SFTP_BASEDIR"
chmod 755 "$KATKO_SFTP_BASEDIR"

#Configure sshd to sftp to correct dir
if [ -e $KATKO_INSTALL_DIR ]; then
  #Kätkölä sftp already configured
  echo ""
else
  sed "s/ChrootDirectory.*/ChrootDirectory $KATKO_SFTP_BASEDIR_ESC\/%u/" /etc/ssh/sshd_config
  service sshd restart
fi


if [ $(grep 'katkola' /etc/users) ]; then
  #Kätkölä-user created
  echo ""
else
  useradd -m katkola -s /usr/sbin/nologin
  mkdir -p "$KATKO_SFTP_BASEDIR/katkola/private"
  cp -r public_html "$KATKO_SFTP_BASEDIR/katkola/"
  chown -R katkola: "$KATKO_SFTP_BASEDIR/katkola"
  ln -s "$KATKO_SFTP_BASEDIR/katkola/public_html" "/home/katkola/public_html"
  chown katkola: "/home/katkola/public_html"
fi

apt-get install apache2
cp conf/apache2.conf /etc/apache2/sites-available/katkola.conf
a2ensite katkola
a2dissite 000-default
a2enmod userdir
service apache2 restart


if [ -e $KATKO_INSTALL_DIR ]; then
  mkdir -p $KATKO_BASE_DIR
  cp -r katkola/* "$KATKO_BASE_DIR/"
else
  echo "$KATKO_INSTALL_DIR/ doesn't exist. That is the Kätkölä www-files location. Exitting with error status."
  exit 1
fi

