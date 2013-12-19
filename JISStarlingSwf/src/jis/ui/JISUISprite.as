package jis.ui
{
	import jis.loader.JISRepeatLoaderCache;
	import jis.loader.JISSimpleLoaderSprite;
	import jis.util.JISManagerSpriteUtil;
	
	import lzm.starling.swf.Swf;
	
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	
	
	/**
	 * UI基础类
	 * @author jiessie 2013-11-19
	 */
	public class JISUISprite extends JISSimpleLoaderSprite implements JISISpriteManager
	{
		private var swfHrefName:String;
		private var assetGetName:String;
		protected var sourceSwf:Swf;
		protected var display:DisplayObject;
		
		/**
		 * @param swfHrefName swf中导出连接名，如：“spr_MainUI”
		 * @param assetGetName swf文件名，如：加载的main.swf文件的话，该值为“main”
		 */
		public function JISUISprite(swfHrefName:String,assetGetName:String)
		{
			super();
			this.swfHrefName = swfHrefName;
			this.assetGetName = assetGetName;
		}
		/** 设置将要显示的链接名字，该名字为swf导出链接名 */
		public function setSwfHrefName(name:String):void { this.swfHrefName = name;}
		/** 设置资源名字,即byte文件名，因为有的时候设置的资源地址是一个目录，这种情况不知道里面的资源该获取哪一个！所以还请详细指定是那个资源名字 */
		public function setAssetGetName(name:String):void { this.assetGetName = name;}
		/** 子类如果覆盖该方法的话，如无特殊情况请调用父类的该方法 */
		protected override function loadComplete():void
		{
			sourceSwf = new Swf(getAssetByteArrayForName(assetGetName),getAssetManager());
			setCurrDisplay(sourceSwf.createSprite(swfHrefName));
		}
		/** 设置当前显示的对象 */
		public function setCurrDisplay(display:DisplayObject):void
		{
			this.display = display;
			addCurrDisplay(display);
			if(display is DisplayObjectContainer) syncPropertyForDisplayContainer(display as DisplayObjectContainer);
			init();
		}
		/** 如果子类不想将显示对象添加到当前显示对象的话可以 */
		protected function addCurrDisplay(display:DisplayObject):void { this.addChild(display);}
		/** 将一个显示对象的子对象交给该类进行管理 */
		public function syncPropertyForDisplayContainer(displayContainer:DisplayObjectContainer):void
		{
			JISManagerSpriteUtil.syncManagerSprite(this,displayContainer);
		}
		
		protected function init():void { }
		
		public override function dispose():void
		{
			if(display) display.removeFromParent(true);
			display = null
			super.dispose();
			if(sourceSwf) sourceSwf.dispose(false);
			sourceSwf = null;
		}
		/** 获取数据源 */
		public function getSourceSwf():Swf { return this.sourceSwf; }
		/** 获取当前显示的display */
		public function getDisplay():DisplayObject { return this.display; }
	}
}