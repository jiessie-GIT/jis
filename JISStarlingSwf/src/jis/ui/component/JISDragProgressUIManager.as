package jis.ui.component
{
	import flash.geom.Rectangle;
	
	import lzm.starling.gestures.DragGestures;
	
	import starling.display.DisplayObject;
	
	/**
	 * 可推拽滚动进度条
	 * @author jiessie 2014-12-19
	 */
	public class JISDragProgressUIManager extends JISUIProgressManager
	{
		public var _Ball:DisplayObject;
		
		private var dragGestures:DragGestures;
		
		public function JISDragProgressUIManager(speedProgressHandler:Function=null, hasMask:Boolean=true)
		{
			super(speedProgressHandler, hasMask);
		}
		
		protected override function init():void{
			super.init();
			dragGestures = new DragGestures(_Ball,onDragHandler);
			dragGestures.setDragRectangle(new Rectangle(-_Ball.pivotX,_Ball.y-_Ball.pivotY,_Back.width,0),0,0);
		}
		
		private function onDragHandler():void{
			setProgress(_Ball.x,_Back.width);
		}
		
		/** 根据当前值与最大值计算得出最新的长度 */
		public override function setProgress(progress:int,maxProgress:int):void
		{
			super.setProgress(progress,maxProgress);
		}
	}
}