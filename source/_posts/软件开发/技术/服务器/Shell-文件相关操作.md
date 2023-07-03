---
title: Shell 文件相关操作
tags:
  - shell
categories:
  - 技术
date: 2022-07-01 11:26:20
thumbnail:
---
| 命令  | 命令直译                    | 描述                                                         | 实例                     |
| :---- | --------------------------- | ------------------------------------------------------------ | ------------------------ |
| ls    | List                        | ls会列举出当前工作目录的内容（文件或文件夹）。               | `ls`                     |
| mkdir | Make Directory              | mkdir 用于新建一个新目录                                     | `mkdir mywork`           |
| pwd   | Print Working Directory     | 显示当前工作目录                                             | `pwd`                    |
| cd    | Change Directory            | 切换文件路径，cd 将给定的文件夹（或目录）设置成当前工作目录。 | `cd /usr/mongo`          |
| rmdir | Remove Directory            | 删除给定的目录，只能删除空目录（目录下不能有文件）。         | `rmdir mywork`           |
| rm    | Remove                      | rm 会删除给定的文件。<br/> rm -rf会删除一个文件夹，r遍历，f强行删除。（终端删除的文件不可恢复）<br/ > | `rm work.html`           |
| cp    | Copy                        | cp 命令对文件进行复制<br/> `cp [选项] 源文件 目标文件`       | `cp work.html /usr/work` |
| mv    | Move                        | mv 命令对文件或文件夹进行移动，如果文件或文件夹存在于当前工作目录，还可以对文件或文件夹进行重命名。<br/> `mv [选项] 源文件 目标文件` | `mv work.html /usr/work` |
| cat   | concatenate and print files | cat 用于在标准输出（监控器或屏幕）上查看文件内容             | `cat work.html`          |
| tail  | print TAIL(from last)       | tail 默认在标准输出上显示给定文件的最后10行内容。<br/>tail -n N 指定在标准输出上显示文件的最后N行内容。<br/>tail -f 持续跟踪文件情况，用于实时查看日志。 | `tail work.html`         |
| less  | print LESS                  | less 按页或按窗口打印文件内容。在查看包含大量文本数据的大文件时是非常有用和高效的。你可以使用Ctrl+F向前翻页，Ctrl+B向后翻页。 |                          |
| find  |                             | 这个命令会在给定位置搜寻与条件匹配的文件。你可以使用find -name 的-name选项来进行区分大小写的搜寻，find -iname 来进行不区分大小写的搜寻。 | `find -iname work.html`  |
| tar   |                             | tar命令能创建、查看和提取tar压缩文件。tar -cvf 是创建对应压缩文件，tar -tvf 来查看对应压缩文件，tar -xvf 来提取对应压缩文件。 |                          |

## 1. tar、zip、rar 文件解压缩

参考中文文档：[tar](http://linux.51yip.com/search/tar)、[rar](http://linux.51yip.com/search/rar)、[unrar](http://linux.51yip.com/search/unrar)、[zip](http://linux.51yip.com/search/zip)、[unzip](http://linux.51yip.com/search/unzip)

### 1.1. tar 命令

语法： tar [主选项 + 辅选项] 文件或目录

示例：

```sh
# 压缩文件 file1 和目录 dir2 到 test.tar.gz
tar -zcvf test.tar.gz file1 dir2

# 解压 test.tar.gz（将 c 换成 x 即可）
tar -zxvf test.tar.gz

# 列出压缩文件的内容
tar -ztvf test.tar.gz 

# 解压到指定目录
tar -zxvf test.tar.gz -C /home
```

释义：

- -z : 使用 gzip 来压缩和解压文件

- -v : --verbose 详细的列出处理的文件

- -f : --file=ARCHIVE 使用档案文件或设备，这个选项通常是必选的

- -c : --create 创建一个新的归档（压缩包）

- -x : 从压缩包中解出文件

其它：

tar 命令其实并不是真的解压缩的处理者，而是使用了 gzip 或者 bzip2 等其它命令来达成，但是 gzip 等命令通常只能处理单个文件，并不方便，所以一般我们都是选择使用 tar 命令间接的完成解压缩。

### 1.2. rar 命令

示例：

```sh
# 压缩文件
rar a -r test.rar file

# 解压文件
unrar x test.rar
```

释义：

- a : 添加到压缩文件

- -r : 递归处理

- x : 以绝对路径解压文件

### 1.3. zip 命令

示例：

```sh
# 压缩文件
zip -r test.zip file

# 解压文件
unzip test.zip
```

释义：

- -r : 递归处理

## 2. mv 文件移动

> mv: move

将一个文件移动到另一个文件内

```sh
mv /file1/file.txt /file2
```

合理利用 \* 号。（\*代表模糊查询。）

```sh
# 将一个文件内所有文件，移动到另一个文件内
mv /file1/* /file2
# 将文件内所有jpg类型的文件，移动到另一个文件内
mv /file1/*.jpg /file2
```

## 3. scp 服务器之间copy文件

```sh
# 以tank用户登录并将服务器文件夹copy到本地
scp -r root@192.16.1.1:/var/www/blog /home/www/blog  
# 将本地文件copy到服务器，添填写用户，默认当前用户
scp /home/www/blog/index.php root@192.16.1.1:/var/www/blog 
# 加端口
scp -P 333333 home/www/blog/index.php root@192.16.1.1:/var/www/blog 
```

## 4. ls 查看文件夹信息

```shell
# 查看当前目录有哪些文件
ls

# 查看当前目录有哪些文件，并且查看其文件的相关信息，如：创建时间、文件大小
ll 
# or
ls -l

# 查看当前目录有哪些文件，并且查看其文件的相关信息，并按照修改时间排序。
ll -t
# or 
ls -lt

# 查看当前目录有哪些文件，并且查看其文件的相关信息，文件大小转换为人们容易理解的格式。如：134M
ll -h
# or
ls -lh
```
