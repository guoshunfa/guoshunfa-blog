---
title: Spring框架 SpringEvent
tags:
    - spring
    - springevent
categories:
    - 技术
date: 2022-07-01 12:01:01
thumbnail:
---

Spring 官方文档翻译如下 ：

> *ApplicationContext 通过 ApplicationEvent 类和 ApplicationListener 接口进行事件处理。 如果将实现 ApplicationListener 接口的 bean 注入到上下文中，则每次使用 ApplicationContext 发布 ApplicationEvent 时，都会通知该 bean。 本质上，这是标准的观察者设计模式。*



Spring的事件（Application Event）其实就是一个观察者设计模式，**一个 Bean 处理完成任务后希望通知其它 Bean** 或者说 **一个Bean 想观察监听另一个Bean的行为。**



Spring 事件只需要几步：

- 自定义事件，继承 ApplicationEvent

- 定义监听器，实现 ApplicationListener 或者通过 @EventListener 注解到方法上

- 定义发布者，通过 ApplicationEventPublisher

  

## 1. 自定义Event

```java
@Data
public class DemoEvent extends ApplicationEvent {
    private Long id;
    private String message;

    public DemoEvent(Object source, Long id, String message) {
        super(source);
        this.id = id;
        this.message = message;
    }
}
```

> - 事件没要处理的监听器，就会被抛弃。
> - 一个事件可以同时被多个监听处理类监听处理。
> - 如果代码结构较复杂，多处发布相同的事件，建议发布事件时将this作为source传递，便于通过分析日志确定发布源。
> - 以上处理事件都是同步的，如果发布事件处的业务存在事务，监听器处理也会在相同的事务中。这个一定要注意！如果对于事件的处理不想受到影响，可以onApplicationEvent方法上加@Aync支持异步(参考taskExecutor的使用)。
> - 原理部分可以参考 [博客](http://jinnianshilongnian.iteye.com/blog/1902886) [事件体系](https://blog.csdn.net/caihaijiang/article/details/7460888)



## 2. 监听器

> 监听器分为两种方式，一种是实现ApplicationListener 接口，一种是方法上加@EventListener注解。

- 实现ApplicationListener 接口

```java
@Component
public class DemoListener implements ApplicationListener<DemoEvent> {

    @Override
    public void onApplicationEvent(DemoEvent demoEvent) {
        System.out.println(">>>>>>>>>DemoListener>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
        System.out.println("收到了：" + demoEvent.getSource() + "消息;时间：" + demoEvent.getTimestamp());
        System.out.println("消息：" + demoEvent.getId() + ":" + demoEvent.getMessage());
    }
}
```

> 泛型为需要监听的事件类型
>
> 如果要实现有序的监听，实现SmartApplicationListener 接口即可。

- @EventListener

```java
@Component
public class DemoListener2 {

    @EventListener
    public void onApplicationEvent(DemoEvent demoEvent) {
        System.out.println(">>>>>>>>>DemoListener2>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
        System.out.println("收到了：" + demoEvent.getSource() + "消息;时间：" + demoEvent.getTimestamp());
        System.out.println("消息：" + demoEvent.getId() + ":" + demoEvent.getMessage());
    }
}
```

会根据方法参数类型来自动监听相应事件的发布。
       如果要监听多个事件类型的发布，可以在@EventListener(classes = {FaceEvent.class,ArmEvent.class})指定，spring会多次调用此方法来处理多个事件。但是注意此时，方法参数不能有多个，否则会发生转换异常，可以将使用多个事件的父类作为唯一的方法参数来接收处理事件，但除非必要否则并不推荐监听多个事件的发布。

​		如果有多个监听器监听同一事件，我们可以在方法上使用spring的@order注解来定义多个监听器的顺序，如：

```java
		@EventListener
    @Order(4)
    public void onApplicationEvent(FaceEvent event) {
        User user = (User) event.getSource();
        LOGGER.info("===> A 收到人脸事件:  {}",user);
    }

    @EventListener({FaceEvent.class,ArmEvent.class})
    @Order(3)
    public void onApplicationEvent3(Object event) {

        if(event instanceof FaceEvent){
            LOGGER.info("===> B 收到人脸事件:  {}",((FaceEvent) event).getEventData());
        }else if(event instanceof ArmEvent){
            ArmEvent armEvent = (ArmEvent) event;
            LOGGER.info("===> B 收到臂膀事件:  {}",armEvent.getEventData());
        }
    }
```

> @EventListener还有一个属性，condition（）里可以使用SPEL表达式来过滤监听到事件，即只有符合某种条件的才进行接收处理。暂时还用不到。



## 3. 消息发布者

```java
@Component
public class DemoPublisher {

    private final ApplicationContext applicationContext;

    @Autowired
    public DemoPublisher(ApplicationContext applicationContext) {
        this.applicationContext = applicationContext;
    }

    public void publish(long id, String message) {
        applicationContext.publishEvent(new DemoEvent(this, id, message));
    }

}
```

> 扩展：
>
> 我们可以通过工具类发布来避免在代码耦合注入ApplicationContext，工具类实现ApplicationEventPublisherAware 接口，具体可参考spring的aware学习。
>     这里有一个小细节，如果通过注入ApplicationContext的方式来发布事件，idea在代码左边会有一个类似耳机的小图标，点击可以跳到监听此发布事件的监听者位置，用工具类发布事件就没有此提示了。



## 4. 测试方法

```java
@Test
public void publisherTest() {
    demoPublisher.publish(1L, "成功了！");
}
```



## 5. 结果

```test
>>>>>>>>>DemoListener2>>>>>>>>>>>>>>>>>>>>>>>>>>>>
收到了：com.jiuxian.publisher.DemoPublisher@3a62c01e消息;时间：1551762322376
消息：1:成功了！
>>>>>>>>>DemoListener>>>>>>>>>>>>>>>>>>>>>>>>>>>>
收到了：com.jiuxian.publisher.DemoPublisher@3a62c01e消息;时间：1551762322376
消息：1:成功了！
```



## 6. 示例源码

[GitHub  https://github.com/Zejun-Liu/SpringBoot2.0/tree/master/springboot-event](https://github.com/Zejun-Liu/SpringBoot2.0/tree/master/springboot-event)



## 7. 扩展 - 监听事件时的事务隔离

​		@TransactionalEventListener和@EventListener都可以监听事件，但前者可以对发布事件和监听事件进行一些事务上的隔离。

​		@TransactionalEventListenerr指不和发布事件的方法在同一个事务内，发布事件的方法事务结束后才会执行本监听方法，监听逻辑内发生异常不会回滚发布事件方法的事务。

```java
@Transactional(rollbackFor = Exception.class)
public void handle(){
    User user = new User();
    user.setAge(34);
    user.setUsername("人脸事件");
    user.setHobby("抓拍");

    //处理完上面的逻辑后，发布事件
    EventPublisherUtil.publishEvent(new FaceEvent(user));
 
    //数据库添加操作
    Integer integer = deviceAlarmService.addDevice();
}
```

可以看到发布事件的方法处在事务控制中，我们使用@TransactionalEventListener来监听事件：


```java
@TransactionalEventListener(fallbackExecution = true)
public void onApplicationEvent(FaceEvent event) {
    User user = event.getEventData();
    LOGGER.info("===> A 收到人脸事件:  {}}",user);

    //@TransactionalEventListener指不和发布事件的在同一个事务内，发布事件的方法事务结束后才会执行本方法
    // ，本方法发生异常不会回滚发布事件的事务，
    throw new  RuntimeException("监听事件抛出异常");
}
```

运行结果，addDevice正常在数据库插入数据，但是修改为@EventListener监听则插入数据失败。

​		@TransactionalEventListener有一个属性为fallbackExecution，默认为false，指发布事件的方法没有事务控制时，监听器不进行监听事件，此为默认情况！ fallbackExecution=true，则指发布事件的方法没有事务控制时，监听方法仍可以监听事件进行处理。

```java
/**
  * Whether the event should be processed if no transaction is running.
  */
    boolean fallbackExecution() default false;
```

​		刚才我们说到使用@TransactionalEventListener会在发布事件的方法事务结束后执行监听方法，但其实我们还可以进行细化的控制。它有一个属性为TransactionPhase，默认为TransactionPhase.AFTER_COMMIT，即事务提交后。还可以根据需要选择AFTER_COMPLETION、BEFORE_COMMIT、AFTER_ROLLBACK。
​		但仍需注意，如果fallbackExecution=false，且发布事件的方法没有事务控制时，监听器根本不会监听到事件，此处的TransactionPhase也就没有意义了。
