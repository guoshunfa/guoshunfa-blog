---
title: Oracle存储过程与存储函数
tags:
  - oracle
  - 存储过程
  - 存储函数
categories:
  - 技术
date: 2022-07-01 11:03:53
thumbnail:
---
## 一. 存储过程和存储函数的定义

- **定义：**存储在数据库中，供所有用户程序调用的**子程序**叫做存储过程/存储函数。

  **复杂点的解释：**存储过程(Stored Procedure)，就是一组用于完成特定数据库功能的**SQL 语句集**，该SQL语句集经过编译后存储在数据库系统中。在使用时候，用户通过指定已经定义的存储过程名字并给出相应的存储过程参数来调用并执行它，从而完成一个或一系列的数据库操作。

- **区别：**是否可以通过return返回函数值。
  存储函数可以通过return返回函数值；而存储过程不可以。

- **注意点：**由于通过**out**参数，存储过程也可以返回函数值，所以存储过程和存储函数已经没有太大的区别了。而存储函数仍然存在，是由于oracle不断升级，需要实现向下兼容，所以存储函数就一直存留着。

## 二. 存储过程

### 1. 创建和使用存储过程

用**create procedure**命令建立存储过程，语法如下：

```csharp
create [or replace] procedure 过程名(参数列表)
as   -- as不可以省略
PLSQL子程序体;
```

**注意事项：**

1. 存储过程或者存储函数，只能创建或者替换 。
2. 参数可以带也可以不带。
3. **as**相当于PLSQL语句中的declare，用来声明变量、游标等，但是**不可以省略**。

### 2. 入门案例

#### （1）不带参数的存储过程:不用带括号

```csharp
create or replace procedure sayHello
as
begin
   dbms_output.put_line('HelloWorld');
end;
/
```

**调用方式：**

- <1> 使用execute：
  **exec**是sqlplus命令，**只能在sqlplus中使用**，使用时，exec可以直接跟过程名（可以省略括号）；
  控制台执行示例:

```bash
SQL> set serveroutput on;
SQL> exec sayHello;
```

- <2> 使用call：
  **使用call时，要带上括号**;call为SQL命令使用时，对场景没有限制。
  控制台执行示例:

```csharp
SQL> set serveroutput on;
SQL> call sayHello();
```

- <3> 使用PLSQL语句调用：
  控制台执行示例:

```csharp
SQL> set serveroutput on;
SQL> begin
         sayHello;
    end;
/
```

#### （2）带参数的存储过程:

- 给指定的员工涨100元工资,并且打印涨前和涨后的薪水:

```csharp
create or replace procedure addSal(pempno in emp.empno%type)
as
    pename emp.ename%type;
    beforesal emp.sal%type;
    aftersal emp.sal%type;
begin
    select ename,sal into pename,beforesal from emp where empno=pempno;
    aftersal:=beforesal+100;
    update emp set sal=aftersal where empno=pempno; 
    dbms_output.put_line('姓名: '||pename||' 涨前工资:'||beforesal||'涨后工资:'||aftersal);
end;
/
```

```shell
SQL> set serveroutput on;
SQL> begin
	2	 addSal(7782);
	3	 addSal(7788);
	4  commit;
	5  end;
	6  /
姓名：CLARK 涨前工资:7608.87 涨后工资:7708.87
姓名：SCOTT 涨前工资:7263.4 涨后工资:7363.4
```

**注意事项：**

- <1> **要说明**，参数是输入参数(in)还是输出参数(out)；
- <2> 为保证调用多个存储过程中处在同一个事务中，所以一般不在存储过程或者存储函数中，commit或rollback；

## 三. 存储函数

### 1. 存储函数

- 函数(Function)为一命名的存储程序,可带参数,并返回一计算值.
- 函数和过程的结构类似,但必须有一个return子句,用于返回函数值.

### 2. 创建存储函数的语法

```kotlin
create [or replace] function 函数名(参数列表)
return 函数值类型
as
PLSQL子程序体;
```

**注意事项:**

- (1) 与存储过程注意事项类似,不同的是,**必须有个返回值**;
- (2) 参数列表可以有,也可以没有.当没有时,函数名后面不要带括号.

```rust
create or replace function queryempannal(pempno in number)
return number
as
  psal emp.sal%type;
  pcomm emp.comm%type;
begin
  select sal,comm into psal,pcomm from emp where empno=pempno;
  return psal*12+nvl(pcomm,0);
end;
```

## 四. in和out参数

### 1.概述

- (1) 一般来讲,存储过程和存储函数的区别在于存储函数可以有一个返回值;而存储过程没有返回值.
- (2) 过程和函数都可以通过out指定一个或多个输出参数.我们可以利用out参数,在过程和函数中实现返回多个值.
    - a. 存储过程和存储函数都可以有out参数;
    - b. 存储过程和存储函数都可以有多个out参数;
    - c. 存储过程可以通过out参数来实现返回值;
