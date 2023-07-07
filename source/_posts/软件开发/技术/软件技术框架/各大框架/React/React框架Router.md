---
title: React框架 Router
tags:
  - React
categories:
  - 软件技术框架
date: 2022-07-01 12:01:01
thumbnail:
---

# React框架 - Router

> 前往 [React Router V6 官方文档](https://reactrouter.com/docs/en/v6)
>
> react-router-dom为针对web开发的组件库。
>

## 1. v6 版本

### 1.1. 版本更新内容

> 推出了很多好用hooks，但是路由组件内props的三个实用属性去掉了。 = =

1. `<Switch>`重命名为`<Routes>`。
2. `<Route>`的新特性变更。
3. 嵌套路由变得更简单。
4. 用`useNavigate`代替`useHistory`。
5. 新钩子`useRoutes`代替`react-router-config`。
6. 大小减少：从`20kb`到`8kb`

### 1.2. 常用路由组件和hooks

| 组件名      | 作用           | 说明                                                         |
| ----------- | -------------- | ------------------------------------------------------------ |
| `<Routers>` | 一组路由       | 代替原有`<Switch>`，所有子路由都用基础的Router children来表示 |
| `<Router>`  | 基础路由       | Router是可以嵌套的，解决原有V5中严格模式，后面与V5区别会详细介绍 |
| `<Link>`    | 导航组件       | 在实际页面中跳转使用                                         |
| `<Outlet/>` | 自适应渲染组件 | 根据实际路由url自动选择组件                                  |

| hooks名           | 作用                                  | 说明                      |
| ----------------- | ------------------------------------- | ------------------------- |
| `useParams`       | 返回当前参数                          | 根据路径读取参数          |
| `useNavigate`     | 返回当前路由                          | 代替原有V5中的 useHistory |
| `useOutlet`       | 返回根据路由生成的element             |                           |
| `useLocation`     | 返回当前的location 对象               |                           |
| `useRoutes`       | 同Routers组件一样，只不过是在js中使用 |                           |
| `useSearchParams` | 用来匹配URL中?后面的搜索参数          |                           |

### 1.2. 路由的基本使用

1. 导航，使用Link标签。`<Link to="/">Home</Link>`
2. 路由Routes与Route搭配使用。

> element直接写入组件，可以传入props。

```jsx
<Routes>
  <Route path="/" element={<App />}></Route>
</Routes>
```

### 1.3. 嵌套路由

```jsx
<Routes>
  <Route path="/" element={<App />}>
    <Route index element={<Home />} />
    <Route path="teams" element={<Teams />}>
      <Route path=":teamId" element={<Team />} />
      <Route path="new" element={<NewTeamForm />} />
      <Route index element={<LeagueStandings />} />
    </Route>
  </Route>
</Routes>
```

### 1.4. Outlet

`<Outlet/>`根据定义的不同路由参数进行渲染组件。

## 2. v5 版本

### 2.1. 路由的基本使用

​            1.明确好界面中的导航区、展示区
​            2.导航区的a标签改为Link标签
​                        `<Link to="/xxxxx">Demo</Link>`
​            3.展示区写Route标签进行路径的匹配
​                        `<Route path='/xxxx' component={Demo}/>`
​            4.`<App>`的最外侧包裹了一个`<BrowserRouter>`或`<HashRouter>`

### 2.2. 路由组件与一般组件

​            1.写法不同：
​                        一般组件：`<Demo/>`
​                        路由组件：`<Route path="/demo" component={Demo}/>`
​            2.存放位置不同：
​                        一般组件：components
​                        路由组件：pages
​            3.接收到的props不同：
​                        一般组件：写组件标签时传递了什么，就能收到什么
​                        路由组件：接收到三个固定的属性

```
history:
	go: ƒ go(n)
	goBack: ƒ goBack()
	goForward: ƒ goForward()
	push: ƒ push(path, state)
	replace: ƒ replace(path, state)
location:
	pathname: "/about"
	search: ""
	state: undefined
match:
	params: {}
	path: "/about"
	url: "/about"
```

### 2.3. NavLink与封装NavLink

​                1.NavLink可以实现路由链接的高亮，通过activeClassName指定样式名

### 2.4. Switch的使用

​                1.通常情况下，path和component是一一对应的关系。
​                2.Switch可以提高路由匹配效率(单一匹配)。

### 2.5. 解决多级路径刷新页面样式丢失的问题

​                1.public/index.html 中 引入样式时不写 ./ 写 / （常用）
​                2.public/index.html 中 引入样式时不写 ./ 写 %PUBLIC_URL% （常用）
​                3.使用HashRouter

### 2.6. 路由的严格匹配与模糊匹配

​                1.默认使用的是模糊匹配（简单记：【输入的路径】必须包含要【匹配的路径】，且顺序要一致）
​                2.开启严格匹配：`<Route exact={true} path="/about" component={About}/>`
​                3.严格匹配不要随便开启，需要再开，有些时候开启会导致无法继续匹配二级路由

### 2.7. Redirect的使用

​                1.一般写在所有路由注册的最下方，当所有路由都无法匹配时，跳转到Redirect指定的路由
​                2.具体编码：

```js
<Switch>
  <Route path="/about" component={About}/>
  <Route path="/home" component={Home}/>
  <Redirect to="/about"/>
</Switch>
```

​                        

### 2.8. 嵌套路由

​                1.注册子路由时要写上父路由的path值
​                2.路由的匹配是按照注册路由的顺序进行的

### 2.9. 向路由组件传递参数

```
1.params参数
	路由链接(携带参数)：<Link to='/demo/test/tom/18'}>详情</Link>
	注册路由(声明接收)：<Route path="/demo/test/:name/:age" component={Test}/>
	接收参数：this.props.match.params
2.search参数
  路由链接(携带参数)：<Link to='/demo/test?name=tom&age=18'}>详情</Link>
  注册路由(无需声明，正常注册即可)：<Route path="/demo/test" component={Test}/>
  接收参数：this.props.location.search
  备注：获取到的search是urlencoded编码字符串，需要借助querystring解析
3.state参数
  路由链接(携带参数)：<Link to={{pathname:'/demo/test',state:{name:'tom',age:18}}}>详情</Link>
  注册路由(无需声明，正常注册即可)：<Route path="/demo/test" component={Test}/>
  接收参数：this.props.location.state
  备注：刷新也可以保留住参数        
```

### 2.10. 编程式路由导航

​                    借助this.prosp.history对象上的API对操作路由跳转、前进、后退

```
-this.prosp.history.push()
-this.prosp.history.replace()
-this.prosp.history.goBack()
-this.prosp.history.goForward()
-this.prosp.history.go()
```

### 2.11. BrowserRouter与HashRouter的区别

​            1.底层原理不一样：
​                        BrowserRouter使用的是H5的history API，不兼容IE9及以下版本。
​                        HashRouter使用的是URL的哈希值。
​            2.path表现形式不一样
​                        BrowserRouter的路径中没有#,例如：localhost:3000/demo/test
​                        HashRouter的路径包含#,例如：localhost:3000/#/demo/test
​            3.刷新后对路由state参数的影响
​                        (1).BrowserRouter没有任何影响，因为state保存在history对象中。
​                        (2).HashRouter刷新后会导致路由state参数的丢失！！！
​            4.备注：HashRouter可以用于解决一些路径错误相关的问题。

## 参考文档

- [尚硅谷](https://atguigu.com)
- [React-Router V6 使用详解(干货)](https://juejin.cn/post/7033313711947251743#heading-2)
- [React-Router v6 新特性解读及迁移指南](https://blog.csdn.net/weixin_40906515/article/details/104957712)
- [什么，React Router已经到V6了 ？？](https://juejin.cn/post/7025418839454122015)
