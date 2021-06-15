#!/usr/bin/env bash

# dont overide the existing config
if [ -d "/etc/nginx" ]; then
  # Take action if $DIR exists. #
  echo "Detecting existing nginx configuration ....."
  read -p "Do you want to move the existing config to /etc/nginx.old? [Y/n] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
        sudo mv /etc/nginx /etc/nginx.old
    else
        echo "Deleting existing config ..."
        sudo rm -rf /etc/nginx
    fi
fi

echo "Installing nginx ..."
sudo apt-get upgrade
sudo apt-get install nginx -y

read -p "Do you want to install certbot fo nginx? [Y/n] " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
    sudo apt-get install certbot python3-certbot-nginx -y
fi

echo "Downloading nginx.conf ..."
sudo rm /etc/nginx/nginx.conf
sudo curl -o /etc/nginx/nginx.conf https://raw.githubusercontent.com/ValentinKolb/nginx.conf/main/nginx.conf

echo "Setting up folder structure ..."
sudo mkdir /etc/nginx/conf.d/http
sudo mkdir /etc/nginx/conf.d/stream

echo "Moving default site to /etc/nginx/conf.d/http/default.conf ..."
sudo mv /etc/nginx/sites-available/default /etc/nginx/conf.d/http/default.conf

echo "Removing /etc/nginx/sites-available /etc/nginx/sites-enabled ..."
sudo rm -rf /etc/nginx/sites-available
sudo rm -rf /etc/nginx/sites-enabled

# todo further clean up

echo "... done"
