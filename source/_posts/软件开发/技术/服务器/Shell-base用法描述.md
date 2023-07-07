---
title: Shell base用法描述
tags:
  - Shell
categories:
  - 服务器管理
date: 2022-07-01 11:30:05
thumbnail:
---
> bash是Linux和Unix下的shell。
>
>
>
> 本教程关注的是 Bash，也就是 Bourne Again Shell，由于易用和免费，Bash 在日常工作中被广泛使用。同时，Bash 也是大多数Linux 系统默认的 Shell。
>
> 在一般情况下，人们并不区分 Bourne Shell 和 Bourne Again Shell，所以，像 **#!/bin/sh**，它同样也可以改为 **#!/bin/bash**。
>
> **#!** 告诉系统其后路径所指定的程序即是解释此脚本文件的 Shell 程序。

## 1. base shell 基础知识

### 1.1. 注释

**单行注释**

“#”命令代表单行注释，在任何一行代码前加上”#”及将这行变为注释

```sh
# 我是注释1
```

**多行注释**

多行注释则使用:<

```sh
:<<EOF
......
......
.....
EOF
```

### 1.2. 变量

**变量定义**

变量定义不用加任何符号，直接用[变量名]=[变量值]：

```shell
name="jianjian"
```

**命名规则**

- 变量名和变量值与等号之间不能加空格
- 命名只能使用英文字母，数字和下划线，首个字符不能以数字开头。
- 中间不能有空格，可以使用下划线（_）。
- 不能使用标点符号。
- 不能使用bash里的关键字（可用help命令查看保留关键字）。

**使用变量**

使用一个定义过的变量，只要在变量前加上美元符即可

```sh
name="jianjian"
echo $name
echo ${name}
```

花括号是可选的，主要是为了识别变量边界，例如这种情况

```sh
ScriptName="Java"
echo "i use ${ScriptName}Script"
```

不加上花括号则可能识别变量名为$ScriptNameScript

**只读变量**

给变量加上readonly命令就能把它变成一个只读的变量

```sh
name="jianjian"
readonly name
```

**删除变量**

给变量加上unset命令就能删除这个变量

```sh
name="jianjian"
unset name
# 将不会有任何输出
echo $name
```

**变量类型**

在shell中存在三种变量

- 局部变量:::局部变量在脚本或命令中定义，仅在当前shell实例中有效，其他shell启动的程序不能访问局部变量。
- 环境变量:::所有的程序，包括shell启动的程序，都能访问环境变量，有些程序需要环境变量来保证其正常运行。必要的时候shell脚本也可以定义环境变量。
- shell变量:::shell变量是由shell程序设置的特殊变量。shell变量中有一部分是环境变量，有一部分是局部变量，这些变量保证了shell的正常运行

### 1.3. 字符串

**字符串定义**

bash中的字符串可以用单引号和双引号，其区别就是，单引号内不能解释变量，而双引号内可以解释变量

```sh
name="jianjian"
echo '$name'
echo "$name"
```

上述代码将输出为：

```sh
$name
jianjian
```

**字符串拼接**

```sh
firstName="im"
lastName="jianjian"
name="${firstName}${lastName}"
echo $name
```

**获取字符串长度**

```sh
name="imjianjian"
echo ${#name}
```

**查找子字符串**

```sh
str="oh! Bash is so good!"
echo `expr index "$str" is`
# 将输出7，即在第七位找到is中的s
```

他找到的是is中的任意一个字符，那个线出现就返回哪个
主义这里使用的是“而不是”,这个符号在exc下面

### 1.4. 数组

**数组定义**

bash支持一维数组，不支持多维数组
数组的下标从0开始，获取数组时下边可以使用算术表达式
数组用（）包裹，每个子元素都用空格分开

```sh
#直接定义
arr1=(1 2 3 4)
#单独定义
arr2[0]=1
arr2[1]=2
arr2[2]=3
arr2[3]=4
```

**数组使用**

```sh
arr=(1 2 3 4)
echo ${arr[0]}
```

**数组长度**

获取数组的长度

```sh
arr=(1 2 3 4)
echo ${#arr(*)}
```

获取单个元素长度

```sh
arr=(12 22 32 42)
echo ${#arr[0]}
```

### 1.5. 传参

**使用方法**

我们在使用脚本文件的时候可以向文件中传递一些参数，脚本则可以使用n这种方式来获取参数，n这种方式来获取参数，0代表文件名，1代表的是第一个参数，1代表的是第一个参数，2代表第二个参数，以此类推。。。

test1.sh:

```sh
#!/bin/bash

echo "文件名：$0";
echo "第一个参数为：$1";
echo "第二个参数为：$2";
```

