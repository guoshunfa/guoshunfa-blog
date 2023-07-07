---
title: React框架 介绍
tags:
  - React
categories:
  - 软件技术框架
date: 2022-07-01 12:01:01
thumbnail:
---

> 进入 [React官网](https://zh-hans.reactjs.org)  
>
> 尚硅谷 React教学视频：[b站](https://www.bilibili.com/video/BV1wy4y1D7JT?p=1) | [百度网盘](https://pan.baidu.com/s/1jEZvC45ZgX4N4Jc1MeFQWw) 提取码：c1ac（包含视频、源码、课件）
>
> (在网络允许的情况下，可以查看React官网进行了解React。)

## 1. 什么是React

**声明式**

React 使创建交互式 UI 变得轻而易举。为你应用的每一个状态设计简洁的视图，当数据变动时 React 能高效更新并渲染合适的组件。

以声明式编写 UI，可以让你的代码更加可靠，且方便调试。

**组件化**

构建管理自身状态的封装组件，然后对其组合以构成复杂的 UI。

由于组件逻辑使用 JavaScript 编写而非模板，因此你可以轻松地在应用中传递数据，并保持状态与 DOM 分离。

**一次学习，跨平台编写**

无论你现在使用什么技术栈，在无需重写现有代码的前提下，通过引入 React 来开发新功能。

React 还可以使用 Node 进行服务器渲染，或使用 [React Native](https://reactnative.dev/) 开发原生移动应用。

## 2. CDN 链接

>  可以通过 CDN 获得 React 和 ReactDOM 的 UMD 版本。

```html
<script crossorigin src="https://unpkg.com/react@17/umd/react.development.js"></script>
<script crossorigin src="https://unpkg.com/react-dom@17/umd/react-dom.development.js"></script>
```

上述版本仅用于开发环境，不适合用于生产环境。压缩优化后可用于生产的 React 版本可通过如下方式引用：

```html
<script crossorigin src="https://unpkg.com/react@17/umd/react.production.min.js"></script>
<script crossorigin src="https://unpkg.com/react-dom@17/umd/react-dom.production.min.js"></script>
```

如果需要加载指定版本的 `react` 和 `react-dom`，可以把 `17` 替换成所需加载的版本号。



babel:

```html
<script src="https://unpkg.com/babel-standalone@6/babel.min.js"></script>
```

## 参考资料

- [尚硅谷](http://www.atguigu.com)
- [React 官方文档](https://zh-hans.reactjs.org)



