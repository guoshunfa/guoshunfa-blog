---
title: Gitlab GitlabRunner注册
tags:
    - gitlab
    - GitlabRunner
categories:
    - 服务&组件
date: 2022-07-01 12:01:01
thumbnail:
---
# Gitlab - GitlabRunner注册

> 官方地址：https://docs.gitlab.com/runner/register/

注册运行器是将运行器与一个或多个GitLab实例绑定的过程。

您可以通过重复`register`命令在同一台主机上注册多个运行器，每个运行器配置不同。

## 要求

在注册跑步者之前，您必须首先：

- 在与安装GitLab的位置分开的服务器上[安装它](https://docs.gitlab.com/runner/install/index.html)
- 获取令牌：
  - 对于[共享运行器](https://docs.gitlab.com/ee/ci/runners/runners_scope.html#shared-runners)，请管理员转到GitLab管理区域，然后单击**概述>运行器**
  - 对于[小组跑步者](https://docs.gitlab.com/ee/ci/runners/runners_scope.html#group-runners)，请转到**设置>CI/CD**并展开**跑步者**部分
  - 对于[特定于项目的运行器](https://docs.gitlab.com/ee/ci/runners/runners_scope.html#specific-runners)，请转到**设置>CI/CD**并展开**运行器**部分



在GitLab.com上注册跑步者时，`gitlab-ci coordinator URL`是`https://gitlab.com`。

## Docker

本节中的说明适用于您在[容器中安装GitLab Runner](https://docs.gitlab.com/runner/install/docker.html)*后*。

以下步骤描述了启动一个短寿命的`gitlab-runner`容器来注册您在安装期间创建的容器。完成注册后，生成的配置将写入您选择的配置卷（例如，`/srv/gitlab-runner/config`），并由运行器使用该配置卷加载。

要使用Docker容器注册运行器：

1. 根据挂载类型运行register命令：

   对于本地系统卷装载：

   ```shell
   docker run --rm -it -v /srv/gitlab-runner/config:/etc/gitlab-runner gitlab/gitlab-runner register
   ```

   

   如果您在安装过程中使用了`/srv/gitlab-runner/config`以外的配置卷，请务必使用正确的卷更新命令。

   对于Docker卷挂载：

   ```shell
   docker run --rm -it -v gitlab-runner-config:/etc/gitlab-runner gitlab/gitlab-runner:latest register
   ```

2. 输入您的GitLab实例URL（也称为`gitlab-ci coordinator URL`）。

3. 输入您获得的令牌以注册跑步者。

4. 输入跑步者的描述。您可以稍后在GitLab用户界面中更改此值。

5. 输入[与运行器关联的标签](https://docs.gitlab.com/ee/ci/runners/configure_runners.html#use-tags-to-control-which-jobs-a-runner-can-run)，用逗号分隔。您可以稍后在GitLab用户界面中更改此值。

6. 输入跑步者的任何可选维护备注。

7. 提供[运行器执行器](https://docs.gitlab.com/runner/executors/index.html)。对于大多数用例，请输入`docker`。

8. 如果您输入`docker`作为执行人，系统会要求您将默认映像用于未在`.gitlab-ci.yml`中定义一个的项目。

## Linux

要在Linux下注册运行器：

1. 运行以下命令：

   ```shell
   sudo gitlab-runner register
   ```

   如果您在代理后面，请添加环境变量，然后运行注册命令：

   ```shell
   export HTTP_PROXY=http://yourproxyurl:3128
   export HTTPS_PROXY=http://yourproxyurl:3128
   
   sudo -E gitlab-runner register
   ```

2. 输入您的GitLab实例URL（也称为`gitlab-ci coordinator URL`）。

3. 输入您获得的令牌以注册跑步者。

4. 输入跑步者的描述。您可以稍后在GitLab用户界面中更改此值。

5. 输入[与运行器关联的标签](https://docs.gitlab.com/ee/ci/runners/configure_runners.html#use-tags-to-control-which-jobs-a-runner-can-run)，用逗号分隔。您可以稍后在GitLab用户界面中更改此值。

6. 输入跑步者的任何可选维护备注。

7. 提供[运行器执行器](https://docs.gitlab.com/runner/executors/index.html)。对于大多数用例，请输入`docker`。

8. 如果您输入`docker`作为执行人，系统会要求您将默认映像用于未在`.gitlab-ci.yml`中定义一个的项目。

## macOS



在macOS下注册运行器之前，请先安装[Docker.app](https://docs.docker.com/docker-for-mac/install/)。

要在macOS下注册运行器：

1. 运行以下命令：

   ```shell
   gitlab-runner register
   ```

2. 输入您的GitLab实例URL（也称为`gitlab-ci coordinator URL`）。

3. 输入您获得的令牌以注册跑步者。

4. 输入跑步者的描述。您可以稍后在GitLab用户界面中更改此值。

5. 输入[与运行器关联的标签](https://docs.gitlab.com/ee/ci/runners/configure_runners.html#use-tags-to-control-which-jobs-a-runner-can-run)，用逗号分隔。您可以稍后在GitLab用户界面中更改此值。

6. 输入跑步者的任何可选维护备注。

7. 提供[运行器执行器](https://docs.gitlab.com/runner/executors/index.html)。对于大多数用例，请输入`docker`。

8. 如果您输入`docker`作为执行人，系统将要求您将默认映像用于未定义`.gitlab-ci.yml`的项目。

## 窗户

要在Windows下注册运行器：

1. 运行以下命令：

   ```shell
   .\gitlab-runner.exe register
   ```

2. 输入您的GitLab实例URL（也称为`gitlab-ci coordinator URL`）。

3. 输入您获得的令牌以注册跑步者。

4. 输入跑步者的描述。您可以稍后在GitLab用户界面中更改此值。

5. 输入[与运行器关联的标签](https://docs.gitlab.com/ee/ci/runners/configure_runners.html#use-tags-to-control-which-jobs-a-runner-can-run)，用逗号分隔。您可以稍后在GitLab用户界面中更改此值。

6. 输入跑步者的任何可选维护备注。

7. 提供[运行器执行器](https://docs.gitlab.com/runner/executors/index.html)。对于大多数用例，请输入`docker`。

8. 如果您输入`docker`作为执行人，系统会要求您将默认映像用于未在`.gitlab-ci.yml`中定义一个的项目。

## FreeBSD

要在FreeBSD下注册跑步者：

1. 运行以下命令：

   ```shell
   sudo -u gitlab-runner -H /usr/local/bin/gitlab-runner register
   ```

2. 输入您的GitLab实例URL（也称为`gitlab-ci coordinator URL`）。

3. 输入您获得的令牌以注册跑步者。

4. 输入跑步者的描述。您可以稍后在GitLab用户界面中更改此值。

5. 输入[与运行器关联的标签](https://docs.gitlab.com/ee/ci/runners/configure_runners.html#use-tags-to-control-which-jobs-a-runner-can-run)，用逗号分隔。您可以稍后在GitLab用户界面中更改此值。

6. 输入跑步者的任何可选维护备注。

7. 提供[运行器执行器](https://docs.gitlab.com/runner/executors/index.html)。对于大多数用例，请输入`docker`。

8. 如果您输入`docker`作为执行人，系统会要求您将默认映像用于未在`.gitlab-ci.yml`中定义一个的项目。

## 一行注册命令

如果您想使用非交互式模式注册运行器，您可以使用`register`子命令或使用其等效的环境变量。

要显示所有`register`子命令的列表，请运行以下命令：

```shell
gitlab-runner register -h
```

要使用最常见的选项注册跑步者，您将执行以下操作：

```shell
sudo gitlab-runner register \
  --non-interactive \
  --url "https://gitlab.com/" \
  --registration-token "PROJECT_REGISTRATION_TOKEN" \
  --executor "docker" \
  --docker-image alpine:latest \
  --description "docker-runner" \
  --maintenance-note "Free-form maintainer notes about this runner" \
  --tag-list "docker,aws" \
  --run-untagged="true" \
  --locked="false" \
  --access-level="not_protected"
```

如果您在Docker容器中运行运行器，则`register`命令的结构类似于以下内容：

```shell
docker run --rm -v /srv/gitlab-runner/config:/etc/gitlab-runner gitlab/gitlab-runner register \
  --non-interactive \
  --executor "docker" \
  --docker-image alpine:latest \
  --url "https://gitlab.com/" \
  --registration-token "PROJECT_REGISTRATION_TOKEN" \
  --description "docker-runner" \
  --maintenance-note "Free-form maintainer notes about this runner" \
  --tag-list "docker,aws" \
  --run-untagged="true" \
  --locked="false" \
  --access-level="not_protected"
```

`--access-level`参数已在GitLab Runner 12.0中添加。它使用GitLab 11.11中引入的注册API参数。在注册期间使用此参数创建[受保护](https://docs.gitlab.com/ee/ci/runners/configure_runners.html#prevent-runners-from-revealing-sensitive-information)的[运行器](https://docs.gitlab.com/ee/ci/runners/configure_runners.html#prevent-runners-from-revealing-sensitive-information)。对于受保护的运行器，请使用`--access-level="ref_protected"`参数。对于不受保护的运行器，请使用`--access-level="not_protected"`或者不定义该值。此值稍后可以在项目的**设置>CI/CD**菜单中打开或关闭。

`--maintenance-note`参数已在GitLab Runner 14.8[中添加](https://gitlab.com/gitlab-org/gitlab-runner/-/merge_requests/3268)。您可以使用它来添加与运行器维护相关的信息。允许的最大长度为255个字符。

## `Check registration token`错误

当GitLab实例无法识别输入的注册令牌时，将显示`check registration token`注册令牌错误消息。当实例组或项目注册令牌在GitLab中更改或用户未正确输入注册令牌时，可能会出现此问题。

发生此错误时，第一步是要求GitLab管理员验证注册令牌是否有效。

## `[[runners]]`配置模板文件

在GitLab Runner 12.2中[介绍](https://gitlab.com/gitlab-org/gitlab-runner/-/issues/4228)。

某些运行器配置设置无法使用环境变量或命令行选项进行设置。

例如：

- 环境变量不支持切片。
- 命令行选项支持故意不适用于整个Kubernetes执行器卷树的设置。

对于由任何类型的自动化处理的环境来说，这是一个问题，例如[GitLab Runner官方Helm图表](https://docs.gitlab.com/runner/install/kubernetes.html)。在此类情况下，唯一的解决方案是在运行器注册后手动更新`config.toml`文件。这不太理想，容易出错，也不可靠。特别是当为同一GitLab Runner安装完成多个注册时。

这个问题可以通过使用*配置模板文件*来解决。

要使用配置文件模板文件，请传递文件的路径以`register`：

- `--template-config`命令行选项。
- `TEMPLATE_CONFIG_FILE`环境变量。

配置模板文件支持：

- 只有单个[`[[runners\]]`](https://docs.gitlab.com/runner/configuration/advanced-configuration.html#the-runners-section)部分。
- 没有全局选项。

当使用`--template-config`或`TEMPLATE_CONFIG_FILE`时，`[[runners]]`条目的配置将合并到常规`config.toml`文件中新创建的`[[runners]]`条目的配置中。

合并仅适用于*空*的选项。那就是：

- 空的绳子。
- 无效或/不存在条目。
- 零。

有了这个：

- `register`命令调用期间，所有配备命令行选项和/或环境变量的配置都优先。
- 该模板填补了空白，并添加了其他设置。

### 例子

我们将基于Kubernetes执行器的运行器注册到一些测试项目，并查看`config.toml`文件的样子：

```shell
$ sudo gitlab-runner register \
     --config /tmp/test-config.toml \
     --non-interactive \
     --url https://gitlab.com \
     --registration-token __REDACTED__ \
     --name test-runner \
     --tag-list kubernetes,test \
     --locked \
     --paused \
     --executor kubernetes \
     --kubernetes-host http://localhost:9876/

Runtime platform                                    arch=amd64 os=linux pid=1684 revision=88310882 version=11.10.0~beta.1251.g88310882

Registering runner... succeeded                     runner=__REDACTED__
Runner registered successfully. Feel free to start it, but if it's running already the config should be automatically reloaded!
```

上面的命令创建以下`config.toml`文件：

```shell
concurrent = 1
check_interval = 0

[session_server]
  session_timeout = 1800

[[runners]]
  name = "test-runner"
  url = "https://gitlab.com"
  token = "__REDACTED__"
  executor = "kubernetes"
  [runners.cache]
    [runners.cache.s3]
    [runners.cache.gcs]
  [runners.kubernetes]
    host = "http://localhost:9876/"
    bearer_token_overwrite_allowed = false
    image = ""
    namespace = ""
    namespace_overwrite_allowed = ""
    privileged = false
    service_account_overwrite_allowed = ""
    pod_annotations_overwrite_allowed = ""
    [runners.kubernetes.volumes]
```

我们可以看到从提供的命令行选项创建的基本配置：

- 运行器凭据（URL和令牌）。
- 指定了遗嘱执行人。
- 默认的空部分`runners.kubernetes`，在注册期间只提供了一个选项。

通常，人们必须再设置几个选项才能使Kubernetes执行器可用，但上述内容就足以让我们的例子而言。

现在假设我们必须为我们的Kubernetes执行器配置一个`emptyDir`卷。在注册环境变量或命令行选项时，无法添加此内容。我们必须**手动将**这样的东西**附加**到文件的末尾：

```shell
[[runners.kubernetes.volumes.empty_dir]]
  name = "empty_dir"
  mount_path = "/path/to/empty_dir"
  medium = "Memory"
```

由于[TOML](https://github.com/toml-lang/toml)不需要适当的缩进（它依赖于条目排序），我们只需将所需的更改附加到文件末尾即可。然而，当更多`[[runners]]`部分在 oneconfig`config.toml`文件中注册时，这会变得棘手。假设新的总是在最后是有风险的。

使用GitLab Runner 12.2，使用`--template-config`标志会容易得多。

```shell
$ cat > /tmp/test-config.template.toml << EOF
[[runners]]
  [runners.kubernetes]
    [runners.kubernetes.volumes]
      [[runners.kubernetes.volumes.empty_dir]]
        name = "empty_dir"
        mount_path = "/path/to/empty_dir"
        medium = "Memory"
EOF
```

有了这个文件，我们现在可以尝试再次注册运行器，但这次添加了`--template-config /tmp/test-config.template.toml`选项。除了此更改外，注册命令的其余部分完全相同：

```shell
$ sudo gitlab-runner register \
     --config /tmp/test-config.toml \
     --template-config /tmp/test-config.template.toml \
     --non-interactive \
     --url https://gitlab.com \
     --registration-token __REDACTED__ \
     --name test-runner \
     --tag-list kubernetes,test \
     --locked \
     --paused \
     --executor kubernetes \
     --kubernetes-host http://localhost:9876/

Runtime platform                                    arch=amd64 os=linux pid=8798 revision=88310882 version=11.10.0~beta.1251.g88310882

Registering runner... succeeded                     runner=__REDACTED__
Merging configuration from template file
Runner registered successfully. Feel free to start it, but if it's running already the config should be automatically reloaded!
```

As we can see, there is a little change in the output of the registration command. We can see a `Merging configuration from template file` line.

现在让我们看看使用模板后配置文件是什么样子的：

```shell
concurrent = 1
check_interval = 0

[session_server]
  session_timeout = 1800

[[runners]]
  name = "test-runner"
  url = "https://gitlab.com"
  token = "__REDACTED__"
  executor = "kubernetes"
  [runners.cache]
    [runners.cache.s3]
    [runners.cache.gcs]
  [runners.kubernetes]
    host = "http://localhost:9876/"
    bearer_token_overwrite_allowed = false
    image = ""
    namespace = ""
    namespace_overwrite_allowed = ""
    privileged = false
    service_account_overwrite_allowed = ""
    pod_annotations_overwrite_allowed = ""
    [runners.kubernetes.volumes]

      [[runners.kubernetes.volumes.empty_dir]]
        name = "empty_dir"
        mount_path = "/path/to/empty_dir"
        medium = "Memory"
```

我们可以看到，配置几乎和以前一样。唯一的变化是，它现在有`[[runners.kubernetes.volumes.empty_dir]]`条目，其选项位于文件末尾。它被添加到注册创建的`[[runners]]`条目中。由于整个文件是用相同的机制保存的，所以我们也有适当的缩进。

如果配置模板包含设置，并且将相同的设置传递给`register`命令，则传递给`register`命令的设置优先于配置模板中指定的设置。

```shell
$ cat > /tmp/test-config.template.toml << EOF
[[runners]]
  executor = "docker"
EOF

$ sudo gitlab-runner register \
     --config /tmp/test-config.toml \
     --template-config /tmp/test-config.template.toml \
     --non-interactive \
     --url https://gitlab.com \
     --registration-token __REDACTED__ \
     --name test-runner \
     --tag-list shell,test \
     --locked \
     --paused \
     --executor shell

Runtime platform                                    arch=amd64 os=linux pid=12359 revision=88310882 version=11.10.0~beta.1251.g88310882

Registering runner... succeeded                     runner=__REDACTED__
Merging configuration from template file
Runner registered successfully. Feel free to start it, but if it's running already the config should be automatically reloaded!
```

正如我们所看到的，注册命令指定了`shell`执行器，而模板包含`docker`一个。让我们看看最终配置内容是什么：

```shell
concurrent = 1
check_interval = 0

[session_server]
  session_timeout = 1800

[[runners]]
  name = "test-runner"
  url = "https://gitlab.com"
  token = "__REDACTED__"
  executor = "shell"
  [runners.cache]
    [runners.cache.s3]
    [runners.cache.gcs]
```

带有`register`命令选项的配置集优先，并被选择放置在最终配置中。
