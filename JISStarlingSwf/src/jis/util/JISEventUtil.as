package jis.util
{
	import flash.utils.Dictionary;
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * 事件工具
	 * @author jiessie 2013-11-19
	 */
	public class JISEventUtil
	{
		/** 点击非当前窗口触发 */
		public static const EVENT_CLICK_NOT_DISPLAY:String = "EVENT_CLICK_NOT_DISPLAY";
		
		private static var displayEventListenerDic:Dictionary = new Dictionary(); 
		/** 添加对象鼠标事件,一个对象只允许添加一次 */
		public static function addDisplayMouseEventHandler(display:DisplayObject,handler:Function,...touchTypes):void
		{
			if(!display) return;
			if(displayEventListenerDic[display] != null) removeDisplayClickEventHandler(display);
			
			function listener(e:TouchEvent):void
			{
				for each(var touchType:String in touchTypes)
				{
					var touch:Touch = e.getTouch(display,touchType);
					if(touch)
					{
						if(handler != null)
						{
							if(handler.length == 0) handler.call();
							else if(handler.length == 1) handler.call(null,touchType);
							else if(handler.length == 2) handler.call(null,touchType,display);
							else if(handler.length == 3) handler.call(null,touchType,display,touch);
						}
					}
				}
			}
			display.addEventListener(TouchEvent.TOUCH,listener);
			displayEventListenerDic[display] = listener;
		}
		
		/** 点击事件 */
		public static function addDisplayClickHandler(display:DisplayObject,handler:Function):void
		{
			addDisplayMouseEventHandler(display,handler,TouchPhase.ENDED);
		}
		
		/** 按下事件 */
		public static function addDisplayDownHandler(display:DisplayObject,handler:Function):void
		{
			addDisplayMouseEventHandler(display,handler,TouchPhase.BEGAN);
		}
		
		/** 删除监听事件 */
		public static function removeDisplayClickEventHandler(display:DisplayObject):void
		{
			if(display && displayEventListenerDic[display] != null)
			{
				display.removeEventListener(TouchEvent.TOUCH,displayEventListenerDic[display]);
				delete displayEventListenerDic[display];
			}
		}
		
		/** 点击非DisplayObject区域触发 */
		public static function addClickNotDisplayEvent(display:DisplayObject,handler:Function,hasRestart:Boolean = false):void{
			if(displayEventListenerDic[display] != null) removeClickNorDisplayEvent(display);
			var listener:Function = 
				function(e:TouchEvent):void{
					if(e.getTouch(Starling.current.root,TouchPhase.ENDED) != null){
						if(e.getTouch(display,TouchPhase.ENDED) == null){
							handler.call();
							if(!hasRestart) removeClickNorDisplayEvent(display);
						}
					}
				};
			Starling.current.root.addEventListener(TouchEvent.TOUCH,listener);
			displayEventListenerDic[display] = listener;
		}
		
		public static function removeClickNorDisplayEvent(display:DisplayObject):void{
			if(display && displayEventListenerDic[display] != null)
			{
				Starling.current.root.removeEventListener(TouchEvent.TOUCH,displayEventListenerDic[display]);
				delete displayEventListenerDic[display];
			}
		}
	}
}