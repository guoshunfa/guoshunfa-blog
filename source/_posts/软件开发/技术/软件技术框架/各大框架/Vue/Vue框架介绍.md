---
title: Vue框架 介绍
tags:
    - Vue
categories:
    - 软件技术框架
date: 2022-07-01 12:01:01
thumbnail:
---


> 介绍内容包含：Vue.js是什么、Vue项目搭建。

[Vue 官方文档](https://cn.vuejs.org/) 

## 1. [Vue.js 是什么](https://cn.vuejs.org/v2/guide/#Vue-js-是什么)

​		Vue (读音 /vjuː/，类似于 **view**) 是一套用于构建用户界面的**渐进式框架**。与其它大型框架不同的是，Vue 被设计为可以自底向上逐层应用。Vue 的核心库只关注视图层，不仅易于上手，还便于与第三方库或既有项目整合。另一方面，当与[现代化的工具链](https://cn.vuejs.org/v2/guide/single-file-components.html)以及各种[支持类库](https://github.com/vuejs/awesome-vue#libraries--plugins)结合使用时，Vue 也完全能够为复杂的单页应用提供驱动。

## 2. Vue项目搭建

### 2.1. 什么是vue-cli

Vue CLI 是一个基于 Vue.js 进行快速开发的完整系统，提供：

1. 通过 @vue/cli 实现的交互式的项目脚手架。
2. 通过 @vue/cli + @vue/cli-service-global 实现的零配置原型开发。
3. 一个运行时依赖 (@vue/cli-service)，这个依赖：
   （1）可升级；
   （2）基于 webpack 构建，并带有合理的默认配置；
   （3）可以通过项目内的配置文件进行配置；
   （4）可以通过插件进行扩展。
4. 一个丰富的官方插件集合，集成了前端生态中最好的工具。
5. 一套完全图形化的创建和管理 Vue.js 项目的用户界面。

### 2.2. 快速创建项目

（1）如果你还没有安装 VueCLI，请执行下面的命令安装或是升级：

```powershell
npm install --global @vue/cli
```

（2）在命令行中输入以下命令创建 Vue 项目：

```powershell
vue create 项目名
```

### 2.3. 图形化界面创建

通过 `vue ui` 命令以图形化界面创建和管理项目

```powershell
vue ui
```