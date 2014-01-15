package jis.ui.component
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import jis.ui.JISUIManager;
	import jis.util.JISTextFieldUtil;
	
	import starling.events.Event;
	import starling.text.TextField;
	
	
	/**
	 * 时间文本管理组件,可以直接将该类指向一个TextField,也可以是管理的Sprite中存在一个_TimeText的TextField
	 * @author jiessie 2014-1-6
	 */
	public class JISTimeTextUIManager extends JISUIManager
	{
		public var _TimeText:TextField;
		
		private var timer:Timer;
		private var timeRemain:Number;
		private var defultText:String;
		
		/**
		 * @param defultText 当没有计时的时候显示的文本
		 * @param timeDelay 计时器运行间隔时间
		 */
		public function JISTimeTextUIManager(defultText:String = "",timeDelay:Number = 1000)
		{
			super();
			timer = new Timer(timeDelay);
			timer.addEventListener(TimerEvent.TIMER,onTimerHandler);
			this.defultText = defultText;
		}
		
		protected override function init():void
		{
			if(!_TimeText)
			{
				if(this.display is TextField) _TimeText = this.display as TextField;
			}
			stop();
		}
		
		public override function dispose():void
		{
			super.dispose();
			if(_TimeText) _TimeText = null;
		}
		
		private function onTimerHandler(e:TimerEvent):void
		{
			timeRemain -= timer.delay;
			if(_TimeText) _TimeText.text = JISTextFieldUtil.getTimeStringForTime(timeRemain);
			if(timeRemain <= 0)
			{
				this.dispatchEvent(new Event(Event.COMPLETE));
				stop();
			}
		}
		
		/** 
		 * 开始计时
		 * @param time 倒计时毫秒
		 */
		public function startTime(time:Number):void
		{
			timeRemain = time;
			if(timeRemain > 0)
			{
				this.timer.start();
				onTimerHandler(null);
			}
		}
		
		/**
		 * 根据当前时间与结束时间开始计时
		 * @param current 当前时间,可以是一个Date也可以是一个毫秒级Number
		 * @param end 结束时间,可以是一个Date也可以是一个毫秒级Number
		 */
		public function startTimeForCurrAndEnd(current:*,end:*):void
		{
			var currentTime:Number = current != null ? current is Date ? (current as Date).time:current:-1;
			var endTime:Number = end != null ? end is Date ? (end as Date).time:end:-1;
			if(currentTime > 0 && endTime > 0) startTime(endTime - currentTime);
			else stop();
		}
		
		/** 停止计时 */
		public function stop():void
		{
			timer.stop();
			if(_TimeText) _TimeText.text = defultText;
		}
		/** 获得剩余时间 */
		public function getRemainTime():Number { return this.timeRemain; }
		/** 是否运行中 */
		public function isRuning():Boolean { return this.timer.running; }
	}
}