package jis.ui.component
{
	import flash.geom.Point;
	
	import feathers.events.FeathersEventType;
	
	import jis.ui.JISUIManager;
	
	import lzm.starling.display.ScrollContainer;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	
	/**
	 * 会把管理的_Info添加到ScrollContainer中,如果_Info为空的话则会管理display
	 * @author jiessie 2014-4-9
	 */
	public class JISScrollUIManager extends JISUIManager
	{
		public var _Info:DisplayObject;
		public var _ScrollBar:JISScrollBarUIManager;
		
		private var scrollContiner:ScrollContainer;
		private var oldDisplay:DisplayObject;
		
		public function JISScrollUIManager(scrollWidth:int,scrollHeight:int,hasScrollBarVertical:Boolean = true)
		{
			_ScrollBar = new JISScrollBarUIManager(hasScrollBarVertical);
			scrollContiner = new ScrollContainer();
			scrollContiner.width = scrollWidth;
			scrollContiner.height = scrollHeight;
			super();
		}
		
		protected override function init():void
		{
			oldDisplay = this.display;
			if(_Info == null) _Info = this.display;
			scrollContiner.x = _Info.x;
			scrollContiner.y = _Info.y;
			scrollContiner.name = _Info.name;
			_Info.parent.addChildAt(scrollContiner,_Info.parent.getChildIndex(_Info));
			_Info.x = 0;
			_Info.y = 0;
			scrollContiner.addChild(_Info);
			if(_Info == this.display) this.display = scrollContiner;
			if(_ScrollBar.getDisplay())
			{
				_ScrollBar.setScrollContainer(scrollContiner);
			}else
			{
				_ScrollBar = null;
			}
			
//			scrollContiner.addEventListener(TouchEvent.TOUCH,onTouch);
		}
//		
//		private function onTouch(e:TouchEvent):void{
//			var touch:Touch = e.getTouch(scrollContiner);
//			if(touch)
//			{
//				if(touch.phase == TouchPhase.BEGAN) {
//					trace("touch BEGAN");
//					_Info.touchable = false;
//				}else if(touch.phase == TouchPhase.ENDED){
//					trace("touch end");
//					Starling.juggler.delayCall(resetInfoTouchable,0.1);
//				}
//			}
//		}
//		
//		private function resetInfoTouchable():void
//		{
//			_Info.touchable = true;
//		}
		
		/** 获得添加到滚动列表中的显示对象 */
		public function getOldDisplay():DisplayObject { return oldDisplay; }
	}
}