然后用下列代码运行该文件：

```sh
bash test1.sh 1 2
```

输出:

```sh
文件名：test1.sh
第一个参数为：1
第二个参数为：2
```

**其他字符**

| 参数处理 | 说明                                                |
| -------- | --------------------------------------------------- |
| $#       | 参数个数                                            |
| $*       | 输出所有的参数                                      |
| $$       | 当前脚本进程ID                                      |
| $!       | 后台运行的最后一个进程ID                            |
| $@       | 与$*相同，但使用时家加引号                          |
| $-       | 现时shell当前选项                                   |
| $?       | 现时最后命令的退出状态。0表示没有错误，其他表示错误 |

### 1.6. 运算符

**算术运算符**

bash本身不支持简单的数学计算，需要通过其他命令来实现，例如awk和expr

```sh
num=`expr 2 + 2`
echo "和为:${num}"
```

其他运算符：
设a为10。b为20

| 运算符 | 说明                                          | 例子                           |
| ------ | --------------------------------------------- | ------------------------------ |
| +      | 加法                                          | `expr $a + $b` 结果为 30。     |
| -      | 减法                                          | `expr $a - $b` 结果为 -10。    |
| *      | 乘法                                          | `expr $a \* $b` 结果为 200。   |
| /      | 除法                                          | `expr $b / $a` 结果为 2。      |
| %      | 取余                                          | `expr $b % $a` 结果为 0。      |
| =      | 赋值                                          | `a=$b` 将把变量 b 的值赋给 a。 |
| ==     | 相等。用于比较两个数字，相同则返回 true。     | `[ a==b ]` 返回 false。        |
| !=     | 不相等。用于比较两个数字，不相同则返回 true。 | `[ a!=b ]` 返回 true。         |

**关系运算符**

关系运算符只支持数字，不支持字符串，除非字符串的值是数字

设a为10。b为20

| 运算符 | 说明                                                  | 举例                       |
| ------ | ----------------------------------------------------- | -------------------------- |
| -eq    | 检测两个数是否相等，相等返回 true。                   | `[ a −eq b ]` 返回 false。 |
| -ne    | 检测两个数是否不相等，不相等返回 true。               | `[ a −ne b ]` 返回 true。  |
| -gt    | 检测左边的数是否大于右边的，如果是，则返回 true。     | `[ a −gt b ]` 返回 false。 |
| -lt    | 检测左边的数是否小于右边的，如果是，则返回 true。     | `[ a −ltb ]` 返回 true。   |
| -ge    | 检测左边的数是否大于等于右边的，如果是，则返回 true。 | `[ a −ge b ]` 返回 false。 |
| -le    | 检测左边的数是否小于等于右边的，如果是，则返回 true。 | `[ a −le b ]` 返回 true。  |

**布尔运算符**

设a为10。b为20

| 运算符 | 说明                                                | 举例                                     |
| ------ | --------------------------------------------------- | ---------------------------------------- |
| !      | 非运算，表达式为 true 则返回 false，否则返回 true。 | [ ! false ] 返回 true。                  |
| -o     | 或运算，有一个表达式为 true 则返回 true。           | `[ a −lt 20 −o b -gt 100 ]` 返回 true。  |
| -a     | 与运算，两个表达式都为 true 才返回 true。           | `[ a −lt 20 −a b -gt 100 ]` 返回 false。 |

**逻辑运算符**

设a为10。b为20

| 运算符 | 说明       | 举例                                     |
| ------ | ---------- | ---------------------------------------- |
| &&     | 逻辑的 AND | `[[ a -lt 100 &&b -gt 100 ]] `返回 false |
| \|\|   | 逻辑的 OR  | `[[ a -lt 100 &&b -gt 100 ]]` 返回 true  |

**字符串运算符**

设a 为 “abc”，b 为 “efg”：

| 运算符 | 说明                                      | 举例                      |
| ------ | ----------------------------------------- | ------------------------- |
| =      | 检测两个字符串是否相等，相等返回 true。   | `[ a=b ]` 返回 false。    |
| !=     | 检测两个字符串是否相等，不相等返回 true。 | `[ a!=b ]` 返回 true。    |
| -z     | 检测字符串长度是否为0，为0返回 true。     | `[ -z $a ]` 返回 false。  |
| -n     | 检测字符串长度是否为0，不为0返回 true。   | `[ -n “$a” ]` 返回 true。 |
| str    | 检测字符串是否为空，不为空返回 true。     | `[ $a ]` 返回 true。      |

**文件测试运算符**

