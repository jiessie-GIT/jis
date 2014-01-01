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
				for each(var childDisplay:DisplayObject in getDisplayCOntainerChlids(disContainer))
				{
					if((spriteManager as Object).hasOwnProperty(childDisplay.name))
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
		
		/** 根据同步规则销毁显示内容 */
		public static function disposeSyncManagerSprite(spriteManager:JISISpriteManager,display:DisplayObject):void
		{
			if(display is DisplayObjectContainer)
			{
				var disContainer:DisplayObjectContainer = display as DisplayObjectContainer;
				for(var i:int= disContainer.numChildren-1;i>=0;i--)
				{
					var childDisplay:DisplayObject = disContainer.getChildAt(i);
					if(childDisplay.name != "" && (spriteManager as Object).hasOwnProperty(childDisplay.name))
					{
						if(spriteManager[childDisplay.name] is JISISpriteManager)
						{
							(spriteManager[childDisplay.name] as JISISpriteManager).dispose();
						}
						spriteManager[childDisplay.name] = null;
					}
				}
			}
		}
		
		/**  获得显示列表内容 */
		public static function getDisplayCOntainerChlids(display:DisplayObjectContainer):Array
		{
			var displayChilds:Array = [];
			for(var i:int= 0;i<display.numChildren;i++)
			{
				displayChilds.push(display.getChildAt(i));
			}
			return displayChilds;
		}
	}
}