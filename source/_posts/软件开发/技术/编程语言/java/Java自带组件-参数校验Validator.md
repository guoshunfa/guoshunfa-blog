---
title: Java自带组件 参数校验Validator
tags:
    - Oracle
    - Java
    - Validator
categories:
    - Java
date: 2020-07-01 12:01:01
thumbnail:
---


应用在执行业务逻辑之前，必须通过校验保证接受到的输入数据是合法正确的，但很多时候同样的校验出现了多次，在不同的层，不同的方法上，导致代码冗余，浪费时间，违反DRY原则。

- 每一个控制器都要校验
- 过多的校验参数会导致代码太长
- 代码的复用率太差，同样的代码如果出现多次，在业务越来越复杂的情况下，维护成本呈指数上升。

可以考虑把校验的代码封装起来，来解决出现的这些问题。

> @Validated和@Valid搭配使用，@Validated用来标注让Spring扫描，@Valid用来标注需要验证的对象。

## 1. 用法实例

**maven**

```xml
	<dependency>
		<groupId>org.hibernate</groupId>
		<artifactId>hibernate-validator</artifactId>
		<version>5.2.4.Final</version>
	</dependency>
```

### 1.1. 校验对象

1. 编写校验对象

```java
public class User {
    // 名字不允许为空，并且名字的长度在2位到30位之间
    // 如果名字的长度校验不通过，那么提示错误信息
    @NotNull
    @Size(min=2, max=30,message = "请检查名字的长度是否有问题")
    private String name;

    // 不允许为空，并且年龄的最小值为18
    @NotNull
    @Min(18)
    private Integer age;
}
```

2. 创建控制器

```java
    // 1. 要校验的参数前，加上@Valid注解
    // 2. 紧随其后的，跟上一个BindingResult来存储校验信息
    @RequestMapping("/test1")
    public Object test1(@Valid User user) {
        return "OK";
    }
```

### 1.2. 直接校验参数

```java
@Controller
@Validated
@RequestMapping(value = "validator")
public class ParameterValidatorDemoController {

    @ResponseBody
    @GetMapping(value = "simple")
    public String validateParameter(@Valid @Size(min = 1, max = 5) String name) {
        System.out.println(name);
        return "OK";
    }

}
```

> 类上的**@Validated**注解则告诉spring需要扫描这个类，来检查其中的constraint注解。

## 2. 常见的校验注解

> javax.validation.constraints
> 
> @Null 被注释的元素必须为 null
>
> @NotNull 被注释的元素必须不为 null
>
> @AssertTrue 被注释的元素必须为 true
>
> @AssertFalse 被注释的元素必须为 false
>
> @Min(value) 被注释的元素必须是一个数字，其值必须大于等于指定的最小值
>
> @Max(value) 被注释的元素必须是一个数字，其值必须小于等于指定的最大值
>
> @DecimalMin(value) 被注释的元素必须是一个数字，其值必须大于等于指定的最小值
>
> @DecimalMax(value) 被注释的元素必须是一个数字，其值必须小于等于指定的最大值
>
> @Size(max=, min=) 被注释的元素的大小必须在指定的范围内
>
> @Digits (integer, fraction) 被注释的元素必须是一个数字，其值必须在可接受的范围内
>
> @Past 被注释的元素必须是一个过去的日期
>
> @Future 被注释的元素必须是一个将来的日期
>
> @Pattern(regex=,flag=) 被注释的元素必须符合指定的正则表达式
> 
> @NotBlank(message =) 验证字符串非null，且长度必须大于0
>
> @Email 被注释的元素必须是电子邮箱地址
>
> @Length(min=,max=) 被注释的字符串的大小必须在指定的范围内
>
> @NotEmpty 被注释的字符串的必须非空
>
> @Range(min=,max=,message=) 被注释的元素必须在合适的范围内

## 3. 自定义校验注解

有时候，第三方库中并没有我们想要的校验类型，好在系统提供了很好的扩展能力，我们可以自定义检验。
比如，我们想校验用户的手机格式，写手机号码校验器

1、编写校验注解

```java
// 我们可以直接拷贝系统内的注解如@Min，复制到我们新的注解中，然后根据需要修改。
@Target({METHOD, FIELD, ANNOTATION_TYPE, CONSTRUCTOR, PARAMETER})
@Retention(RUNTIME)
@Documented
//注解的实现类。
@Constraint(validatedBy = {IsMobileValidator.class})
public @interface IsMobile {
    //校验错误的默认信息
    String message() default "手机号码格式有问题";

    //是否强制校验
    boolean isRequired() default false;
    
    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};
}
```

2、编写具体的实现类
我们知道注解只是一个标记，真正的逻辑还要在特定的类中实现，上一步的注解指定了实现校验功能的类为IsMobileValidator。

```java
// 自定义注解一定要实现ConstraintValidator接口奥，里面的两个参数
// 第一个为 具体要校验的注解
// 第二个为 校验的参数类型
public class IsMobileValidator implements ConstraintValidator<IsMobile, String> {

    private boolean required = false;

    private static final Pattern mobile_pattern = Pattern.compile("1\\d{10}");
    //工具方法，判断是否是手机号
    public static boolean isMobile(String src) {
        if (StringUtils.isEmpty(src)) {
            return false;
        }
        Matcher m = mobile_pattern.matcher(src);
        return m.matches();
    }

    @Override
    public void initialize(IsMobile constraintAnnotation) {
        required = constraintAnnotation.isRequired();
    }

    @Override
    public boolean isValid(String phone, ConstraintValidatorContext constraintValidatorContext) {
        //是否为手机号的实现
        if (required) {
            return isMobile(phone);
        } else {
            if (StringUtils.isEmpty(phone)) {
                return true;
            } else {
                return isMobile(phone);
            }
        }
    }
    
}
```

3、测试自定义注解的功能

```java
@Data
public class User {
    @NotNull
    @Size(min=2, max=30,message = "请检查名字的长度是否有问题")
    private String name;

    @NotNull
    @Min(18)
    private Integer age;

    //这里是新添加的注解奥
    @IsMobile
    private String phone;
}
```

