---
title: Vuepress框架 问题记录
tags:
  - vuepress
categories:
  - 技术
date: 2022-07-01 12:01:01
thumbnail:
---

## 1. [正确解决VuePress本地访问出现资源报错404的问题](https://blog.csdn.net/zpfz756/article/details/110458257)

**背景**

最近发现好多小伙伴刚用VuePress，然后一build完就直接用本地浏览器访问，结果出现黑块。仅仅出现那种问题还好，给项目安装 vuepress-plugin-serve 插件就行了，
但是如果有需求是需要离线查看 VuePress 生成后的文档呢？所以我特地研究了一下——

**解决办法**

打开 .vuepress/config.js 文件，把 base 的值改成 ./，为了方便调试，最好这样写：

```js
//base: "/",
base: "./",
```

写两个，一个用于Dev，一个用于Build。
然后打开项目下的 node_modules\@vuepress\core\lib\client 下的 app.js 文件，找到下方这个片段：

```js
 const router = new Router({
  base: routerBase,
  mode: 'history',
  fallback: false,
  routes,
  scrollBehavior (to, from, savedPosition) {
    if (savedPosition) {
      return savedPosition
    } else if (to.hash) {
      if (Vue.$vuepress.$get('disableScrollBehavior')) {
        return false
      }
      return {
        selector: decodeURIComponent(to.hash)
      }
    } else {
      return { x: 0, y: 0 }
    }
  }
})
```

把 mode: 'history', 注释掉就行了（让它默认为 hash 模式）。
