---
title: MongoDB 命令记录
tags:
  - mongodb
  - 记录
  - 命令
categories:
  - 技术
date: 2022-07-01 11:37:06
thumbnail:
---
> 一下内容基于MongoDB 4.4.11版本。
>
> 命令行连接数据库方式：
>
> 1. 直接输入`mongo`。
> 2. `mongo mongodb://username:password@hostname/dbname`。例子：`mongo mongodb://admin:123456@123.1.2.3:12345/test01`

## 1. MongoDB 主要命令描述

> **这里直接通过help命令的放回内容进行记录。**
>
> 备注：这里描述的表、集合、文档，都是表达数据库表的意思。

### 1.1. help 命令

```shell
> help												 关于mongodb主要方法的帮助
	db.help()                    关于数据库方法的帮助
	db.mycoll.help()             关于数据库表方法的帮助
	sh.help()                    分片方法的帮助
	rs.help()                    副本集方法的帮助
	help admin                   行政帮助
	help connect                 连接到数据库的帮助
	help keys                    键的快捷方式
	help misc                    misc things to know
	help mr                      mapreduce（一种分布式并行编程模型）

	show dbs                     展示所有数据库的名称
	show collections             展示当前数据库的所有集合（表）名称
	show users                   展示当前数据库的所有用户
	show profile                 显示时间为>= 1ms的最近的system.profile条目
	show logs                    显示可访问的log名称
	show log [name]              打印出内存中日志的最后一段，global是默认值
	use <db_name>                设置当前数据库
	db.mycoll.find()             查询集合mycoll中所有的记录
	db.mycoll.find( { a : 1 } )  查询集合mycoll中的记录，只查询满足条件a=1的记录
	it                           最后一行求值的结果;用于进一步迭代（目前不知道在哪使用）
	DBQuery.shellBatchSize = x   设置shell上显示的项目的默认数量（目前不知道在哪使用）
	exit                         退出mongo shell
```

### 1.2. db.help() 命令

```shell
> db.help()
DB methods:
	db.adminCommand(nameOrDocument) - 切换到'admin' db，并运行命令 [只调用 db.runCommand(...)]（目前不知道在哪使用）
	db.aggregate([pipeline], {options}) - 对该数据库执行无集合聚合;返回一个指针（目前不知道在哪使用）
	db.auth(username, password)（目前不知道在哪使用）
	db.cloneDatabase(fromhost) - will only function with MongoDB 4.0 and below
	db.commandHelp(name) returns the help for the command
	db.copyDatabase(fromdb, todb, fromhost) - will only function with MongoDB 4.0 and below
	db.createCollection(name, {size: ..., capped: ..., max: ...})
	db.createUser(userDocument)
	db.createView(name, viewOn, [{$operator: {...}}, ...], {viewOptions})
	db.currentOp() displays currently executing operations in the db
	db.dropDatabase(writeConcern)
	db.dropUser(username)
	db.eval() - deprecated
	db.fsyncLock() flush data to disk and lock server for backups
	db.fsyncUnlock() unlocks server following a db.fsyncLock()
	db.getCollection(cname) same as db['cname'] or db.cname
	db.getCollectionInfos([filter]) - returns a list that contains the names and options of the db's collections
	db.getCollectionNames()
	db.getLastError() - just returns the err msg string
	db.getLastErrorObj() - return full status object
	db.getLogComponents()
	db.getMongo() get the server connection object
	db.getMongo().setSlaveOk() allow queries on a replication slave server
	db.getName()
	db.getProfilingLevel() - deprecated
	db.getProfilingStatus() - returns if profiling is on and slow threshold
	db.getReplicationInfo()
	db.getSiblingDB(name) get the db at the same server as this one
	db.getWriteConcern() - returns the write concern used for any operations on this db, inherited from server object if set
	db.hostInfo() get details about the server's host
	db.isMaster() check replica primary status
	db.killOp(opid) kills the current operation in the db
	db.listCommands() lists all the db commands
	db.loadServerScripts() loads all the myscripts in db.system.js
	db.logout()
	db.printCollectionStats()
	db.printReplicationInfo()
	db.printShardingStatus()
	db.printSlaveReplicationInfo()
	db.resetError()
	db.runCommand(cmdObj) run a database command.  if cmdObj is a string, turns it into {cmdObj: 1}
	db.serverStatus()
	db.setLogLevel(level,<component>)
	db.setProfilingLevel(level,slowms) 0=off 1=slow 2=all
	db.setVerboseShell(flag) display extra information in shell output
	db.setWriteConcern(<write concern doc>) - sets the write concern for writes to the db
	db.shutdownServer()
	db.stats()
	db.unsetWriteConcern(<write concern doc>) - unsets the write concern for writes to the db
	db.version() current version of the server
	db.watch() - opens a change stream cursor for a database to report on all  changes to its non-system collections.
```

