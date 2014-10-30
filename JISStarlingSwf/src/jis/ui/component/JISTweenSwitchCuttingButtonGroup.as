package jis.ui.component
{
	import flash.geom.Point;
	
	import jis.ui.component.JISButton;
	import jis.ui.component.JISButtonGroup;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	
	
	/**
	 * 动态切换选中内容，会将选中的项交换设置为指定标识的位置，<br>
	 * 使用该类你需要通过设置setIdentificationForName的方式设置指定标识位置，<br>
	 * 默认采用的是Transitions.EASE_IN_BACK运动方式，更改可以通过setMoveTransition函数设置新的运动方式
	 * @author jiessie 2013-12-26
	 */
	public class JISTweenSwitchCuttingButtonGroup extends JISButtonGroup
	{
		private var identificationPoint:Point;
		private var moveTransition:String = Transitions.EASE_IN_BACK;
		private var lock:Boolean;
		
		public function JISTweenSwitchCuttingButtonGroup()
		{
			super();
		}
		
		/**
		 * 根据Display的名称后剩余的内容来定位标识坐标
		 */
		public function setIdentificationForName(name:String):void
		{
			var button:JISButton = getButtonForDisplayName(name);
			if(button)
			{
				setSelectBtn(button);
				identificationPoint = new Point(button.getDisplay().x,button.getDisplay().y);
			}
		}
		
		/** 设置运动方式 */
		public function setMoveTransition(transition:String):void { this.moveTransition = transition; }
		/** 设置选中按钮 */
		public override function setSelectBtn(btn:JISButton,hasDispatchEvent:Boolean = true):void
		{
			if(lock) return;
			var oldBtn:JISButton = getCurrentSelectBtn();
			super.setSelectBtn(btn,hasDispatchEvent);
			var newBtn:JISButton = getCurrentSelectBtn();
			if(oldBtn != newBtn && identificationPoint)
			{
				(this.display as DisplayObjectContainer).swapChildren(oldBtn.getDisplay(),newBtn.getDisplay());
				lock = true;
				//开始交换位置
				Starling.juggler.tween(oldBtn.getDisplay(),0.5,{"x":newBtn.getDisplay().x,"y":newBtn.getDisplay().y,"transition":moveTransition});
				Starling.juggler.tween(newBtn.getDisplay(),0.5,{"x":identificationPoint.x,"y":identificationPoint.y,"transition":moveTransition,"onComplete":moveBtnEndHandler});
			}
		}
		
		private function moveBtnEndHandler():void
		{
			lock = false;
		}
		
		public override function dispose():void
		{
			identificationPoint = null;
			super.dispose();
		}
	}
}