---
title: 搭建单体SpringBoot项目 集成MongoDB数据库
tags:
    - SpringBoot
    - 集成
    - MongoDB
    - 数据库
categories:
    - 技术
    - 搭建单体SpringBoot项目
date: 2022-07-01 12:01:01
thumbnail:
---

## 1. 集成

### 1.1. Maven

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-data-mongodb</artifactId>
</dependency>
```

### 1.2. 环境配置

```properties
# application.properties
# MongoDB数据库
spring.data.mongodb.uri=mongodb://127.0.0.1:27017/gsf_test
```

spring.data.mongodb.uri=mongodb://name:pass@localhost:27017/test，其中name是用户名，pass是密码

如果要配置多个数据库，则中间用","分割，例如

spring.data.mongodb.uri=mongodb://192.168.1.1:20000,192.168.1.2:20000,192.168.252.12:20000/test

### 1.3. demo

```java
@SpringBootTest
class TestMongodbApplicationTests {

    @Autowired
    private MongoTemplate mongoTemplate;

    @Test
    void contextLoads() {
        HouseHold houseHold = mongoTemplate.findById("60fa3b3635f8c5790b880297", HouseHold.class, "HouseHold");
        System.out.println(houseHold.getId() + houseHold.getCreateTime());
    }

    class HouseHold {
        private String id;
        private Date createTime;
        // 省略set get
    }
}

```