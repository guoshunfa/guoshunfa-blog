---
title: 搭建单体SpringBoot项目 集成FastJson json数据处理
tags:
   - SpringBoot
   - 集成
   - FastJson
   - Json
categories:
   - 技术
   - 搭建单体SpringBoot项目
date: 2022-07-01 12:01:01
thumbnail:
---

## 1. 集成 Fastjson

简单使用

- 通过maven引入相应的json包

```xml
    <dependencies>
        <dependency>
            <groupId>com.alibaba</groupId>
            <artifactId>fastjson</artifactId>
            <version>1.2.49</version>
        </dependency>
    </dependencies>
```

## 2. fastjson - 自定义序列化

> 序列化时需要进行特殊处理的**类型**，可以进行特殊配置。

### 2.1. 自定义反序列化解析器 - ObjectSerializer

```java
package com.ivan.json.converter;

import java.io.IOException;
import java.lang.reflect.Type;

import com.alibaba.fastjson.serializer.JSONSerializer;
import com.alibaba.fastjson.serializer.ObjectSerializer;

public class SexSerializer implements ObjectSerializer {

    public void write(JSONSerializer serializer,
                      Object object,
                      Object fieldName,
                      Type fieldType,
                      int features)
            throws IOException {
        /**
        	* 处理过程
        	*/
        // text为处理结果
        serializer.write(text);
    }

}
```

### 2.2. 使用解析器

有三种方法，按情况决定使用哪种。

1. 定义的字段上加解析器注解

```java
@Setter
@Getter
private static class ResultData {
		@JSONField(serializeUsing = SexSerializer.class)
    private Sex sex;
}
```

2. **框架统一配置**，序列化时会根据类型进行匹配。

   在WebAppConfigurer#configureMessageConverters中加入。

```java
SerializeConfig.getGlobalInstance().put(AlarmString.class,AlarmStringSerializer.instance);
```

3. 系列化时使用。

```java
SerializeConfig config = new SerializeConfig();
config.put(AlarmString.class,AlarmStringSerializer.instance);
String jsonStr = JSON.toJsonString(alarm, config);
```

### 2.3. 序列化相关的概念

- SerializeConfig：内部是个map容器主要功能是配置并记录每种Java类型对应的序列化类。

- SerializeWriter 继承自Java的Writer，其实就是个转为FastJSON而生的StringBuilder，完成高性能的字符串拼接。

- SerializeFilter: 用于对对象的序列化实现各种定制化的需求。

- SerializerFeature：对于对输出的json做各种格式化的需求。

- JSONSerializer：相当于一个序列化组合器，集成了SerializeConfig， SerializeWriter ， SerializeFilter与SerializerFeature。

  

  序列化的入口代码如下，上面提到的各种概念都包含了

```java
    public static String toJSONString(Object object, // 
                                      SerializeConfig config, // 
                                      SerializeFilter[] filters, // 
                                      String dateFormat, //
                                      int defaultFeatures, // 
                                      SerializerFeature... features) {
        SerializeWriter out = new SerializeWriter(null, defaultFeatures, features);

        try {
            JSONSerializer serializer = new JSONSerializer(out, config);
            
            if (dateFormat != null && dateFormat.length() != 0) {
                serializer.setDateFormat(dateFormat);
                serializer.config(SerializerFeature.WriteDateUseDateFormat, true);
            }

            if (filters != null) {
                for (SerializeFilter filter : filters) {
                    serializer.addFilter(filter);
                }
            }

            serializer.write(object);

            return out.toString();
        } finally {
            out.close();
        }
    }
```

## 3. fastjson - 自定义反序列化

> 反序列化时需要进行特殊处理的**类型**，可以进行特殊配置。

### 3.1. 自定义反序列化解析器 - ObjectDeserializer

```java
public class PersonDeserializer implements ObjectDeserializer {

    @Override
    public Person deserialze(DefaultJSONParser parser, Type type, Object fieldName) {
				/*
				 * 处理过程
				 */
      
      	// 处理之后的返回结果
        return null;
    }

    @Override
    public int getFastMatchToken() {
        return 0;
    }

}

```