### 1.3. db.collection.help() 命令

```shell
> db.demo.help()
DBCollection help
	db.demo.find().help() - 展示 DBCursor 方法帮助
	db.demo.bulkWrite( operations, <optional params> ) - bulk execute write operations, optional parameters are: w, wtimeout, j
	db.demo.count( query = {}, <optional params> ) - 计算匹配查询的文档数量，可选参数有:limit、skip、hint、maxTimeMS
	db.demo.countDocuments( query = {}, <optional params> ) - count the number of documents that matches the query, optional parameters are: limit, skip, hint, maxTimeMS
	db.demo.estimatedDocumentCount( <optional params> ) - estimate the document count using collection metadata, optional parameters are: maxTimeMS
	db.demo.convertToCapped(maxBytes) - calls {convertToCapped:'demo', size:maxBytes}} command
	db.demo.createIndex(keypattern[,options])
	db.demo.createIndexes([keypatterns], <options>)
	db.demo.dataSize()
	db.demo.deleteOne( filter, <optional params> ) - delete first matching document, optional parameters are: w, wtimeout, j
	db.demo.deleteMany( filter, <optional params> ) - delete all matching documents, optional parameters are: w, wtimeout, j
	db.demo.distinct( key, query, <optional params> ) - e.g. db.demo.distinct( 'x' ), optional parameters are: maxTimeMS
	db.demo.drop() drop the collection
	db.demo.dropIndex(index) - e.g. db.demo.dropIndex( "indexName" ) or db.demo.dropIndex( { "indexKey" : 1 } )
	db.demo.hideIndex(index) - e.g. db.demo.hideIndex( "indexName" ) or db.demo.hideIndex( { "indexKey" : 1 } )
	db.demo.unhideIndex(index) - e.g. db.demo.unhideIndex( "indexName" ) or db.demo.unhideIndex( { "indexKey" : 1 } )
	db.demo.dropIndexes()
	db.demo.ensureIndex(keypattern[,options]) - DEPRECATED, use createIndex() instead
	db.demo.explain().help() - show explain help
	db.demo.reIndex()
	db.demo.find([query],[fields]) - query is an optional query filter. fields is optional set of fields to return.
	                                              e.g. db.demo.find( {x:77} , {name:1, x:1} )
	db.demo.find(...).count()
	db.demo.find(...).limit(n)
	db.demo.find(...).skip(n)
	db.demo.find(...).sort(...)
	db.demo.findOne([query], [fields], [options], [readConcern])
	db.demo.findOneAndDelete( filter, <optional params> ) - delete first matching document, optional parameters are: projection, sort, maxTimeMS
	db.demo.findOneAndReplace( filter, replacement, <optional params> ) - replace first matching document, optional parameters are: projection, sort, maxTimeMS, upsert, returnNewDocument
	db.demo.findOneAndUpdate( filter, <update object or pipeline>, <optional params> ) - update first matching document, optional parameters are: projection, sort, maxTimeMS, upsert, returnNewDocument
	db.demo.getDB() get DB object associated with collection
	db.demo.getPlanCache() get query plan cache associated with collection
	db.demo.getIndexes()
	db.demo.insert(obj)
	db.demo.insertOne( obj, <optional params> ) - insert a document, optional parameters are: w, wtimeout, j
	db.demo.insertMany( [objects], <optional params> ) - insert multiple documents, optional parameters are: w, wtimeout, j
	db.demo.mapReduce( mapFunction , reduceFunction , <optional params> )
	db.demo.aggregate( [pipeline], <optional params> ) - performs an aggregation on a collection; returns a cursor
	db.demo.remove(query)
	db.demo.replaceOne( filter, replacement, <optional params> ) - replace the first matching document, optional parameters are: upsert, w, wtimeout, j
	db.demo.renameCollection( newName , <dropTarget> ) renames the collection.
	db.demo.runCommand( name , <options> ) runs a db command with the given name where the first param is the collection name
	db.demo.save(obj)
	db.demo.stats({scale: N, indexDetails: true/false, indexDetailsKey: <index key>, indexDetailsName: <index name>})
	db.demo.storageSize() - includes free space allocated to this collection
	db.demo.totalIndexSize() - size in bytes of all the indexes
	db.demo.totalSize() - storage allocated for all data and indexes
	db.demo.update( query, <update object or pipeline>[, upsert_bool, multi_bool] ) - instead of two flags, you can pass an object with fields: upsert, multi, hint
	db.demo.updateOne( filter, <update object or pipeline>, <optional params> ) - update the first matching document, optional parameters are: upsert, w, wtimeout, j, hint
	db.demo.updateMany( filter, <update object or pipeline>, <optional params> ) - update all matching documents, optional parameters are: upsert, w, wtimeout, j, hint
	db.demo.validate( <full> ) - SLOW
	db.demo.getShardVersion() - only for use with sharding
	db.demo.getShardDistribution() - prints statistics about data distribution in the cluster
	db.demo.getSplitKeysForChunks( <maxChunkSize> ) - calculates split points over all chunks and returns splitter function
	db.demo.getWriteConcern() - returns the write concern used for any operations on this collection, inherited from server/db if set
	db.demo.setWriteConcern( <write concern doc> ) - sets the write concern for writes to the collection
	db.demo.unsetWriteConcern( <write concern doc> ) - unsets the write concern for writes to the collection
	db.demo.latencyStats() - display operation latency histograms for this collection
```

