---
title: React框架基础
tags:
  - React
categories:
  - 软件技术框架
date: 2022-07-01 12:01:01
thumbnail:
---

> 进入 [React官网](https://zh-hans.reactjs.org)  
>
> 尚硅谷 React教学视频：[b站](https://www.bilibili.com/video/BV1wy4y1D7JT?p=1) | [百度网盘](https://pan.baidu.com/s/1jEZvC45ZgX4N4Jc1MeFQWw) 提取码：c1ac（包含视频、源码、课件）

## 1. hello react

```html
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>hello_react</title>
</head>
<body>
	<!-- 准备好一个“容器” -->
	<div id="test"></div>

	<!-- 引入react核心库 -->
	<script type="text/javascript" src="../js/react.development.js"></script>
	<!-- 引入react-dom，用于支持react操作DOM -->
	<script type="text/javascript" src="../js/react-dom.development.js"></script>
	<!-- 引入babel，用于将jsx转为js -->
	<script type="text/javascript" src="../js/babel.min.js"></script>

	<script type="text/babel" > /* 此处一定要写babel */
		//1.创建虚拟DOM
		const VDOM = <h1>Hello,React</h1> /* 此处一定不要写引号，因为不是字符串 */
		//2.渲染虚拟DOM到页面
		ReactDOM.render(VDOM,document.getElementById('test'))
	</script>
</body>
</html>
```

## 2. JSX

> *jsx语法规则：*
>
> ​                        *1.定义虚拟DOM时，不要写引号。*
>
> ​                        *2.标签中混入JS表达式时要用{}。*
>
> ​                        *3.样式的类名指定不要用class，要用className。*
>
> ​                        *4.内联样式，要用的⬇️形式去写。*
>
> `style={{key:value}}`
>
> ​                        *5.只有一个根标签*
>
> ​                        *6.标签必须闭合*
>
> ​                        *7.标签首字母*
>
> ​                                *(1).若小写字母开头，则将该标签转为html中同名元素，若html中无该标签对应的同名元素，则报错。*
>
> ​                                *(2).若大写字母开头，react就去渲染对应的组件，若组件没有定义，则报错。*

```jsx
const VDOM = (  /* 此处一定不要写引号，因为不是字符串 */
			<h1 id="title">
				<span>Hello,React</span>
			</h1>
		)
```

## 3. 组件定义方式

**函数式组件**  

```js
//1.创建函数式组件
function MyComponent(){
  console.log(this); //此处的this是undefined，因为babel编译后开启了严格模式
  return <h2>我是用函数定义的组件(适用于【简单组件】的定义)</h2>
}
//2.渲染组件到页面
ReactDOM.render(<MyComponent/>,document.getElementById('test'))
/* 
			执行了ReactDOM.render(<MyComponent/>.......之后，发生了什么？
					1.React解析组件标签，找到了MyComponent组件。
					2.发现组件是使用函数定义的，随后调用该函数，将返回的虚拟DOM转为真实DOM，随后呈现在页面中。
		*/
```

**类式组件**

1. 必须继承React.Component。
2. 实现render方法，并返回需要展示的组件内容。

```jsx
//1.创建类式组件
class MyComponent extends React.Component {
  render(){
    //render是放在哪里的？—— MyComponent的原型对象上，供实例使用。
    //render中的this是谁？—— MyComponent的实例对象 <=> MyComponent组件实例对象。
    console.log('render中的this:',this);
    return <h2>我是用类定义的组件(适用于【复杂组件】的定义)</h2>
  }
}
//2.渲染组件到页面
ReactDOM.render(<MyComponent/>,document.getElementById('test'))
/* 
			执行了ReactDOM.render(<MyComponent/>.......之后，发生了什么？
					1.React解析组件标签，找到了MyComponent组件。
					2.发现组件是使用类定义的，随后new出来该类的实例，并通过该实例调用到原型上的render方法。
					3.将render返回的虚拟DOM转为真实DOM，随后呈现在页面中。
		*/
```

## 4. 组件实例三大属性

### 4.1. props

> 通过组件的形式传递的参数都会被放到props。

```jsx
//创建组件
class Person extends React.Component{
  render(){
    // console.log(this);
    const {name,age,sex} = this.props
    return (
      <ul>
        <li>姓名：{name}</li>
        <li>性别：{sex}</li>
        <li>年龄：{age+1}</li>
      </ul>
    )
  }
}
//渲染组件到页面
ReactDOM.render(<Person name="jerry" age={19}  sex="男"/>,document.getElementById('test1'))
```

**对传入的参数进行限制：**

```jsx
//创建组件
class Person extends React.Component{
  render(){
    // console.log(this);
    const {name,age,sex} = this.props
    //props是只读的
    //this.props.name = 'jack' //此行代码会报错，因为props是只读的
    return (
      <ul>
        <li>姓名：{name}</li>
        <li>性别：{sex}</li>
        <li>年龄：{age+1}</li>
      </ul>
    )
  }
}
//对标签属性进行类型、必要性的限制
Person.propTypes = {
  name:PropTypes.string.isRequired, //限制name必传，且为字符串
  sex:PropTypes.string,//限制sex为字符串
  age:PropTypes.number,//限制age为数值
  speak:PropTypes.func,//限制speak为函数
}
//指定默认标签属性值
Person.defaultProps = {
  sex:'男',//sex默认值为男
  age:18 //age默认值为18
}
//渲染组件到页面
ReactDOM.render(<Person name={100} speak={speak}/>,document.getElementById('test1'))
```

**限制简化（将限制处理放入类）：**

```jsx
//创建组件
class Person extends React.Component{

  constructor(props){
    //构造器是否接收props，是否传递给super，取决于：是否希望在构造器中通过this访问props
    // console.log(props);
    super(props)
    console.log('constructor',this.props);
  }

  //对标签属性进行类型、必要性的限制
  static propTypes = {
    name:PropTypes.string.isRequired, //限制name必传，且为字符串
    sex:PropTypes.string,//限制sex为字符串
    age:PropTypes.number,//限制age为数值
  }

  //指定默认标签属性值
  static defaultProps = {
    sex:'男',//sex默认值为男
    age:18 //age默认值为18
  }

  render(){
    // console.log(this);
    const {name,age,sex} = this.props
    //props是只读的
    //this.props.name = 'jack' //此行代码会报错，因为props是只读的
    return (
      <ul>
        <li>姓名：{name}</li>
        <li>性别：{sex}</li>
        <li>年龄：{age+1}</li>
      </ul>
    )
  }
}

//渲染组件到页面
ReactDOM.render(<Person name="jerry"/>,document.getElementById('test1'))
```

**函数组件使用props：**

```jsx
//创建组件
function Person (props){
  const {name,age,sex} = props
  return (
    <ul>
      <li>姓名：{name}</li>
      <li>性别：{sex}</li>
      <li>年龄：{age}</li>
    </ul>
  )
}
Person.propTypes = {
  name:PropTypes.string.isRequired, //限制name必传，且为字符串
  sex:PropTypes.string,//限制sex为字符串
  age:PropTypes.number,//限制age为数值
}

//指定默认标签属性值
Person.defaultProps = {
  sex:'男',//sex默认值为男
  age:18 //age默认值为18
}
//渲染组件到页面
ReactDOM.render(<Person name="jerry"/>,document.getElementById('test1'))
```

### 4.2. state

> state: 状态，用于存储组件内数据信息。
>
> constructor: 构造函数，作用是初始化state和绑定事件。

```jsx
class Weather extends React.Component{
  //构造器调用几次？ ———— 1次
  constructor(props){
    console.log('constructor');
    super(props)
    //初始化状态
    this.state = {isHot:false,wind:'微风'}
  }
}
```

```jsx
class Weather extends React.Component{
  //初始化状态
  this.state = {isHot:false,wind:'微风'}
}
```

### 4.3. refs

> 官方不建议过度使用ref。

**字符串形式的ref**

> 官方不建议使用。

```jsx
//创建组件
class Demo extends React.Component{
  //展示左侧输入框的数据
  showData = ()=>{
    const {input1} = this.refs
    alert(input1.value)
  }
  //展示右侧输入框的数据
  showData2 = ()=>{
    const {input2} = this.refs
    alert(input2.value)
  }
  render(){
    return(
      <div>
        <input ref="input1" type="text" placeholder="点击按钮提示数据"/>&nbsp;
        <button onClick={this.showData}>点我提示左侧的数据</button>&nbsp;
        <input ref="input2" onBlur={this.showData2} type="text" placeholder="失去焦点提示数据"/>
      </div>
    )
  }
}
//渲染组件到页面
ReactDOM.render(<Demo a="1" b="2"/>,document.getElementById('test'))
```

**回调函数形式的ref**

```jsx
//创建组件
class Demo extends React.Component{
  //展示左侧输入框的数据
  showData = ()=>{
    const {input1} = this
    alert(input1.value)
  }
  //展示右侧输入框的数据
  showData2 = ()=>{
    const {input2} = this
    alert(input2.value)
  }
  render(){
    return(
      <div>
        <input ref={c => this.input1 = c } type="text" placeholder="点击按钮提示数据"/>&nbsp;
        <button onClick={this.showData}>点我提示左侧的数据</button>&nbsp;
        <input onBlur={this.showData2} ref={c => this.input2 = c } type="text" placeholder="失去焦点提示数据"/>&nbsp;
      </div>
    )
  }
}
//渲染组件到页面
ReactDOM.render(<Demo a="1" b="2"/>,document.getElementById('test'))
```

**createRef 的方式构建ref（React提供的方法）**

> 官方推荐使用的方式。  
>
> 缺陷：React.createRef() 一次只能创建一个ref

```jsx
//创建组件
class Demo extends React.Component{
  /* 
				React.createRef调用后可以返回一个容器，该容器可以存储被ref所标识的节点,该容器是“专人专用”的
			 */
  myRef = React.createRef()
  myRef2 = React.createRef()
  //展示左侧输入框的数据
  showData = ()=>{
    alert(this.myRef.current.value);
  }
  //展示右侧输入框的数据
  showData2 = ()=>{
    alert(this.myRef2.current.value);
  }
  render(){
    return(
      <div>
        <input ref={this.myRef} type="text" placeholder="点击按钮提示数据"/>&nbsp;
        <button onClick={this.showData}>点我提示左侧的数据</button>&nbsp;
        <input onBlur={this.showData2} ref={this.myRef2} type="text" placeholder="失去焦点提示数据"/>&nbsp;
      </div>
    )
  }
}
//渲染组件到页面
ReactDOM.render(<Demo a="1" b="2"/>,document.getElementById('test'))
```

## 5. 生命周期

**React 新生命周期（React v16之后）：**

![3_react生命周期(新)](https://file.pandacode.cn/blog/202201311505182.png)

```jsx
//创建组件
class Count extends React.Component{
  /* 
				1. 初始化阶段: 由ReactDOM.render()触发---初次渲染
								1.	constructor()
								2.	getDerivedStateFromProps 
								3.	render()
								4.	componentDidMount() =====> 常用
											一般在这个钩子中做一些初始化的事，例如：开启定时器、发送网络请求、订阅消息
				2. 更新阶段: 由组件内部this.setSate()或父组件重新render触发
								1.	getDerivedStateFromProps
								2.	shouldComponentUpdate()
								3.	render()
								4.	getSnapshotBeforeUpdate
								5.	componentDidUpdate()
				3. 卸载组件: 由ReactDOM.unmountComponentAtNode()触发
								1.	componentWillUnmount()  =====> 常用
											一般在这个钩子中做一些收尾的事，例如：关闭定时器、取消订阅消息
			*/
  //构造器
  constructor(props){
    console.log('Count---constructor');
    super(props)
    //初始化状态
    this.state = {count:0}
  }

  //加1按钮的回调
  add = ()=>{
    //获取原状态
    const {count} = this.state
    //更新状态
    this.setState({count:count+1})
  }

  //卸载组件按钮的回调
  death = ()=>{
    ReactDOM.unmountComponentAtNode(document.getElementById('test'))
  }

  //强制更新按钮的回调
  force = ()=>{
    this.forceUpdate()
  }

  //若state的值在任何时候都取决于props，那么可以使用ge tDerivedStateFromProps
  static getDerivedStateFromProps(props,state){
    console.log('getDerivedStateFromProps',props,state);
    return null
  }

  //在更新之前获取快照
  getSnapshotBeforeUpdate(){
    console.log('getSnapshotBeforeUpdate');
    return 'atguigu'
  }

  //组件挂载完毕的钩子
  componentDidMount(){
    console.log('Count---componentDidMount');
  }

  //组件将要卸载的钩子
  componentWillUnmount(){
    console.log('Count---componentWillUnmount');
  }

  //控制组件更新的“阀门”
  shouldComponentUpdate(){
    console.log('Count---shouldComponentUpdate');
    return true
  }

  //组件更新完毕的钩子
  componentDidUpdate(preProps,preState,snapshotValue){
    console.log('Count---componentDidUpdate',preProps,preState,snapshotValue);
  }

  render(){
    console.log('Count---render');
    const {count} = this.state
    return(
      <div>
        <h2>当前求和为：{count}</h2>
        <button onClick={this.add}>点我+1</button>
        <button onClick={this.death}>卸载组件</button>
        <button onClick={this.force}>不更改任何状态中的数据，强制更新一下</button>
      </div>
    )
  }
}

//渲染组件
ReactDOM.render(<Count count={199}/>,document.getElementById('test'))
```

**React v16 前生命周期：**

![2_react生命周期(旧)](https://file.pandacode.cn/blog/202201311504455.png)

```jsx
/* 
				1. 初始化阶段: 由ReactDOM.render()触发---初次渲染
									1.	constructor()
									2.	componentWillMount()
									3.	render()
									4.	componentDidMount() =====> 常用
													一般在这个钩子中做一些初始化的事，例如：开启定时器、发送网络请求、订阅消息
				2. 更新阶段: 由组件内部this.setSate()或父组件render触发
									1.	shouldComponentUpdate()
									2.	componentWillUpdate()
									3.	render() =====> 必须使用的一个
									4.	componentDidUpdate()
				3. 卸载组件: 由ReactDOM.unmountComponentAtNode()触发
									1.	componentWillUnmount()  =====> 常用
													一般在这个钩子中做一些收尾的事，例如：关闭定时器、取消订阅消息
		*/
//创建组件
class Count extends React.Component{

  //构造器
  constructor(props){
    console.log('Count---constructor');
    super(props)
    //初始化状态
    this.state = {count:0}
  }

  //加1按钮的回调
  add = ()=>{
    //获取原状态
    const {count} = this.state
    //更新状态
    this.setState({count:count+1})
  }

  //卸载组件按钮的回调
  death = ()=>{
    ReactDOM.unmountComponentAtNode(document.getElementById('test'))
  }

  //强制更新按钮的回调
  force = ()=>{
    this.forceUpdate()
  }

  //组件将要挂载的钩子
  componentWillMount(){
    console.log('Count---componentWillMount');
  }

  //组件挂载完毕的钩子
  componentDidMount(){
    console.log('Count---componentDidMount');
  }

  //组件将要卸载的钩子
  componentWillUnmount(){
    console.log('Count---componentWillUnmount');
  }

  //控制组件更新的“阀门”
  shouldComponentUpdate(){
    console.log('Count---shouldComponentUpdate');
    return true
  }

  //组件将要更新的钩子
  componentWillUpdate(){
    console.log('Count---componentWillUpdate');
  }

  //组件更新完毕的钩子
  componentDidUpdate(){
    console.log('Count---componentDidUpdate');
  }

  render(){
    console.log('Count---render');
    const {count} = this.state
    return(
      <div>
        <h2>当前求和为：{count}</h2>
        <button onClick={this.add}>点我+1</button>
        <button onClick={this.death}>卸载组件</button>
        <button onClick={this.force}>不更改任何状态中的数据，强制更新一下</button>
      </div>
    )
  }
}

//父组件A
class A extends React.Component{
  //初始化状态
  state = {carName:'奔驰'}

  changeCar = ()=>{
    this.setState({carName:'奥拓'})
  }

  render(){
    return(
      <div>
        <div>我是A组件</div>
        <button onClick={this.changeCar}>换车</button>
        <B carName={this.state.carName}/>
      </div>
    )
  }
}

//子组件B
class B extends React.Component{
  //组件将要接收新的props的钩子
  componentWillReceiveProps(props){
    console.log('B---componentWillReceiveProps',props);
  }

  //控制组件更新的“阀门”
  shouldComponentUpdate(){
    console.log('B---shouldComponentUpdate');
    return true
  }
  //组件将要更新的钩子
  componentWillUpdate(){
    console.log('B---componentWillUpdate');
  }

  //组件更新完毕的钩子
  componentDidUpdate(){
    console.log('B---componentDidUpdate');
  }

  render(){
    console.log('B---render');
    return(
      <div>我是B组件，接收到的车是:{this.props.carName}</div>
    )
  }
}

//渲染组件
ReactDOM.render(<Count/>,document.getElementById('test'))
```

## 6. 相比于HTML的语法区别

HTML的class - > React 的 className

HTML的style="" - > React 的 `style={{}}`

## 参考资料

- [尚硅谷](http://www.atguigu.com)
- [React 官方文档](https://zh-hans.reactjs.org)