---
title: 搭建单体SpringBoot项目 特殊响应结构
tags:
    - SpringBoot
categories:
    - 技术
    - 搭建单体SpringBoot项目
date: 2022-07-01 12:01:01
thumbnail:
---

并不是所有的需求都要求使用统一的响应结构，在编写对外开放的接口时，可能会使用另外一套响应规则进行返回。

这里在原有的[统一响应结构](/pages/dd4ecf/)的基础上，进行一些定制化处理。

## 定义一个特殊响应注解

定义一个用于特殊响应的注解，把注解放在想要特殊响应的接口方法上。

```java
import java.lang.annotation.*;

@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface NotUnifiedResult {
}
```

## 调整封装返回结果

```java
import org.springframework.core.MethodParameter;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.method.support.HandlerMethodReturnValueHandler;
import org.springframework.web.method.support.ModelAndViewContainer;

/**
 * 封装返回结果
 */
public class PandaHandlerMethodReturnValueHandler implements HandlerMethodReturnValueHandler {

    private final HandlerMethodReturnValueHandler returnValueHandler;

    public PandaHandlerMethodReturnValueHandler(HandlerMethodReturnValueHandler returnValueHandler) {
        this.returnValueHandler = returnValueHandler;
    }

    @Override
    public boolean supportsReturnType(MethodParameter returnType) {
        return returnValueHandler.supportsReturnType(returnType);
    }

    @Override
    public void handleReturnValue(Object returnValue, MethodParameter returnType, ModelAndViewContainer mavContainer, NativeWebRequest webRequest) throws Exception {
        // 不需要统一封装的接口，直接返回。
        if (returnType.hasMethodAnnotation(NotUnifiedResult.class)) {
            this.returnValueHandler.handleReturnValue(returnValue, returnType, mavContainer, webRequest);
            return;
        }
        // 人为的使用的统一封装，不会再次封装。
        if (returnValue instanceof ApiResult) {
            this.returnValueHandler.handleReturnValue(returnValue, returnType, mavContainer, webRequest);
            return;
        }
        this.returnValueHandler.handleReturnValue(ApiResult.ok(returnValue), returnType, mavContainer, webRequest);
    }
}
```

