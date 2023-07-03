---
title: React框架 UI组件库
tags:
  - kafka
categories:
  - 技术
date: 2022-07-01 12:01:01
thumbnail:
---

##  1. material-ui(国外)

- 官网: [http://www.material-ui.com/#/](#/)

- github: https://github.com/callemall/material-ui

###  2. ant-design(国内蚂蚁金服)

- 官网: https://ant.design/index-cn

- Github: https://github.com/ant-design/ant-design/

### 2.1. antd的按需引入+自定主题

1. 安装依赖：yarn add react-app-rewired customize-cra babel-plugin-import less less-loader

2. 修改package.json

  ```json
  ....
  
  "myscripts": {
  
    "start": "react-app-rewired start",
  
    "build": "react-app-rewired build",
  
    "test": "react-app-rewired test",
  
    "eject": "react-myscripts eject"
  
  },
  
  ....
  ```

3. 根目录下创建config-overrides.js

```js
//配置具体的修改规则
const { override, fixBabelImports,addLessLoader} = require('customize-cra');
module.exports = override(
  fixBabelImports('import', {
    libraryName: 'antd',
    libraryDirectory: 'es',
    style: true,
  }),
  addLessLoader({
    lessOptions:{
      javascriptEnabled: true,
      modifyVars: { '@primary-color': 'green' },
    }
  }),
);
```

4. 备注：不用在组件里亲自引入样式了，即：import 'antd/dist/antd.css'应该删掉