### 1.4. help keys 命令

```shell
> help keys
Tab completion and command history is available at the command prompt.
Some emacs keystrokes are available too:
  Ctrl-A start of line
  Ctrl-E end of line
  Ctrl-K del to end of line

Multi-line commands
You can enter a multi line javascript expression.  If parens, braces, etc. are not closed, you will see a new line 
beginning with '...' characters.  Type the rest of your expression.  Press Ctrl-C to abort the data entry if you
get stuck.
```

翻译为中文：

在命令提示符处可以使用制表符补全和命令历史记录。
一些emacs按键也可用:

- Ctrl-A 去到行开始
- Ctrl-E 去到行结束
- Ctrl-K 删除整行

多行命令
您可以输入多行javascript表达式。如果括号、大括号等没有关闭，你会看到一个新行开始的……的字符。输入表达式的其余部分。按Ctrl-C中止数据输入，如果您被卡住了。

### 1.5. db.collection.find().help() 命令

```shell
> db.HouseHold.find().help()
find(<predicate>, <projection>) modifiers
	.sort({...})
	.limit(<n>)
	.skip(<n>)
	.batchSize(<n>) - sets the number of docs to return per getMore
	.collation({...})
	.hint({...})
	.readConcern(<level>)
	.readPref(<mode>, <tagset>)
	.count(<applySkipLimit>) - total # of objects matching query. by default ignores skip,limit
	.size() - total # of objects cursor would return, honors skip,limit
	.explain(<verbosity>) - accepted verbosities are {'queryPlanner', 'executionStats', 'allPlansExecution'}
	.min({...})
	.max({...})
	.maxTimeMS(<n>)
	.comment(<comment>)
	.tailable(<isAwaitData>)
	.noCursorTimeout()
	.allowPartialResults()
	.returnKey()
	.showRecordId() - adds a $recordId field to each returned object
	.allowDiskUse() - allow using disk in completing the query

Cursor methods
	.toArray() - iterates through docs and returns an array of the results
	.forEach(<func>)
	.map(<func>)
	.hasNext()
	.next()
	.close()
	.objsLeftInBatch() - returns count of docs left in current batch (when exhausted, a new getMore will be issued)
	.itcount() - iterates through documents and counts them
	.pretty() - pretty print each document, possibly over multiple lines
```

