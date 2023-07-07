---
title: Web组件库 JS组件方法记录
tags:
  - 组件库
  -	HTML/CSS/JavaScript
categories:
  - 服务&组件
date: 2022-07-01 12:01:01
thumbnail:
---

> 以折叠面板的形式进行组件描述，点击对应的面板会展示对应信息。


```
/**
        * @description 将扁平化数据 转换成 树状结构
        * @param {Array} arrayList 扁平化的数据
        * @param {String} pidStr parentId的key名
        * @param {String} idStr id的key名
        * @param {String} childrenStr children的key名
        */
       function fommat({arrayList, pidStr = 'pid', idStr = 'id', childrenStr = 'children'}) {
           let listOjb = {}; // 用来储存{key: obj}格式的对象
           let treeList = []; // 用来储存最终树形结构数据的数组
           // 将数据变换成{key: obj}格式，方便下面处理数据
           for (let i = 0; i < arrayList.length; i++) {
               listOjb[arrayList[i][idStr]] = arrayList[i]
           }
           // 根据pid来将数据进行格式化
           for (let j = 0; j < arrayList.length; j++) {
               // 判断父级是否存在
               let haveParent = listOjb[arrayList[j][pidStr]] 
               if (haveParent) {
                   // 如果有没有父级children字段，就创建一个children字段
                   !haveParent[childrenStr] && (haveParent[childrenStr] = [])
                   // 在父级里插入子项
                   haveParent[childrenStr].push(arrayList[j])
               } else {
                   // 如果没有父级直接插入到最外层
                   treeList.push(arrayList[j])
               }
           }
           return treeList
       }
            

        // 测试数据
        var menu_list = [{
          id: '1',
          menu_name: '设置',
          menu_url: 'setting',
          parent_id: 0
        }, {
          id: '1-1',
          menu_name: '权限设置',
          menu_url: 'setting.permission',
          parent_id: '1'
        }, {
          id: '1-1-1',
          menu_name: '用户管理列表',
          menu_url: 'setting.permission.user_list',
          parent_id: '1-1'
        }, {
          id: '1-1-2',
          menu_name: '用户管理新增',
          menu_url: 'setting.permission.user_add',
          parent_id: '1-1'
        }, {
          id: '1-1-3',
          menu_name: '角色管理列表',
          menu_url: 'setting.permission.role_list',
          parent_id: '1-1'
        }, {
          id: '1-2',
          menu_name: '菜单设置',
          menu_url: 'setting.menu',
          parent_id: '1'
        }, {
          id: '1-2-1',
          menu_name: '菜单列表',
          menu_url: 'setting.menu.menu_list',
          parent_id: '1-2'
        }, {
          id: '1-2-2',
          menu_name: '菜单添加',
          menu_url: 'setting.menu.menu_add',
          parent_id: '1-2'
        }, {
          id: '2',
          menu_name: '订单',
          menu_url: 'order',
          parent_id: 0
        }, {
          id: '2-1',
          menu_name: '报单审核',
          menu_url: 'order.orderreview',
          parent_id: '2'
        }, {
          id: '2-2',
          menu_name: '退款管理',
          menu_url: 'order.refundmanagement',
          parent_id: '2'
        }, {
          id: '2-2-1',
          menu_name: '退款管理2-1',
          menu_url: 'order.refundmanagement',
          parent_id: '2-2'
        }
    ]
    
    // 输出
    console.log(
           fommat({
               arrayList: menu_list,
               pidStr: 'parent_id'
           })
       )

```
