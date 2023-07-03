---
title: Vuepress框架 插件包收藏
tags:
  - kafka
categories:
  - 技术
date: 2022-07-01 12:01:01
thumbnail:
---

## 一、插件包收藏

- [vuepress-plugin-mermaidjs](https://mermaid-js.github.io/mermaid/#/README) 流程图、时序图、类图、状态图 ......
- [vuepress-plugin-baidu-autopush](https://github.com/IOriens/vuepress-plugin-baidu-autopush) 百度推送
- [vuepress-plugin-thirdparty-search](https://www.npmjs.com/package/vuepress-plugin-thirdparty-search) 第三方搜索链接
- [vuepress-plugin-one-click-copy](https://github.com/vxhly/vuepress-plugin-one-click-copy) 代码块复制按钮
- [vuepress-plugin-zooming](https://vuepress-community.netlify.app/zh/plugins/zooming/#%E5%AE%89%E8%A3%85) 放大图片
- vuepress-plugin-comment Valine方式加入评论 | [Valine-Admin](https://github.com/zhaojun1998/Valine-Admin) 加入邮箱通知
- [vuepress-plugin-element-ui](https://www.npmjs.com/package/vuepress-plugin-element-ui/) Element UI
- [站点信息模块](https://notes.youngkbt.cn/about/website/info/)
- [私密文章功能](https://notes.youngkbt.cn/about/website/private/)
- [首页大图模块](https://notes.youngkbt.cn/about/website/index-big-img/)

## 二、各插件包使用说明

### 2.1. vuepress-plugin-comment 平台评论

先放官网链接：https://github.com/dongyuanxin/vuepress-plugin-comment

#### Features

- Support Gitalk, Valine
- Dynamic Import
- Response router change and refresh automatic
- User can use passage's `$frontmatter`

#### Usage

##### Install

With `npm`:

```
npm install --save vuepress-plugin-comment
```

With `yarn`:

```
yarn add vuepress-plugin-comment -D
```

With `cnpm`:

```
cnpm i --save vuepress-plugin-comment
```

##### ⚠️Route object properties

**Don't use `window` object directly to get route information**.

Plugin has registered correct route information in `frontmatter.to` object and `frontmatter.from` object. Their properties are the same as [vue-router's route object](https://router.vuejs.org/api/#route-object-properties).

##### Use in Gitalk

The `options` is exactly the same as `Gitalk` configuration.

```
module.exports = {
  plugins: [
    [
      'vuepress-plugin-comment',
      {
        choosen: 'gitalk', 
        options: {
          clientID: 'GitHub Application Client ID',
          clientSecret: 'GitHub Application Client Secret',
          repo: 'GitHub repo',
          owner: 'GitHub repo owner',
          admin: ['GitHub repo owner and collaborators, only these guys can initialize github issues'],
          distractionFreeMode: false 
        }
      }
    ]
  ]
}
```

If you want to access variables, such as `$frontmatter` and `window`, please use **EJS** syntax.

```
module.exports = {
  plugins: [
    [
      'vuepress-plugin-comment',
      {
        choosen: 'gitalk', 
        options: {
          id: '<%- frontmatter.commentid || frontmatter.permalink %>',
          title: '「Comment」<%- frontmatter.title %>',
          body: '<%- frontmatter.title %>：<%-window.location.origin %><%- frontmatter.to.path || window.location.pathname %>',
          clientID: 'GitHub Application Client ID',
          clientSecret: 'GitHub Application Client Secret',
          repo: 'GitHub repo',
          owner: 'GitHub repo owner',
          admin: ['GitHub repo owner and collaborators, only these guys can initialize github issues'],
          distractionFreeMode: false,
        }
      }
    ]
  ]
}
```

**Note**: Never use callback function in plugin configuration, that will be filtered by vuepress. So I have to support EJS syntax.

##### Use in Valine

> https://github.com/DesertsP/Valine-Admin

The `options` is exactly the same as `Valine` configuration.

```
module.exports = {
  plugins: [
    [
      'vuepress-plugin-comment',
      {
        choosen: 'valine', 
        options: {
          el: '#valine-vuepress-comment',
          appId: 'Your own appId',
          appKey: 'Your own appKey'
        }
      }
    ]
  ]
}
```

If you want to access variables, such as `$frontmatter` and `window`, please use **EJS** syntax.

```
module.exports = {
  plugins: [
    [
      'vuepress-plugin-comment',
      {
        choosen: 'valine', 
        options: {
          el: '#valine-vuepress-comment',
          appId: 'Your own appId',
          appKey: 'Your own appKey',
          path: '<%- frontmatter.commentid || frontmatter.permalink %>'
        }
      }
    ]
  ]
}
```

##### How to hide page comment

If you want to hide comment plugin in specified page, set `$frontmatter.comment` or `$frontmatter.comments` to `false`.

For example:

```
---
comment: false 
# comments: false 
---
```

Comment won't appear in the page of this passage.

#### Options Detail

- **choosen** `string`

  **Required**.

- **options** `object`

  **Required**. The options of choosen comment plugin.

- **container** `string`

  **Optional, default as `'main.page'`**. The dom selector that contains choosen comment plugin.
