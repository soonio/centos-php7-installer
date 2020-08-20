# 安装PHP
## PHP版本
PHP_VERSION=7.2.33

## swoole版本
SWOOLE_VERSION=4.5.2

WORK_DIR="/home/tmp"

# 创建工作目录
mkdir -p ${WORK_DIR}

# 定义PHP的安装目录、PHP的配置目录
PHP_INSTALL_RID=/usr/local/php72
PHP_INI_DIR=/usr/local/etc/php

# 安装依赖
yum update -y \
&& yum install -y \
  gcc \
  autoconf \
  pcre pcre-devel \
  zlib zlib-devel \
  libxml2 libxml2-devel \
  openssl openssl-devel \
  libcurl libcurl-devel \
  libjpeg libjpeg-devel \
  libpng libpng-devel \
  freetype freetype-devel \
  libmcrypt libmcrypt-devel

# 官网源太慢了，换用sohu源
# curl -SL "https://www.php.net/distributions/php-7.2.33.tar.gz" -o php72.tar.gz
cd ${WORK_DIR} \
&& curl -SL "http://mirrors.sohu.com/php/php-${PHP_VERSION}.tar.gz"  -o php72.tar.gz \
&& mkdir -p php72 \
&& tar -xf ${WORK_DIR}/php72.tar.gz -C php72 --strip-components=1 \
&& ( \
  cd php72 \
  && mkdir -p "${PHP_INI_DIR}/conf.d" \
  && ./configure \
    --prefix=${PHP_INSTALL_RID} \
    --with-config-file-path="${PHP_INI_DIR}" \
    --with-config-file-scan-dir="${PHP_INI_DIR}/conf.d" \
    --with-mysqli \
    --with-pdo-mysql \
    --with-jpeg-dir \
    --with-png-dir \
    --with-iconv-dir \
    --with-freetype-dir \
    --with-zlib \
    --with-libxml-dir \
    --with-gd \
    --with-openssl \
    --with-mhash \
    --with-curl \
    --with-fpm-user=nobody \
    --with-fpm-group=nobody \
    --enable-bcmath \
    --enable-soap \
    --enable-zip \
    --enable-fpm \
    --enable-mbstring \
    --enable-sockets \
    --enable-opcache \
    --enable-pcntl \
    --enable-simplexml \
    --enable-xml \
    --disable-fileinfo \
    --disable-rpath \
  && make -s -j$(nproc) \
  && make install \
  && /bin/cp -rf php.ini-production ${PHP_INI_DIR}/php.ini
)

# 把PHP加入环境变量
echo "PATH=\$PATH:/usr/local/php72/bin" > /etc/profile.d/php.sh
echo "export PATH" >> /etc/profile.d/php.sh
source /etc/profile

# 打印PHP版本
php -v
php -m

## 安装swoole
yum install -y glibc-headers gcc-c++
cd ${WORK_DIR} \
&& curl -SL "https://github.com/swoole/swoole-src/archive/v${SWOOLE_VERSION}.tar.gz" -o swoole.tar.gz \
&& mkdir -p swoole \
&& tar -xf swoole.tar.gz -C swoole --strip-components=1 \
&& ( \
    cd swoole \
    && phpize \
    && ./configure --enable-mysqlnd --enable-openssl --enable-http2 \
    && make -s -j$(nproc) \
    && make install \
) \
&& echo "extension=swoole.so" > ${PHP_INI_DIR}/conf.d/50_swoole.ini \
&& php --ri swoole

## 安装memcache
cd ${WORK_DIR} \
&& curl -SL https://github.com/websupport-sk/pecl-memcache/archive/4.0.4.tar.gz -o memcache.tar.gz \
&& mkdir -p memcache \
&& tar -xf memcache.tar.gz -C memcache --strip-components=1 \
&& ( \
    cd memcache \
    && phpize \
    && ./configure --disable-memcache-session \
    && make -s -j$(nproc) \
    && make install \
) \
&& echo "extension=memcache.so" > ${PHP_INI_DIR}/conf.d/50_memcache.ini \
&& php --ri memcache

## 安装memcached
dnf config-manager --set-enabled PowerTools
yum install -y libmemcached libmemcached-devel

cd ${WORK_DIR} \
&& curl -SL https://github.com/php-memcached-dev/php-memcached/archive/v3.1.5.tar.gz -o memcached.tar.gz \
&& mkdir -p memcached \
&& tar -xf memcached.tar.gz -C memcached --strip-components=1 \
&& ( \
    cd memcached \
    && phpize \
    && ./configure \
    && make -s -j$(nproc) \
    && make install \
) \
&& echo "extension=memcached.so" > ${PHP_INI_DIR}/conf.d/50_memcached.ini \
&& php --ri memcached

# 安装amqp依赖、amqp
cd ${WORK_DIR} \
&& curl -SL https://github.com/alanxz/rabbitmq-c/releases/download/v0.8.0/rabbitmq-c-0.8.0.tar.gz -o rabbitmq-c.tar.gz \
&& mkdir -p rabbitmq-c \
&& tar -xf rabbitmq-c.tar.gz -C rabbitmq-c --strip-components=1 \
&& ( \
    cd rabbitmq-c \
    && ./configure --prefix=/usr/local/rabbitmq-c \
    && make -s -j$(nproc) \
    && make install \
) \
&& cd ${WORK_DIR} \
&& curl -SL https://github.com/php-amqp/php-amqp/archive/v1.10.2.tar.gz -o rabbitmq.tar.gz \
&& mkdir -p rabbitmq \
&& tar -xf rabbitmq.tar.gz -C rabbitmq --strip-components=1 \
&& ( \
    cd rabbitmq \
    && phpize \
    && ./configure --with-librabbitmq-dir=/usr/local/rabbitmq-c \
    && make -s -j$(nproc) \
    && make install \
) \
&& echo "extension=amqp.so" > ${PHP_INI_DIR}/conf.d/50_amqp.ini \
&& php --ri amqp

cd ${WORK_DIR} \
&& curl -SL https://github.com/phpredis/phpredis/archive/5.3.1.tar.gz -o redis.tar.gz \
&& mkdir -p redis \
&& tar -xf redis.tar.gz -C redis --strip-components=1 \
&& ( \
    cd redis \
    && phpize \
    && ./configure \
    && make -s -j$(nproc) \
    && make install \
) \
&& echo "extension=redis.so" > ${PHP_INI_DIR}/conf.d/50_redis.ini \
&& php --ri redis

echo "\033[32m😂 mission completed.\033[0m"