### 3.2. 使用解析器

有三种方法，按情况决定使用哪种。

1. 定义的字段上加解析器注解

```java
@Setter
@Getter
private static class ResultData {
		@JSONField(deserializeUsing = PersonDeserializer.class)
    private Person personInfo;
}
```

2. **框架统一配置**，反序列化时会根据类型进行匹配。

   在WebAppConfigurer#configureMessageConverters中加入。

```java
ParserConfig.getGlobalInstance().putDeserializer(AlarmString.class,AlarmStringDeserializer.instance);
```

3. 反系列化时使用。

```java
ParserConfig parserConfig = new ParserConfig();
parserConfig.putDeserializer(AlarmString.class, AlarmStringDeserializer.instance);
Alarm alarm = JSON.parseObject(jsonStr, Alarm.class, parserConfig);
```

###### 3.2.1. 反序列化相关的概念

- ParserConfig：内部通过一个map保存各种ObjectDeserializer。
- JSONLexer : 与SerializeWriter相对应，用于解析json字符串。
- JSONToken：定义了一系统的特殊字符，这些称为token。
- ParseProcess ：定制反序列化，类似于SerializeFilter。
- Feature：用于定制各种反序列化的特性。
- DefaultJSONParser：相当于反序列化组合器，集成了ParserConfig，Feature， JSONLexer 与ParseProcess。

反序列化的入口代码如下，上面的概念基本都包含了：

```java
    @SuppressWarnings("unchecked")
    public static <T> T parseObject(String input, Type clazz, ParserConfig config, ParseProcess processor,
                                          int featureValues, Feature... features) {
        if (input == null) {
            return null;
        }

        if (features != null) {
            for (Feature feature : features) {
                featureValues |= feature.mask;
            }
        }

        DefaultJSONParser parser = new DefaultJSONParser(input, config, featureValues);

        if (processor != null) {
            if (processor instanceof ExtraTypeProvider) {
                parser.getExtraTypeProviders().add((ExtraTypeProvider) processor);
            }

            if (processor instanceof ExtraProcessor) {
                parser.getExtraProcessors().add((ExtraProcessor) processor);
            }

            if (processor instanceof FieldTypeResolver) {
                parser.setFieldTypeResolver((FieldTypeResolver) processor);
            }
        }

        T value = (T) parser.parseObject(clazz, null);

        parser.handleResovleTask(value);

        parser.close();

        return (T) value;
    }
```



## 4. JSONField与JSONType注解的使用

### 4.1. @JSONField

​		fastjson提供了JSONField对序列化与反序列化进行定制，比如可以指定字段的名称，序列化的顺序。JSONField用于属性，方法方法参数上。JSONField的源码如下：

```java
package com.alibaba.fastjson.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;
import com.alibaba.fastjson.parser.Feature;
import com.alibaba.fastjson.serializer.SerializerFeature;

@Retention(RetentionPolicy.RUNTIME)
@Target({ ElementType.METHOD, ElementType.FIELD, ElementType.PARAMETER })
public @interface JSONField {
// 配置序列化和反序列化的顺序
    int ordinal() default 0;
// 指定字段的名称
    String name() default "";
// 指定字段的格式，对日期格式有用
    String format() default "";
 // 是否序列化
    boolean serialize() default true;
// 是否反序列化
    boolean deserialize() default true;
//字段级别的SerializerFeature
    SerializerFeature[] serialzeFeatures() default {};
//
    Feature[] parseFeatures() default {};
   //给属性打上标签， 相当于给属性进行了分组
    String label() default "";
    
    boolean jsonDirect() default false;
    
//制定属性的序列化类
    Class<?> serializeUsing() default Void.class;
 //制定属性的反序列化类
    Class<?> deserializeUsing() default Void.class;

    String[] alternateNames() default {};

    boolean unwrapped() default false;
}
```

### 4.2. @JSONType

​		fastjosn提供了JSONType用于类级别的定制化, JSONType的源码如下：

