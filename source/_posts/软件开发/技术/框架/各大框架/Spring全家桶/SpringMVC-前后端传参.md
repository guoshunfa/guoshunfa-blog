---
title: SpringMVC 前后端传参
tags:
  - springmvc
categories:
  - 技术
date: 2022-07-01 12:01:01
thumbnail:
---

## ModelAndView + thymeleaf

> 废话不多说，直接上demo。

**properties:**

```properties
# ----------------------Springmvc配置-----------------------------
# 指定前端页面的前缀
spring.mvc.view.prefix=/
# 指定前端页面的后缀
spring.mvc.view.suffix=.html
# ------------------------thymeleaf配置-----------------------------------
spring.thymeleaf.servlet.content-type=text/html
# 指定文件路径
spring.thymeleaf.prefix=classpath:/templates/
spring.thymeleaf.check-template=false
spring.thymeleaf.check-template-location=false
spring.thymeleaf.mode=HTML
spring.thymeleaf.encoding=UTF-8
spring.thymeleaf.cache=false
```

**maven:**

```xml
<!-- thymeleaf -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-thymeleaf</artifactId>
</dependency>
        <!-- 省略其他springboot包 -->
```

**controller:**

```java
// 页面跳转controller
@Controller
public class PageController {
    @RequestMapping("/")
    public ModelAndView index() {
        ModelAndView mav = new ModelAndView();
        mav.addObject("testParam", "欧吼");
        mav.setViewName("index");
        return mav;
    }
}
```

**html:**

```html

<html lang="zh-CN"
      xmlns:th="http://www.thymeleaf.org">
<script th:inline="javascript">
    var testParam = [[${testParam}]];
    console.log(testParam)
</script>
</html>
```

效果：

<img src="https://file.pandacode.cn/blog/2022119111119.png"  />