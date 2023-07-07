---
title: SQL命令记录
tags:
  - SQL
  - Mysql
  - Oracle
categories:
  - 数据库
date: 2022-07-01 10:59:08
thumbnail:
---

> 前往[菜鸟教程](https://www.runoob.com/sql/sql-tutorial.html)。
>
> 命令行连接数据库方式：
>
> ​	打开终端输入```mysql -uroot -p```，随后输入密码。
>
> ​	root可替换成其他用户名。

## 1. sql 主要命令描述

> 所有 MySQL 命令的列表：注意，所有文本命令必须在一行的开头，并且以分号“;”结束
>
> | 命令                                          | 缩写 | 命令说明                                                     | 示例                                 |
> | --------------------------------------------- | ---- | ------------------------------------------------------------ | ------------------------------------ |
> | ?                                             | ?    | “help”的同义词。                                             | mysql> ?                             |
> | clear                                         | c    | 清除当前输入的语句。一般用于多行命令。                       | mysql> c                             |
> | connect                                       | r    | 重新连接到服务器。可选参数是 db 和 host。连接 ID 将会改变。  | mysql> r                             |
> | mysql> r [数据库] [主机]                      |      |                                                              |                                      |
> | delimiter                                     | d    | 设置语句定界符。默认为“;”。                                  | mysql> d 定界符                      |
> | ego                                           | G    | 发送命令到 MySQL 服务器，垂直显示结果。                      | mysql> SHOW DATABASESG               |
> | exit                                          | q    | 退出 MySQL。与 quit 相同。                                   | mysql> exit                          |
> | go                                            | g    | 发送命令到 MySQL 服务器。                                    | mysql> SELECT \`id\` FROM \`table\`g |
> | help                                          | h    | 显示该帮助信息。                                             | mysql> h                             |
> | notee                                         | t    | 不要写到 outfile 中。                                        | mysql> notee                         |
> | print                                         | p    | 打印当前命令。                                               | mysql> SHOW TABLESp;                 |
> | prompt                                        | R    | 改变你的 MySQL 提示符。                                      | mysql> prompt -->                    |
> | quit                                          | q    | 退出 MySQL。                                                 | mysql> q                             |
> | rehash                                        | #    | 重建完整的 hash（用于自动完成名称）。                        | mysql> #                             |
> | source                                        | .    | 执行一个 SQL 脚本文件。使用一个文件名作为参数。              | mysql> source D:my.sql               |
> | status                                        | s    | 从服务器取得状态信息。                                       | mysql> status                        |
> | tee                                           | T    | 设置 outfile 为 [to_outfile]。向已给出的 outfile 文件中追加所有东西。 | mysql> tee E:store.txt               |
> | use                                           | u    | 使用另一个数据库。使用一个数据库名作为参数。                 | mysql> use 数据库                    |
> | charset                                       | C    | 切换到其它字符集。可能需要使用多字节字符集来处理二进制日志。 | mysql> charset 字符集                |
> | warnings                                      | W    | 在每一个语句后面显示警告。                                   | mysql> W                             |
> | nowarning                                     | w    | 不在每一个语句后面显示警告。                                 | mysql> w                             |
> | 要获得服务器端的帮助信息，键入“help contents” |      |                                                              |                                      |

### 1.1. 数据库操作

创建数据库：`CREATE DATABASE database_name;`

删除数据库：`DROP DATABASE database_name`

### 1.2. 数据库表操作

> CREATE TABLE 语句用于创建数据库中的表。
>
> 表由行和列组成，每个表都必须有个表名。

```sql
CREATE TABLE table_name
(
column_name1 data_type(size),
column_name2 data_type(size),
column_name3 data_type(size),
....
);
```

column_name 参数规定表中列的名称。

data_type 参数规定列的数据类型（例如 varchar、integer、decimal、date 等等）。

size 参数规定表中列的最大长度。

**提示：**如需了解 MS Access、MySQL 和 SQL Server 中可用的数据类型，请访问我们完整的 [数据类型参考手册](https://www.runoob.com/sql/sql-datatypes.html)。

#### 1.2.1. [SQL约束（Constraints）](https://www.runoob.com/sql/sql-constraints.html)

> 不同数据库的约束不同，详细查看[菜鸟教程](https://www.runoob.com/sql/sql-constraints.html)的API描述。

SQL 约束用于规定表中的数据规则。

如果存在违反约束的数据行为，行为会被约束终止。

约束可以在**创建表**时规定（通过 CREATE TABLE 语句），或者在**表创建之后**规定（通过 ALTER TABLE 语句）。

```sql
CREATE TABLE table_name
(
column_name1 data_type(size) constraint_name,
column_name2 data_type(size) constraint_name,
column_name3 data_type(size) constraint_name,
....
);
```

在 SQL 中，我们有如下约束：

- **NOT NULL** - 指示某列不能存储 NULL 值。
- **UNIQUE** - 保证某列的每行必须有唯一的值。
- **PRIMARY KEY** - 主键，NOT NULL 和 UNIQUE 的结合。确保某列（或两个列多个列的结合）有唯一标识，有助于更容易更快速地找到表中的一个特定的记录。
- **FOREIGN KEY** - 外键，保证一个表中的数据匹配另一个表中的值的参照完整性。
- **CHECK** - 保证列中的值符合指定的条件。
- **DEFAULT** - 规定没有给列赋值时的默认值。

#### 1.2.2. 索引

您可以在表中创建索引，以便更加快速高效地查询数据。

用户无法看到索引，它们只能被用来加速搜索/查询。

**注释：**更新一个包含索引的表需要比更新一个没有索引的表花费更多的时间，这是由于索引本身也需要更新。因此，理想的做法是仅仅在常常被搜索的列（以及表）上面创建索引。

**SQL CREATE INDEX 语法**

在表上创建一个简单的索引。允许使用重复的值：

CREATE INDEX index_name
ON table_name (column_name)

**SQL CREATE UNIQUE INDEX 语法**

在表上创建一个唯一的索引。不允许使用重复的值：唯一的索引意味着两个行不能拥有相同的索引值。Creates a unique index on a table. Duplicate values are not allowed:

CREATE UNIQUE INDEX index_name
ON table_name (column_name)

**注释：**用于创建索引的语法在不同的数据库中不一样。因此，检查您的数据库中创建索引的语法。



## 2. crud

### 2.1. 查询

| 命令                                                         | 命令说明                                                     | 命令示例                                                     |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| **SELECT**                                                   | 查询语句头。                                                 | **SELECT** column_name <br>**FROM** table_name;              |
| [**SELECT DISTINCT**](#_2-1-1-select-distinct语法)           | 查询DISTINCT 关键词用于返回唯一不同的值。                    | **SELECT** **DISTINCT** column_name,column_name <br>**FROM** table_name; |
| [**WHERE**](#_2-1-2-where-条件查询相关语法)                  | 条件查询。下面会梳理出和WHERE搭配使用的语法。                | **SELECT** column_name,column_name <br>**FROM** table_name <br>**WHERE** column_name operator value; |
| **ORDER BY**                                                 | 排序。指定列进行排序(ASC)，默认为升序。添加DESC可调整成倒序。 | **SELECT** column_name,column_name <br/>**FROM** table_name <br/>**ORDER BY** column_name,*column_name* **ASC\|DESC**; |
| **LIMIT**                                                    | 返回指定数目的数据。常用于分页查询。                         | **SELECT** column_name<br/>**FROM** *table_name*<br/>**LIMIT** *number*; |
| [**JOIN**](#_2-1-4- SQL-JOIN)                                | 多表连查，SQL join 用于把来自两个或多个表的行结合起来。      | **SELECT** Websites.id, Websites.name, access_log.count, access_log.date<br/>**FROM** Websites<br/>**INNER JOIN** access_log<br/>**ON** Websites.id=access_log.site_id; |
| **UNION** \| **UNION ALL**                                   | SQL UNION 操作符合并两个或多个 SELECT 语句的结果。**UNION 操作符选取不同的值。如果允许重复的值，请使用 UNION ALL。**<br>支持使用WHERE、JOIN等操作符。 | **SELECT** *column_name(s)* FROM *table1*<br/>**UNION**<br/>**SELECT** *column_name(s)* FROM *table2*; |
| [**SELECT INTO**](https://www.runoob.com/sql/sql-select-into.html) | 通过 SQL，您可以从一个表复制信息到另一个表。SELECT INTO 语句从一个表复制数据，然后把数据插入到另一个新表中。<br>支持使用WHERE、JOIN等操作符。<br>MYSQL不支持，但支持INSERT INTO.... SELECT。 | **SELECT** *column_name(s)*<br/>**INTO** *newtable* [IN *externaldb*]<br/>**FROM** *table1;* |
| [**INSERT INTO SELECT**](https://www.runoob.com/sql/sql-insert-into-select.html) | 通过 SQL，您可以从一个表复制信息到另一个表。INSERT INTO SELECT 语句从一个表复制数据，然后把数据插入到一个已存在的表中。目标表中任何已存在的行都不会受影响。 | **INSERT** **INTO** table2<br/>(column_name(s))<br/>**SELECT** column_name(s)<br/>**FROM** table1; |
|                                                              |                                                              |                                                              |
|                                                              |                                                              |                                                              |
|                                                              |                                                              |                                                              |
|                                                              |                                                              |                                                              |
|                                                              |                                                              |                                                              |
|                                                              |                                                              |                                                              |
|                                                              |                                                              |                                                              |
|                                                              |                                                              |                                                              |
|                                                              |                                                              |                                                              |

#### 2.1.1. SELECT DISTINCT语法

下面是选自 "Websites" 表的数据：

```
+----+--------------+---------------------------+-------+---------+
| id | name         | url                       | alexa | country |
+----+--------------+---------------------------+-------+---------+
| 1  | Google       | https://www.google.cm/    | 1     | USA     |
| 2  | 淘宝          | https://www.taobao.com/   | 13    | CN      |
| 3  | 菜鸟教程      | http://www.runoob.com/    | 4689  | CN      |
| 4  | 微博          | http://weibo.com/         | 20    | CN      |
| 5  | Facebook     | https://www.facebook.com/ | 3     | USA     |
+----+--------------+---------------------------+-------+---------+
```

输入：

```sql
SELECT DISTINCT country FROM Websites;
```

输出：

```
+---------+
| country |
+---------+
| USA     |
| CN      |
+---------+
```

#### 2.1.2. WHERE 条件查询相关语法

| 操作符                       | 操作符描述                                                   | 示例                                                         |
| ---------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| **AND**                      | 查询出两个条件都满足的记录。                                 | **SELECT** column_name,column_name <br>**FROM** table_name <br>**WHERE** column_name operator value <br>**and** column_name operator value; |
| **OR**                       | 查询出两个条件有一个满足就可以的记录                         | **SELECT** column_name,column_name <br/>**FROM** table_name <br/>**WHERE** column_name operator value <br>**or** column_name operator value; |
| **LIKE** \| **NOT LIKE**     | 模糊查询。<br>**LIKE**:取匹配的数据;<br>**NOT LIKE**:取不匹配的数据;<br>通过[通配符](#_2-1-3-通配符)`-`、`%`操控模糊查询部分。 | **SELECT** *column_name(s)*<br/>**FROM** *table_name*<br/>**WHERE** *column_name* <br>**LIKE \| NOT LIKE**  *pattern*; |
| **REGEXP** \| **NOT REGEXP** | 正则查询。<br/>**REGEXP**:取匹配的数据;<br/>**NOT REGEXP**:取不匹配的数据;<br/>通过[通配符](#_2-1-3-通配符)`[charlist]`操控模糊查询部分。 | **SELECT** *column_name(s)*<br/>**FROM** *table_name*<br/>**WHERE** *column_name* <br>**REGEXP** \| **NOT REGEXP** pattern; |
| **IN**                       | IN 操作符允许您在 WHERE 子句中规定多个值。                   | **SELECT** *column_name(s)*<br/>**FROM** *table_name*<br/>**WHERE** *column_name* **IN** (*value1*,*value2*,...); |
| **BETWEEN**                  | BETWEEN 操作符用于选取介于**两个值之间的数据范围内的值**。这些值可以是数值、文本或者日期。 | **SELECT** *column_name(s)*<br/>**FROM** *table_name*<br/>**WHERE** *column_name* <br>**BETWEEN** *value1* **AND** *value2;* |
|                              |                                                              |                                                              |
|                              |                                                              |                                                              |
|                              |                                                              |                                                              |

#### 2.1.3. 通配符

| 通配符                         | 描述                       |
| :----------------------------- | :------------------------- |
| %                              | 替代 0 个或多个字符        |
| _                              | 替代一个字符               |
| [*charlist*]                   | 字符列中的任何单一字符     |
| [^*charlist*] 或 [!*charlist*] | 不在字符列中的任何单一字符 |

案例一：

```sql
# 查询url开头为https的数据。
SELECT * FROM Websites
WHERE url LIKE 'https%';
```

案例二：

```sql
# 查询url中包含oo的数据。
SELECT * FROM Websites
WHERE url LIKE '%oo%';
```

案例三：

```sql
# 选取 name 以一个任意字符开始，然后是 "oogle" 的所有客户
SELECT * FROM Websites
WHERE name LIKE '_oogle';
```

#### 2.1.4. SQL JOIN

<img src="https://file.pandacode.cn/blog/202207261033383.png" alt="img" style="zoom: 67%;" /> 

- **INNER JOIN**：如果表中有至少一个匹配，则返回行
- **LEFT JOIN**：即使右表中没有匹配，也从左表返回所有的行
- **RIGHT JOIN**：即使左表中没有匹配，也从右表返回所有的行
- **FULL JOIN**：只要其中一个表中存在匹配，则返回行

### 2.2. 新增

| 命令        | 命令描述 | 示例                                                         |
| ----------- | -------- | ------------------------------------------------------------ |
| INSERT INTO | 新增数据 | **INSERT INTO** *table_name* (*column1*,*column2*,*column3*,...)<br/>**VALUES** (*value1*,*value2*,*value3*,...); |



### 2.3. 修改

> **请注意 SQL UPDATE 语句中的 WHERE 子句！**
> WHERE 子句规定哪条记录或者哪些记录需要更新。如果您省略了 WHERE 子句，所有的记录都将被更新！

| 命令   | 命令描述 | 示例                                                         |
| ------ | -------- | ------------------------------------------------------------ |
| UPDATE | 修改数据 | **UPDATE** *table_name*<br/>**SET** *column1*=*value1*,*column2*=*value2*,...<br/>**WHERE** *some_column*=*some_value*; |

### 2.4. 删除

> **请注意 SQL DELETE 语句中的 WHERE 子句！**
> WHERE 子句规定哪条记录或者哪些记录需要删除。如果您省略了 WHERE 子句，所有的记录都将被删除！

| 命令   | 命令描述 | 示例                                                         |
| ------ | -------- | ------------------------------------------------------------ |
| DELETE | 删除数据 | DELETE FROM *table_name*<br/>WHERE *some_column*=*some_value*; |

### 2.5. 通用操作符

| 操作符 | 操作符描述     | 示例                                                         |
| ------ | -------------- | ------------------------------------------------------------ |
| **AS** | **SQL 别名**。 | **SELECT** t.column_name AS alias_name <br>**FROM** table_name AS t; |



## 参考文章

- [菜鸟教程](https://www.runoob.com/sql/sql-tutorial.html)
