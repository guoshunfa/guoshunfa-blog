---
title: 搭建单体SpringBoot项目 集成FreeMarker模板引擎
tags:
    - SpringBoot
    - 集成
    - FreeMarker
    - 模版引擎
categories:
    - 技术
    - 搭建单体SpringBoot项目
date: 2022-07-01 12:01:01
thumbnail:
---

> [官网](https://freemarker.apache.org) | [中文官网](http://freemarker.foofun.cn) 
>
> 本文暂不介绍freemarker api，以案例的方式进行介绍。

项目引入freemarker

```xml
<dependency>
  <groupId>org.freemarker</groupId>
  <artifactId>freemarker</artifactId>
  <version>2.3.31</version>
</dependency>
```

## FreeMarker使用doc模板

使用doc模版，将数据引入。

模版示例：

![image-20220815090000392](https://file.pandacode.cn/blog/202208150900661.png)

结果示例：

![image-20220815090416991](https://file.pandacode.cn/blog/202208150904035.png)

1. 先准备doc模版文件。将需要放入值的属性加上`${}`，如：`${aa}`。
2. 将准备好的doc文件转换成html文件。
3. 将html文件放入同项目的templates中（如要调整存放文件位置，可以同步把下方工具类里路径也调整了。）
4. 引入下方工具类。
5. 使用工具类。

> 工具类可以根据个人需求进行调整。

```java
// 工具类
import com.ruoyi.common.config.RuoYiConfig;
import com.ruoyi.common.core.domain.AjaxResult;
import freemarker.template.Configuration;
import freemarker.template.Template;

import java.io.*;
import java.util.Map;
import java.util.UUID;

public class WordUtil {
    private static Configuration configuration = null;
    static {
        configuration = new Configuration();
        configuration.setDefaultEncoding("utf-8");
        configuration.setClassForTemplateLoading(WordUtil.class, "/templates");
    }

    private WordUtil() {
        throw new AssertionError();
    }

    public static AjaxResult exportMillCertificateWord(Map map, String title, String ftlFile) throws IOException {
        Template freemarkerTemplate = configuration.getTemplate(ftlFile);
        String fileName = UUID.randomUUID().toString() + "_" + title + ".doc";
        String downloadPath = RuoYiConfig.getDownloadPath() + fileName;
        File desc = new File(downloadPath);
        if (!desc.getParentFile().exists())
        {
            desc.getParentFile().mkdirs();
        }
        // 调用工具类的createDoc方法生成Word文档
        createDoc(map,freemarkerTemplate,downloadPath);
        return AjaxResult.success(fileName);
    }

    private static File createDoc(Map<?, ?> dataMap, Template template, String name) {
        File f = new File(name);
        Template t = template;
        try {
            // 这个地方不能使用FileWriter因为需要指定编码类型否则生成的Word文档会因为有无法识别的编码而无法打开
            Writer w = new OutputStreamWriter(new FileOutputStream(f), "utf-8");
            t.process(dataMap, w);
            w.close();
        } catch (Exception ex) {
            ex.printStackTrace();
            throw new RuntimeException(ex);
        }
        return f;
    }
}
```

```java
// 使用工具类
Map map = new HashMap();
map.put("aa","张三");
map.put("bb","李四");
map.put("cc","王五");
map.put("dd","赵六");
map.put("ee","孙七");
return WordUtil.exportMillCertificateWord(map,"offer","test.html");
```

## 参考文档

- [**java使用freemarker通过模板导出word(基于若依)**](https://blog.51cto.com/u_15067246/4534434)