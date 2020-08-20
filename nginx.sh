# 安装nginx
yum update -y
yum install yum-utils -y
## 定义nginx配置
nginx_repo="
[nginx-stable]
name=nginx stable repo
baseurl=http://nginx.org/packages/centos/\$releasever/\$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true

[nginx-mainline]
name=nginx mainline repo
baseurl=http://nginx.org/packages/mainline/centos/\$releasever/\$basearch/
gpgcheck=1
enabled=0
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true
"
## 把源配置到系统中、配置、安装
echo "$nginx_repo" > /etc/yum.repos.d/nginx.repo
yum-config-manager --enable nginx-mainline -y
yum install nginx -y
## 设置nginx开机启动
systemctl enable nginx.service

## 启动nginx
systemctl start nginx

echo -e "\033[32m😂 mission completed.\033[0m"
