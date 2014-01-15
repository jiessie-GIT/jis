package jis.ui.component
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import jis.ui.JISUIManager;
	import jis.ui.JISUISprite;
	
	import starling.display.DisplayObjectContainer;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	
	/**
	 * 图片组成的倒计时文字
	 * @author jiessie 2014-1-13
	 */
	public class JISCharTimeUIManager extends JISUIManager
	{
		private var numCharQuadBatch:JISCharQuadBatch;
		private var swfSource:JISUISprite;
		private var charName:String;
		/** 垂直方向 */
		private var vAlign:String;
		/** 水平方向 */
		private var hAlign:String;
		
		private var _completeHandler:Function;
		private var time:Timer;
		
		public function JISCharTimeUIManager(swfSource:JISUISprite,charName:String,vAlign:String = VAlign.TOP,hAlign:String = HAlign.CENTER)
		{
			super();
			
			this.swfSource = swfSource;
			this.charName = charName;
			this.vAlign = vAlign;
			this.hAlign = hAlign;
		}
		
		private function getNumberCharacterQuadBatch():JISCharQuadBatch
		{
			if(!numCharQuadBatch)
			{
				numCharQuadBatch = new JISCharQuadBatch(swfSource.getSourceSwf(),charName,vAlign,hAlign);
				(this.display as DisplayObjectContainer).addChild(numCharQuadBatch);
			}
			return numCharQuadBatch;
		}
		
		/** 设置倒计时秒数 */
		public function setTimeSecond(second:int,completeHandler:Function):void
		{
			if(!time)
			{
				time = new Timer(1000);
				time.addEventListener(TimerEvent.TIMER,onTimerHandler);
				time.addEventListener(TimerEvent.TIMER_COMPLETE,onTimerCompleteHandler);
			}
			_completeHandler = completeHandler;
			time.reset();
			time.repeatCount = second;
			time.start();
			onTimerHandler(null);
		}
		
		public function stop():void
		{
			time.stop();
		}
		
		private function onTimerHandler(e:TimerEvent):void
		{
			var minute:String = (int)((time.repeatCount-time.currentCount)/60)+"";
			if(minute.length == 1) minute = "0"+minute;
			var second:String = (time.repeatCount-time.currentCount)%60+"";
			if(second.length == 1) second = "0"+second;
			getNumberCharacterQuadBatch().setChar(minute+":"+second);
		}
		
		private function onTimerCompleteHandler(e:TimerEvent):void
		{
			time.reset();
			if(_completeHandler != null) _completeHandler.call();
		}
		
		public override function dispose():void
		{
			time.stop();
			time.removeEventListener(TimerEvent.TIMER,onTimerHandler);
			time.removeEventListener(TimerEvent.TIMER_COMPLETE,onTimerCompleteHandler);
			time = null;
			_completeHandler = null;
			swfSource = null;
			numCharQuadBatch.dispose();
			numCharQuadBatch = null;
			super.dispose();
		}
	}
}