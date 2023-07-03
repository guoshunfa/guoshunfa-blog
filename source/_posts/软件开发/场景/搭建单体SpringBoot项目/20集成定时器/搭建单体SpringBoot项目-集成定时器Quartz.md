---
title: 搭建单体SpringBoot项目 集成定时器Quartz
tags:
    - quartz
    - spring-boot
categories:
    - 技术
    - 搭建单体SpringBoot项目
date: 2022-07-01 12:01:01
thumbnail:
---

## 1. Quartz 介绍

> Quartz是功能强大的开源作业调度库，几乎可以集成到任何Java应用程序中-从最小的独立应用程序到最大的电子商务系统。 
> Quartz可用于创建简单或复杂的计划，以执行数以十计，百计，万计的工作。
> 任务标准Java组件的任务，都可以执行您对其执行的任何编程操作。
> Quartz Scheduler包含许多企业级功能，例如对JTA事务和集群的支持。
>
> Quartz是免费使用的，并根据Apache 2.0许可获得许可。

## 2. 集成 Quartz

架构描述：
- Mysql作为Quartz持久化数据库。
- MongoDB作为主数据存储数据库。
- SpringBoot框架。

支持服务：
- 根据cron定时执行任务。

（可扩展一次执行。）

### 2.1. 项目框架准备

#### 2.1.1. 添加maven库

```xml
<!-- lombok -->
<dependency>
  <groupId>org.projectlombok</groupId>
  <artifactId>lombok</artifactId>
</dependency>
<!-- quartz -->
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-quartz</artifactId>
</dependency>
<dependency>
  <groupId>org.quartz-scheduler</groupId>
  <artifactId>quartz</artifactId>
  <version>2.2.3</version>
</dependency>
<dependency>
  <groupId>org.quartz-scheduler</groupId>
  <artifactId>quartz-jobs</artifactId>
  <version>2.2.3</version>
</dependency>
<dependency>
  <groupId>org.springframework</groupId>
  <artifactId>spring-context-support</artifactId>
</dependency>
<!-- Spring Boot web启动器 -->
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-web</artifactId>
</dependency>
<!-- Mysql -->
<dependency>
  <groupId>mysql</groupId>
  <artifactId>mysql-connector-java</artifactId>
</dependency>
<!-- MongoDB -->
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-data-jpa</artifactId>
</dependency>
<dependency>
  <groupId>org.springframework.boot</groupId>
  <artifactId>spring-boot-starter-data-mongodb</artifactId>
</dependency>
```

#### 2.1.2. 执行 Mysql sql文件

> job运行时需要的文件，主要作用是持久化。

