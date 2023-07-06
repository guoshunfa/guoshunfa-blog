---
title: 搭建单体SpringBoot项目 统一响应结构
tags:
  - SpringBoot
  - Java
categories:
  - 搭建单体SpringBoot项目
date: 2022-07-01 12:01:01
thumbnail:
---



每个接口都需要有一个统一的响应结构。比如：

```json
{
  "code": 200,
  "msg": "OK",
  "data": "我是数据"
}
```

## 结果展示

**接口定义：**

<img src="https://file.pandacode.cn/blog/202210121603228.png" alt="image-20221012160346154" style="zoom:50%;" /> <img src="https://file.pandacode.cn/blog/202210121606999.png" alt="image-20221012160606935" style="zoom: 40%;" />

**请求响应结果：**

<img src="https://file.pandacode.cn/blog/202210121604694.png" alt="image-20221012160455612" style="zoom:50%;" /> 

<img src="https://file.pandacode.cn/blog/202210121608394.png" alt="image-20221012160805338" style="zoom:50%;" /> 

## 设定一个统一的响应模版

### 接口响应内容

```java
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel("接口响应内容")
public class ApiResult<T> {

    @ApiModelProperty("响应码")
    private Integer code;

    @ApiModelProperty("消息内容")
    private String msg;

    @ApiModelProperty("响应数据")
    private T data;

    public static ApiResult ok() {
        return ok(null);
    }

    public static <T> ApiResult<T> ok(T data) {
        return ok("请求成功", data);
    }

    public static <T> ApiResult<T> ok(String msg, T data) {
        return init(ApiResultCodeEnum.SUCCESS.getCode(), msg, data);
    }

    public static ApiResult fail() {
        return fail(null);
    }

    public static <T> ApiResult<T> fail(T data) {
        return fail("请求失败", data);
    }

    public static <T> ApiResult<T> fail(String msg, T data) {
        return init(ApiResultCodeEnum.FAILURE.getCode(), msg, data);
    }

    public static <T> ApiResult<T> init(Integer code, String msg, T data) {
        ApiResult<T> apiResult = new ApiResult<T>();
        apiResult.setCode(code);
        apiResult.setMsg(msg);
        apiResult.setData(data);
        return apiResult;
    }

    public Integer getCode() {
        return code;
    }

    public void setCode(Integer code) {
        this.code = code;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }
}
```

### 响应码枚举

```java
/**
 * 响应码枚举
 */
public enum ApiResultCodeEnum {

    SUCCESS(200, "SUCCESS"),
    FAILURE(500, "FAILURE"),
    UN_LOGIN(401, "请求未授权"),
    NOT_FOUND(404, "接口不存在");

    private Integer code;

    private String msg;

    ApiResultCodeEnum(Integer code, String msg) {
        this.code = code;
        this.msg = msg;
    }

    public Integer getCode() {
        return code;
    }

    public void setCode(Integer code) {
        this.code = code;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }
}

```

## 封装返回结果

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
        if (returnValue instanceof ApiResult) {
            this.returnValueHandler.handleReturnValue(returnValue, returnType, mavContainer, webRequest);
            return;
        }
        this.returnValueHandler.handleReturnValue(ApiResult.ok(returnValue), returnType, mavContainer, webRequest);
    }
}
```

## 添加配置

```java
import org.springframework.beans.factory.InitializingBean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.method.support.HandlerMethodReturnValueHandler;
import org.springframework.web.servlet.mvc.method.annotation.RequestMappingHandlerAdapter;
import org.springframework.web.servlet.mvc.method.annotation.RequestResponseBodyMethodProcessor;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

@Configuration
public class ReturnValueConfig implements InitializingBean {

    @Resource
    RequestMappingHandlerAdapter requestMappingHandlerAdapter;

    @Override
    public void afterPropertiesSet() {
        List<HandlerMethodReturnValueHandler> unmodifiableList = requestMappingHandlerAdapter.getReturnValueHandlers();
        List<HandlerMethodReturnValueHandler> list = new ArrayList<>(unmodifiableList.size());
        for (HandlerMethodReturnValueHandler returnValueHandler : unmodifiableList) {
            if (returnValueHandler instanceof RequestResponseBodyMethodProcessor) {
                list.add(new PandaHandlerMethodReturnValueHandler(returnValueHandler));
            } else {
                list.add(returnValueHandler);
            }
        }
        requestMappingHandlerAdapter.setReturnValueHandlers(list);
    }
}
```
