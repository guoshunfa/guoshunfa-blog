---
title: 搭建单体SpringBoot项目 集成Kafka消息队列
tags:
    - Kafka
    - SpringBoot
categories:
    - 技术
    - 搭建单体SpringBoot项目
date: 2022-07-01 12:01:01
thumbnail:
---

## 1. SpringBoot 集成 kafka

> 下面的例子是一个SpringBoot项目引入多个Kafka服务，如果只需要引入一个，只需要有一个配置就好。

### 1.1. 引入kafka依赖

```xml
<dependency>
  <groupId>org.springframework.kafka</groupId>
  <artifactId>spring-kafka</artifactId>
  <version>1.1.1.RELEASE</version>
</dependency>
```

### 1.2. 修改配置文件(application.yml)

```
spring:
  kafka:
    one:
      bootstrap-servers: IP:PORT
      consumer:
        group-id: YOUR_GROUP_ID
        enable-auto-commit: true
     .......其他属性
    two:
      bootstrap-servers: IP:PORT
      consumer:
        group-id: YOUR_GROUP_ID
        enable-auto-commit: true
    .......其他属性
```

### 1.3. Kafka生产者和消费者的配置

通过@Configuration、@EnableKafka，声明Config并且打开KafkaTemplate能力。

```java
@EnableKafka
@Configuration
public class KafkaOneConfig {
 
    @Value("${spring.kafka.one.bootstrap-servers}")
    private String bootstrapServers;
    @Value("${spring.kafka.one.consumer.group-id}")
    private String groupId;
    @Value("${spring.kafka.one.consumer.enable-auto-commit}")
    private boolean enableAutoCommit;
 
    @Bean
    public KafkaTemplate<String, String> kafkaOneTemplate() {
        return new KafkaTemplate<>(producerFactory());
    }
 
    @Bean
    KafkaListenerContainerFactory<ConcurrentMessageListenerContainer<Integer, String>> kafkaOneContainerFactory() {
        ConcurrentKafkaListenerContainerFactory<Integer, String> factory = new ConcurrentKafkaListenerContainerFactory<>();
        factory.setConsumerFactory(consumerFactory());
        factory.setConcurrency(3);
        factory.getContainerProperties().setPollTimeout(3000);
        return factory;
    }
 
    private ProducerFactory<String, String> producerFactory() {
        return new DefaultKafkaProducerFactory<>(producerConfigs());
    }
 
    public ConsumerFactory<Integer, String> consumerFactory() {
        return new DefaultKafkaConsumerFactory<>(consumerConfigs());
    }
 
    private Map<String, Object> producerConfigs() {
        Map<String, Object> props = new HashMap<>();
        props.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServers);
        props.put(ProducerConfig.RETRIES_CONFIG, 0);
        props.put(ProducerConfig.ACKS_CONFIG, "1"); // 不能写成 1
        props.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class);
        props.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, StringSerializer.class);
        return props;
    }
 
    private Map<String, Object> consumerConfigs() {
        Map<String, Object> props = new HashMap<>();
        props.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServers);
        props.put(ConsumerConfig.GROUP_ID_CONFIG, groupId);
        props.put(ConsumerConfig.ENABLE_AUTO_COMMIT_CONFIG, enableAutoCommit);
        props.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class);
        props.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class);
        return props;
    }
}
```

### 1.4. 多个kafka则继续加配置

```java
@Configuration
public class KafkaTwoConfig {
 
    @Value("${spring.kafka.two.bootstrap-servers}")
    private String bootstrapServers;
    @Value("${spring.kafka.two.consumer.group-id}")
    private String groupId;
    @Value("${spring.kafka.two.consumer.enable-auto-commit}")
    private boolean enableAutoCommit;
 
    @Bean
    public KafkaTemplate<String, String> kafkaTwoTemplate() {
        return new KafkaTemplate<>(producerFactory());
    }
 
    @Bean
    KafkaListenerContainerFactory<ConcurrentMessageListenerContainer<Integer, String>> kafkaTwoContainerFactory() {
        ConcurrentKafkaListenerContainerFactory<Integer, String> factory = new ConcurrentKafkaListenerContainerFactory<>();
        factory.setConsumerFactory(consumerFactory());
        factory.setConcurrency(3);
        factory.getContainerProperties().setPollTimeout(3000);
        return factory;
    }
 
    private ProducerFactory<String, String> producerFactory() {
        return new DefaultKafkaProducerFactory<>(producerConfigs());
    }
 
    public ConsumerFactory<Integer, String> consumerFactory() {
        return new DefaultKafkaConsumerFactory<>(consumerConfigs());
    }
 
    private Map<String, Object> producerConfigs() {
        Map<String, Object> props = new HashMap<>();
        props.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServers);
        props.put(ProducerConfig.RETRIES_CONFIG, 0);
        props.put(ProducerConfig.ACKS_CONFIG, "1");
        props.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class);
        props.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, StringSerializer.class);
        return props;
    }
 
    private Map<String, Object> consumerConfigs() {
        Map<String, Object> props = new HashMap<>();
        props.put(ConsumerConfig.BOOTSTRAP_SERVERS_CONFIG, bootstrapServers);
        props.put(ConsumerConfig.GROUP_ID_CONFIG, groupId);
        props.put(ConsumerConfig.ENABLE_AUTO_COMMIT_CONFIG, enableAutoCommit);
        props.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class);
        props.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class);
        return props;
    }
}
```

### 1.5. Kafka 消息生产者

```java
@Controller
public class TestController {
 
    @Autowired
    private KafkaTemplate kafkaOneTemplate;
    @Autowired
    private KafkaTemplate kafkaTwoTemplate;
 
    @RequestMapping("/send")
    @ResponseBody
    public String send() {
        final String TOPIC = "TOPIC_1";
        kafkaOneTemplate.send(TOPIC, "kafka one");
        kafkaTwoTemplate.send(TOPIC, "kafka two");
 
        return "success";
    }
}
```

### 1.6. Kafka 消息消费者

```java
@Component
public class KafkaConsumer {
 
    private static final Logger LOGGER = LoggerFactory.getLogger(KafkaConsumer.class);
 
    final String TOPIC = "TOPIC_1";
 
    // containerFactory的值要与配置中KafkaListenerContainerFactory的Bean名称相同
    @KafkaListener(topics = {TOPIC}, containerFactory = "kafkaOneContainerFactory")
    public void listenerOne(ConsumerRecord<?, ?> record) {
        LOGGER.info(" kafka one 接收到消息：{}", record.value());
    }
 
    @KafkaListener(topics = {TOPIC}, containerFactory = "kafkaTwoContainerFactory")
    public void listenerTwo(ConsumerRecord<?, ?> record) {
        LOGGER.info(" kafka two 接收到消息：{}", record.value());
    }
}
```

运行结果如下：

![image-20211108212559925](https://cdn.jsdelivr.net/gh/guoshunfa/pandacode-files/blog/202111082126216.png) 
