package jis.gestures
{
	import lzm.starling.gestures.Gestures;
	
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.events.TouchPhase;
	
	
	/**
	 * 滑动手势
	 * @author jiessie 2014-10-22
	 */
	public class SlitherGestures extends Gestures
	{
		public static const DIR_LEFT:String = "left";
		public static const DIR_RIGHT:String = "right";
		public static const DIR_TOP:String = "top";
		public static const DIR_BOTTOM:String = "bottom";
		
		private var beginX:Number;
		private var beginY:Number;
		
		public function SlitherGestures(target:DisplayObject, callBack:Function=null)
		{
			super(target, callBack);
		}
		
		public override function checkGestures(touch:Touch):void{
			if(touch.phase == TouchPhase.BEGAN){
				beginX = touch.globalX;
				beginY = touch.globalY;
			}else if(touch.phase == TouchPhase.ENDED){
				var dir:String = "";
				var xLength:int = touch.globalX - beginX;
				var yLength:int = touch.globalY - beginY;
				if(Math.abs(xLength) < 20 && Math.abs(yLength) < 20) return;
				if(xLength > 0 && xLength >= Math.abs(yLength)) dir = DIR_RIGHT;
				if(xLength < 0 && Math.abs(xLength) >= Math.abs(yLength)) dir = DIR_LEFT;
				if(yLength > 0 && yLength >= Math.abs(xLength)) dir = DIR_BOTTOM;
				if(yLength < 0 && Math.abs(yLength) >= Math.abs(xLength)) dir = DIR_TOP;
				callBack.call(null,dir);
			}
		}
	}
}