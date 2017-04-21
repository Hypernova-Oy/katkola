KATKO_INSTALL_DIR="/var/www"
KATKO_BASE_DIR="$KATKO_INSTALL_DIR/katkola"


useradd -m katkola -s /usr/sbin/nologin
su -c "cp -r public_html /home/katkola/" -s /bin/bash katkola

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

