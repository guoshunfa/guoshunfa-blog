---
title: Python ui自动化测试
tags:
  - python
  - 自动化测试
  - 测试
categories:
  - 技术
date: 2022-06-28 10:52:46
thumbnail:
---

> selenium+unittest包，来做ui自动化测试。
>
>
>
> API/DEMO：[selenium-python中文文档](https://python-selenium-zh.readthedocs.io/zh_CN/latest/) | [seleniumbase(基于selenium封装)](https://github.com/guoshunfa/SeleniumBase) | [demo项目](https://gitee.com/guoshunfa/python-selenium-unittest)

## 1. 理解

类似于爬虫，通过html源代码的方式，捕捉到对应标签，再通过浏览器事件进行点击、输入框输入、双击等操作，最终完成 打开浏览器 - 自动点击/输入操作 - 关闭浏览器，这一系列操作。

## 2. demo

```python
# coding=utf-8

from selenium import webdriver
import unittest, time
from utils.log import logger

class BaiduTest(unittest.TestCase):
    def setUp(self):
        self.driver = webdriver.Chrome("/Library/work/workspace-my/python/chromedriver")
        self.driver.implicitly_wait(30) #隐性等待时间为30秒
        self.base_url = "https://www.baidu.com"
    
    def test_baidu(self):
        driver = self.driver
        driver.get(self.base_url + "/")
        driver.find_element_by_id("kw").clear()
        logger.info("Input search str")#Print input unittest
        driver.find_element_by_id("kw").send_keys("unittest")
        driver.find_element_by_id("su").click()
        time.sleep(3)
        title=driver.title
        self.assertEqual(title, "unittest_百度搜索") 

    def tearDown(self):
        self.driver.quit()

if __name__ == "__main__":
    unittest.main()
```

