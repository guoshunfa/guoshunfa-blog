---
title: Kafka 错误记录
tags:
    - kafka
    - 错误
    - 记录
categories:
    - 技术
date: 2022-07-01 12:01:01
thumbnail:
---
# Kafka - 错误记录

#### cannot allocate memory

日志描述：

```text
// Java运行时环境的内存不足，无法继续运行。
## There is insufficient memory for the Java Runtime Environment to continue.    
// 1073741824刚好是1G, 这句话的意思是本机内存分配未能为提交保留内存分配1G内存。
# Native memory allocation (malloc) failed to allocate 1073741824 bytes for committing reserved memory.
```

解决方案：

从这两行提示信息来看，应该是内存不够，经过百度，发现是kafka默认启动内存是1G, 而JVM默认内存也是1G, JVM自然不能所有内存都分配给kafka， 所以kafka就启动不了，解决方法是把kafka的最小启动内存设置为小于1G的值，即把kafka-server-start.sh中把'export KAFKA_HEAP_OPTS="-Xmx1G -Xms1G"'中的Xms设置为256M, 这样，kafka最小只需要256M即可启动。

<img src="https://file.pandacode.cn/blog/2022111104657.png"  />

重启kafka服务。

#### Executing consumer group command failed due to Request METADATA failed on brokers List(ubuntu:9092 (id: -1 rack: null))

日志描述：

运行`bin/kafka-consumer-groups.sh --bootstrap-server localhost:9092 --list`触发的错误日志。消费者团体执行命令失败由于请求元数据失败的经纪人名单上。

解决方案：

查看server.properties zookeeper的配置信息。调整成正确的YOUR_IP_ADDRESS即可。`bin/kafka-consumer-groups.sh --bootstrap-server YOUR_IP_ADDRESS:9092 --list`

#### 参考资料
- [启动kafka提示OOM异常，cannot allocate memory](https://www.cnblogs.com/hi3254014978/p/14092865.html)
- [KafkaConsumer 长时间地在poll(long )方法中阻塞](https://www.cnblogs.com/hapjin/p/7396063.html)