```sql
#
# Quartz seems to work best with the driver mm.mysql-2.0.7-bin.jar
#
# PLEASE consider using mysql with innodb tables to avoid locking issues
#
# In your Quartz properties file, you'll need to set
# org.quartz.jobStore.driverDelegateClass = org.quartz.impl.jdbcjobstore.StdJDBCDelegate
#

DROP TABLE IF EXISTS QRTZ_FIRED_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_PAUSED_TRIGGER_GRPS;
DROP TABLE IF EXISTS QRTZ_SCHEDULER_STATE;
DROP TABLE IF EXISTS QRTZ_LOCKS;
DROP TABLE IF EXISTS QRTZ_SIMPLE_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_SIMPROP_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_CRON_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_BLOB_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_TRIGGERS;
DROP TABLE IF EXISTS QRTZ_JOB_DETAILS;
DROP TABLE IF EXISTS QRTZ_CALENDARS;


CREATE TABLE QRTZ_JOB_DETAILS
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    JOB_NAME  VARCHAR(200) NOT NULL,
    JOB_GROUP VARCHAR(200) NOT NULL,
    DESCRIPTION VARCHAR(250) NULL,
    JOB_CLASS_NAME   VARCHAR(250) NOT NULL,
    IS_DURABLE VARCHAR(1) NOT NULL,
    IS_NONCONCURRENT VARCHAR(1) NOT NULL,
    IS_UPDATE_DATA VARCHAR(1) NOT NULL,
    REQUESTS_RECOVERY VARCHAR(1) NOT NULL,
    JOB_DATA BLOB NULL,
    PRIMARY KEY (SCHED_NAME,JOB_NAME,JOB_GROUP)
);

CREATE TABLE QRTZ_TRIGGERS
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    TRIGGER_NAME VARCHAR(200) NOT NULL,
    TRIGGER_GROUP VARCHAR(200) NOT NULL,
    JOB_NAME  VARCHAR(200) NOT NULL,
    JOB_GROUP VARCHAR(200) NOT NULL,
    DESCRIPTION VARCHAR(250) NULL,
    NEXT_FIRE_TIME BIGINT(13) NULL,
    PREV_FIRE_TIME BIGINT(13) NULL,
    PRIORITY INTEGER NULL,
    TRIGGER_STATE VARCHAR(16) NOT NULL,
    TRIGGER_TYPE VARCHAR(8) NOT NULL,
    START_TIME BIGINT(13) NOT NULL,
    END_TIME BIGINT(13) NULL,
    CALENDAR_NAME VARCHAR(200) NULL,
    MISFIRE_INSTR SMALLINT(2) NULL,
    JOB_DATA BLOB NULL,
    PRIMARY KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP),
    FOREIGN KEY (SCHED_NAME,JOB_NAME,JOB_GROUP)
        REFERENCES QRTZ_JOB_DETAILS(SCHED_NAME,JOB_NAME,JOB_GROUP)
);

CREATE TABLE QRTZ_SIMPLE_TRIGGERS
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    TRIGGER_NAME VARCHAR(200) NOT NULL,
    TRIGGER_GROUP VARCHAR(200) NOT NULL,
    REPEAT_COUNT BIGINT(7) NOT NULL,
    REPEAT_INTERVAL BIGINT(12) NOT NULL,
    TIMES_TRIGGERED BIGINT(10) NOT NULL,
    PRIMARY KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP),
    FOREIGN KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
        REFERENCES QRTZ_TRIGGERS(SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
);

CREATE TABLE QRTZ_CRON_TRIGGERS
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    TRIGGER_NAME VARCHAR(200) NOT NULL,
    TRIGGER_GROUP VARCHAR(200) NOT NULL,
    CRON_EXPRESSION VARCHAR(200) NOT NULL,
    TIME_ZONE_ID VARCHAR(80),
    PRIMARY KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP),
    FOREIGN KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
        REFERENCES QRTZ_TRIGGERS(SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
);

CREATE TABLE QRTZ_SIMPROP_TRIGGERS
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    TRIGGER_NAME VARCHAR(200) NOT NULL,
    TRIGGER_GROUP VARCHAR(200) NOT NULL,
    STR_PROP_1 VARCHAR(512) NULL,
    STR_PROP_2 VARCHAR(512) NULL,
    STR_PROP_3 VARCHAR(512) NULL,
    INT_PROP_1 INT NULL,
    INT_PROP_2 INT NULL,
    LONG_PROP_1 BIGINT NULL,
    LONG_PROP_2 BIGINT NULL,
    DEC_PROP_1 NUMERIC(13,4) NULL,
    DEC_PROP_2 NUMERIC(13,4) NULL,
    BOOL_PROP_1 VARCHAR(1) NULL,
    BOOL_PROP_2 VARCHAR(1) NULL,
    PRIMARY KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP),
    FOREIGN KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
    REFERENCES QRTZ_TRIGGERS(SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
);

CREATE TABLE QRTZ_BLOB_TRIGGERS
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    TRIGGER_NAME VARCHAR(200) NOT NULL,
    TRIGGER_GROUP VARCHAR(200) NOT NULL,
    BLOB_DATA BLOB NULL,
    PRIMARY KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP),
    FOREIGN KEY (SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
        REFERENCES QRTZ_TRIGGERS(SCHED_NAME,TRIGGER_NAME,TRIGGER_GROUP)
);

CREATE TABLE QRTZ_CALENDARS
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    CALENDAR_NAME  VARCHAR(200) NOT NULL,
    CALENDAR BLOB NOT NULL,
    PRIMARY KEY (SCHED_NAME,CALENDAR_NAME)
);

CREATE TABLE QRTZ_PAUSED_TRIGGER_GRPS
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    TRIGGER_GROUP  VARCHAR(200) NOT NULL,
    PRIMARY KEY (SCHED_NAME,TRIGGER_GROUP)
);

CREATE TABLE QRTZ_FIRED_TRIGGERS
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    ENTRY_ID VARCHAR(95) NOT NULL,
    TRIGGER_NAME VARCHAR(200) NOT NULL,
    TRIGGER_GROUP VARCHAR(200) NOT NULL,
    INSTANCE_NAME VARCHAR(200) NOT NULL,
    FIRED_TIME BIGINT(13) NOT NULL,
    SCHED_TIME BIGINT(13) NOT NULL,
    PRIORITY INTEGER NOT NULL,
    STATE VARCHAR(16) NOT NULL,
    JOB_NAME VARCHAR(200) NULL,
    JOB_GROUP VARCHAR(200) NULL,
    IS_NONCONCURRENT VARCHAR(1) NULL,
    REQUESTS_RECOVERY VARCHAR(1) NULL,
    PRIMARY KEY (SCHED_NAME,ENTRY_ID)
);

CREATE TABLE QRTZ_SCHEDULER_STATE
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    INSTANCE_NAME VARCHAR(200) NOT NULL,
    LAST_CHECKIN_TIME BIGINT(13) NOT NULL,
    CHECKIN_INTERVAL BIGINT(13) NOT NULL,
    PRIMARY KEY (SCHED_NAME,INSTANCE_NAME)
);

CREATE TABLE QRTZ_LOCKS
  (
    SCHED_NAME VARCHAR(120) NOT NULL,
    LOCK_NAME  VARCHAR(40) NOT NULL,
    PRIMARY KEY (SCHED_NAME,LOCK_NAME)
);


commit;

```

