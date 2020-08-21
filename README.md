# centos8的PHP72环境构建

## docker环境测试脚本可用性

```bash
docker pull centos:8.2.2004
docker run -it --rm --name c8env -w /home centos:8.2.2004
```

## 一键安装

```bash
# 安装PHP
curl -SL https://raw.githubusercontent.com/soonio/centos-php7-installer/master/php.sh -o php.sh \
    && chmod +x php.sh \
    && ./php.sh \
    && source /etc/profile

# 安装nginx
curl -SL https://raw.githubusercontent.com/soonio/centos-php7-installer/master/nginx.sh -o nginx.sh \
    && chmod +x nginx.sh \
    && ./nginx.sh
```


