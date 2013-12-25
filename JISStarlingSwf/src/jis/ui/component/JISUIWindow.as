package jis.ui.component
{
	import jis.JISConfig;
	import jis.ui.JISUISprite;
	
	import starling.display.DisplayObject;
	
	
	/**
	 * 窗口，可选按钮_Close，必须符合JISButton按钮标准，如果该按钮存在，那么点击该按钮会关闭窗口
	 * @author jiessie 2013-11-19
	 */
	public class JISUIWindow extends JISUISprite
	{
		public var _Close:JISButton;
		
		/**
		 * @param swfHrefName swf中导出连接名，如：“spr_MainUI”
		 * @param assetGetName swf文件名，如：加载的main.swf文件的话，该值为“main”
		 */
		public function JISUIWindow(swfHrefName:String, assetGetName:String)
		{
			_Close = new JISButton();
			super(swfHrefName, assetGetName);
		}
		
		/** 设置当前显示的对象 */
		public override function setCurrDisplay(display:DisplayObject):void
		{
			super.setCurrDisplay(display);
			if(_Close) _Close.addEventListener(JISButton.BUTTON_CLICK,close);
		}
		
		/** 关闭，会从父类移除 */
		public function close(e:* = null):void
		{
			this.removeFromParent(false);
		}
		
		/** 将会添加到JISConfig.windowStage显示列表中 */
		public function show():void
		{
			if(JISConfig.windowStage) JISConfig.windowStage.addChild(this);
		}
		
		public override function dispose():void
		{
			if(_Close) _Close.removeEventListener(JISButton.BUTTON_CLICK,close);
			_Close = null;
			super.dispose();
		}
		
		/** 是否显示 */
		public function isShow():Boolean { return this.parent != null; }
	}
}