#### 2.1.3. 项目配置

```yml
server.port=9992
# MongoDB数据库
spring.data.mongodb.uri=mongodb://127.0.0.1:27017/gsf_mongodb_20210710
#=======================================================
#调度器配置
#=======================================================
org.quartz.scheduler.instanceId=AUTO
org.quartz.scheduler.instanceName=project1QuartzScheduler
org.quartz.scheduler.rmi.export=false
org.quartz.scheduler.rmi.proxy=false
#=======================================================
#线程池配置
#=======================================================
org.quartz.threadPool.class=org.quartz.simpl.SimpleThreadPool
org.quartz.threadPool.threadCount=5
org.quartz.threadPool.threadPriority=5
org.quartz.threadPool.threadsInheritContextClassLoaderOfInitializingThread=true
#=======================================================
#JobStore配置
#=======================================================
org.quartz.jobStore.misfireThreshold=60000
org.quartz.jobStore.class=org.quartz.impl.jdbcjobstore.JobStoreTX
org.quartz.jobStore.driverDelegateClass=org.quartz.impl.jdbcjobstore.StdJDBCDelegate
org.quartz.jobStore.isClustered=false
org.quartz.jobStore.tablePrefix=QRTZ_
org.quartz.jobStore.dataSource=myDS
#=======================================================
#Mysql数据库配置
#=======================================================
org.quartz.dataSource.myDS.driver=com.mysql.jdbc.Driver
org.quartz.dataSource.myDS.URL=jdbc:mysql://localhost:3306/gsf_quartz_20210711?characterEncoding=utf-8
org.quartz.dataSource.myDS.user=root
org.quartz.dataSource.myDS.password=guoshunfa
org.quartz.dataSource.myDS.maxConnections=5

```

### 2.2. 服务代码

#### 2.2.1. Job服务统一执行类

```java
import cn.hutool.extra.spring.SpringUtil;
import com.gsf.job.entity.JobDataMap;
import lombok.Getter;
import lombok.Setter;
import org.quartz.JobDetail;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.scheduling.quartz.QuartzJobBean;

import java.lang.reflect.Method;

//@DisallowConcurrentExecution // 并发处理
public class JobAutoExe extends QuartzJobBean {

    /**
     * 由quartz框架自动设值：jobDetail.getJobDataMap().put("jobId", bean.getId()) 这里面的值都会被设置到实例中
     */
    @Getter
    @Setter
    private String jobId;

    @Autowired
    private MongoTemplate mongoTemplate;

    @Override
    protected void executeInternal(JobExecutionContext jobExecutionContext) throws JobExecutionException {
        JobDetail jobdetail = jobExecutionContext.getJobDetail();
        JobDataMap jobDataMap = mongoTemplate.findById(jobId, JobDataMap.class);
        if (jobDataMap == null) {
            return;
        }
        Object service = SpringUtil.getBean(jobDataMap.getClassName());
        try {
            Method method = service.getClass().getMethod(jobDataMap.getMethodName());
            method.invoke(service);
        } catch (Exception e) {
            e.printStackTrace();
        }
        System.out.println("job统一执行类");
    }

}
```

