package jis.ui.component
{
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	
	
	/**
	 * 黑幕
	 * @author jiessie 2014-1-16
	 */
	public class JISInsideStoryQuad extends Quad
	{
		private var startAplha:Number;
		private var time:Number;
		private var showCenterHandler:Function;
		private var showEndHandler:Function;
		
		public function JISInsideStoryQuad(width:Number, height:Number, color:uint=16777215, premultipliedAlpha:Boolean=true)
		{
			super(width, height, color, premultipliedAlpha);
		}
		
		/**
		 * 透明过程：startAplha->1
		 * @param time 整个黑幕时间
		 * @param startAplha 开始透明参数
		 * @param showCenterHandler 透明到1后的回调
		 * @param showEndHandler 透明回到0后的回调
		 */ 
		public function play(time:Number,owner:DisplayObjectContainer = null,startAplha:Number = 0,showCenterHandler:Function = null,showEndHandler:Function = null):void
		{
			if(owner == null) owner = Starling.current.root as DisplayObjectContainer;
			owner.addChild(this);
			this.alpha = startAplha;
			this.startAplha = startAplha;
			this.showCenterHandler = showCenterHandler;
			this.showEndHandler = showEndHandler;
			this.time = time;
			Starling.juggler.tween(this,time/2,{"alpha":1,"onComplete":onAlphaToCenterHandler});
		}
		
		public function show(time:Number,owner:DisplayObjectContainer = null,startAplha:Number = 0,endHandler:Function = null):void
		{
			this.alpha = startAplha;
			if(owner == null) owner = Starling.current.root as DisplayObjectContainer;
			this.showEndHandler = endHandler;
			owner.addChild(this);
			Starling.juggler.tween(this,time,{"alpha":1,"onComplete":onShowEndHandler});
		}
		
		private function onShowEndHandler():void
		{
			this.removeFromParent();
			if(this.showEndHandler) this.showEndHandler.call();
			this.showEndHandler = null;
		}
		
		public function close(time:Number,owner:DisplayObjectContainer = null,startAplha:Number = 0,endHandler:Function = null):void
		{
			this.alpha = 0;
			if(owner == null) owner = Starling.current.root as DisplayObjectContainer;
			this.showEndHandler = endHandler;
			owner.addChild(this);
			Starling.juggler.tween(this,time,{"alpha":startAplha,"onComplete":onCloseEndHandler});
		}
		
		private function onCloseEndHandler():void
		{
			this.removeFromParent();
			if(this.showEndHandler) this.showEndHandler.call();
			this.showEndHandler = null;
		}
		
		private function onAlphaToCenterHandler():void
		{
			if(showCenterHandler) showCenterHandler.call();
			Starling.juggler.tween(this,time/2,{"alpha":startAplha,"onComplete":onAlphaToStartHandler});
		}
		
		private function onAlphaToStartHandler():void
		{
			if(showEndHandler) showEndHandler.call();
			this.removeFromParent();
			showEndHandler = null;
			showCenterHandler = null;
		}
	}
}