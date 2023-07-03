---
title: React框架 组件之间通讯
tags:
  - kafka
categories:
  - 技术
date: 2022-07-01 12:01:01
thumbnail:
---

# React框架 - 组件之间通讯

React 父子组件、兄弟组件、叔侄应该如何进行通讯，这里描述一下两种方法。

**props function**

缺点：

1. 操作繁琐，组件关系越复杂代码量越多。
2. 耦合性太强。

**消息 订阅与发布**

优点：

1. 只需在指定的位置进行订阅消息、发布消息即可。
2. 极大程度上降低耦合性。

## 1. 通过props function进行通讯

**原理：**

找到父子、兄弟、叔侄组件的共同组件，绑定props function，进行通讯。



### 1.1. 类式组件用法

<code-group>
  <code-block title="父组件 App.jsx" active>

  ```jsx
  // 父组件 App.jsx
  import React, { Component } from "react";
  import List from "./compoments/List";
  import Search from "./compoments/Search";
  
  export default class App extends Component {
    state = { datas: [] };
    dataChange = (data) => {
      let { datas } = this.state;
      datas.push(data);
      this.setState({ datas: datas });
    };
    render() {
      return (
        <div>
          <Search dataChange={this.dataChange} />
          <List datas={this.state.datas} />
        </div>
      );
    }
  }
  ```
  </code-block>

  <code-block title="子组件 List.jsx">

  ```jsx
// 子组件 List.jsx
import React, { Component } from "react";

export default class List extends Component {
  render() {
    return (
      <div>
        {this.props.datas.map((data) => {
          return <div key={data.id}>{data.name}</div>;
        })}
      </div>
    );
  }
}
  ```

  </code-block>

  <code-block title="子组件 Search.jsx">

  ```jsx
// 子组件 Search.jsx
import React, { Component } from "react";

export default class Search extends Component {
  dataChange = () => {
    this.props.dataChange({ id: Date.now(), name: "加了加了" });
  };
  render() {
    return (
      <div>
        <button onClick={this.dataChange}>点击添加一条数据</button>
      </div>
    );
  }
}
  ```

  </code-block>

</code-group>



### 1.2. 函数式组件用法

<code-group>
  <code-block title="父组件 App.jsx" active>

  ```jsx
// 父组件 App.jsx
import React, { Component } from "react";
import List from "./compoments/List";
import Search from "./compoments/Search";

export default class App extends Component {
  state = { datas: [] };
  dataChange = (data) => {
    let { datas } = this.state;
    datas.push(data);
    this.setState({ datas: datas });
  };
  render() {
    return (
      <div>
        <Search dataChange={this.dataChange} />
        <List datas={this.state.datas} />
      </div>
    );
  }
}
  ```

  </code-block>

  <code-block title="子组件 List.jsx">

  ```jsx
// 子组件 List.jsx
import React from "react";

export default function List(props) {
  return (
    <div>
      {props.datas.map((data) => {
        return <div key={data.id}>{data.name}</div>;
      })}
    </div>
  );
}
  ```

  </code-block>

  <code-block title="子组件 Search.jsx">

  ```jsx
// 子组件 Search.jsx
import React from "react";

export default function Search(props) {
  let dataChange = () => {
    props.dataChange({ id: Date.now(), name: "加了加了" });
  };
  return (
    <div>
      <button onClick={dataChange}>点击添加一条数据</button>
    </div>
  );
}

  ```

  </code-block>

</code-group>



> 通过function dataChange进行通信。
>
> 操作繁琐，本应跟App.jsx无关的操作，现在代码放到了App.jsx中。

## 2.  消息 订阅与发布

> 接着使用上面的例子。通过比较可以直接看出优缺点。
>
> 不能直接使用，需要安装额外的组件库。这里使用的是PubSubJS，详细内容请查看[PubSubJS笔记](/pages/c31095/)。

### 2.1. 类式组件用法

<code-group>
  <code-block title="父组件 App.jsx" active>

  ```jsx
// 父组件 App.jsx
import React, { Component } from 'react';
import List from './compoments/List';
import Search from './compoments/Search';

export default class App extends Component {
  render() {
    return <div>
      <Search />
      <List />
    </div>
  }
}
  ```

  </code-block>

  <code-block title="子组件 List.jsx">

  ```jsx
// 子组件 List.jsx
import React, { Component } from 'react';
import PubSub from 'pubsub-js';

export default class List extends Component {
  state={datas:[]}
  
  //组件挂载完毕的钩子
  componentDidMount(){
    this.dataChangeToken = PubSub.subscribe("dataChange", (msg, data) => {
        let { datas } = this.state;
        datas.push(data);
        this.setState({ datas: datas });
    });
  }

  //组件将要卸载的钩子
  componentWillUnmount(){
    PubSub.unsubscribe(this.dataChangeToken);
  }
  render() {
    return <div>
      {
        this.state.datas.map(data=>{
          return <div key={data.id}>{data.name}</div>
        })
      }
    </div>
  }
}
  ```

  </code-block>

  <code-block title="子组件 Search.jsx">

  ```jsx
// 子组件 Search.jsx
import React, { Component } from 'react';
import PubSub from 'pubsub-js';

export default class Search extends Component {
  dataChange=()=>{
    // 发布消息
    PubSub.publish("dataChange", { id: Date.now(), name: "加了加了" });
  }
  
  render() {
    return <div>
      <button onClick={this.dataChange}>我点</button>
    </div>
  }
}
  ```

  </code-block>

</code-group>



1. 兄弟组件之间通讯直接通过发布、订阅消息，使得父组件App.jsx只需要管理组件摆放位置即可。
2. 这里用到的消息发布订阅的组件包是[PubSubJS](/pages/c31095/)。
3. token的管理不能像本文中直接使用字符串，需要设定一个TOKEN工厂来统一进行管理。

## 3. 集中式管理

>  redux
>
> TODO: 有机会整理

## 4. conText

> TODO: 有机会整理
