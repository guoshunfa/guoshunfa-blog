---
title: Nginx 部署静态文件
tags:
    - nginx
    - 部署
categories:
    - 技术
date: 2022-07-01 12:01:01
thumbnail:
---

> 以需求为导向，进行配置。
>
> 这里已经默认安装过了Nginx。

## 1. 简单部署

```conf
server {
  listen       8991;                                                         
  server_name  127.0.0.1;     
  index index.html;
  root /Users/guoshunfa/workspace/my/git-project/panda-doc/docs/.vuepress/dist;
}
```

## 2. 绑定域名(可多个)

```shell
server {
  listen       80;                                                         
  server_name  guoshunfa.cn pandacode.cn blog.pandacode.cn;     
  index index.html;
  root /Users/guoshunfa/workspace/my/git-project/panda-doc/docs/.vuepress/dist;
}
```

## 3. 域名配置ssl

> 阿里云官方介绍[文档](https://developer.aliyun.com/article/766958)。
>
> TODO：没有进行验证

### 3.1. 准备工作

#### 3.1.1. Nginx 的 SSL 模块安装配置

查看 nginx 是否安装 http_ssl_module 模块。

```shell
/usr/local/nginx/sbin/nginx -V
```

如果出现 configure arguments: –with-http_ssl_module, 则已安装（下面的步骤可以跳过，进入 [准备SSL证书](#3.1.2. 准备SSL 证书)）。

**配置ssl模块**

```shell
# 配置ssl模块
cd nginx-1.15.9 # nginx目录
./configure --prefix=/usr/local/nginx --with-http_ssl_module
```

使用 make 命令编译（使用make install会重新安装nginx），此时当前目录会出现 objs 文件夹。

用新的 nginx 文件覆盖当前的 nginx 文件。

```shell
cp ./objs/nginx /usr/local/nginx/sbin/
```

再次查看安装的模块（configure arguments: –with-http_ssl_module说明ssl模块已安装）。

```shell
/usr/local/nginx/sbin/nginx -V
nginx version: nginx/1.15.9...configure arguments: --with-http_ssl_module
```

#### 3.1.2. 准备SSL 证书

下载申请好的 ssl 证书文件压缩包到本地并解压（这里是用的 pem 与 key 文件，文件名可以更改）。

在 nginx 目录新建 cert 文件夹存放证书文件。

```shell
cd /usr/local/nginx
mkdir cert
```

将这两个文件上传至服务器的 cert 目录里。
这里使用 mac 终端上传至服务器的 scp 命令（这里需要新开一个终端，不要使用连接服务器的窗口）:

```shell
scp /Users/yourname/Downloads/ssl.pem root@xxx.xx.xxx.xx:/usr/local/nginx/cert/
scp /Users/yourname/Downloads/ssl.key root@xxx.xx.xxx.xx:/usr/local/nginx/cert/
```

#### 3.1.3. 放行ssl默认端口

服务器放行443端口，避免拦截。

#### 4. Nginx.conf 配置

编辑 nginx.conf 配置文件：

配置 https [server](https://www.aliyun.com/minisite/goods?spm=a2c6h.12873639.0.0.c59a5caahlH2sx&userCode=veyumm2k)：

```
server {
# 服务器端口使用443，开启ssl, 这里ssl就是上面安装的ssl模块
listen       443 ssl;
# 域名，多个以空格分开
server_name  <a href="https://www.aliyun.com/minisite/goods?userCode=veyumm2k" target="_blank">hack520.com</a> <a href="https://www.aliyun.com/minisite/goods?userCode=veyumm2k" target="_blank">www.hack520.com</a>;

# ssl证书地址
ssl_certificate     /usr/local/nginx/cert/ssl.pem;  # pem文件的路径
ssl_certificate_key  /usr/local/nginx/cert/ssl.key; # key文件的路径

# ssl验证相关配置
ssl_session_timeout  5m;    #缓存有效期
ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE:ECDH:AES:HIGH:!NULL:!aNULL:!MD5:!ADH:!RC4;    #加密算法
ssl_protocols TLSv1 TLSv1.1 TLSv1.2;    #安全链接可选的加密协议
ssl_prefer_server_ciphers on;   #使用服务器端的首选算法

location / {
    root   html;
    index  index.html index.htm;
	}
}
```

将 http 重定向 https。

```
server {
  listen       80;
  server_name  <a href="https://www.aliyun.com/minisite/goods?userCode=veyumm2k" target="_blank">hack520.com</a> <a href="https://www.aliyun.com/minisite/goods?userCode=veyumm2k" target="_blank">www.hack520.com</a>;
  return 301 https://$server_name$request_uri;
}
```
