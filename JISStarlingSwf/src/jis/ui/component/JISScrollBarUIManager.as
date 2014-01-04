package jis.ui.component
{
	import feathers.controls.Scroller;
	
	import jis.ui.JISUIManager;
	
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	
	/**
	 * 滚动条,默认为竖向
	 * @author jiessie 2014-1-3
	 */
	public class JISScrollBarUIManager extends JISUIManager
	{
		public var _Back:DisplayObject;
		public var _Slider:DisplayObject;
		
		private var scrollContainer:Scroller;
		/** 是否竖向 */
		private var hasVertical:Boolean = true;
		
		public function JISScrollBarUIManager(hasVertical:Boolean = true)
		{
			this.hasVertical = hasVertical;
			super();
		}
		
		/** 设置滚动容器 */
		public function setScrollContainer(scrollContainer:Scroller):void
		{
			if(this.scrollContainer)
			{
				this.scrollContainer.removeEventListener(Event.SCROLL,updateScrollBar);
			}
			this.scrollContainer = scrollContainer;
			if(this.scrollContainer)
			{
				this.scrollContainer.addEventListener(Event.SCROLL,updateScrollBar);
				updateScrollBar();
			}
		}
		
		private function updateScrollBar(e:* = null):void
		{
			if(this._Slider && scrollContainer)
			{
				if(this.hasVertical)
				{
					var vScrollScale:Number = scrollContainer.maxVerticalScrollPosition <= 0 ? 0:scrollContainer.verticalScrollPosition/scrollContainer.maxVerticalScrollPosition;
					this.display.visible = scrollContainer.maxVerticalScrollPosition > 0;
					if(this.display.visible) this._Slider.y = Math.max(Math.min(vScrollScale*(_Back.height - _Slider.height),_Back.height - _Slider.height),0);
				}else
				{
					var hScrollScale:Number = scrollContainer.maxHorizontalScrollPosition <= 0 ? 0:scrollContainer.horizontalScrollPosition/(scrollContainer.maxHorizontalScrollPosition - _Slider.width);
					this.display.visible = scrollContainer.maxHorizontalScrollPosition > 0;
					if(this.display.visible) this._Slider.x = Math.max(Math.min(hScrollScale*(_Back.width - _Slider.width),_Back.width - _Slider.width),0);
				}
			}
		}
		
		public override function dispose():void
		{
			setScrollContainer(null);
			super.dispose();
		}
	}
}