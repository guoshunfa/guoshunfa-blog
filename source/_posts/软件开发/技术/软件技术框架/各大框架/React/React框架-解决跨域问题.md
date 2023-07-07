---
title: React框架 - 解决跨域问题
tags:
  - React
  - 跨域
categories:
  - 软件技术框架
date: 2022-07-01 12:01:01
thumbnail:
---

## **1. 场景**

React服务的地址是`127.0.0.1:3000`，接口服务的地址是`127.0.0.1:5000`。

React服务3000直接调用接口服务5000可能会产生跨域问题。



这里有两种解决方案，一种是直接在package.json中配置，一种是使用单独的配置文件。下面会对这两种进行介绍。



## 2. 第一种：package.json 配置

> 缺点：
>
> 1. 只能配置一个服务，如有多个服务不能使用。
>
> 优点：
>
> 1. 配置简单。

**配置：**

```json
"proxy": "http://127.0.0.1:5000"
```

**访问：**

正常访问3000服务，会被转发到5000，如：`http://127.0.0.1:3000/findUsers`。

## 3. 第二种：使用 http-proxy-middleware 组件包

> 缺点：
>
> 1. 配置繁琐。
> 2. 接口调用必须加前缀，如/api1。
>
> 优点：
>
> 1. 可配置多个接口服务。

**配置：**

src文件下创建setupProxy.js文件，文件内容如下。

```js
const proxy = require('http-proxy-middleware')

module.exports = function(app){
	app.use(
		proxy('/api1',{ //遇见/api1前缀的请求，就会触发该代理配置
			target:'http://localhost:5000', //请求转发给谁
			changeOrigin:true,//控制服务器收到的请求头中Host的值
			pathRewrite:{'^/api1':''} //重写请求路径(必须)
		}),
		proxy('/api2',{
			target:'http://localhost:5001',
			changeOrigin:true,
			pathRewrite:{'^/api2':''}
		}),
	)
}
```

访问：

`http://127.0.0.1:3000/api1/findUsers`，会被转发到5001服务的`http://127.0.0.1:5001/findUsers`

