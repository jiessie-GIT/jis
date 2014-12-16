package jis.ui.component
{
	import jis.JISConfig;
	import jis.ui.JISImageSprite;
	import jis.ui.JISUISprite;
	import jis.util.JISDisplayUtil;
	
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	
	
	/**
	 * 窗口，可选按钮_Close，必须符合JISButton按钮标准，如果该按钮存在，那么点击该按钮会关闭窗口
	 * @author jiessie 2013-11-19
	 */
	public class JISUIWindow extends JISUISprite
	{
		public var _Close:JISButton;
		protected var backImage:JISImageSprite;
		private var owner:DisplayObjectContainer;
		
		/**
		 * @param swfHrefName swf中导出连接名，如：“spr_MainUI”
		 * @param assetGetName swf文件名，如：加载的main.bytes、main.png、main.xml或者main文件夹的话，该值为“main”
		 */
		public function JISUIWindow(swfHrefName:String, assetGetName:String,owner:DisplayObjectContainer = null)
		{
			_Close = new JISButton();
			this.owner = owner;
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
			if(this.owner) this.owner.addChild(this);
			else if(JISConfig.windowStage) JISConfig.windowStage.addChild(this);
		}
		
		public function showForCenter():void{
			show();
			JISDisplayUtil.setDisplayToCenter(this);
		}
		
		public override function dispose():void
		{
			if(_Close) _Close.removeEventListener(JISButton.BUTTON_CLICK,close);
			if(backImage)
			{
				backImage.removeFromParent(true);
				backImage = null;
			}
			this.owner = null;
			super.dispose();
		}
		
		/** 是否显示 */
		public function isShow():Boolean { return this.parent != null; }
		
		public function setBackImageAssetSource(url:*):void
		{
			if(!backImage)
			{
				backImage = new JISImageSprite(url);
				this.addChildAt(backImage,0);
			}else
			{
				backImage.setAssetSource(url);
			}
		}
	}
}