package jis.util
{
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	
	/**
	 * 
	 * @author jiessie 2014-1-9
	 */
	public class JISTweenUtil
	{
		/** [[背景Display,x,y,alpha,Tween类型,delay],[背景Display,x,y,alpha,Tween类型,delay] */
		public static function moveListToEndBackPoint(tweenList:Array,time:Number,endHandler:Function = null):void
		{
			for each(var infos:Array in tweenList)
			{
				moveToEndBackPoint(infos[0],
					time,
					infos[1] == null ? infos[0].x:infos[1],
					infos[2] == null ? infos[0].y:infos[2],
					infos[3] == null ? infos[0].alpha:infos[3],
					endHandler,
					infos[4],
					infos[5] == null ? 0:infos[5]);
				endHandler = null;
			}
		}
		
		/** 在移动结束之后设置显示对象坐标为原始坐标 */
		public static function moveToEndBackPoint(display:DisplayObject,time:Number,x:int,y:int,alpha:Number,moveEndHandler:Function = null,transition:String = Transitions.EASE_IN,delay:Number = 0):void
		{
			var oldX:int = display.x;
			var oldY:int = display.y;
			var oldAlpha:Number = display.alpha;
			
			function moveEnd():void
			{
				if(moveEndHandler) moveEndHandler.call();
				display.x = oldX;
				display.y = oldY;
				display.alpha = oldAlpha;
			}
			if(transition == null || transition == "") transition = Transitions.EASE_IN;
			Starling.juggler.tween(display,time,{"x":x,"y":y,"alpha":alpha,"onComplete":moveEnd,"transition":transition,"delay":delay});
		}
		
		/** [[背景Display,x,y,alpha,Tween类型,delay],[背景Display,x,y,alpha,Tween类型,delay] */
		public static function moveListFromPoint(tweenList:Array,time:Number,endHandler:Function = null):void
		{
			for each(var infos:Array in tweenList)
			{
				moveFromPoint(infos[0],
					time,
					infos[1] == null ? infos[0].x:infos[1],
					infos[2] == null ? infos[0].y:infos[2],
					infos[3] == null ? infos[0].alpha:infos[3],
					endHandler,
					infos[4],
					infos[5] == null ? 0:infos[5]);
				endHandler = null;
			}
		}
		
		/** 从指定坐标开始移动到当前坐标 */
		public static function moveFromPoint(display:DisplayObject,time:Number,x:int,y:int,alpha:Number,moveEndHandler:Function = null,transition:String = Transitions.EASE_IN,delay:Number = 0):void
		{
			var oldX:int = display.x;
			var oldY:int = display.y;
			var oldAlpha:Number = display.alpha;
			
			display.x = x;
			display.y = y;
			display.alpha = alpha;
			
			if(transition == null || transition == "") transition = Transitions.EASE_IN;
			Starling.juggler.tween(display,time,{"x":oldX,"y":oldY,"alpha":oldAlpha,"onComplete":moveEndHandler,"transition":transition,"delay":delay});
		}
	}
}