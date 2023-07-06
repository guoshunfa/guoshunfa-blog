---
title: Java测试 Assert断言
tags:
    - oracle
    - java
    - 测试
    - assert
    - 断言
categories:
    - Java
date: 2020-07-01 12:01:01
thumbnail:
---

> 在 JDK 1.4之前，开发人员经常使用注释来记录关于程序正确性的假设。然而，注释作为测试和调试假设的机制是无用的。编译器忽略注释，因此无法使用它们进行 bug 检测。开发人员在更改代码时也经常不更新注释。
>
> 在 JDK 1.4中，断言被引入作为测试和调试代码假设的新机制。实质上，断言是在运行时执行的可编译实体，假设你已经为程序测试启用了它们。可以通过编写断言来通知 bug 发生的地方，这样可以大大减少调试失败程序的时间。

## 1. 编写断言的表达式

```java
assert BooleanExpr;
```

如果 BooleanExpr 的计算结果为 true，则不会发生任何事情，并继续执行。但是，如果表达式计算结果为 false，那么将抛出 AssertionError

### 1.1. 举个例子

```java
public static void main(String[] args) {
  int a = 10;
  assert a>100;//false
}
```

## 2. 运行后没有反应??

`有的小伙伴发现自己的IDE并没有抛出Error 这是因为没有显示开启,启用断言` 开启方法: vm options 加入 -ea

此时我们运行项目 发现抛出了异常

```java
Exception in thread "main" java.lang.AssertionError
    at Scratch.main(scratch_4.java:4)
```

## 3. 希望获得更多信息?

此时我们已经知道了断言的基本用法 但是抛出Error后我们并不知道是什么问题导致的 还需要去翻看代码找到报错的地方, 如果我们希望获得更多有用的信息 我们可以这样修改Assert语句:

```text
assert BooleanExpr : expr;
```

expr 是任何可以返回值的表达式(包括方法调用)但是不能调用具有 void 返回类型的方法。一个有用的表达式是一个字符串，用它来描述失败的原因

### 3.1. 举个例子

```java
public static void main(String[] args) {
        int a = 10;
        assert a>100 : "a < 100"; 
    }
```

运行:

```text
Exception in thread "main" java.lang.AssertionError: a < 100
    at Scratch.main(scratch_4.java:5)
```

无论哪个例子，在不使用-ea (启用断言)选项的情况下运行都不会产生输出。当断言未启用时，它们不会执行，尽管它们仍然存在于类文件中。

## 4. 前置条件和后置条件

前置条件: 是在执行某些代码之前必须求值为 true 的条件

后置条件: 是在执行某些代码后必须求值为 true 的条件

### 4.1. 前置条件

前置条件检查:

```text
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

class PNG
    {
        /**
         *  Create a PNG instance, read specified PNG file, and decode
         *  it into suitable structures.
         *
         *  @param filespec path and name of PNG file to read
         *
         *  @throws NullPointerException when <code>filespec</code> is
         *          <code>null</code>
         */
        PNG(String filespec) throws IOException
        {
            //在非私有构造方法中 使用前置条件
            if (filespec == null)
                throw new NullPointerException("filespec is null");
            try (FileInputStream fis = new FileInputStream(filespec))
            {
                readHeader(fis);
            }
        }

        private void readHeader(InputStream is) throws IOException
        {  
                //在私有方法中使用前置条件检查
            assert is != null : "null passed to is";
        }
    }

    class Scratch
    {
        public static void main(String[] args) throws IOException
        {
            PNG png = new PNG((args.length == 0) ? null : args[0]);
        }
    }
```

### 4.2. 后置条件

后置条件检查:

```text
public class AssertDemo
{
   public static void main(String[] args)
   {
      int[] array = { 20, 91, -6, 16, 0, 7, 51, 42, 3, 1 };
      sort(array);
      for (int element: array)
         System.out.printf("%d ", element);
      System.out.println();
   }

   private static boolean isSorted(int[] x)
   {
      for (int i = 0; i < x.length - 1; i++)
         if (x[i] > x[i + 1])
            return false;
      return true;
   }

   private static void sort(int[] x)
   {
      int j, a;
      // For all integer values except the leftmost value ...
      for (int i = 1; i < x.length; i++)
      {
         // Get integer value a.
         a = x[i];
         // Get index of a. This is the initial insert position, which is
         // used if a is larger than all values in the sorted section.
         j = i;
         // While values exist to the left of a's insert position and the
         // value immediately to the left of that insert position is
         // numerically greater than a's value ...
         while (j > 0 && x[j - 1] > a)
         {
            // Shift left value -- x[j - 1] -- one position to its right --
            // x[j].
            x[j] = x[j - 1];
            // Update insert position to shifted value's original position
            // (one position to the left).
            j--;
         }
         // Insert a at insert position (which is either the initial insert
         // position or the final insert position), where a is greater than
         // or equal to all values to its left.
         x[j] = a;
      }
      //在 sort ()返回给它的调用者之前，我使用 assert 检查 x 被排序的后置条件。
      assert isSorted(x): "array not sorted";
   }
}
```

## 5. 陷阱

assert关键字用法简单，但是使用assert往往会让你陷入越来越深的陷阱中。应避免使用。笔者经过研究，总结了以下原因：

> 1、 assert关键字需要在运行时候显式开启才能生效，否则你的断言就没有任何意义。而现在主流的Java IDE工具默认都没有开启-ea断言检查功能。这就意味着你如果使用IDE工具编码，调试运行时候会有一定的麻烦。并且，对于Java Web应用，程序代码都是部署在容器里面，你没法直接去控制程序的运行，如果一定要开启-ea的开关，则需要更改Web容器的运行配置参数。这对程序的移 植和部署都带来很大的不便。

> 2、用assert代替if是陷阱之二。assert的判断和if语句差不多，但两者的作用有着本质的区别：assert关键字本意上是为测试 调试程序时使用的，但如果不小心用assert来控制了程序的业务流程，那在测试调试结束后去掉assert关键字就意味着修改了程序的正常的逻辑。

> 3、assert断言失败将面临程序的退出。这在一个生产环境下的应用是绝不能容忍的。一般都是通过异常处理来解决程序中潜在的错误。但是使用断言就很危险，一旦失败系统就挂了。

## 6. 总结

assert既然是为了调试测试程序用，不在正式生产环境下用，那应该考虑更好的测试JUint来代替其做用，JUint相对assert关键的所提供的功能是有过之而无不及。当然完全可以通过IDE debug来进行调试测试

因此，应当避免在Java中使用assert关键字，除非哪一天Java默认支持开启-ea的开关，这时候可以考虑。对比一下，assert能给你带来多少好处，多少麻烦，这是我们选择是否使用的的原则,读者可以自行取舍.
