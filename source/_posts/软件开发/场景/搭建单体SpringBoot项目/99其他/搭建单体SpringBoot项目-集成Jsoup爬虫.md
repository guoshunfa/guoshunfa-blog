---
title: 搭建单体SpringBoot项目 集成Jsoup爬虫
tags:
    - SpringBoot
    - 集成
    - Jsoup
    - 爬虫
categories:
    - 技术
    - 搭建单体SpringBoot项目
date: 2022-07-01 12:01:01
thumbnail:
---

## 1. maven

```xml
        <dependency>
            <groupId>org.jsoup</groupId>
            <artifactId>jsoup</artifactId>
            <version>1.13.1</version>
        </dependency>
```

## 2. demo

```java
    public static void main(String[] args) throws IOException {
        String url = "https://www.baidu.com/s?wd=a&rsv_spt=1&rsv_iqid=0xf26984b00030eeb8&issp=1&f=8&rsv_bp=1&rsv_idx=2&ie=utf-8&tn=baiduhome_pg&rsv_enter=1&rsv_dl=tb&rsv_sug3=1&rsv_sug1=1&rsv_sug7=100&rsv_sug2=0&rsv_btype=i&inputT=995&rsv_sug4=995";

        Document document = Jsoup.parse(new URL(url), 100000);
        Element elementByClass = document.getElementsByClass("c-table opr-toplist1-table").get(0);
        Elements trElements = elementByClass.getElementsByTag("tr");
        for (Element trElement : trElements) {
            Elements tdElements = trElement.getElementsByTag("td");
            String index = tdElements.get(0).getElementsByTag("span").get(0).text();
            String note = tdElements.get(0).getElementsByTag("a").get(0).text();
            String num = tdElements.get(1).text();
            System.out.println(index + "---" + note + "---" + num);
        }

        System.out.println();
    }
```