#### 2.2.2. Job服务调用

```java
import com.gsf.job.entity.JobDataMap;
import org.quartz.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.text.ParseException;

@Service
public class QuartzService {

    @Autowired
    private MongoTemplate mongoTemplate;

    @Autowired
    private Scheduler scheduler;

    /**
     * 保存/修改job
     * @param bean
     */
    public void saveJob(JobDataMap bean) {
        try {
            JobKey jobKey = new JobKey(bean.getJobName());
            JobDetail jobDetail = scheduler.getJobDetail(jobKey);
            if (jobDetail == null) {
                jobDetail = newJobDetail(bean);
            }
            Trigger trigger = newCronTrigger(bean);
            if (trigger != null) {
                scheduler.scheduleJob(jobDetail, trigger);
            }
            cronUpdate(bean);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException(e);
        }
    }

    /**
     * 移除job
     * @param bean
     */
    public void removeJob(JobDataMap bean) {
        try {
            TriggerKey key = new TriggerKey(bean.getJobName());
            scheduler.pauseTrigger(key);
            scheduler.unscheduleJob(key);
            JobKey jobKey = new JobKey(bean.getJobName());
            scheduler.deleteJob(jobKey);
        } catch (SchedulerException e) {
            throw new RuntimeException(e);
        }
    }

    public void pausedJob(JobDataMap bean) {
        try {
            if (bean.isPaused()) {
                scheduler.pauseTrigger(new TriggerKey(bean.getJobName()));
            } else {
                scheduler.resumeTrigger(new TriggerKey(bean.getJobName()));
            }
        } catch (SchedulerException e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * cron 调整
     * @param bean
     */
    private void cronUpdate(JobDataMap bean) {
        try {
            JobKey jobKey = new JobKey(bean.getJobName());
            JobDetail quartzJob = scheduler.getJobDetail(jobKey);
            if (quartzJob == null) {//没有任务时创建任务并调度
                quartzJob = newJobDetail(bean);
                Trigger trigger = newCronTrigger(bean);
                if (trigger != null) {
                    scheduler.scheduleJob(quartzJob, trigger);
                }
            } else {//重新调度
                TriggerKey triggerKey = new TriggerKey(bean.getJobName());
                Trigger trigger = newCronTrigger(bean);
                scheduler.rescheduleJob(triggerKey, trigger);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private JobDetail newJobDetail(JobDataMap bean) throws InstantiationException, IllegalAccessException {
        JobDetail jobDetail = JobBuilder.newJob(JobAutoExe.class)
                .withIdentity(bean.getJobName()).build();
        jobDetail.getJobDataMap().put("jobId", bean.getId());//job实例执行前会将这些属性值设置进实例中，运行前根据id查询详情
        return jobDetail;
    }

    /**
     * 根据调度设置决定使用cron还是毫秒数
     *
     * @param bean
     * @return
     * @throws ParseException
     */
    private Trigger newCronTrigger(JobDataMap bean) throws ParseException {
        if (StringUtils.isEmpty(bean.getCron())) {
            return null;
        }
        return TriggerBuilder.newTrigger().forJob(bean.getJobName())
                .withIdentity(bean.getJobName())
                .withSchedule(CronScheduleBuilder.cronSchedule(bean.getCron()))
                .build();
    }

}

```

#### 2.2.3. Job通用实体类

```java
import com.gsf.common.base.BaseEntity;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

@Data
public class JobDataMap extends BaseEntity {
    @ApiModelProperty("job名称")
    private String jobName;

    @ApiModelProperty("类名称")
    private String className;

    @ApiModelProperty("方法名称")
    private String methodName;

    @ApiModelProperty("cron规则")
    private String cron;

    @ApiModelProperty("任务状态，是否暂停。默认不暂停")
    private boolean paused = false;
}
```

#### 2.2.4. Job服务调用

