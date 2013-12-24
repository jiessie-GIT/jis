package jis.ui.component
{
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	
	/**
	 * 数字输入框<br>
	 * 其中数字命名必须以“_Num_”开头后面的内容对应输入的内容<br>
	 * 内容更改可以监听Event.CHANGE事件
	 * @author jiessie 2013-12-24
	 */
	public class JISNumberInputWindow extends JISUIWindow
	{
		private var btnGroup:JISButtonGroup;
		private var text:TextField;
		
		private var timeId:uint;
		private var changeHandler:Function;
		
		public function JISNumberInputWindow(swfHrefName:String, assetGetName:String)
		{
			super(swfHrefName, assetGetName);
		}
		
		protected override function init():void
		{
			btnGroup = new JISButtonGroup();
			btnGroup.setState(JISButtonGroup.STAGE_NORMAL);
			btnGroup.setCurrDisplay(this.display);
			btnGroup.setSelectBtnHandler(selectBtnHandler);
		}
		
		/**
		 * 根据一个文本框位置进行显示
		 * @param textField 输入的值会修改该TextField
		 * @param changeHandler 每次输入或者删除都会触发的函数
		 */
		public function showForTextField(textField:TextField,changeHandler:Function = null):void
		{
			this.text = textField;
			this.changeHandler = changeHandler;
			var point:Point = textField.localToGlobal(new Point());
			this.x = point.x;
			this.y = point.y;
			this.show();
			
			timeId = setTimeout(addListener,1);
		}
		
		private function addListener():void
		{
			clearTimeout(timeId);
			Starling.current.root.addEventListener(TouchEvent.TOUCH,touchStageHandler);
		}
		
		private function touchStageHandler(e:TouchEvent):void
		{
			if(e.getTouch(Starling.current.root,TouchPhase.BEGAN) != null 
				&& e.getTouch(this,TouchPhase.BEGAN) == null)
			{
				close();
			}
		}
		
		public override function close(e:*=null):void
		{
			Starling.current.root.removeEventListener(TouchEvent.TOUCH,touchStageHandler);
			this.text = null;
			changeHandler = null;
			super.close();
		}
		
		private function selectBtnHandler(btn:JISButton):void
		{
			var numStr:String = btn.getDisplay().name.substr("_Num_".length);
			var newStr:String = this.text.text;
			if(newStr == "0") newStr = "";
			if(numStr == "c") newStr = "";
			else if(numStr == "x") newStr = newStr.substring(0,newStr.length-1);
			else newStr += numStr;
			if(newStr == "") newStr = "0";
			this.text.text = newStr;
			this.dispatchEvent(new Event(Event.CHANGE));
			if(this.changeHandler != null) this.changeHandler.call();
		}
		
		public override function dispose():void
		{
			close();
			btnGroup.dispose();
			btnGroup = null;
			super.dispose();
		}
	}
}