## MongoDB用户操作

> 转载自：https://blog.csdn.net/hbtj_1216/article/details/120875957

```sql
use admin

db.createUser({
  user: 'admin',    // 用户名（自定义）
  pwd: 'Abc123++',  // 密码（自定义）
  roles:[{
    role: 'root',   // 使用超级用户角色
    db: 'admin'     // 指定数据库
  }]
})
```

设置完成，可以通过指令 `show users` 查看是否设置成功。

```sql
# 查看当前库下的用户
show users
# 删除用户
db.dropUser('testadmin')
# 修改用户密码
db.updateUser('admin', {pwd: '654321'})
# 密码认证
db.auth('admin', '654321')


```

| **角色描述**   | 角色标识                                                     |
| -------------- | ------------------------------------------------------------ |
| 数据库用户角色 | read、readWrite                                              |
| 数据库管理角色 | dbAdmin、dbOwner、userAdmin                                  |
| 集群管理角色   | clusterAdmin、clusterManager、clusterMonitor、hostManager    |
| 备份恢复角色   | backup、restore                                              |
| 所有数据库角色 | readAnyDatabase、readWriteAnyDatabase、userAdminAnyDatabase、 dbAdminAnyDatabase |
| 超级用户角色   | root                                                         |

## 查询 find()

### 查询函数

| 函数          | 描述                                                         | 🌰                                                            |
| ------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| `find()`      | 查询方法，可在方法内规定查询规则。<br/>                      | 可以使用两种方式查询。<br/> `db.表名.find();  `<br/> `db.getCollection('表名').find()` |
| `find({},{})` | 参数一：查询条件。<br/>参数二：规定返回哪些参数，类似于select age from 表名重中的age。<br/> ` {'age': 1,'name': 0}`值为1返回字段，值为0不返回字段。默认为0。 | `db.col.find({'name':'小明'},{'name':1,'_id':0})`            |
| `pretty()`    | 使得查询出来的数据在命令行中更加美观的显示，不至于太紧凑。   | `db.col.find().pretty()`                                     |
| `limit()`     | 参数：数字。想要读取的数据条数。不填写默认返回全部数据。     | `db.col.find().limit(1)`                                     |
| `skip()`      | 参数：数字。跳过多少数据开始查询。默认值为0。                | `db.col.find().skip(1)`                                      |

### 查询操作符

> 可以单字段多条件组合查询。如：`db.col.find({age : {$lt :18, $gt : 38, $ne : 20}})`

