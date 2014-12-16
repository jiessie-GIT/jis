package jis.util
{
	import flash.geom.Rectangle;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	
	/**
	 * 显示对象工具
	 * @author jiessie 2013-12-6
	 */
	public class JISDisplayUtil
	{
		/** 
		 * 尝试以遮罩的形式设置显示对象宽度，如果是image的话，
		 * 会调用image对象的setTexCoordsTo的方式设置遮罩，否则的话会直接调用width与height
		 */
		public static function setDisplayWidthForMask(display:DisplayObject,w:int,h:int):void
		{
//			if(display is Image)
//			{
//				var image:Image = display as Image;
//				var frame:Rectangle = image.texture.frame;
//				var width:Number  = frame ? frame.width  : image.texture.width;
//				var height:Number = frame ? frame.height : image.texture.height;
//				if(w < 0 || true) w = width;
//				if(h < 0 || true) h = height;
//				image.setTexCoordsTo(1,w,0.0);
//				image.setTexCoordsTo(2,0.0,h);
//				image.setTexCoordsTo(3,w,h);
//			}else
//			{
				if(w >= 0) display.width = w;
				if(h >= 0) display.height = h;
//			}
		}
		
		/** 将显示对象设置到父级的最上层 */
		public static function setDisplayToTop(display:DisplayObject):void
		{
			if(display.parent) display.parent.setChildIndex(display,display.parent.numChildren-1);
		}
		
		public static function setDisplayToCenter(display:DisplayObject):void{
			if(display.parent){
				display.x = display.parent.width/2 - display.width/2;
				display.y = display.parent.height/2 - display.height/2;
			}
		}
	}
}