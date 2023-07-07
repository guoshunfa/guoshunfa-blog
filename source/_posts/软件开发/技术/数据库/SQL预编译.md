---
title: SQL预编译
tags:
  - SQL
categories:
  - 数据库
date: 2022-07-01 12:01:01
thumbnail:
---


> 作者：嘻洋洋
> 链接：https://www.jianshu.com/p/9972d7b33061
> 来源：简书
> 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。

## 数据库预编译起源

（1）数据库SQL语句编译特性：
 数据库接受到sql语句之后，需要词法和语义解析，优化sql语句，制定执行计划。这需要花费一些时间。但是很多情况，我们的一条sql语句可能会反复执行，或者`每次执行的时候只有个别的值不同`（比如query的where子句值不同，update的set子句值不同,insert的values值不同）。
 （2）减少编译的方法
 如果每次都需要经过上面的词法语义解析、语句优化、制定执行计划等，则效率就明显不行了。为了解决上面的问题，于是就有了预编译，预编译语句就是将这类语句中的`值用占位符替代`，可以视为将`sql语句模板化或者说参数化`。一次编译、多次运行，省去了解析优化等过程。
 （3）缓存预编译
 预编译语句被DB的编译器编译后的执行代码被缓存下来,那么下次调用时只要是相同的预编译语句就不需要编译,只要将参数直接传入编译过的语句执行代码中(相当于一个涵数)就会得到执行。
 `并不是所以预编译语句都一定会被缓存`,数据库本身会用一种策略（内部机制）。
 (4) 预编译的实现方法
 预编译是通过PreparedStatement和占位符来实现的。

## 预编译作用

- 预编译阶段可以优化 sql 的执行
   预编译之后的 sql 多数情况下可以直接执行，DBMS 不需要再次编译，越复杂的sql，编译的复杂度将越大，预编译阶段可以合并多次操作为一个操作。可以提升性能。
- 防止SQL注入
   使用预编译，而其后注入的参数将`不会再进行SQL编译`。也就是说其后注入进来的参数系统将不会认为它会是一条SQL语句，而默认其是`一个参数`，参数中的or或者and 等就不是SQL语法保留字了。

## 预编译开启

（1）数据库是否默认开启预编译和JDBC版本有关。
 也可以配置jdbc链接时强制开启预编译和缓存:useServerPrepStmts和cachePrepStmts参数。预编译和预编译缓存一定要同时开启或同时关闭。否则会影响执行效率



```bash
conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/prepare_stmt_test?user=root&password=root&useServerPrepStmts=true&cachePrepStmts=true");  
```

（2）mysql的预编译

- 开启了预编译缓存后，connection之间，预编译的结果是独立的，是无法共享的，一个connection无法得到另外一个connection的预编译缓存结果。
- 经过试验，mysql的预编译功能对性能影响不大，但在jdbc中使用PreparedStatement是必要的，可以有效地防止sql注入。
- 相同PreparedStatement的对象 ，可以不用开启预编译缓存。



```csharp
          conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/prepare_stmt_test?user=root&password=root&useServerPrepStmts=true");  
          PreparedStatement stmt = conn.prepareStatement(sql);  
          stmt.setString(1, "aaa");  
          ResultSet rs1 = stmt.executeQuery();//第一次执行  
          s1.close();  
          stmt.setString(1, "ddd");  
          ResultSet rs2 = stmt.executeQuery();//第二次执行  
          rs2.close();  
          stmt.close(); 
//查看mysql日志
          1 Prepare          select * from users where name = ?
          1 Execute          select * from users where name = 'aaa'
          1 Execute          select * from users where name = 'ddd'
```

## mybatis是如何实现预编译的

mybatis 默认情况下，将对所有的 sql 进行预编译。mybatis底层使用PreparedStatement，过程是先将带有占位符（即”?”）的sql模板发送至mysql服务器，由服务器对此无参数的sql进行编译后，将编译结果缓存，然后直接执行带有真实参数的sql。`核心是通过#{ } 实现的`。
 在预编译之前，#{ } 解析为一个 JDBC 预编译语句（prepared statement）的参数标记符?。



```csharp
//sqlMap 中如下的 sql 语句
select * from user where name = #{name};
//解析成为预编译语句
select * from user where name = ?;
```

如果${ }，SQL 解析阶段将会进行变量替换。不能实现预编译。



```csharp
select * from user where name = '${name}'
//传递的参数为 "ruhua" 时,解析为如下，然后发送数据库服务器进行编译。
select * from user where name = "ruhua";
```