| 表达式    | 描述                                                         | 实例                                                 | RDBMS中的类似语句        |
| :-------- | :----------------------------------------------------------- | :--------------------------------------------------- | :----------------------- |
| 😊         | `{<key>:<value>`}<br/>等于                                   | `db.col.find({"name":"小明"})`                       | `where name = '小明'`    |
| `$lt`     | `{<key>:{$lt:<value>}}`<br/>小于                             | `db.col.find({"likes":{$lt:50}})`                    | `where likes < 50`       |
| `$lte`    | `{<key>:{$lte:<value>}}`<br/>小于等于                        | `db.col.find({"likes":{$lte:50}})`                   | `where likes <= 50`      |
| `$gt`     | `{<key>:{$gt:<value>}}`<br/>大于                             | `db.col.find({"likes":{$gt:50}})`                    | `where likes > 50`       |
| `$gte`    | `{<key>:{$gte:<value>}}`<br/>大于等于                        | `db.col.find({"likes":{$gte:50}})`                   | `where likes >= 50`      |
| `$in`     | `{ <key>: { $in: [<value1>, <value2>, ... <valueN> ] } }`<br/> 包含 | `db.col.find( { item : { $in: false } } )`           | `where likes in () `     |
| `$nin`    | `{ <key>: { $nin: [ <value1>, <value2> ... <valueN> ]} }`<br/> 不包含 | `db.col.find( { item : { $nin: false } } )`          | `where likes not in () ` |
| `$ne`     | `{<key>:{$ne:<value>}}`<br/> 不等于                          | `db.col.find({"likes":{$ne:50}})`                    | `where likes != 50`      |
| `$or`     | `{$or:{<key:<value>,<key>:<value>>}}`<br/>多条件查询，可以组合其他查询条件使用。 | `db.col.find({$or:[{"name":"小明"},{"age": "18"}]})` |                          |
| `$type`   | `{<key>:{$type:<value>}}`<br/>类型比较，**Mongodb中存在的类型。** | `db.col.find({"title" : {$type : 'string'}})`        |                          |
| `$exists` | `{<key>:{$exists:<value>}}`<br/>字段是否存在。               | `db.col.find( { item : { $exists: false } } )`       |                          |
| 模糊查询  | 没有操作符，根据书写规则来决定是否是模糊查询。<br/> 和普通is查询一样，但是值需要加`//`。<br/> like：`{name:/小/}`<br/> likeBegin: `{name:/^小/}`<br/> likeEnd:`{name:/小^/}` | `db.col.find( { item : /小/} } )`                    | `where name like "%小%"` |

### 特殊查询

#### 嵌套文档/文档数组查询

> 字段是数组或对象都可以使用size.uom来进行操作。

```sql
# 新增数据
db.inventory.insertMany( [
    { item: "journal", qty: 25, size: { h: 14, w: 21, uom: "cm" }, status: "A" },
    { item: "notebook", qty: 50, size: { h: 8.5, w: 11, uom: "in" }, status: "A" },
    { item: "paper", qty: 100, size: { h: 8.5, w: 11, uom: "in" }, status: "D" },
    { item: "planner", qty: 75, size: { h: 22.85, w: 30, uom: "cm" }, status: "D" },
    { item: "postcard", qty: 45, size: { h: 10, w: 15.25, uom: "cm" }, status: "A" }
]);

# 嵌套文档查询，size必须完全匹配
db.inventory.find( { size: { h: 14, w: 21, uom: "cm" } } )
# 嵌套字段查询，直接查询size.uom。
db.inventory.find( { "size.uom": "in" } )
```

## 聚合查询 aggregate()

### 管道的概念

> 管道在Unix和Linux中一般用于将当前命令的输出结果作为下一个命令的参数。
>
> MongoDB的聚合管道将MongoDB文档在**一个管道处理完毕后将结果传递给下一个管道处理**。管道操作是可以重复的。
>
> 表达式：处理输入文档并输出。表达式是无状态的，只能用于计算当前聚合管道的文档，不能处理其它的文档。
>
> 这里我们介绍一下聚合框架中常用的几个操作：
>
> - `$project`：修改输入文档的结构。可以用来重命名、增加或删除域，也可以用于创建计算结果以及嵌套文档。
> - `$match`：用于过滤数据，只输出符合条件的文档。`$​match`使用MongoDB的标准查询操作。
> - `$limit`：用来限制MongoDB聚合管道返回的文档数。
> - `$skip`：在聚合管道中跳过指定数量的文档，并返回余下的文档。
> - `$unwind`：将文档中的某一个数组类型字段拆分成多条，每条包含数组中的一个值。
> - `$group`：将集合中的文档分组，可用于统计结果。
> - `$sort`：将输入文档排序后输出。
> - `$geoNear`：输出接近某一地理位置的有序文档。

### `$project`

> `$project`：修改输入文档的结构。可以用来重命名、增加或删除域，也可以用于创建计算结果以及嵌套文档。

#### 操作符

