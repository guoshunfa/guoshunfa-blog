---
title: Web组件库 iframe引入各平台视频
tags:
  - kafka
categories:
  - 技术
date: 2022-07-01 12:01:01
thumbnail:
---

## 1. 引入B站视频

### 1.1. 效果

<iframe src="//player.bilibili.com/player.html?aid=420367466&bvid=BV1N3411q7z7&cid=401728312&page=1&as_wide=1&high_quality=1&danmaku=0" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true" style="width: 100%;height: 500px;max-width: 100%;align: center;padding: 20px 0;"> </iframe>

代码：

```html
<iframe src="//player.bilibili.com/player.html?aid=420367466&bvid=BV1N3411q7z7&cid=401728312&page=1&as_wide=1&high_quality=1&danmaku=0" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true" style="width: 100%;height: 500px;max-width: 100%;align: center;padding: 20px 0;"> </iframe>
```

### 1.2. 实现

找到B站视频下方分享，将嵌入代码放入源代码中即可展示B站视频。

![image-20210905130818150](https://file.pandacode.cn//blog/202109111303699.png) 

例：

```html
<iframe src="//player.bilibili.com/player.html?aid=420367466&bvid=BV1N3411q7z7&cid=401728312&page=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>
```

<iframe src="//player.bilibili.com/player.html?aid=420367466&bvid=BV1N3411q7z7&cid=401728312&page=1" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true"> </iframe>



#### 1.2.1. 参数描述（src）

| key          | 说明                                                         |
| ------------ | ------------------------------------------------------------ |
| aid          | 之前 B 站使用的 AV 号                                        |
| bvid         | 目前的 BV 号                                                 |
| page         | 第几个视频, 起始下标为 1 (默认值也是为 1)就是 B 站视频, 选集里的, 第几个视频 |
| as_wide      | 是否宽屏 【1: 宽屏, 0: 小屏】                                |
| high_quality | 是否高清 【1: 高清(最高1080p) / 0: 最低视频质量(默认)】      |
| danmaku      | 是否开启弹幕 【1: 开启(默认), 0: 关闭】                      |

#### 1.2.2. 调整样式

```stylus
<style scoped lang='stylus'>
iframe {
  width: 100%;
  height: 500px;
  max-width: 100%;
  align: center;
  padding: 20px 0;
}
</style>
```

最终效果：

<iframe src="//player.bilibili.com/player.html?aid=420367466&bvid=BV1N3411q7z7&cid=401728312&page=1&as_wide=1&high_quality=1&danmaku=0" scrolling="no" border="0" frameborder="no" framespacing="0" allowfullscreen="true" style="width: 100%;height: 500px;max-width: 100%;align: center;padding: 20px 0;"> </iframe>

## 2. 引入腾讯视频

> 与B站视频同理，引入内嵌代码即可查看视频。

### 2.1. 效果

<iframe frameborder="0" src="https://v.qq.com/iframe/player.html?vid=v3270e4uem9" allowFullScreen="true" style="width: 100%;height: 500px;max-width: 100%;align: center;padding: 20px 0;"></iframe>

代码：

```html
<iframe frameborder="0" src="https://v.qq.com/iframe/player.html?vid=v3270e4uem9" allowFullScreen="true" style="width: 100%;height: 500px;max-width: 100%;align: center;padding: 20px 0;"></iframe>
```

### 2.2. 实现

#### 2.2.1. 参数描述

| key  | 说明       |
| ---- | ---------- |
| vid  | 视频唯一值 |

##### 2.2.1.1. 去广告

有广告：

```html
<center><iframe frameborder="0" src="https://v.qq.com/txp/iframe/player.html?vid=h30676epxvg" width="100%" height="240"></iframe></center>
```

无广告：

```html
<center><iframe frameborder="0" src="https://v.qq.com/iframe/player.html?vid=h30676epxvg" width="100%" height="240"></iframe></center>
```

地址去掉/txp，可关闭广告。
