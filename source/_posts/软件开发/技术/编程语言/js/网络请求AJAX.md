---
title: 网络请求AJAX
tags:
  - ajax
categories:
  - 技术
date: 2022-07-01 12:01:01
thumbnail:
---

## 1. AJAX 介绍

​		Ajax即**A**synchronous **J**avascript **A**nd **X**ML（异步JavaScript和[XML](https://baike.baidu.com/item/XML/86251)）在 2005年被Jesse James Garrett提出的新术语，用来描述一种使用现有技术集合的‘新’方法，包括: [HTML](https://baike.baidu.com/item/HTML/97049) 或 [XHTML](https://baike.baidu.com/item/XHTML/316621), CSS, [JavaScript](https://baike.baidu.com/item/JavaScript/321142), [DOM](https://baike.baidu.com/item/DOM/50288), XML, [XSLT](https://baike.baidu.com/item/XSLT/1330564), 以及最重要的[XMLHttpRequest](https://baike.baidu.com/item/XMLHttpRequest/6788735)。 [3] 使用Ajax技术网页应用能够快速地将增量更新呈现在[用户界面](https://baike.baidu.com/item/用户界面/6582461)上，而不需要重载（刷新）整个页面，这使得程序能够更快地回应用户的操作。

## 2. AJAX 的实现方式介绍网络

目前前端进行网络请求有两种方式，XHR和fatch。

对XHR进行封装的组件有很多，常见的有axios，jquery。 

**备注：XHR（XMLHttpRequest）**    

（建议使用axios。）

### 2.1. 优缺点

##### **XHR**

**缺点：**

1. API用法繁琐。
2. 没有关注分离的设计思想。

##### **fetch**

**优点：**

1. 关注分离的设计思想。
2. API相对于XHR更简单。
3. fetch是浏览器原生支持的，使用fetch可以不用引用http的类库即可实现。

**缺点：**

1. 老版浏览器兼容问题。（IE系列是完全不支持的，主流浏览器的早起版本也不支持，所以如果在项目中使用需要做兼容方案处理。）

## 3. 原生JS 实现 AJAX

> 直接使用XHR(XMLHttpRequest)。

```js
var xhr = new XMLHttpRequest();
xhr.open("get",url, true);
xhr.send(null);
xhr.onreadystatechange = function(){
    if(xhr.readyState === 4){
        if(xhr.status == 200){
            alert(xhr.responseText);
        }
    }
}
```

## 4. axios 实现 AJAX

> 前往 [github](https://github.com/axios/axios) （详情请查看axios Github 项目README.md 文件。）

### 4.1. 安装

Using npm:

```
$ npm install axios
```

Using bower:

```
$ bower install axios
```

Using yarn:

```
$ yarn add axios
```

Using jsDelivr CDN:

```
<script src="https://cdn.jsdelivr.net/npm/axios/dist/axios.min.js"></script>
```

Using unpkg CDN:

```
<script src="https://unpkg.com/axios/dist/axios.min.js"></script>
```

### 4.2. API demo

```js
// Send a POST request
axios({
  method: 'post',
  url: '/user/12345',
  data: {
    firstName: 'Fred',
    lastName: 'Flintstone'
  }
});
```



```js
// GET request for remote image in node.js
axios({
  method: 'get',
  url: 'http://bit.ly/2mTM3nY',
  responseType: 'stream'
})
  .then(function (response) {
    response.data.pipe(fs.createWriteStream('ada_lovelace.jpg'))
  });
```

## 5. JQuery 实现 AJAX

```js
$.ajax({
  url: 'url',
  type: 'get',
  success: function(){
  }
})
```

## 6. Fetch 实现 AJAX

```js
try {
  const response= await fetch(url)
  const data = await response.json()
} catch (error) {
  console.log('请求出错',error);
}
```



**Fetch 更多参数:**

```js
fetch(url, {
  body: JSON.stringify(data), // must match 'Content-Type' header
  cache: 'no-cache', // *default, no-cache, reload, force-cache, only-if-cached
  credentials: 'same-origin', // include, same-origin, *omit
  headers: {
    'user-agent': 'Mozilla/4.0 MDN Example',
    'content-type': 'application/json'
  },
  method: 'POST', // *GET, POST, PUT, DELETE, etc.
  mode: 'cors', // no-cors, cors, *same-origin
  redirect: 'follow', // manual, *follow, error
  referrer: 'no-referrer', // *client, no-referrer
})
```



## 参考文档

- [XHR 和 Fetch 的使用详解和区别总结](https://blog.csdn.net/weixin_41275295/article/details/100699978)
- [百度百科](https://baike.baidu.com/item/ajax/8425)
