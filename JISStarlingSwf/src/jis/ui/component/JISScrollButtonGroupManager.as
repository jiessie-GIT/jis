package jis.ui.component
{
	import starling.display.DisplayObject;
	
	/**
	 * 可滚动的按钮组
	 * @author jiessie 2014-7-14
	 */
	public class JISScrollButtonGroupManager extends JISButtonGroup
	{
		private var scrollContainer:JISScrollContiner;
		
		public function JISScrollButtonGroupManager(w:int,h:int,list:Array=null, btnClass:Class=null,scrollType:String = "auto",scrollState:String = "normal")
		{
			super(list, btnClass);
			scrollContainer = new JISScrollContiner(scrollType,scrollState);
			scrollContainer.width = w;
			scrollContainer.height = h;
		}
		
		public override function setCurrDisplay(display:DisplayObject):void
		{
			scrollContainer.name = display.name;
			scrollContainer.x = display.x;
			scrollContainer.y = display.y;
			display.x = 0;
			display.y = 0;
			display.parent.addChildAt(scrollContainer,display.parent.getChildIndex(display));
			scrollContainer.addChild(display);
			super.setCurrDisplay(display);
		}
		
		public function getScrollContainer():JISScrollContiner{
			return scrollContainer;
		}
	}
}