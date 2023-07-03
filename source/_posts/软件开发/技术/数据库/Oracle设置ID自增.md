---
title: Oracle 设置ID自增
tags:
  - oracle
categories:
  - 技术
date: 2022-07-01 12:01:01
thumbnail:
---

## 1. 先有个表

```sql
# 首先得有个表
create table t_user(
user_id number not null primary key,
user_name varchar2(30),
credits number,
user_password varchar2(32),
last_visit date,
last_ip varchar2(23)
)
```

## 2. 创建一个序列

> 转载自：https://blog.csdn.net/jiejie5945/article/details/44198283

```sql
# 为这个表创建序列
create sequence T_USER_SEQ
minvalue 1
maxvalue 999999999999999999999999999
start with 21
increment by 1
cache 20;
```

参数描述：

- `create sequence seq_name`：创建序列，`seq_name`为序列名称

- `minvalue`：自增最小值，缺省值为nominvalue，即不设置最小值。

- `maxvalue`：自增最大值，缺省值为nomaxvalue，即不设置最大值；系统能产生的最大值为10的27次方。

- `start with`：自增开始值，设置成21则从21开始自增。

- `increment by`：自增数值，设置成1则每次递增1，负数表示递减，缺省值为1。

- `cache`：定义缓存序列的个数，缺省值为20，nocache表示不设置缓存；使用缓存可以提高序列的性能，但数据库出错时会造成数据丢失使序列不连续。

- `NOCYCLE`：一直累加，不循环
- `cycle`：定义当序列达到最大/小值后是否循环，缺省值为不循环；`nocycle`：不循环；**`cycle`**：循环；如果不使用循环达到限制值后继续产生新值就会出错；使用循环达到最大值后的下一个值为1，和**`start`** **`with`**设置的值无关，递增还是`increment` **`by`**设置的值；

### 2.1. 序列详细描述

一旦定义了`emp_sequence`，你就可以用`CURRVAL`，`NEXTVAL`
`CURRVAL` = 返回`sequence`的当前值
`NEXTVAL` = 增加`sequence`的值，然后返回`sequence`值
比如：
`emp_sequence.CURRVAL`
`emp_sequence.NEXTVAL`

可以使用`sequence`的地方：

- 不包含子查询、`snapshot`、`VIEW`的 `SELECT` 语句
- `INSERT`语句的子查询中
- `NSERT`语句的`VALUES`中
- `UPDATE` 的 `SET`中

可以看如下例子： 

```sql
INSERT INTO emp VALUES
(empseq.nextval, 'LEWIS', 'CLERK',7902, SYSDATE, 1200, NULL, 20); 

SELECT empseq.currval FROM DUAL; 
```

但是要注意的是： 

- 第一次`NEXTVAL`返回的是初始值；随后的`NEXTVAL`会自动增加你定义的`INCREMENT BY`值，
  然后返回增加后的值。`CURRVAL` 总是返回当前`sequence`的值，但是在第一次`NEXTVAL`
  初始化之后才能使用`CURRVAL`，否则会出错。一次`NEXTVAL`会增加一次`sequence`的值，
  所以如果你在同一个语句里面使用多个`NEXTVAL`，其值就是不一样的。明白？ 
- 如果指定`CACHE`值，`oracle`就可以预先在内存里面放置一些`sequence`，这样存取的快
  些。
- `cache`里面的取完后，`oracle`自动再取一组到`cache`。 使用`cache`或许会跳号， 比如
  数据库突然不正常`down`掉（`shutdown abort`),`cache`中的`sequence`就会丢失. 所以可
  以在`create sequence`的时候用`nocache`防止这种情况。 

### 2.2. 调整序列

你或者是该`sequence`的`owner`，或者有`ALTER ANY sequence`权限才能改动`sequence`。 可
以`alter`除`start`值之外的所有`sequence`参数。如果想要改变`start`值，必须`drop sequence`
再`re-create`。例子：

```sql
ALTER sequence emp_sequence
INCREMENT BY 10
MAXVALUE 10000
CYCLE -- 到10000后从头开始
NOCACHE;
```

影响`sequence`的初始化参数： 
`sequence_CACHE_ENTRIES =`
设置能同时被`cache`的`sequence`数目。 

可以很简单的`Drop sequence `
`DROP sequence order_seq; `

## 3.  创建一个触发器

```sql
create or replace trigger t_user_tr
before insert on t_user
for each row
begin
select t_user_seq.nextval into :new.user_id from dual;
end t_user_tr;
```

**参数描述：**

- `t_user_tr`: 随意的名字，不要重复就行
- `t_user`: 表名
- `user_id` ：自增的id

**删除触发器：**

```sql
DROP TRIGGER trigger_name;
```

**参数描述**

- *trigger_name*：要删除的触发器的名称。

## 4. 测试

```sql
insert into t_user values(null,'xiaoming',123,'1114',sysdate,'192.168.37.132');
insert into t_user values(null,'xiaoming1',123,'1114',sysdate,'192.168.37.132');
insert into t_user values(null,'xiaoming1',123,'1114',sysdate,'192.168.37.132');
insert into t_user values(null,'xiaoming1',123,'1114',sysdate,'192.168.37.132');
insert into t_user values(null,'xiaoming2',123,'1114',sysdate,'192.168.37.132');
insert into t_user values(null,'xiaoming',123,'1114',sysdate,'192.168.37.132');
insert into t_user values(null,'xiaoming',123,'1114',sysdate,'192.168.37.132');
insert into t_user values(null,'xiaoming',123,'1114',sysdate,'192.168.37.132');
insert into t_user values(null,'xiaoming',123,'1114',sysdate,'192.168.37.132');
insert into t_user values(null,'xiaoming',123,'1114',sysdate,'192.168.37.132');

select * from t_user
```

## 参考文章

- https://blog.csdn.net/qq_42055933/article/details/117401672
- [oracle如何实现ID自增长](https://blog.csdn.net/QingXu1234/article/details/116048728)
