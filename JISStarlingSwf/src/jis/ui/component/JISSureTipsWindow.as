package jis.ui.component
{
	import starling.events.Event;
	import starling.text.TextField;
	
	/**
	 * 含有确定、取消、提示文本的窗口
	 * @author jiessie 2014-1-14
	 */
	public class JISSureTipsWindow extends JISUIWindow
	{
		public var _YesBtn:JISButton;
		public var _NoBtn:JISButton;
		public var _Text:TextField;
		
		private var _completeHandler:Function;
		private var text:String;
		
		public function JISSureTipsWindow(swfHrefName:String, assetGetName:String)
		{
			_YesBtn = new JISButton();
			_NoBtn = new JISButton();
			super(swfHrefName, assetGetName);
		}
		
		protected override function init():void
		{
			_YesBtn.addEventListener(JISButton.BUTTON_CLICK,onYesBtnHandler);
			_NoBtn.addEventListener(JISButton.BUTTON_CLICK,onNoBtnHandler);
			showForText(text,_completeHandler);
		}
		
		public function showForText(text:String,completeHandler:Function):void
		{
			_completeHandler = completeHandler;
			this.text = text;
			if(!this.hasLoadOK()) return;
			_Text.text = this.text;
			this.show();
		}
		
		private function onYesBtnHandler(e:Event):void
		{
			handlerComplete(true);
			this.close();
		}
		
		private function onNoBtnHandler(e:Event):void
		{
			handlerComplete(false);
			this.close();
		}
		
		public override function close(e:*=null):void
		{
			if(e)
			{
				handlerComplete(false);
			}
			super.close();
		}
		
		private function handlerComplete(hasSure:Boolean):void
		{
			if(_completeHandler) _completeHandler.call(null,hasSure);
			_completeHandler = null;
		}
		
		public override function dispose():void
		{
			_YesBtn.removeEventListener(JISButton.BUTTON_CLICK,onYesBtnHandler);
			_NoBtn.removeEventListener(JISButton.BUTTON_CLICK,onNoBtnHandler);
			super.dispose();
		}
	}
}