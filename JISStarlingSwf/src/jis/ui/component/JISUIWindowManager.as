package jis.ui.component
{
	import jis.JISConfig;
	import jis.ui.JISImageSprite;
	import jis.ui.JISUIManager;
	
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	
	
	/**
	 * UI中管理窗口，比如设计UI的时候窗口中存在2级窗口，就可以使用该窗口进行管理，初始化的时候会关闭2级窗口<br>
	 * 可选按钮_Close，必须符合JISButton按钮标准，如果该按钮存在，那么点击该按钮会关闭窗口
	 * @author jiessie 2013-11-22
	 */
	public class JISUIWindowManager extends JISUIManager
	{
		public var _Close:JISButton;
		protected var backImage:JISImageSprite;
			
		public function JISUIWindowManager()
		{
			_Close = new JISButton();
			super();
		}
		
		
		/** 设置当前显示的对象 */
		public override function setCurrDisplay(display:DisplayObject):void
		{
			super.setCurrDisplay(display);
			if(_Close) _Close.addEventListener(JISButton.BUTTON_CLICK,close);
			
			if(backImage && this.display is DisplayObjectContainer)
			{
				(this.display as DisplayObjectContainer).addChildAt(backImage,0);
			}
			
			close();
		}
		
		/** 关闭，设置显示对象visible=false */
		public function close(e:* = null):void
		{
			this.display.visible = false;
		}
		
		/** 显示，设置显示对象visible=true */
		public function show():void
		{
			this.display.visible = true;
		}
		
		public override function dispose():void
		{
			if(_Close) _Close.removeEventListener(JISButton.BUTTON_CLICK,close);
			if(backImage)
			{
				backImage.removeFromParent(true);
				backImage = null;
			}
			super.dispose();
		}
		//
		public function setBackImageAssetSource(url:*):void
		{
			if(!backImage)
			{
				backImage = new JISImageSprite(url);
				if(this.display is DisplayObjectContainer)
				{
					(this.display as DisplayObjectContainer).addChildAt(backImage,0);
				}
			}else
			{
				backImage.setAssetSource(url);
			}
		}
	}
}