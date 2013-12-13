package jis.util
{
	import starling.display.DisplayObject;

	/**
	 * 进度条计算类
	 * @author jiessie 2013-11-22
	 */
	public class JISSpeedProgressUtil
	{
		/** 横向从左侧过度到右侧 */
		public static function rowLeftToRigth(currNum:Number,maxNum:Number,centerDisplay:DisplayObject,leftDisplay:DisplayObject = null,leftNum:Number = 0,rightDisplay:DisplayObject = null):void
		{
			currNum = Math.max(0,Math.min(currNum,maxNum));
			if(currNum == 0)
			{
				if(leftDisplay)
				{
					leftDisplay.visible = false;
				}
				if(rightDisplay)
				{
					rightDisplay.visible = false;
				}
				//				centerDisplay.visible = false;
				setDisplayW(centerDisplay,0);
			}else if(leftDisplay && currNum < leftDisplay.width)
			{
				setDisplayW(leftDisplay,currNum);
				centerDisplay.visible = false;
				
				if(rightDisplay)
				{
					rightDisplay.visible = false;
				}
			}else
			{
				if(leftDisplay)
				{
					setDisplayW(leftDisplay,leftNum);
					//					currNum -= leftWidth;
					leftDisplay.visible = true;
				}
				if(rightDisplay)
				{
					currNum -= rightDisplay.width;
					rightDisplay.x = centerDisplay.x+currNum;
					rightDisplay.visible = true;
				}
				setDisplayW(centerDisplay,currNum);
				centerDisplay.visible = true;
			}
		}
		
		/** 从下到上方过度的进度条 */
		public static function colBottomToTop(currNum:Number,maxNum:Number,centerDisplay:DisplayObject,leftDisplay:DisplayObject = null,leftNum:Number = 0,rightDisplay:DisplayObject = null):void
		{
			currNum = Math.max(0,Math.min(currNum,maxNum));
			if(currNum == 0)
			{
				if(leftDisplay)
				{
					leftDisplay.visible = false;
				}
				if(rightDisplay)
				{
					rightDisplay.visible = false;
				}
				centerDisplay.visible = false;
			}else if(leftDisplay && currNum < leftDisplay.height)
			{
				setDisplayH(leftDisplay,currNum);
				centerDisplay.visible = false;
				
				if(rightDisplay)
				{
					rightDisplay.visible = false;
				}
			}else
			{
				if(leftDisplay)
				{
					setDisplayH(leftDisplay,leftNum);
					//					currNum -= leftWidth;
					leftDisplay.visible = true;
				}
				if(rightDisplay)
				{
					currNum -= rightDisplay.height;
					rightDisplay.y = centerDisplay.y+currNum;
					rightDisplay.visible = true;
				}
				setDisplayH(centerDisplay,currNum);
				centerDisplay.visible = true;
			}
		}
		
		private static function setDisplayW(display:DisplayObject,w:int):void
		{
			display.width = w;
//			JISDisplayUtil.setDisplayWidthForMask(display,w,-1);
		}
		
		private static function setDisplayH(display:DisplayObject,h:int):void
		{
			display.height = h;
//			JISDisplayUtil.setDisplayWidthForMask(display,-1,h);
		}
	}
}