```java
package com.alibaba.fastjson.annotation;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

import com.alibaba.fastjson.PropertyNamingStrategy;
import com.alibaba.fastjson.parser.Feature;
import com.alibaba.fastjson.serializer.SerializeFilter;
import com.alibaba.fastjson.serializer.SerializerFeature;

@Retention(RetentionPolicy.RUNTIME)
//需要标注在类上
@Target({ ElementType.TYPE })
public @interface JSONType {

    boolean asm() default true;
//这里可以定义输出json的字段顺序
    String[] orders() default {};
//包含的字段
    String[] includes() default {};
//不包含的字段
    String[] ignores() default {};
//类级别的序列化特性定义
    SerializerFeature[] serialzeFeatures() default {};
    Feature[] parseFeatures() default {};
    //按字母顺序进行输出
    boolean alphabetic() default true;
    
    Class<?> mappingTo() default Void.class;
    
    Class<?> builder() default Void.class;
    
    String typeName() default "";

    String typeKey() default "";
    
    Class<?>[] seeAlso() default{};
    //序列化类
    Class<?> serializer() default Void.class;
    //反序列化类
    Class<?> deserializer() default Void.class;

    boolean serializeEnumAsJavaBean() default false;

    PropertyNamingStrategy naming() default PropertyNamingStrategy.CamelCase;

    Class<? extends SerializeFilter>[] serialzeFilters() default {};
}
```

## 5. SerializeFilter

​	fastjson通过SerializeFilter编程扩展的方式定制序列化fastjson支持以下SerializeFilter用于不同常景的定制序列化：

- PropertyFilter 根据PropertyName和PropertyValue来判断是否序列化,接口定义如下：

```
package com.alibaba.fastjson.serializer;

/**
 * @author wenshao[szujobs@hotmail.com]
 */
public interface PropertyFilter extends SerializeFilter {

    /**
     * @param object the owner of the property
     * @param name the name of the property
     * @param value the value of the property
     * @return true if the property will be included, false if to be filtered out
    * 根据 属性的name与value判断是否进行序列化
     */
    boolean apply(Object object, String name, Object value);
}
```

- PropertyPreFilter根据PropertyName判断是否序列化

```
package com.alibaba.fastjson.serializer;

public interface PropertyPreFilter extends SerializeFilter {

//根据 object与name判断是否进行序列化
    boolean apply(JSONSerializer serializer, Object object, String name);
}
```

- NameFilter 序列化时修改Key

```
package com.alibaba.fastjson.serializer;

public interface NameFilter extends SerializeFilter {
//根据 name与value的值，返回json字段key的值
    String process(Object object, String name, Object value);
}
```

- ValueFilter 序列化时修改Value

```
package com.alibaba.fastjson.serializer;

public interface ValueFilter extends SerializeFilter {
  //根据name与value定制输出json的value
    Object process(Object object, String name, Object value);
}
```

- BeforeFilter 在序列化对象的所有属性之前执行某些操作

```
package com.alibaba.fastjson.serializer;

public abstract class BeforeFilter implements SerializeFilter {

    private static final ThreadLocal<JSONSerializer> serializerLocal = new ThreadLocal<JSONSerializer>();
    private static final ThreadLocal<Character>      seperatorLocal  = new ThreadLocal<Character>();

    private final static Character                   COMMA           = Character.valueOf(',');

    final char writeBefore(JSONSerializer serializer, Object object, char seperator) {
        serializerLocal.set(serializer);
        seperatorLocal.set(seperator);
        writeBefore(object);
        serializerLocal.set(null);
        return seperatorLocal.get();
    }

    protected final void writeKeyValue(String key, Object value) {
        JSONSerializer serializer = serializerLocal.get();
        char seperator = seperatorLocal.get();
        serializer.writeKeyValue(seperator, key, value);
        if (seperator != ',') {
            seperatorLocal.set(COMMA);
        }
    }
//需要实现的方法，在实际实现中可以调用writeKeyValue增加json的内容
    public abstract void writeBefore(Object object);
}
```

- AfterFilter 在序列化对象的所有属性之后执行某些操作