| 操作符  | 说明                                                         | 举例                      |
| ------- | ------------------------------------------------------------ | ------------------------- |
| -b file | 检测文件是否是块设备文件，如果是，则返回 true。              | [ -b $file ] 返回 false。 |
| -c file | 检测文件是否是字符设备文件，如果是，则返回 true。            | [ -c $file ] 返回 false。 |
| -d file | 检测文件是否是目录，如果是，则返回 true。                    | [ -d $file ] 返回 false。 |
| -f file | 检测文件是否是普通文件（既不是目录，也不是设备文件），如果是，则返回 true。 | [ -f $file ] 返回 true。  |
| -g file | 检测文件是否设置了 SGID 位，如果是，则返回 true。            | [ -g $file ] 返回 false。 |
| -k file | 检测文件是否设置了粘着位(Sticky Bit)，如果是，则返回 true。  | [ -k $file ] 返回 false。 |
| -p file | 检测文件是否是有名管道，如果是，则返回 true。                | [ -p $file ] 返回 false。 |
| -u file | 检测文件是否设置了 SUID 位，如果是，则返回 true。            | [ -u $file ] 返回 false。 |
| -r file | 检测文件是否可读，如果是，则返回 true。                      | [ -r $file ] 返回 true。  |
| -w file | 检测文件是否可写，如果是，则返回 true。                      | [ -w $file ] 返回 true。  |
| -x file | 检测文件是否可执行，如果是，则返回 true。                    | [ -x $file ] 返回 true。  |
| -s file | 检测文件是否为空（文件大小是否大于0），不为空返回 true。     | [ -s $file ] 返回 true。  |
| -e file | 检测文件（包括目录）是否存在，如果是，则返回 true。          | [ -e $file ] 返回 true    |

### 1.7. echo命令

**输出普通字符串**

echo 用于输出字符串，单双引号的作用不同，单引号只输出文本，双引号中可以输出变量，并且双引号也可以省去

```sh
name="imjianjian"
echo 'my name is $name'
echo "my name is $name"
echo my name is $name
```

输出为：

```sh
my name is $name
my name is imjianjian
my name is imjianjian
```

**输出转义字符**

```sh
echo "\"hello world\""
```

输出

```sh
"hello world"
```

**换行/不换行**

```sh
# -e 开启转义
:<<EOF
\n 换行
\c 不换行
EOF
echo -e "hello world! \n" 
echo -e "hello world! \c" 
```

**输出定向到文件**

```sh
echo "hello world" > testFile
```

### 1.8. printf命令

和echo相比，printf模仿了c语言中的printf()方法，所以移植性更好。printf支持用格式化字符串，定制字符床宽度，对齐等。

**语法**

```sh
printf string [argument]
```

- string 为字符串
- argument 为参数列表

**格式替代符**

在字符串中使用格式替换符占位，然后通过参数来对应带入，并最终输出对应字符串

```sh
printf "%-10s %-8s %-6s\n" 姓名 性别 身高
```

格式替换符有%s,%d,%c,%f等
%s是替代字符串，-为左对齐，不写则是右对齐。10表示字符串将会在10个字符以内的宽度上显示，不足则会用空格占满，炒出的也会正常显示

**转义字符**

| 序列                      | 说明                                                         |
| ------------------------- | ------------------------------------------------------------ |
| \a                        | 警告字符，通常为ASCII的BEL字符                               |
| \b                        | 后退                                                         |
| \c                        | 抑制（不显示）输出结果中任何结尾的换行字符（只在%b格式指示符控制下的参数字符串中有效），而且，任何留在参数里的字符、任何接下来的参数以及任何留在格式字符串中的字符，都被忽略 |
| \f                        | 换页（formfeed）                                             |
| \n                        | 换行                                                         |
| \r                        | 回车（Carriage return）                                      |
| \t                        | 水平制表符                                                   |
| \v                        | 垂直制表符                                                   |
| \| 一个字面上的反斜杠字符 |                                                              |
| \ddd                      | 表示1到3位数八进制值的字符。仅在格式字符串中有效             |
| \0ddd                     | 表示1到3位的八进制值字符                                     |

### 1.9. test命令

test命令用于检测某个条件是否成立，可以用来进行数值比较，字符比较，文件等测试。成立则返回true，否则返回false。

> test -eq

**数值测试**

| 参数 | 说明           |
| ---- | -------------- |
| -eq  | 等于则为真     |
| -ne  | 不等于则为真   |
| -gt  | 大于则为真     |
| -ge  | 大于等于则为真 |
| -lt  | 小于则为真     |
| -le  | 小于等于则为真 |

**字符测试**

