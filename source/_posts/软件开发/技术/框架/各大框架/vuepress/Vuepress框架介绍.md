---
title: Vuepress框架 介绍
tags:
  - kafka
categories:
  - 技术
date: 2022-07-01 12:01:01
thumbnail:
---

> [vuepress](https://vuepress.vuejs.org/zh/) | [vuepress-theme-vdoing](https://doc.xugaoyi.com/) | [vuepress-theme-reco 主题](https://vuepress-theme-reco.recoluan.com/)

## 介绍

VuePress 由两部分组成：第一部分是一个[极简静态网站生成器 (opens new window)](https://github.com/vuejs/vuepress/tree/master/packages/%40vuepress/core)，它包含由 Vue 驱动的[主题系统](https://vuepress.vuejs.org/zh/theme/)和[插件 API](https://vuepress.vuejs.org/zh/plugin/)，另一个部分是为书写技术文档而优化的[默认主题](https://vuepress.vuejs.org/zh/theme/default-theme-config.html)，它的诞生初衷是为了支持 Vue 及其子项目的文档需求。

每一个由 VuePress 生成的页面都带有预渲染好的 HTML，也因此具有非常好的加载性能和搜索引擎优化（SEO）。同时，一旦页面被加载，Vue 将接管这些静态内容，并将其转换成一个完整的单页应用（SPA），其他的页面则会只在用户浏览到的时候才按需加载。

## 它是如何工作的？

事实上，一个 VuePress 网站是一个由 [Vue (opens new window)](http://vuejs.org/)、[Vue Router (opens new window)](https://github.com/vuejs/vue-router)和 [webpack (opens new window)](http://webpack.js.org/)驱动的单页应用。如果你以前使用过 Vue 的话，当你在开发一个自定义主题的时候，你会感受到非常熟悉的开发体验，你甚至可以使用 Vue DevTools 去调试你的自定义主题。

在构建时，我们会为应用创建一个服务端渲染（SSR）的版本，然后通过虚拟访问每一条路径来渲染对应的HTML。这种做法的灵感来源于 [Nuxt (opens new window)](https://nuxtjs.org/)的 `nuxt generate` 命令，以及其他的一些项目，比如 [Gatsby (opens new window)](https://www.gatsbyjs.org/)。

## 2. 插件包收藏

- [vuepress-plugin-mermaidjs](https://mermaid-js.github.io/mermaid/#/README) 流程图、时序图、类图、状态图 ......
- [vuepress-plugin-baidu-autopush](https://github.com/IOriens/vuepress-plugin-baidu-autopush) 百度推送
- [vuepress-plugin-thirdparty-search](https://www.npmjs.com/package/vuepress-plugin-thirdparty-search) 第三方搜索链接
- [vuepress-plugin-one-click-copy](https://github.com/vxhly/vuepress-plugin-one-click-copy) 代码块复制按钮
- [vuepress-plugin-zooming](https://vuepress-community.netlify.app/zh/plugins/zooming/#%E5%AE%89%E8%A3%85) 放大图片
- vuepress-plugin-comment Valine方式加入评论 | [Valine-Admin](https://github.com/zhaojun1998/Valine-Admin) 加入邮箱通知
- [vuepress-plugin-element-ui](https://www.npmjs.com/package/vuepress-plugin-element-ui/)Element UI
- [站点信息模块](https://notes.youngkbt.cn/about/website/info/)
- [私密文章功能](https://notes.youngkbt.cn/about/website/private/)
- [首页大图模块](https://notes.youngkbt.cn/about/website/index-big-img/)

## 3. 其他

[GitHub Actions 定时运行代码：每天定时百度链接推送](https://xugaoyi.com/pages/f44d2f9ad04ab8d3/)

