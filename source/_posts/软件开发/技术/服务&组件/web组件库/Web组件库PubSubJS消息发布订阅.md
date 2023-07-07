---
title: Web组件库 PubSubJS 消息发布订阅
tags:
  - PubSubJS
  -	HTML/CSS/JavaScript
categories:
  - 服务&组件
date: 2022-07-01 12:01:01
thumbnail:
---

> 前往 [Github](https://github.com/mroderick/PubSubJS)

### 1. PubSubJS 介绍

PubSubJS是一个[用](http://en.wikipedia.org/wiki/Publish–subscribe_pattern#Message_filtering)JavaScript编写的[基于主题](http://en.wikipedia.org/wiki/Publish–subscribe_pattern#Message_filtering)的[发布/订阅](http://en.wikipedia.org/wiki/Publish/subscribe)库。

PubSubJS具有同步解耦，因此主题是异步发布的。这有助于保持程序的可预测性，因为在消费者处理主题时，主题的发起者不会被阻止。

对于冒险家来说，PubSubJS还支持同步主题发布。这可能会在某些环境中（浏览器，不是所有环境）加快速度，但也可能导致一些非常难以推理的程序，即一个主题触发同一执行链中另一个主题的发布。

#### 单一流程

PubSubJS旨在用于**单个进程**，不是多进程应用程序（如[Node.js – ](http://nodejs.org/api/cluster.html)具有许多子进程的[集群](http://nodejs.org/api/cluster.html)）的好候选程序。如果您的Node.js应用程序是一个单一的进程应用程序，那么您就很好。如果它是（或将要）一个多进程应用程序，您可能最好使用[redis Pub/Sub](http://redis.io/topics/pubsub)或类似

#### 主要功能

- 无依赖项
- 同步解耦
- ES3兼容。PubSubJS应该能够在可以执行JavaScript的任何地方运行。浏览器、服务器、电子书阅读器、旧手机、游戏机。
- AMD/CommonJS模块支持
- 不修改订阅者（jQuery自定义事件修改订阅者）
- 易于理解和使用（感谢同步解耦）
- 小（略号），小于1kb的缩小和gzipped

## 2. 安装}}

有几种方法可以获取PubSubJS

- 通过npm安装（`npm install pubsub-js`）
  - 通过yarn安装（`yarn add pubsub-js`）

- 直接从CDN使用
  - http://www.jsdelivr.com/#!pubsubjs
  - https://cdnjs.com/libraries/pubsub-js
  - https://unpkg.com/pubsub-js
- 从GitHub[下载标记版本](https://github.com/mroderick/PubSubJS/tags)

## 3. 导入

```
import PubSub from 'pubsub-js'

// or when using CommonJS
const PubSub = require('pubsub-js');
```

## 4. API 使用

### 4.1. 基本示例

```js
//创建一个订阅主题的函数
var mySubscriber = (msg,data)=>{console.log(msg,data)}

// 将该功能添加到特定主题的订阅者列表中
// 我们保留了返回的令牌，以便能够取消订阅
// 从后面的主题开始
var token = PubSub.subscribe('MY TOPIC', mySubscriber);

//异步发布主题
PubSub.publish("MY TOPIC", "你好，世界！");

//同步发布主题，这在某些环境中更快，
// 但当一个主题触发了
// 相同的执行链
// 小心使用，这是龙！！！
PubSub.publishSync("MY TOPIC","你好，世界！");
```

### 4.2. 取消特定订阅

```js
//创建一个函数来接收主题
var mySubscriber = (msg,data)=>{console.log(msg,data)}

//将该函数添加到特定主题的订阅者列表中
// 我们保留了返回的令牌，以便能够取消订阅
// 从后面的主题开始
var token = PubSub.subscribe('MY TOPIC', mySubscriber);

//取消订阅此订阅者此主题
PubSub.unsubscribe(token);
```

### 4.3. 取消功能的所有订阅

```js
//创建一个函数来接收主题
var mySubscriber = (msg,data)=>{console.log(msg,data)}

//取消订阅mySubscriber的所有主题
PubSub.unsubscribe(mySubscriber);
```

### 4.4. 清除主题的所有订阅

```js
PubSub.subscribe('a', myFunc1);
PubSub.subscribe('a.b', myFunc2);
PubSub.subscribe('a.b.c', myFunc3);

PubSub.unsubscribe('a.b');
// 没有关于“a.b”和“a.b.c”主题的进一步通知
//“a”的通知仍将发布
```

### 4.5. 清除所有订阅

```js
PubSub.clearAllSubscriptions();
// 所有订阅均已删除
```

### 4.6. 获取订阅

```js
PubSub.getSubscriptions('token');
// 按代币从所有主题订阅
```

### 4.7. 计数订阅

```js
PubSub.countSubscriptions('token');
// 按所有主题的令牌计数
```

### 4.8. 错误处理

```js
// isPublished是一个布尔值，表示是否有订阅者注册了此主题
var isPublished = PubSub.publish('a');

// 如果出现问题，且订阅者未注册，令牌将是假的
var token = PubSub.subscribe('MY TOPIC', mySubscriber); 
```

### 4.9. 分层寻址

```js
//创建一个订阅者，从主题层次结构中接收所有主题
var myToplevelSubscriber = 函数（msg，数据）{
    console.log（'顶层：'，msg，数据）；
}

//订阅“汽车”层次结构中的所有主题
PubSub.subscribe（“car”，myToplevelSubscriber）；

//创建一个订阅者，仅接收来自层次结构操作主题的叶子主题
var mySpecificSubscriber = function（msg，数据）{
    console.log('specific: ', msg, data);
}

// 仅订阅“car.drive”主题
PubSub.subscribe('car.drive', mySpecificSubscriber);

// 发布一些主题
PubSub.publish('car.purchase', {name: '我的新车'});
PubSub.publish('car.drive', {speed: '14'});
PubSub.publish('car.sell', {newOwner: '其他人'});

// 在这种情况下，将调用myToplevelSubscriber for all
//主题，总共三次
// 但是，mySpecificSubscriber只会被调用一次，因为它只
//订阅“car.drive”主题
```

## 5. 提示

对主题使用“常量”，而不是字符串文本。PubSubJS使用字符串作为主题，并将很高兴尝试将您的主题与任何主题一起交付。因此，当您进行错别字时，让JavaScript引擎抱怨，从而避免沮丧的调试。

### 5.1. 使用“常量”的示例

```js
// 👎 坏的使用
PubSub.subscribe('hello', function (msg, data) {
	console.log(data)
});

PubSub.publish('hello', 'world');

// 👍 就得这么用
var MY_TOPIC = 'hello';
PubSub.subscribe(MY_TOPIC, function (msg, data) {
	console.log(data)
});

PubSub.publish(MY_TOPIC, 'world');
```

### 5.2. 使用ES6/7语法的“符号常数”示例

```js
// event-types.js
export const MY_TOPIC = Symbol('MY_TOPIC')

// somefile.js
import { MY_TOPIC } from './event-types.js'
PubSub.subscribe(MY_TOPIC, function (msg, data) {
	console.log(data)
});

PubSub.publish(MY_TOPIC, 'world');
```

### 5.3. 开发者工具中堆栈跟踪的即时例外

从1.3.2版本开始，您可以强制立即异常（而不是延迟异常），这的好处是在开发工具中查看时保持堆栈跟踪。

这应该被视为仅开发选项，因为PubSubJS旨在尝试将您的主题交付给所有订阅者，即使有些订阅者失败。

在开发中设置即时异常很容易，只需在加载后告诉PubSubJS。

```js
PubSub.immediateExceptions = true;
```

## 6. 替代方案

这些是几个替代项目，也在JavaScript中实现基于主题的发布订阅。

- http://www.joezimjs.com/projects/publish-subscribe-jquery-plugin/
- http://amplifyjs.com/api/pubsub/
- [http://radio.uxder.com/ ](http://radio.uxder.com/)— 面向“渠道”，没有依赖性
- [https://github.com/pmelander/Subtopic ](https://github.com/pmelander/Subtopic)- 支持香草、下划线、jQuery，甚至可以在NuGet中提供

## 参考文档

- [PubSubJS github readme文档直译](https://github.com/mroderick/PubSubJS)
