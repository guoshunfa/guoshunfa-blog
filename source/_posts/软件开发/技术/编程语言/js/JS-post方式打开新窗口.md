---
title: JS post方式打开新窗口
tags:
  - JS
categories:
  - HTML/CSS/JavaScript
date: 2022-07-01 12:01:01
thumbnail:
---

> 原理：
>
> 1. 前端在打开浏览器窗口的同时，放入一段html代码。
> 2. html代码包含表单，也就相当于模拟表单post方式提交。
> 3. 后端接口也通过表单的方式接受参数。

## 1. html

```html
<input id="btn_amp" type="button" value="点点点" />
<script src="https://cdn.bootcss.com/jquery/1.12.4/jquery.min.js"></script>

<script>
    $(function () {
        $("#btn_amp").click(function () {
            var url = "http://localhost:8080/test3";
            var keys = ["userName"];
            var values = ["123"];
            openWindowWithPost(url, "预览", 500, 400, null, keys, values);
        });
    });
    /**
     * 调用
     */
    function openWindowWithPost(url, name, width, height, resizable, keys, values) {
        var screenWidth = screen.availWidth, screenHeight = screen.availHeight;
        var para = "";
        para += 'width=' + (width ? width : screenWidth - 20);
        para += ',height=' + (height ? height : screenHeight - 43);
        para += ',left=' + (width ? (screenWidth - width) / 2 : 0);
        para += ',top=' + (height ? (screenHeight - height) / 2 : 0);
        if (resizable) para += ',resizable = yes';
        if (!name) name = "";

        var newWindow = window.open("", name, para);
        if (!newWindow) {
            return false;
        }

        var html = "";
        html += "<html><head></head><body><form id='formid' method='post' action='" + url + "'>";
        if (keys && values && (keys.length == values.length)) {
            for (var i = 0; i < keys.length; i++) {
                html += "<input type='hidden' name='" + keys[i] + "' value='" + values[i] + "'/>";
            }
        }

        html += "</form><script type='text/javascript'>document.getElementById(\"formid\").submit()<\/script><\/body><\/html>";
        newWindow.document.write(html);
        return newWindow;
    }
</script>
```

## 2. 接口

```java
@PostMapping("/test3")
public String test3Conllection(@RequestParam("userName") String userName) {
    return "测试成功！userName="+userName;
}
```



