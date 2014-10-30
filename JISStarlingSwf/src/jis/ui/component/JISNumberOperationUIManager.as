package jis.ui.component
{
	import jis.ui.JISUIManager;
	
	import starling.events.Event;
	import starling.text.TextField;
	
	
	/**
	 * 数字操作，具有“减数字_DecNumBtn”、“加数字_IncNumBtn”、“最大数字_MaxNumBtn”以及数字显示文本框_NumText
	 * @author jiessie 2014-1-17
	 */
	public class JISNumberOperationUIManager extends JISUIManager
	{
		public var _DecNumBtn:JISButton = new JISButton();
		public var _IncNumBtn:JISButton = new JISButton();
		public var _MaxNumBtn:JISButton = new JISButton();
		public var _NumText:TextField;
		
		private var currNum:int;
		private var maxNum:int;
		/** 最小数量 */
		private var minNum:int = 0;
		
		private var changeHandler:Function;
		
		public function JISNumberOperationUIManager()
		{
			super();
		}
		
		protected override function init():void
		{
			_DecNumBtn.addEventListener(JISButton.BUTTON_CLICK,onDecNumHandler);
			_IncNumBtn.addEventListener(JISButton.BUTTON_CLICK,onIncNumHandler);
			_MaxNumBtn.addEventListener(JISButton.BUTTON_CLICK,onMaxNumHandler);
			updateNumText();
			if(_NumText) _NumText.autoScale = true;
		}
		
		private function onDecNumHandler(e:*):void
		{
			decNum();
		}
		
		private function onIncNumHandler(e:*):void
		{
			incNum();
		}
		
		public function decNum():void
		{
			if(currNum > 0)
			{
				setCurrNum(currNum-1);
			}
		}
		
		public function incNum():void
		{
			if(currNum < maxNum)
			{
				setCurrNum(currNum+1);
			}
		}
		
		private function onMaxNumHandler(e:*):void
		{
			setCurrNum(maxNum);
		}
		
		public function setMaxNum(maxNum:int):void
		{
			this.maxNum = maxNum;
			updateNumText();
		}
		
		public function setMinNum(minNum:int):void
		{
			this.minNum = minNum;
			updateNumText();
		}
		
		private function updateNumText():void
		{
			currNum = Math.min(currNum,maxNum);
			currNum = Math.max(minNum,currNum);
			_NumText.text = currNum+"/"+maxNum;
			this.dispatchEvent(new Event(Event.CHANGE));
			if(this.changeHandler)
			{
				this.changeHandler.call(null,currNum);
			}
		}
		
		public function setCurrNum(currNum:int):void
		{
			this.currNum = currNum;
			updateNumText();
		}
		
		public function setChangeHandler(handler:Function):void
		{
			this.changeHandler = handler;
		}
		
		public function getCurrNum():int { return currNum; }
		
		public override function dispose():void
		{
			_DecNumBtn.removeEventListener(JISButton.BUTTON_CLICK,onDecNumHandler);
			_IncNumBtn.removeEventListener(JISButton.BUTTON_CLICK,onIncNumHandler);
			_MaxNumBtn.removeEventListener(JISButton.BUTTON_CLICK,onMaxNumHandler);
			this.changeHandler = null;
			super.dispose();
		}
	}
}