```
package com.alibaba.fastjson.serializer;

/**
 * @since 1.1.35
 */
public abstract class AfterFilter implements SerializeFilter {

    private static final ThreadLocal<JSONSerializer> serializerLocal = new ThreadLocal<JSONSerializer>();
    private static final ThreadLocal<Character>      seperatorLocal  = new ThreadLocal<Character>();

    private final static Character                   COMMA           = Character.valueOf(',');

    final char writeAfter(JSONSerializer serializer, Object object, char seperator) {
        serializerLocal.set(serializer);
        seperatorLocal.set(seperator);
        writeAfter(object);
        serializerLocal.set(null);
        return seperatorLocal.get();
    }

    protected final void writeKeyValue(String key, Object value) {
        JSONSerializer serializer = serializerLocal.get();
        char seperator = seperatorLocal.get();
        serializer.writeKeyValue(seperator, key, value);
        if (seperator != ',') {
            seperatorLocal.set(COMMA);
        }
    }
//子类需要实现的方法，实际使用的时候可以调用writeKeyValue增加内容
    public abstract void writeAfter(Object object);
}
```

- LabelFilter根据 JsonField配置的label来判断是否进行输出

```
package com.alibaba.fastjson.serializer;

//根据 JsonField配置的label来判断是否进行输出
public interface LabelFilter extends SerializeFilter {
    boolean apply(String label);
}
```

## 6. Fastjson - SerializerFeature特性的使用

fastjson通过SerializerFeature对生成的json格式的数据进行一些定制，比如可以输入的格式更好看，使用单引号而非双引号等。例子程序如下：

```java
package com.ivan.json;

import java.util.Date;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.serializer.SerializerFeature;
import com.ivan.json.entity.User;

public class SerializerFeatureTest {

    public static void main(String[] args) {
        User user = new User();
        user.setId(11L);
        user.setCreateTime(new Date());
        String jsonString = JSON.toJSONString(user, SerializerFeature.PrettyFormat, 
                SerializerFeature.WriteNullStringAsEmpty, SerializerFeature.UseSingleQuotes);
        System.out.println(jsonString);
    }

}
```

​		输出的结果如下：

```json
{
	'createTime':'2021-06-23 15:17:48',
	'id': 123
	'name': ''
}
```

SerializerFeature常用属性

| 名称                           | 含义                                                         |
| :----------------------------- | :----------------------------------------------------------- |
| QuoteFieldNames                | 输出key时是否使用双引号,默认为true                           |
| UseSingleQuotes                | 使用单引号而不是双引号,默认为false                           |
| WriteMapNullValue              | 是否输出值为null的字段,默认为false                           |
| WriteEnumUsingToString         | Enum输出name()或者original,默认为false                       |
| UseISO8601DateFormat           | Date使用ISO8601格式输出，默认为false                         |
| WriteNullListAsEmpty           | List字段如果为null,输出为[],而非null                         |
| WriteNullStringAsEmpty         | 字符类型字段如果为null,输出为”“,而非null                     |
| WriteNullNumberAsZero          | 数值字段如果为null,输出为0,而非null                          |
| WriteNullBooleanAsFalse        | Boolean字段如果为null,输出为false,而非null                   |
| SkipTransientField             | 如果是true，类中的Get方法对应的Field是transient，序列化时将会被忽略。默认为true |
| SortField                      | 按字段名称排序后输出。默认为false                            |
| WriteTabAsSpecial              | 把\t做转义输出，默认为false不推荐设为true                    |
| PrettyFormat                   | 结果是否格式化,默认为false                                   |
| WriteClassName                 | 序列化时写入类型信息，默认为false。反序列化是需用到          |
| DisableCircularReferenceDetect | 消除对同一对象循环引用的问题，默认为false                    |
| WriteSlashAsSpecial            | 对斜杠’/’进行转义                                            |
| BrowserCompatible              | 将中文都会序列化为\uXXXX格式，字节数会多一些，但是能兼容IE 6，默认为false |
| WriteDateUseDateFormat         | 全局修改日期格式,默认为false。                               |
| DisableCheckSpecialChar        | 一个对象的字符串属性中如果有特殊字符如双引号，将会在转成json时带有反斜杠转移符。如果不需要转义，可以使用这个属性。默认为false |
| BeanToArray                    | 将对象转为array输出                                          |

