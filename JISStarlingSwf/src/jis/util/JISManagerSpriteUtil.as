package jis.util
{
	import jis.ui.JISISpriteManager;
	
	import lzm.starling.swf.display.SwfMovieClip;
	
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	
	/**
	 * 显示对象同步工具
	 * @author jiessie 2013-11-19
	 */
	public class JISManagerSpriteUtil
	{
		/** 同步显示列表 */
		public static function syncManagerSprite(spriteManager:JISISpriteManager,display:DisplayObject):void
		{
			if(display is SwfMovieClip) (display as SwfMovieClip).gotoAndPlay(0);
			if(display is DisplayObjectContainer)
			{
				var disContainer:DisplayObjectContainer = display as DisplayObjectContainer;
				for(var i:int= 0;i<disContainer.numChildren;i++)
				{
					var childDisplay:DisplayObject = disContainer.getChildAt(i);
					if(childDisplay.name != "" && (spriteManager as Object).hasOwnProperty(childDisplay.name))
					{
						if(spriteManager[childDisplay.name] is JISISpriteManager)
						{
							(spriteManager[childDisplay.name] as JISISpriteManager).setCurrDisplay(childDisplay);
						}else
						{
							spriteManager[childDisplay.name] = childDisplay;
						}
					}
				}
			}
		}
	}
}