```java
import com.gsf.job.entity.JobDataMap;
import com.gsf.job.schedule.QuartzService;
import com.mongodb.client.result.DeleteResult;
import com.mongodb.client.result.UpdateResult;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.data.mongodb.core.query.Update;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class JobController {

    @Autowired
    private MongoTemplate mongoTemplate;

    @Autowired
    private QuartzService quartzService;

    @PostMapping("/job/save")
    @ApiOperation(value = "创建/修改job信息")
    public JobDataMap saveJob(@RequestBody JobDataMap jobData) {
        JobDataMap data = mongoTemplate.save(jobData);
        quartzService.saveJob(data);
        return data;
    }

    @GetMapping("/job/remove")
    @ApiOperation(value = "删除job")
    public DeleteResult removeJob(@ApiParam(name = "jobId", required = true) String jobId) {
        DeleteResult deleteResult = mongoTemplate.remove(Query.query(Criteria.where("id").is(jobId)), JobDataMap.class);
        JobDataMap data = mongoTemplate.findById(jobId, JobDataMap.class);
        quartzService.removeJob(data);
        return deleteResult;
    }

    @GetMapping("/job/paused")
    @ApiOperation(value = "暂停/运行job")
    public UpdateResult pausedJob(
            @ApiParam(name = "jobId", required = true) String jobId
            , @ApiParam(name = "paused", required = true) Boolean paused) {
        UpdateResult updateResult = mongoTemplate.updateFirst(Query.query(Criteria.where("id").is(jobId)),
                Update.update("paused", paused), JobDataMap.class);
        JobDataMap data = mongoTemplate.findById(jobId, JobDataMap.class);
        quartzService.pausedJob(data);
        return updateResult;
    }
}

```

#### 2.2.5. 测试

```java
public class TestJob {

  @Test
  public void saveJob() {
    String url = "http://127.0.0.1:9992/job/save";

    JobDataMap jobDataMap = new JobDataMap();
    jobDataMap.setClassName("TestJob");
    jobDataMap.setJobName("测试job");
    jobDataMap.setCron("*/5 * * * * ?"); // 每隔5秒执行一次
    jobDataMap.setMethodName("doJob");
    jobDataMap.setPaused(true);

    String post = HttpUtil.post(url, JSONUtil.toJsonStr(jobDataMap));
    System.out.println(post);
  }

}
```





## 3. 提升

### 3.1. 并发控制（DisallowConcurrentExecution注解）

​		Quartz定时任务默认都是并发执行的，不会等待上一次任务执行完毕，只要间隔时间到就会执行, 如果定时任执行太长，会长时间占用资源，导致其它任务堵塞。


​		在Spring中这时需要设置concurrent的值为false, 禁止并发执行。

​		` <property name="concurrent" value="true" />`
​		当不使用spring的时候就需要在Job的实现类上加@DisallowConcurrentExecution的注释
@DisallowConcurrentExecution 禁止并发执行多个相同定义的JobDetail, 这个注解是加在Job类上的, 但意思并不是不能同时执行多个Job, 而是不能并发执行同一个Job Definition(由JobDetail定义), 但是可以同时执行多个不同的JobDetail, 举例说明,我们有一个Job类,叫做SayHelloJob, 并在这个Job上加了这个注解, 然后在这个Job上定义了很多个JobDetail, 如sayHelloToJoeJobDetail, sayHelloToMikeJobDetail, 那么当scheduler启动时, 不会并发执行多个sayHelloToJoeJobDetail或者sayHelloToMikeJobDetail, 但可以同时执行sayHelloToJoeJobDetail跟sayHelloToMikeJobDetail

- @PersistJobDataAfterExecution 同样, 也是加在Job上,表示当正常执行完Job后, JobDataMap中的数据应该被改动, 以被下一次调用时用。当使用- - @PersistJobDataAfterExecution 注解时, 为了避免并发时, 存储数据造成混乱, 强烈建议把@DisallowConcurrentExecution注解也加上。




@DisallowConcurrentExecution

- 此标记用在实现Job的类上面,意思是不允许并发执行,按照我之前的理解是 不允许调度框架在同一时刻调用Job类，后来经过测试发现并不是这样，而是Job(任务)的执行时间[比如需要10秒]大于任务的时间间隔[Interval（5秒)],那么默认情况下,调度框架为了能让 任务按照我们预定的时间间隔执行,会马上启用新的线程执行任务。否则的话会等待任务执行完毕以后 再重新执行！（这样会导致任务的执行不是按照我们预先定义的时间间隔执行）
- 测试代码，这是官方提供的例子。设定的时间间隔为3秒,但job执行时间是5秒,设置@DisallowConcurrentExecution以后程序会等任务执行完毕以后再去执行,否则会在3秒时再启用新的线程执行
