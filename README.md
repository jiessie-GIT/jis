StarlingSwf扩展UI组件
===

该扩展是建立在StarlingSwf的基础之上进行编写，能够使你在Starling中开发UI变成简单并且高效，能够将你的注意力全部集中在程序逻辑当中.

开发效率很高，针对复杂的UI也能轻松实现

####教程地址：http://bbs.9ria.com/thread-275219-1-1.html
####StarlingSwf地址：https://github.com/zmLiu/StarlingFeathers
####Swf转换工具地址：https://github.com/zmLiu/StarlingSWF
####API地址：http://jiessie-git.github.io/jis_blog/

组件介绍
================

1.JISButton
-------------------
	普通按钮，包装了SwfMovieClip，需要在fla中导出为“mcXXX”
	对应帧：
		第一帧为普通状态
		第二帧为滑过状态
		第三帧为按下状态
		第四帧为选中状态，与JISButtonGroup配合使用可以当作单选按钮使用
		第五帧为不可用状态
	按钮按下会抛出JISButton.BOTTON_CLICK事件，事件类型为starling的Event

2.JISButtonGroup
-------------------
	按钮集合管理，可以在初始化的时候传入JISButton的集合，也可以当成组件使用
	组件使用方式：
		public var _Btn:JISButtonGroup;
		对应的fla中_Btn的导出连接名为sprite，会自动将sprite中的所有SwfMovieClip使用JISButton进行管理
	监听方式：
		_Btn.setSelectBtnHandler(handler);
		//handler需要具备一个参数，调用的时候会传入当前选中的JISButton
		_Btn.addEventListener(JISButtonGroup.CLICK_BTN,handler);
		//通过调用_Btn.getCurrentSelectBtn()的方式获得当前选中项
3.JISCharQuadBatch
-------------------
	处理文字便捷类，比如你想根据文字拼接一个由图片组成的sprite的话，你可以使用该类
	使用规则，swf中存在如下导出图片：
	img_num_1、img_num_2、img_num_3、img_num_4、img_num_-、img_num_+初始化的时候就需要传入“img_num_” 
	然后通过setChar("+333")就可以显示img_num_+、img_num_3、img_num_3、img_num_3这几个图片拼装的显示对象
	比如游戏中的经验值处理为：100/522这种，你只需要传入字符串“100/522”即可。
	如果是用的本扩展加载的swf的话，可以调用加载类的getSourceSwf()获得Swf对象
4.JISCuttingButtonGroup
--------------------
	可以指定一个Sprite中具有相同特征命名的SwfMovieClip交由JISButton进行管理，构造函数可以传入JISButton以及其子类
5.JISDisplayCutting
--------------------
	可以指定一个Sprite中具有相同特征命名的显示对象交由JISUIManager的类或者子类进行管理
6.JISIconManager
--------------------
	图像管理类，内部封装了JISImageSprite，可以将该类指向一个空的Sprite
	通过setImageSource()的方式设置一个图片的url或者File
	setIconWH可以强制指定图片的大小
	该类具备一个遮罩对象，如果管理的Sprite中有一个命名为_MaskImage的Display的话将会实现遮罩功能
7.JISScrollTable
--------------------
	滑动的table，继承至ScrollContainer，可以通过getTable()获得内部的table对象并对其进行参数设置
	滑动说明：
		竖向滑动：如果内部table的width小于等于JISScrollTable的width的话，将可以进行竖向滑动，可以通过getTable().setPreferredWidth的方式强制限制table的宽度
		横向滑动：内部的table的height小于等于JISScrollTable的height的话，将可以进行横向滑动，可以通过getTable().setPreferredHeight的方式强制限制table的高度
	演示代码：
		//竖向滑动
		table = new JISScrollTable();
		table.getTable().setPreferredWidth(300);
		table.width = 300;
		table.height = 445;
8.JISTable
--------------------
	功能强大的表格，可以理解为list，支持横向竖向布局
	功能的强大在于可以设置一个实现了ITabbedCell接口的Class，然后可以通过设置一个data的方式自动创建Class并添加到显示列表中，也可以批量设置data，具体参考addCellData、setCellDatas、removeForCellData
	当选中table中的内容的时候table会抛出JISTable.TABBED_SELECTED事件，通过getSelected()的方式可以获得当前选中
9.JISUIMultipleProgressManager
--------------------
	很多游戏的BOSS都是很多管血量，BOSS掉血是一管一管的递减，该类就是实现这种进度条的组件
	该类管理的Sprite中的显示对象必须满足JISUIProgressManager的规则，也就是说Sprite中其实有N多的进度条
	使用方法：
		通过setMaxProgressNum(max,oneProgress)，其中第一个参数为最大值，第二个参数是每一条进度所占的份额，程序会根据(max/oneProgress的方式计算总共需要多少个进度条
		通过setProgressNum设置当前进度，进度递减过程中使用的starling的缓动类进行控制
10.JISUIProgressManager
--------------------
	进度条管理组件，你可以将该类与一个display进行绑定，也可以将Sprite中的一个名字叫做_Center的显示对象绑定
	使用方法：setProgress(当前，最大)
	要求：制作的时候_Center或者display必须是100%进度条的状态
11.	JISUIWindow
--------------------
	窗口类，可以使用该类加载swf资源，并指定窗口导出的连接名字
12.JISUIWindowManager
--------------------
	窗口管理类，通常用作2级窗口使用，与普通的JISUIManager处理方式一样