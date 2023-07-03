---
title: Python scrapy爬虫
tags:
  - python
  - 脚本
  - scrapy
  - 爬虫
categories:
  - 技术
date: 2022-07-01 12:01:01
thumbnail:
---

> [scrapy API](https://docs.scrapy.org/zh/) | [开源project-github](https://github.com/scrapy/scrapy) 

## 1. demo

```python
import scrapy

class QuotesSpider(scrapy.Spider):
    name = 'quotes'
    start_urls = [
        'http://quotes.toscrape.com/tag/humor/',
    ]

    def parse(self, response):
        for quote in response.css('div.quote'):
            yield {
                'author': quote.xpath('span/small/text()').get(),
                'text': quote.css('span.text::text').get(),
            } 
```

