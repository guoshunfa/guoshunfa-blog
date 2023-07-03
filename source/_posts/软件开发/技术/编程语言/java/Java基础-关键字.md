---
title: Java基础 关键字
tags:
    - oracle
    - java
categories:
    - 技术
date: 2022-07-01 12:01:01
thumbnail:
---

# Java基础-关键字

## java 关键字 - transient

> Java中transient关键字的作用，简单地说，就是让某些被修饰的成员属性变量不被序列化。
>
> 1）一旦变量被transient修饰，变量将不再是对象持久化的一部分，该变量内容在序列化后无法获得访问。
>
> 2）transient关键字只能修饰变量，而不能修饰方法和类。注意，本地变量是不能被transient关键字修饰的。变量如果是用户自定义类变量，则该类需要实现Serializable接口。
>
> 3）被transient关键字修饰的变量不再能被序列化，一个静态变量不管是否被transient修饰，均不能被序列化。

```java
public static void main(String[] args) {
  @Data
  class AA implements Serializable {
    transient String a;
    String b;
  }
  AA aa = new AA();
  aa.setA("a");
  aa.setB("b");
  String s = JSONUtil.toJsonStr(aa);
  JSONObject jsonObject = JSONUtil.parseObj(s);
  System.out.println(s);
  System.out.println(jsonObject);
}
```

console:

```
{"b":"b"}
{"b":"b"}
```

