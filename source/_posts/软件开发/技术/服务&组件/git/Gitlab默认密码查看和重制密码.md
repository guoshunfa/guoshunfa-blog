---
title: Gitlab 默认密码查看和重制密码
tags:
    - Gitlab
categories:
    - 服务&组件
date: 2022-07-01 12:01:01
thumbnail:
---

转发自：https://blog.csdn.net/timonium/article/details/119451755

## 1. GitLab默认密码

- 初次安装Gitlab时，密码放在了一个临时文件中了

```shell
/etc/gitlab/initial_root_password
```

- 这个文件将在首次执行reconfigure后24小时自动删除

```
Notes:
Default admin account has been configured with following details:
Username: root
Password: You didn't opt-in to print initial root password to STDOUT.
Password stored to /etc/gitlab/initial_root_password. This file will be cleaned up in first reconfigure run after 24 hours.

NOTE: Because these credentials might be present in your log files in plain text, it is highly recommended to reset the password following https://docs.gitlab.com/ee/security/reset_user_password.html#reset-your-root-password.

gitlab Reconfigured!
[root@c7-192 src]# cat /etc/gitlab/initial_root_password

# WARNING: This value is valid only in the following conditions

#          1. If provided manually (either via `GITLAB_ROOT_PASSWORD` environment variable or via `gitlab_rails['initial_root_password']` setting in `gitlab.rb`, it was provided before database was seeded for the first time (usually, the first reconfigure run).

#          2. Password hasn't been changed manually, either via UI or via command line.

#

#          If the password shown here doesn't work, you must reset the admin password following https://docs.gitlab.com/ee/security/reset_user_password.html#reset-your-root-password.

Password: thAXLJhVoo6V9sRvRH5HrLrD5rg88C7gccEGZDT4Lq0=

# NOTE: This file will be automatically deleted in the first reconfigure run after 24 hours.
```

## 2. 登录并修改密码

- 拿到这个密码后需要尽快登录web界面进行密码修改

![image-20220424164214291](https://file.pandacode.cn/blog/202204241642571.png)

- 进去修改密码

![image-20220424164250033](https://file.pandacode.cn/blog/202204241642877.png)

- 重置密码

![image-20220424164311299](https://file.pandacode.cn/blog/202204241643193.png)