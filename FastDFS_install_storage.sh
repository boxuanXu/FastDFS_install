#!/bin/bash
#__website__     = "www.seetatech.com"
#__author__      = "seetatech"
#__editor__      = "xuboxuan"
#__Date__        = "20170908"



s_pwd=$PWD

#begin install common
if [ ! -s "/usr/lib64/libfastcommon.so" ];then
   echo "Begin install common file"
   if [ ! -d "libfastcommon" ];then
      echo "Begin download libfastcommon"
      git clone https://github.com/happyfish100/libfastcommon.git
      cd libfastcommon
   else
      echo "Don't need to download libfastcommon"
      cd libfastcommon
   fi
   chmod +x make.sh
   ./make.sh
    ./make.sh install
else
   echo "fastcommon has been installed"
fi


if [ -s "/usr/lib64/libfastcommon.so" ];then
   echo "common file install success"
else
   echo "common file install failed"
   exit 1
fi

cd $s_pwd

#begin install fastdfs-pro


if [ ! -s "/usr/local/fastdfs-pro/bin/fdfs_test" ];then
   echo "Begin install fastdfs"
   if [ ! -d "fastdfs-pro" ];then
      echo "Begin download fastdfs:"
      #git clone https://github.com/happyfish100/fastdfs.git
      #git clone git@47.92.110.187:shenyizhong/fastdfs-pro.git
      wget -c ftp://192.168.1.244/pub/fastdfs-pro.tar.gz
      tar xzvf fastdfs-pro.tar.gz
      cd fastdfs-pro
      git checkout dev 
   else
      echo "Don't need to download fastdfs"
      cd fastdfs-pro
   fi
   chmod +x make.sh
   ./make.sh
    ./make.sh install

    #echo \#\!/bin/sh >> /etc/profile.d/fastdfs-pro.sh
    #echo "export FASTDFS_PRO_HOME=/usr/local/fastdfs-pro" >> /etc/profile.d/fastdfs-pro.sh
    #echo "export PATH=\$PATH:\$FASTDFS_PRO_HOME/bin" >> /etc/profile.d/fastdfs-pro.sh
    #echo "export C_INCLUDE_PATH=\$C_INCLUDE_PATH:\$FASTDFS_PRO_HOME/include" >> /etc/profile.d/fastdfs-pro.sh
    #echo "export CPLUS_INCLUDE_PATH=\$CPLUS_INCLUDE_PATH:\$FASTDFS_PRO_HOME/include" >> /etc/profile.d/fastdfs-pro.sh
    #source /etc/profile
    #rm -rf /usr/lib64/libfdfsclient.so /usr/lib/libfdfsclient.so
    #ln -s /usr/local/fastdfs-pro/lib64/libfdfsclient.so /usr/lib64/libfdfsclient.so
    #ln -s /usr/local/fastdfs-pro/lib64/libfdfsclient.so /usr/lib/libfdfsclient.so 
   #copy configure file to etc dir
    cp conf/http.conf conf/mime.types /etc/fdfs
   

   echo "Begin edit configure file"

   echo "finish edit configure file"

else
   echo "fastdfs has been installed"
fi

if [ -s "/usr/bin/fdfs_test" ];then
   echo "fastdfs install success!!!"
else
   echo "fastdfs install failed"
   exit 1
fi

cd $s_pwd

cp change_storage_conf.sh /etc/fdfs/

#install fastdfs-nginx-model
if [ ! -d "fastdfs-nginx-module" ];then
   echo "Begin download fastdfs-nginx-module:"
   git clone https://github.com/happyfish100/fastdfs-nginx-module
   cd fastdfs-nginx-module/src 
else
   echo "Don't need to download fastdfs-nginx-module"
   cd fastdfs-nginx-module/src
fi

cp mod_fastdfs.conf /etc/fdfs



 ln -s /data/fastdfs/storage/data/ /data/fastdfs/storage/data/M00

echo "FastDFS install success;"

cd $s_pwd
#download nginx-1.8.1

if [ ! -s "nginx-1.8.1.tar.gz" ];then
   echo "Begin download nginx-1.8.1.tar.gz:"
   wget -c -r http://nginx.org/download/nginx-1.8.1.tar.gz
    tar -xvf nginx.org/download/nginx-1.8.1.tar.gz -C /usr/local 
else
   echo "Don't need to download nginx-1.8.1.tar.gz"
    tar -xvf nginx-1.8.1.tar.gz -C /usr/local
fi



echo "nginx down success;"


unzip pcre-8.41.zip
 cp -r pcre-8.41 /usr/local/pcre-8.41


tar zxvf openssl-1.0.2l.tar.gz
 cp  -r    openssl-1.0.2l  /usr/local/openssl-1.0.2l

tar zxvf zlib-1.2.11.tar.gz
 cp  -r    zlib-1.2.11   /usr/local/zlib-1.2.11

cd /usr/local/pcre-8.41/
 ./configure
 make
 make install

cd /usr/local/openssl-1.0.2l/
 ./config
 make
 make install

cd /usr/local/zlib-1.2.11/
 ./configure
 make
 make install

if [ ! -d "/usr/local/nginx" ];then
   cd /usr/local/nginx-1.8.1/
    ./configure --sbin-path=/usr/local/nginx/nginx --conf-path=/usr/local/nginx/nginx.conf --pid-path=/usr/local/nginx/nginx.pid --with-http_ssl_module --with-openssl=../openssl-1.0.2l --with-pcre=../pcre-8.41 --with-zlib=../zlib-1.2.11 --add-module=$s_pwd/fastdfs-nginx-module/src
    make
    make install

    cp $s_pwd/nginx.conf /usr/local/nginx/
   
else
   echo "nginx has been installed"
fi

if [ -s "/usr/local/nginx" ];then
   echo "nginx install success!!!"
else
   echo "nginx install failed"
   exit 1
fi
	



