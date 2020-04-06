Bash:
#!/bin/bash
# chmod +x nginx_rtmp.sh && ./nginx_rtmp.sh

echo "Installing NGINX+RTMP+MPEGTS"

apt-get update -qq
apt-get -y install libpcre3 libpcre3-dev libssl-dev php-fpm

# make folders
mkdir -p /opt/nginx/
mkdir -p /opt/nginx/nginx-mpegts
cd /opt/nginx/

# download / extract nginxnginx
wget http://nginx.org/download/nginx-1.15.8.tar.gz
tar -zxvf nginx-1.15.8.tar.gz

# download / extract nginx rtmp addon
wget https://github.com/sergey-dryabzhinsky/nginx-rtmp-module/archive/dev.zip
unzip dev.zip

# download nginx mpegts addon
cd nginx-mpegts
git clone https://github.com/arut/nginx-ts-module.git .
cd ../

cd nginx-1.15.8

./configure --with-http_ssl_module --add-module=../nginx-rtmp-module-dev --add-module=/opt/nginx/nginx-mpegts
make
make install

mkdir -p /var/media/
mkdir -p /var/log/nginx/
touch /var/log/nginx/error.log

touch /usr/local/nginx/logs/nginx.pid

sed -i 's/\/run\/php\/php7.2-fpm.sock/127.0.0.1:9000/' /etc/php/7.2/fpm/pool.d/www.conf
systemctl restart php7.2-fpm.service
