apt-get install apache2
cp conf/apache2.conf /etc/apache2/sites-available/katkola.conf
a2enmod katkola
a2dismod 000-default
service apache2 restart


if [ -e /mnt/sdd/ ]; then
  mkdir /mnt/sdd/www
  cp -r katkola/* /mnt/sdd/www/
else
  echo "/mnt/sdd doesn't exist. That is the Kätkölä www-files location. Exitting with error status."
  exit 1
fi