| 参数      | 说明                     |
| --------- | ------------------------ |
| =         | 等于则为真               |
| !=        | 不相等则为真             |
| -z 字符串 | 字符串的长度为零则为真   |
| -n 字符串 | 字符串的长度不为零则为真 |

**文件测试**

| 参数      | 说明                                 |
| --------- | ------------------------------------ |
| -e 文件名 | 如果文件存在则为真                   |
| -r 文件名 | 如果文件存在且可读则为真             |
| -w 文件名 | 如果文件存在且可写则为真             |
| -x 文件名 | 如果文件存在且可执行则为真           |
| -s 文件名 | 如果文件存在且至少有一个字符则为真   |
| -d 文件名 | 如果文件存在且为目录则为真           |
| -f 文件名 | 如果文件存在且为普通文件则为真       |
| -c 文件名 | 如果文件存在且为字符型特殊文件则为真 |
| -b 文件名 | 如果文件存在且为块特殊文件则为真     |

### 1.10. 流程控制

**if**

```sh
if condition
then
    ...command
fi
```

**if…else**

```sh
if condition
then
    ...command
else
    ...command
fi
```

**if else-if else**

```sh
if condition
then
    ...command
elif condition
then 
    ...command
else
    ...command
fi
```

**for**

```sh
for var in item1 item2 ... itemN
do
    ...command
done
```

**while**

```sh
while condition
do
    command
done
```

**until**

```sh
until condition
do
    command
done
```

**case**

```sh
case 值 in
模式1)
    command1
    command2
    ...
    commandN
    ;;
模式2）
    command1
    command2
    ...
    commandN
    ;;
esac
```

和大部分语言一样，可以支持使用**break**和**contiune**,来跳出循环

### 1.11. 函数

**语法**

```sh
[function] functionName[()]
{
    ....
    return ....
}
```

**参数列表**

与文件传参类似，函数也是使用相同的语法来传参，取参

```sh
test(){
    echo 第一个参数为$1
    echo 第二个参数为$2
    ...
    ...
    ...
    echo 第10个参数为${10}
    echo 参数共有$#个
    echo 输出所有参数 $* 
}
```

当参数大于10时，参数需要用${n}来获取

**函数调用**

```sh
sun(){
    return `expr $1 + $2`
}

#调用
sun 1 2
echo $?
```

点用函数后，结果通过**$?**来获得

### 1.12. 输入输出重定向

bash一般会将输入和所产生的输出都发送到终端，如果要将其输出到其他位置，则需要重定向

**重定向命令**

| 命令            | 说明                                               |
| --------------- | -------------------------------------------------- |
| command > file  | 将输出重定向到 file。                              |
| command < file  | 将输入重定向到 file。                              |
| command >> file | 将输出以追加的方式重定向到 file。                  |
| n > file        | 将文件描述符为 n 的文件重定向到 file。             |
| n >> file       | 将文件描述符为 n 的文件以追加的方式重定向到 file。 |
| n >& m          | 将输出文件 m 和 n 合并。                           |
| n <& m          | 将输入文件 m 和 n 合并。                           |
| << tag          | 将开始标记 tag 和结束标记 tag 之间的内容作为输入。 |

**输出重定向**

```sh
command1 > file11
```

例如：

```sh
# 将历史命令输出到history.txt文件中
history > history.txt12
```

**输出重定向**

```sh
command1 < file11
```

例如：

```sh
# 统计users文件的行数
wc -l < users12
```

**/dev/null**

```sh
# 所有被重定向到/dev/null的文件都会被丢弃，可以起到禁止任何输出的作用。
# 可以理解为自动清理的垃圾桶
command > /dev/null123
```

### 1.13. 文件引用

和其它语言一样，bash也可以引用外部文件。这样可以把一些公共代码封装到一个独立的文件中。

**引用方式**

```sh
#.和文件名中要有一个空格
. filename 
或
source filename
```



## 2. 好用的脚本片段

### 2.1. shell 脚本 cd 到当前脚本所在目录

```sh
#!/bin/sh

cd `dirname $0`
```

dirname命令的作用是？ `man dirname`得到如下解释：

> dirname - strip last component from file name

通俗来说就是去掉提供的文件名或目录的最后一部分，包括 /。例子如下：
![dirname命令的作用](https://cdn.jsdelivr.net/gh/guoshunfa/pandacode-files/blog/202111161818055.png)

问题

## 参考文档

- [base shell 语法笔记](https://blog.csdn.net/JianJianJianJianDe/article/details/81447987)

- [shell脚本实现ssh自动登录远程服务器示例](https://www.cnblogs.com/lqyye/p/7224268.html)
- [linux expect的使用](https://www.jianshu.com/p/b987f5e92c03)

