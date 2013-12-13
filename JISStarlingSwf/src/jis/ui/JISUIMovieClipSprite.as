package jis.ui
{
	import lzm.starling.swf.display.SwfMovieClip;
	
	import starling.display.DisplayObject;
	
	/**
	 * 该类只是将管理的display转换为SwfMovieClip，方便使用
	 * @author jiessie 2013-11-20
	 */
	public class JISUIMovieClipSprite extends JISUISprite
	{
		protected var movie:SwfMovieClip;
		
		public function JISUIMovieClipSprite(swfHrefName:String, assetGetName:String)
		{
			super(swfHrefName, assetGetName);
		}
		
		public override function setCurrDisplay(display:DisplayObject):void
		{
			movie = display as SwfMovieClip;
			super.setCurrDisplay(display);
		}
		
		public override function dispose():void
		{
			movie = null;
			super.dispose();
		}
	}
}