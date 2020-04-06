#!/bin/bash
###############################
# Here You can Edit Your Data #
###############################
LOG_LOCATION=/tmp
##########################################
##############END EDIT DATA###############
##########################################
txtrst=$(tput sgr0) # Text reset
txtred=$(tput setab 1) # Red Background
textpurple=$(tput setab 5) #Purple Background
txtblue=$(tput setab 4) #Blue Background
txtgreen=$(tput bold ; tput setaf 2) # GreenBold
txtyellow=$(tput bold ; tput setaf 3) # YellowBold
arch=$(getconf LONG_BIT)
iplocal=$(ifconfig  | grep 'inet addr' | awk '{print $2}' | cut -d ':' -f2 |grep -v 127)
alias make="make -j $(nproc)"

echo "${txtblue}Preparing System, please wait ........................ ${txtrst}"
echo "${txtgreen}....................................................................${txtrst}"
apt-get update -y
apt-get install sudo -y
sudo apt-get install dialog pv cron nano aptitude mlocate -y
sleep 2
apt-get install software-properties-common python-software-properties sudo -y
sleep 2
sudo add-apt-repository main
sleep 1
sudo add-apt-repository universe
sleep 1
sudo add-apt-repository restricted
sleep 1
sudo add-apt-repository multiverse
sleep 1
sudo apt-get update
sleep 1
sudo apt-get install pv unzip cron nano curl libssl-dev build-essential libpcre3 libpcre3-dev libssl-dev debconf-utils nano subversion ant tar libfaac-dev gcc g++ cmake -y
sleep 2
sudo apt-get -qq install g++-4.4-multilib -qy
sleep 1
wget http://nginx.org/download/nginx-1.13.7.tar.gz
sleep 1
wget https://github.com/arut/nginx-rtmp-module/archive/master.zip
sleep 1
tar -zxvf nginx-1.13.7.tar.gz
#unzip nginx-1.13.7.zip
sleep 1
unzip master.zip
sleep 1
cd nginx-1.13.7
sleep 1
./configure --with-http_ssl_module --add-module=../nginx-rtmp-module-master
sleep 1
make
sleep 1
sudo make install
sleep 1
cd
sleep 1
sudo wget https://raw.github.com/JasonGiedymin/nginx-init-ubuntu/master/nginx -O /etc/init.d/nginx
sleep 1
sudo chmod +x /etc/init.d/nginx
sleep 1
sudo update-rc.d nginx defaults
sleep 1
sudo service nginx start
sleep 1
sudo service nginx stop
sleep 1
echo | add-apt-repository ppa:kirillshkrogalev/ffmpeg-next
#sudo add-apt-repository ppa:kirillshkrogalev/ffmpeg-next
sleep 1
sudo apt-get update
sleep 1
sudo apt-get install ffmpeg -y
sleep 1
cd
sleep 1
scp -r /usr/local/nginx/conf/nginx.conf /usr/local/nginx/conf/nginx.conf.bak
sleep 2
rm -r /usr/local/nginx/conf/nginx.conf
sleep 1
cat <<'EOF' >> /usr/local/nginx/conf/nginx.conf
user www-data;
worker_processes  1;
#error_log  logs/error.log;
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;
#pid        logs/nginx.pid;
events {
    worker_connections  1024;
}
rtmp {
    server {
        listen 1935;
       
            application mimusica {
            live on;
    meta off;
   
                   
                     exec_pull ffmpeg -re -i http://hlslive.lcdn.une.net.co/v1/AUTH_HLSLIVE/MMHD/tu1_1.m3u8 -threads 1 -c:v libx264 -preset superfast -profile:v baseline -b:v 800K -s 720x576 -f flv -c:a aac -ac 1 -strict -2 -b:a 128k rtmp://127.0.0.1/mimusica/$name;
        }
    }
}
EOF
sleep 1
sudo service nginx restart
sleep 2
echo "********************************************************" | pv -qL 30
echo "********************************************************" | pv -qL 30
echo "********************************************************" | pv -qL 30
end=$(date +%s)
runtime=$(python -c "print '%u:%02u' % ((${end} - ${start})/60, (${end} - ${start})%60)")
echo -e '\E[37;44m''\033[1m Total Time Runtime = '$runtime' \033[0m'  | pv -qL 30
echo "********************************************************" | pv -qL 30
echo "********************************************************" | pv -qL 30
echo "********************************************************" | pv -qL 30
echo -e '\E[37;44m''\033[1m To Test Your First Stream = 'rtmp://$iplocal:1935/mimusica/mimusica' \033[0m'  | pv -qL 30
echo "********************************************************" | pv -qL 30
echo "********************************************************" | pv -qL 30
echo "********************************************************" | pv -qL 30
echo "######################################################" | pv -qL 30
echo "${txtyellow}        xxxxxxxxxx                          ${txtrst}"                | pv -qL 30
echo "######################################################" | pv -qL 30
echo "********************************************************" | pv -qL 30
echo "********************************************************" | pv -qL 30
