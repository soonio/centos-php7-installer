# centos8的PHP72环境构建

## 脚本测试环境

```bash
docker pull centos:8.2.2004
docker run -it --rm --name c8env -w /home centos:8.2.2004 

bash <(curl -sSL https://raw.githubusercontent.com/soonio/centos-php7-installer/master/install.sh)
```
