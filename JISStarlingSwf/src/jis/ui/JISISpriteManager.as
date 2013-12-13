package jis.ui
{
	import starling.display.DisplayObject;

	/**
	 * 管理UI接口<br>
	 * 通常情况下从swf中获取的显示对象是美术人员制作好的一整个UI，我们需要通过引用的方式来管理这些UI中零散的显示组件，
	 * 实现该接口的对象会由JISManagerSpriteUtil调用setCurrDisplay的方式设置一个显示对象，
	 * 如果你需要的只是简单的引用请不要addChild。<br>
	 * <b>设置引用采用的为递归的方式，只要成员是实现该接口的类，就可以无限递归</b><br>
	 * <b>规则：</b><br>
	 * 1.子类属性名必须是public类型<br>
	 * 2.子类属性名必须与显示对象name相同<br>
	 * 3.如果不是系统组件的话需要在构造函数中new出来<br>
	 * 示例:<br>
	 * public var _Text:TextField;<br>
	 * public var _Btn:JISButton;<br>
	 * <br>
	 * public function test()<br>
	 * {<br>
	 * 	   _Btn = new JISButton();<br>
	 * }<br>
	 * 对应swf的display<br>
	 * display.getChildByName("_Text")为TextField<br>
	 * display.getChildByName("_Btn")为SwfMovieClip<br>
	 * @author jiessie 2013-11-21
	 */
	public interface JISISpriteManager
	{
		/** 设置一个显示对象 */
		function setCurrDisplay(display:DisplayObject):void;
		/** 销毁 */
		function dispose():void;
	}
}