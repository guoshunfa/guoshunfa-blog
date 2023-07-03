---
title: 搭建单体SpringBoot项目 统一异常处理
tags:
    - SpringBoot
categories:
    - 技术
    - 搭建单体SpringBoot项目
date: 2022-07-01 12:01:01
thumbnail:
---

所有的异常信息进行统一处理。

> 关于异常相关的知识，请移步到[Java基础 - 异常](/pages/5efeaf)

## 结果展示

**加入测试代码：**

<img src="https://file.pandacode.cn/blog/202210131039788.png" alt="image-20221013103954677" style="zoom:40%;" /> <img src="https://file.pandacode.cn/blog/202210131041832.png" alt="image-20221013104123788" style="zoom:40%;" /> 

**请求响应信息：**

<img src="https://file.pandacode.cn/blog/202210131043136.png" alt="image-20221013104312090" style="zoom:50%;" /> 

<img src="https://file.pandacode.cn/blog/202210131043940.png" alt="image-20221013104335886" style="zoom:50%;" /> 

<img src="https://file.pandacode.cn/blog/202210131043706.png" alt="image-20221013104357673" style="zoom:50%;" /> 

## 添加统一异常处理类

```java
import com.panda.base.exception.custom.PandaException;
import com.panda.base.result.vo.ApiResult;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

@RestControllerAdvice
public class PandaGlobalExceptionHandler {

    /**
     * 这是我的自定义异常
     *
     * @param e
     * @return
     */
    @ExceptionHandler({PandaException.class})
    public ApiResult runtimeException(PandaException e) {
        return ApiResult.fail("PandaException:" + e);
    }

  	/**
  		* 兜底异常，其他异常都没有匹配到的会来到这个方法进行处理。
  		*/
    @ExceptionHandler({Exception.class})
    public ApiResult Exception(Exception e) {
        return ApiResult.fail("Exception:" + e);
    }

}
```

