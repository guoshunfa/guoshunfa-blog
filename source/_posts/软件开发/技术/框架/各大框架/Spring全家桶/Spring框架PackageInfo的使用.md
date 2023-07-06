---
title: Spring框架 PackageInfo的使用
tags:
  - kafka
categories:
  - 技术
date: 2022-07-01 12:01:01
thumbnail:
---

## 场景

以包(package)为范围进行配置。如：将注解直接加到包的维度。

## 创建package-info.java

1. 使用eclipse进行创建包时，可以勾选“Create package-info.java”按钮，进行创建。
2. 如果创建包时没有创建package-info.java，只能在包对应文件夹里，手动创建一个package-info.java，写上包名，最后刷新ide即可。

## package-info.java的使用

1. 提供包级别的类(或接口)，这些类(或接口)只有本包里才能访问，即使是子包也不能访问。
2. 提供包的整体注释说明。

package-info.java

```java
/**   
 * <b>package-info不是平常类，其作用有三个:</b><br>   
 * 1、为标注在包上Annotation提供便利；<br>   
 * 2、声明包的私有类和常量；<br>   
 * 3、提供包的整体注释说明。<br>   
*/   
@JyzTargetPackage(version="1.0")  
package com.jyz.study.jdk.annotation;  
  
class PackageInfo{  
    public void common(){  
        System.out.println("sa");  
    }  
}  
  
class PackageInfoGeneric<T extends Throwable>{  
    private T obj;  
    public void set(T obj){  
        this.obj = obj;  
    }  
    public void common(){  
        System.out.println(obj + "sa");  
    }  
}  
  
interface packageInfoInteger{  
    public void test();  
}  
  
class PackageConstants{  
    public static final String ERROE_CODE = "100001";   
} 
```

TestPackageInfo.java

```java
package com.jyz.study.jdk.annotation;  
  
import java.io.IOException;  
  
/** 
 * 测试package-info.java文件的作用 
 * 1、为标注在包上Annotation提供便利；<br>   
 * 2、声明包的私有类和常量；<br>   
 * @author JoyoungZhang@gmail.com 
 * 
 */  
public class TestPackageInfo {  
  
    public static void main(String[] args) {  
        //1  
        Package p = Package.getPackage("com.jyz.study.jdk.annotation");  
        if(p != null && p.isAnnotationPresent(JyzTargetPackage.class)){  
            JyzTargetPackage nav = p.getAnnotation(JyzTargetPackage.class);  
            if(nav != null){   
                System.out.println("package version:" + nav.version());  
            }  
        }  
        //2  
        PackageInfo packageInfo = new PackageInfo();  
        packageInfo.common();  
        //泛型也能很好的工作，在pakcage-info.java里定义的类和普通类没什么区别  
        PackageInfoGeneric<Exception> packageInfoGeneric = new PackageInfoGeneric<Exception>();  
        packageInfoGeneric.set(new IOException("device io"));  
        packageInfoGeneric.common();  
        Sub sub = new Sub();  
        sub.test();  
        System.out.println(PackageConstants.ERROE_CODE);  
    }  
}  
  
class Sub implements packageInfoInteger{  
    @Override  
    public void test() {  
        System.out.println("sub");  
    }  
}
```

Console output

```
package version:1.0  
sa  
java.io.IOException: device iosa  
sub  
100001  
```

需要注意两点

1. package-info.java里不能声明public class(或 interface)
2. 刚开始p.isAnnotationPresent(JyzTargetPackage.class)返回false，后来找到原因JyzTargetPackage没有加上@Retention(RetentionPolicy.RUNTIME)。