| 表达式                                                       | 描述                                                         | 实例                                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| `$unwind`                                                    | 将集合字段平铺。数据会从`{"data":[{count:1},{count:2}]}`，变为`{"data":{count:1}},{"data":{count:2}}` | `db.col.aggregate([{$unwind:'$data'}])`                      |
| [$add](https://links.jianshu.com/go?to=https%3A%2F%2Fdocs.mongodb.com%2Fmanual%2Freference%2Foperator%2Faggregation%2Fadd%2F) | `{ $add ： [ < expression1 > ， < expression2 > ， ... ] }`<br>多值相加，值可以是指定的值，也可以是字段。 | `db.col.aggregate([{$project:{size:{$add:['$size1','$size2','$size3']}}}])` |
| [$subtract](https://links.jianshu.com/go?to=https%3A%2F%2Fdocs.mongodb.com%2Fmanual%2Freference%2Foperator%2Faggregation%2Fsubtract%2Findex.html) | `{ $subtract: [ <expression1>, <expression2> ] }`<br>expression1减去expression2，值可以是指定的值，也可以是字段。*只能两值相减，多值相减需要嵌套使用。* | `db.col.aggregate([{$project:{size:{$subtract:['$size1','$size2']}}}])` |
| [$multiply](https://links.jianshu.com/go?to=https%3A%2F%2Fdocs.mongodb.com%2Fmanual%2Freference%2Foperator%2Faggregation%2Fmultiply%2F%23exp._S_multiply) | `{ $multiply ： [ < expression1 > ， < expression2 > ， ... ] }`<br>多值相乘，值可以是指定的值，也可以是字段。 | `db.size_test.aggregate([{$project:{size:{$multiply:['$size1','$size2','$size3',100]}}}])` |
| [$divide](https://links.jianshu.com/go?to=https%3A%2F%2Fdocs.mongodb.com%2Fmanual%2Freference%2Foperator%2Faggregation%2Fdivide%2Findex.html) | `{ $divide: [ <expression1>, <expression2> ] }`<br>expression1为被除数，expression2为除数，值可以是指定的值，也可以是字段。*只能两值相除，多值相除需要嵌套使用。* | `db.col.aggregate([{$project:{size:{$divide:['$size1','$size2']}}}])` |
| `$ifNull`                                                    | `{ $ifNull: [ expression, replacement-expression-if-null ] }`：用于判断第一个[表达式](https://so.csdn.net/so/search?q=表达式&spm=1001.2101.3001.7020)是否为 null，如果为 null 则返回第二个参数的值，如果不为 null 则返回第一个参数的值。 | `db.col.aggregate([{$project:{size:{$ifNull:['$size1',100]}}}])` |

#### 时间转换操作符

| 表达式         | 描述                                                         | 实例                                                         |
| -------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| `new Date()`   | 时间创建，必须按照标准的日期格式。<br><font color=#FF000 >**日期格式：yyyy-MM-ddThh:mm:ssZ**</font> | `new Date()`                                                 |
| `ISODate`      | <font color=#FF000 >**可以不按照标准的日期格式**</font>      | `db.col.find({time:{$gt:ISODate("20210101")}})`              |
| `$year`        | 时间转换为年。                                               | `db.HouseHold.aggregate([{$project: {createTime:{$year:'$createTime'}}}])` |
| `$month`       | 时间转换为月。                                               | `db.HouseHold.aggregate([{$project: {createTime:{$month:'$createTime'}}}])` |
| `$week`        | 时间转换为周，当年的第几周。                                 | `db.HouseHold.aggregate([{$project: {createTime:{$week:'$createTime'}}}])` |
| `$dayOfYear`   | 时间转换为日，当年的第几天。                                 | `db.HouseHold.aggregate([{$project: {createTime:{$dayOfYear:'$createTime'}}}])` |
| `$dayOfMonth`  | 时间转换为日，当月的第几天。                                 | `db.HouseHold.aggregate([{$project: {createTime:{$dayOfMonth:'$createTime'}}}])` |
| `$dayOfWeek`   | 时间转换为日，当周的第几天。<br>星期日为1，星期六为7。       | `db.HouseHold.aggregate([{$project: {createTime:{$dayOfWeek:'$createTime'}}}])` |
| `$hour`        | 时间转换为小时，当天的第几小时。                             | `db.HouseHold.aggregate([{$project: {createTime:{$hour:'$createTime'}}}])` |
| `$minute`      | 时间转换为分钟，当前小时的第几分钟。                         | `db.HouseHold.aggregate([{$project: {createTime:{$minute:'$createTime'}}}])` |
| `$second`      | 时间转换为秒，当前分钟的第几秒。                             | `db.HouseHold.aggregate([{$project: {createTime:{$second:'$createTime'}}}])` |
| `$millisecond` | 时间转换为毫秒，当前秒的第几毫秒。                           | `db.HouseHold.aggregate([{$project: {createTime:{$millisecond:'$createTime'}}}]) |

[$dateToString](https://mongodb.net.cn/manual/reference/operator/aggregation/dateToString/)

> `$dateToString`:自定义时间转换

参数描述

```sql
{ $dateToString: {
    date: <dateExpression>,
    format: <formatString>,
    timezone: <tzExpression>,
    onNull: <expression>
} }
```

例子

```sql
db.getCollection('HouseHold').aggregate([
    {$project:
        {
            year:{$dateToString: { format: "%Y", date: "$createTime" }},
            dayofweek:{$dateToString: { format: "%w", date: "$createTime" }},
            weekofyear:{$dateToString: { format: "%U", date: "$createTime" }},
            year:{$dateToString: { format: "%Y-%m-%dT%H:%M", date: "$createTime" }},
            onNull:{$dateToString: { date: null, onNull: "No date supplied" } }
        }}
]).pretty()
```

结果

```json
{
    "_id" : ObjectId("60fa3b3635f8c5790b880297"),
    "year" : "2021",
    "dayofweek" : "5",
    "weekofyear" : "30",
    "UTC" : "2021-07-29T09:10",
    "onNull" : "No date supplied"
}
```

![img](https://file.pandacode.cn//blog/202109111301481.png)

扩展

> 可以使用`$dateToString`从 ObjectId 返回日期字符串。
>
> ObjectId 值是 12 字节的十六进制值，包括：
>
> - 一个 4 字节的时间戳值，表示 ObjectId 的创建，以 Unix 纪元以来的秒数为单位。
> - 一个 5 字节是一个随机值
> - 一个 3 字节递增计数器，初始化为随机值。
>
> 回顾一下，我们的第一个文档如下所示：
>
> ```
> {
> 	"_id" : ObjectId("600631c7c8eb4369cf6ad9c8"),
> 	"name" : "获取",
> 	“出生”：ISODate（“2020-12-31T23：30：15.123Z”）
> }
> ```
>
> 该文档包含一个 ObjectId。因此，我们可以`$dateToString`根据文档的创建日期（或更具体地说，`_id`字段的 ObjectId 值的创建日期）返回一个日期字符串。
>
> 例子：
>
> ```
> db.pets.aggregate(
>    [
>      {
>        $project: {
>           timestamp: { $toDate: "$_id" },
>           dateString: { $dateToString: { format: "%d-%m-%Y", date: "$_id" } }
>        }
>      }
>    ]
> ).pretty()
> ```
>
> 结果：
>
> ```
> {
> 	"_id" : ObjectId("600631c7c8eb4369cf6ad9c8"),
> 	"时间戳" : ISODate("2021-01-19T01:11:35Z"),
> 	“日期字符串”：“19-01-2021”
> }
> ```
>
> 在这种情况下，我决定只返回日期部分（而不是时间部分）。我还改变了天、月和年的顺序，以证明如果需要，您当然可以这样做。

### `$group`

> `$group`：将集合中的文档分组，可用于统计结果。
>
> `db.col.aggregate([{$group : {_id : "$by_user", ........}}])`

| 表达式      | 描述                                           | 实例                                                         |
| :---------- | :--------------------------------------------- | :----------------------------------------------------------- |
| `$sum`      | 计算总和。                                     | `db.col.aggregate([{$group : {_id : "$by_user", num_tutorial : {$sum : "$likes"}}}])` |
| `$avg`      | 计算平均值                                     | `db.col.aggregate([{$group : {_id : "$by_user", num_tutorial : {$avg : "$likes"}}}])` |
| `$min`      | 获取集合中所有文档对应值得最小值。             | `db.col.aggregate([{$group : {_id : "$by_user", num_tutorial : {$min : "$likes"}}}])` |
| `$max`      | 获取集合中所有文档对应值得最大值。             | `db.col.aggregate([{$group : {_id : "$by_user", num_tutorial : {$max : "$likes"}}}])` |
| `$push`     | 在结果文档中插入值到一个数组中。               | `db.col.aggregate([{$group : {_id : "$by_user", url : {$push: "$url"}}}])` |
| `$addToSet` | 在结果文档中插入值到一个数组中，但不创建副本。 | `db.col.aggregate([{$group : {_id : "$by_user", url : {$addToSet : "$url"}}}])` |
| `$first`    | 根据资源文档的排序获取第一个文档数据。         | `db.col.aggregate([{$group : {_id : "$by_user", first_url : {$first : "$url"}}}])` |
| `$last`     | 根据资源文档的排序获取最后一个文档数据         | `db.col.aggregate([{$group : {_id : "$by_user", last_url : {$last : "$url"}}}])` |

## 新增

### 新增函数

| 函数           | 描述                                                      | 实例                                                         |
| -------------- | --------------------------------------------------------- | ------------------------------------------------------------ |
| `insertOne()`  | 新增一条。                                                | `db.col.insertOne({"name":"123"})`                           |
| `insertMany()` | 新增多条。                                                | `db.col.insertMany([{"name":"小明","age":29},{"name":"小红","age":32}])` |
| `save()`       | 可同时添加多个文档。<br/>也能够更新数据，但只能更新一条。 | `db.col.save({"name":"123"})`                                |

## 修改

### 修改函数

| 函数           | 描述                                                         | 实例                                                         |
| -------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| `update()`     | `db.collection.update(<query>,<update>,{upsert: <boolean>,multi: <boolean>,writeConcern:<document>})`<br/> 参数说明：<br/>**query** : update的查询条件，类似sql update查询内where后面的。<br/> **update** : update的对象和一些更新的操作符（如$,$inc...）等，也可以理解为sql update查询内set后面的<br/> **upsert** : 可选，这个参数的意思是，如果不存在update的记录，是否插入objNew,true为插入，默认是false，不插入。<br/> **multi** : 可选，mongodb 默认是false,只更新找到的第一条记录，如果这个参数为true,就把按条件查出来多条记录全部更新。<br/> **writeConcern** :可选，抛出异常的级别。 | `db.col.update( { "count" : { $gt : 3 } } , { $set : { "test2" : "OK"} },false,true );` |
| `updateOne()`  | 即使多个文档可能与指定的过滤器匹配，最多更新与指定的过滤器匹配的单个文档。 |                                                              |
| `updateMany()` | 更新所有与指定过滤器匹配的文档。                             |                                                              |
| `replaceOne()` | 即使多个文档可能与指定过滤器匹配，也最多替换一个与指定过滤器匹配的文档。 |                                                              |

### 修改操作符

#### `$set`

```sql
{ $set: { <field1>: <value1>, ... } }
# 例子
db.col.update(
   { _id: 100 },
   { $set:
      {
        quantity: 500,
        details: { model: "14Q3", make: "xyz" },
        tags: [ "coats", "outerwear", "clothing" ]
      }
   }
)
```



## 删除

### 普通删除

#### remove()

```sql
# api
db.collection.remove(
   <query>,
   {
     justOne: <boolean>,
     writeConcern: <document>
   }
)
```

**参数说明：**

- **query** :（可选）删除的文档的条件。
- **justOne** : （可选）如果设为 true 或 1，则只删除一个文档，如果不设置该参数，或使用默认值 false，则删除所有匹配条件的文档。
- **writeConcern** :（可选）抛出异常的级别。

```sql
# 例子
db.col.remove({'title':'abc'})
```

#### deleteOne()

> 即使多个文档可能与指定过滤器匹配，也最多删除一个与指定过滤器匹配的文档。

#### deleteMany()

> 删除所有与指定过滤器匹配的文档。