- (3) 什么时候用存储过程/存储函数?
    - 原则:如果只有一个返回值,用存储函数;否则,就用存储过程.

```csharp
create or replace procedure queryempinform(eno in number,
                                           pename out varchar2,
                                           psal out number,
                                           pjob out varchar2 )
as
begin
  select ename,sal,job into pename,psal,pjob from emp where empno=eno;
end;
/
```

## 五. 案例

### blob类型转换成clob类型

#### 存储函数

```sql
CREATE OR REPLACE FUNCTION blob_to_clob2 (blob_in IN BLOB)
RETURN CLOB
AS
	v_clob    CLOB;
	v_varchar VARCHAR2(32767);
	v_start	 PLS_INTEGER := 1;
	v_buffer  PLS_INTEGER := 32767;
BEGIN
 DBMS_LOB.CREATETEMPORARY(v_clob, TRUE);
 if DBMS_LOB.GETLENGTH(blob_in) is null then
        return empty_clob();
 end if;
	FOR i IN 1..CEIL(DBMS_LOB.GETLENGTH(blob_in) / v_buffer)
	LOOP
	  v_varchar := UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(blob_in, v_buffer, v_start));
           DBMS_LOB.WRITEAPPEND(v_clob, LENGTH(v_varchar), v_varchar);
		v_start := v_start + v_buffer;
	END LOOP;
  RETURN v_clob;
END blob_to_clob2;
```

#### 存储函数使用

```sql
# 使用场景一：表中存在两个字段，一个字段类型为blob，一个字段类型为clob。将blob类型的字段进行转换，并存入clob字段中。
UPDATE 表名 set clob字段名 = blob_to_clob2(blob字段名)
```

### blob类型转换成varchar类型

#### 存储函数

```sql
create or replace FUNCTION blob_to_varchar (blob_in IN BLOB) 
RETURN VARCHAR2 
IS 

v_varchar VARCHAR2(4000); 
v_start PLS_INTEGER := 1; 
v_buffer PLS_INTEGER := 4000; 

BEGIN 
 --select userenv('LANGUAGE') into g_nls_db_char from dual; 
 if DBMS_LOB.GETLENGTH(blob_in) is null then
        return empty_clob();  
 end if;
 DBMS_OUTPUT.put_line('TEST:' || CEIL(DBMS_LOB.GETLENGTH(blob_in)));
 --DBMS_LOB.CREATETEMPORARY(v_clob, TRUE); 
 FOR i IN 1..CEIL(DBMS_LOB.GETLENGTH(blob_in) / v_buffer) 
 LOOP 
 v_varchar := UTL_RAW.CAST_TO_VARCHAR2(utl_raw.convert(DBMS_LOB.SUBSTR(blob_in, v_buffer, v_start),'SIMPLIFIED CHINESE_CHINA.ZHS16GBK', 'AMERICAN_THE NETHERLANDS.UTF8'));
 --DBMS_LOB.WRITEAPPEND(v_clob, LENGTH(v_varchar), v_varchar); 
 v_start := v_start + v_buffer; 
 END LOOP; 
 --DBMS_OUTPUT.put_line(v_varchar);
 RETURN v_varchar; 
end blob_to_varchar;
```

#### 存储函数使用

```sql
# 使用场景一：表中存在两个字段，一个字段类型为blob，一个字段类型为varchar。将blob类型的字段进行转换，并存入varchar字段中。
UPDATE 表名 set varchar字段名 = blob_to_varchar(blob字段名)
```

### blob类型通过base64加密

#### 存储函数

```sql
CREATE  OR  REPLACE  FUNCTION  base64encode(p_blob IN BLOB)
   RETURN  CLOB
IS
   l_clob CLOB;
   l_step PLS_INTEGER := 12000;
BEGIN
   FOR  i  IN  0 .. TRUNC((DBMS_LOB.getlength(p_blob) - 1 )/l_step) LOOP
     l_clob := l_clob || UTL_RAW.cast_to_varchar2(UTL_ENCODE.base64_encode(DBMS_LOB.substr(p_blob, l_step, i * l_step + 1)));
   END  LOOP;
   RETURN  l_clob;
END ;
/
```

## 参考文档

- [Oracle存储过程与存储函数-入门](https://www.jianshu.com/p/be6d1bbebd03)
- [blob转clob和varchar2](https://codeantenna.com/a/o0AyRF3Ipp)
- [Oracle的存储过程基本写法](https://blog.csdn.net/c851204293/article/details/104915395)
