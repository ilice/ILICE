echo sleep 3
sleep 3

echo build starting nginx config

echo replacing __www.hipicasolera.com__/$HIPICASOLERA_DOMAIN

# Put your domain name into the nginx reverse proxy config.
sed -i "s/__www.hipicasolera.com__/$HIPICASOLERA_DOMAIN/g" /etc/nginx/conf.d/ilice.conf

cat /etc/nginx/conf.d/ilice.conf
echo .
echo Firing up nginx in the background.
nginx

# This bit waits until the letsencrypt container has done its thing.
# We see the changes here bceause there's a docker volume mapped.
echo Waiting for folder /etc/letsencrypt/live/$HIPICASOLERA_DOMAIN to exist
while [ ! -d /etc/letsencrypt/live/$HIPICASOLERA_DOMAIN ] ;
do
    sleep 2
done

while [ ! -f /etc/letsencrypt/live/$HIPICASOLERA_DOMAIN/fullchain.pem ] ;
do
    echo Waiting for file fullchain.pem to exist
    sleep 2
done

while [ ! -f /etc/letsencrypt/live/$HIPICASOLERA_DOMAIN/privkey.pem ] ;
do
  echo Waiting for file privkey.pem to exist
  sleep 2
done

echo replacing __www.hipicasolera.com__/$HIPICASOLERA_DOMAIN

sed -i "s/__www.hipicasolera.com__/$HIPICASOLERA_DOMAIN/g" /etc/nginx/ilice-secure.conf

# Put your domain name into the nginx reverse proxy config.

#go!
kill $(ps aux | grep '[n]ginx' | awk '{print $2}')
cp /etc/nginx/ilice-secure.conf /etc/nginx/conf.d/ilice.conf

cat /etc/nginx/conf.d/ilice.conf
echo .
echo Firing up nginx in the background.

nginx -g 'daemon off;'
