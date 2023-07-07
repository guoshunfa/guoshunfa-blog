---
title: Kafka 命令记录
tags:
    - Kafka
categories:
    - 服务&组件
date: 2022-07-01 12:01:01
thumbnail:
---
## 1. 服务管理

前台启动broker

`bin/kafka-server-start.sh <path>/server.properties`
Ctrl + C 关闭

后台启动broker

`bin/kafka-server-start.sh -daemon <path>/server.properties`

关闭broker

`bin/kafka-server-stop.sh`

## 2. Topic管理

创建topic

`bin/kafka-topics.sh --create --zookeeper localhost:2181 --partitions 3 --replication-factor 3 --topic topicname`

删除topic

`bin/kafka-topics.sh --delete --zookeeper localhost:2181 --topic topicname`

查询topic列表

`bin/kafka-topics.sh --zookeeper localhost:2181 --list`

查询topic详情

`bin/kafka-topics.sh --zookeeper localhost:2181 --describe --topic topicname`

修改topic

`bin/kafka-topics.sh --alter --zookeeper localhost:2181 --partitions 6 --topic topicname`

相关可选参数

| 参数                                         | 描述                                                                                                                                         | 例子                                                                                                                                                                                                          |
| ---------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `--bootstrap-server`指定kafka服务            | 指定连接到的kafka服务; 如果有这个参数,则`--zookeeper`可以不需要                                                                              | --bootstrap-server localhost:9092                                                                                                                                                                             |
| `--zookeeper`                                | 弃用, 通过zk的连接方式连接到kafka集群;                                                                                                       | --zookeeper localhost:2181 或者localhost:2181/kafka                                                                                                                                                           |
| `--replication-factor`                       | 副本数量,注意不能大于broker数量;如果不提供,则会用集群中默认配置                                                                              | --replication-factor 3                                                                                                                                                                                        |
| `--partitions`                               | 分区数量,当创建或者修改topic的时候,用这个来指定分区数;如果创建的时候没有提供参数,则用集群中默认值; 注意如果是修改的时候,分区比之前小会有问题 | --partitions 3                                                                                                                                                                                                |
| `--replica-assignment`                       | 副本分区分配方式;创建topic的时候可以自己指定副本分配情况;                                                                                    | `--replica-assignment`BrokerId-0:BrokerId-1:BrokerId-2,BrokerId-1:BrokerId-2:BrokerId-0,BrokerId-2:BrokerId-1:BrokerId-0 ; 这个意思是有三个分区和三个副本,对应分配的Broker; 逗号隔开标识分区;冒号隔开表示副本 |
| `--config`<String: name=value>               | 用来设置topic级别的配置以覆盖默认配置;**只在--create 和--bootstrap-server 同时使用时候生效** ; 可以配置的参数列表请看文末附件                | 例如覆盖两个配置`--config retention.bytes=123455 --config retention.ms=600001`                                                                                                                                |
| `--command-config`<String: command 文件路径> | 用来配置客户端Admin Client启动配置,**只在--bootstrap-server 同时使用时候生效** ;                                                             | 例如:设置请求的超时时间`--command-config config/producer.proterties`; 然后在文件中配置 request.timeout.ms=300000                                                                                              |


## 3. Consumer-Groups管理

**查询消费者组**

`bin/kafka-consumer-groups.sh --bootstrap-server localhost:9092 --list`

**查询消费者组详情**

`bin/kafka-consumer-groups.sh --bootstrap-server localhost:9092 --describe --group groupname`

**重设消费者组位移**

```shell
# 最早处
bin/kafka-consumer-groups.sh --bootstrap-server localhost:9092 --group groupname --reset-offsets --all-topics --to-earliest --execute
# 最新处
bin/kafka-consumer-groups.sh --bootstrap-server localhost:9092 --group groupname --reset-offsets --all-topics --to-latest --execute
# 某个位置
bin/kafka-consumer-groups.sh --bootstrap-server localhost:9092 --group groupname --reset-offsets --all-topics --to-offset 2000 --execute
# 调整到某个时间之后得最早位移
bin/kafka-consumer-groups.sh --bootstrap-server localhost:9092 --group groupname --reset-offsets --all-topics --to-datetime 2019-09-15T00:00:00.000
```

**删除消费者组**

`bin/kafka-consumer-groups.sh --zookeeper localhost:2181 --delete --group groupname`

## 4. 消息管理

**实时接收消息**

`bin/kafka-console-consumer.sh --topic topin --bootstrap-server ip:port`



## 参考资料

- [Kafka运维命令大全](https://www.cnblogs.com/tree1123/p/11525610.html)
