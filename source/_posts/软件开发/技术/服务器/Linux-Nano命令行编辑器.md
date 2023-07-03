---
title: Linux Nano命令行编辑器
tags:
  - linux
  - nano
categories:
  - 技术
date: 2022-07-01 11:10:51
thumbnail:
---
转载自：https://www.myfreax.com/how-to-use-nano-text-editor/

在命令行上工作时，经常需要创建或编辑文本文件。Vim和Emacs是最强大和最受欢迎的两种命令行编辑器。两者都有陡峭的学习曲线，可能会吓到新用户。对于那些需要简单编辑器的人，可以使用nano。

GNU nano是用于Unix和Linux操作系统的易于使用的命令行文本编辑器。它包括您希望从常规文本编辑器获得的所有基本功能，例如语法高亮显示，多个缓冲区，使用正则表达式进行搜索和替换，拼写检查，UTF-8编码等。

在本教程中，我们将介绍使用nano编辑器的基础知识，包括如何创建和打开文件，编辑文件，保存文件，搜索和替换文本，剪切和粘贴文本，退出nano编辑器，配置nano，配置nano语法高亮。

## 安装Nano

Nano文本编辑器已预装在macOS和大多数Linux发行版上。要检查您的系统上是否安装了它，请输入：

```bash
nano --version
```

Copy

输出将如下所示：

```
GNU nano, version 2.9.3
(C) 1999-2011, 2013-2018 Free Software Foundation, Inc.
(C) 2014-2018 the contributors to nano
Email: nano@nano-editor.org	Web: https://nano-editor.org/
```

如果您的系统上未安装nano，则可以使用发行版的软件包管理器进行安装。

### 在Ubuntu和Debian上安装Nano

```bash
sudo apt install nano
```

Copy

### 在CentOS和Fedora上安装Nano

```bash
sudo yum install nano
```

Copy

## **打开和创建文件**

要打开现有文件或创建新文件，请键入，`nano`然后输入文件名：

```bash
nano filename
```

Copy

这将打开一个新的编辑器窗口，您可以开始编辑文件。在窗口的底部，列出了可与nano编辑器一起使用的按键快捷方式。

所有命令都以`^`或`M`字符作为前缀。`^`表示`Ctrl`键。例如，`^J`意味着同时按下`Ctrl`和`J`键。字母`M`代表`Alt` 键。您可以通过键入`Ctrl+g`获取所有命令的列表。



为了能够打开文件，您必须对该文件具有读取权限。如果要在打开文件是使光标在指定行和字符上，请使用以下语法：

```bash
nano +line_number,character_number filename
```

Copy

如果省略光标则将位于第一个字符上。

## 编辑文件

与vim不同，nano是一种无模式的编辑器，这意味着您可以在打开文件后立即开始输入和编辑文本。要将光标移动到特定的行和字符上，请使用`Ctrl+_`快捷键。你也可以在`Enter line number, column number:`字段中输入数字，然后按`Enter`。

## 搜索和替换

按下`Ctrl+w`将会搜索文本，然后键入搜索词，再按`Enter`。光标将移至第一个匹配项。要移至下一个匹配选项，请按`Alt+w`。

如果要搜索并替换，请按`Ctrl+\`。输入搜索词和要替换的文本。编辑器将移至第一个匹配项，并询问您是否替换它。`Y`或`N`后将移至下一个匹配项。按下`A`将替换所有匹配项。

## 复制/剪切和粘贴

要选择文本，请将光标移动到文本的开头，然后按`Alt+a`。这将设置一个选择标记。使用箭头键将光标移动到要选择的文本的末尾。所选文本将突出显示。如果要取消选择，请按`Ctrl+6`。

使用`Alt+6`命令将所选文本复制到剪贴板。`Ctrl+k`将剪切选定的文本。如果要剪切整行，只需将光标移至该行并按`Ctrl+k`。您可以通过`Ctrl+k`多次单击来剪切多行。

要粘贴文本，请将光标移动到要放置文本的位置，然后按`Ctrl+u`。

## 保存并退出

要保存对文件所做的更改，请按`Ctrl+o`。如果该文件尚不存在，则将在保存后立即创建该文件。

如果要退出nano，请按`Ctrl+x`。如果有未保存的更改，系统将询问您是否要保存更改。要保存文件，您必须具有对该文件的写权限。如果要[创建新文件](https://www.myfreax.com/create-a-file-in-linux/)，则需要对将要创建文件的目录具有写权限。

## **自定义Nano**

当启动nano时，它将从系统范围内配置文件`/etc/nanorc`和用户的配置文件`~/.config/nano/nanorc`或者`~/.nanorc`中读取其配置参数。用户文件中指定的选项优先于全局选项。访问[nanorc](https://www.nano-editor.org/dist/latest/nanorc.5.html)页面以获取所有可用选项的完整列表。

## 语法高亮

Nano附带了针对大多数流行文件类型的语法高亮规则。在大多数Linux系统上，语法文件存储在`/usr/share/nano`目录中，并且默认情况下包含在`/etc/nanorc`配置文件中。

```
include "/usr/share/nano/*.nanorc"
```

/etc/nanorc

要新文件类型启用语法高亮，最简单方式是将语法高亮规则文件添加到`/usr/share/nano`目录中。

## 将Nano设置为默认文本编辑器

在大多数Linux系统上，默认情况下，诸如`visudo`和[`crontab`命令](https://www.myfreax.com/scheduling-cron-jobs-with-crontab/)的默认文本编辑器设置为vi。要使用nano作为默认的文本编辑器，您需要更改`VISUAL`和`EDITOR`[环境变量](https://www.myfreax.com/how-to-set-and-list-environment-variables-in-linux/)。Bash用户可在`~/.bashrc`文件设置`VISUAL`和`EDITOR`[环境变量](https://www.myfreax.com/how-to-set-and-list-environment-variables-in-linux/)：

```
export VISUAL=nano
export EDITOR="$VISUAL"
```

~/.bashrc

## 基本的用法

开始使用nano编辑器的最基本步骤是。首先在终端键入`nano`后接文件名。根据需要编辑文件。使用`Ctrl-x`命令保存并退出文本编辑器。
