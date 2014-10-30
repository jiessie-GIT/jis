package jis.ui.component
{
	import starling.core.Starling;
	import starling.display.DisplayObject;
	
	/**
	 * 滑动背景按钮组，滑块会向当前选中的按钮滑去
	 * @author jiessie 2014-8-14
	 */
	public class JISScrollBackButtonGroup extends JISButtonGroup
	{
		public var _Back:DisplayObject;
		private var tweenTime:Number = 0.2;
		
		public function JISScrollBackButtonGroup(list:Array=null, btnClass:Class=null, tweenTime:Number = 0.2)
		{
			super(list, btnClass);
			this.tweenTime = tweenTime;
		}
		
		public override function setSelectBtn(btn:JISButton, hasDispatchEvent:Boolean=true):void
		{
			super.setSelectBtn(btn);
			if(btn) Starling.juggler.tween(_Back,tweenTime,{"x":btn.getDisplay().x,"y":btn.getDisplay().y});
		}
	}
}