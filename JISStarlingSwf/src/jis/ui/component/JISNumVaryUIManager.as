package jis.ui.component
{
	import jis.ui.JISUIManager;
	import jis.ui.JISUISprite;
	
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	
	/**
	 * 数字跳动组件，也可以纯粹当作JISCharQuadBatch管理组件使用
	 * @author jiessie 2014-1-10
	 */
	public class JISNumVaryUIManager extends JISUIManager
	{
		private var numCharQuadBatch:JISCharQuadBatch;
		private var swfSource:JISUISprite;
		private var charName:String;
		/** 垂直方向 */
		private var vAlign:String;
		/** 水平方向 */
		private var hAlign:String;
		
		private var _currProgress:int;
		private var _completeHandler:Function;
		
		public function JISNumVaryUIManager(swfSource:JISUISprite,charName:String,vAlign:String = VAlign.TOP,hAlign:String = HAlign.CENTER)
		{
			super();
			
			this.swfSource = swfSource;
			this.charName = charName;
			this.vAlign = vAlign;
			this.hAlign = hAlign;
		}
		
		/**
		 * 设置跳动的数字
		 * @param startNum 开始数字
		 * @param endNum 结束数字
		 * @param time 从开始到结束的时间
		 * @param endHandler 跳动完毕的回调
		 */
		public function setVaryNum(startNum:int,endNum:int = 0,time:Number = 1,endHandler:Function = null):void
		{
			currProgress = startNum;
			if(time <= 0 || startNum >= endNum)
			{
				if(endHandler != null) endHandler.call();
				return;
			}
			_completeHandler = endHandler;
			Starling.juggler.tween(this,time,{"currProgress":endNum,"onComplete":onTweenCompleteHandler});
		}
		
		/** 直接设置显示的内容 */
		public function setChar(char:*):void
		{
			getNumberCharacterQuadBatch().setChar(char);
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
		
		private function onTweenCompleteHandler():void
		{
			if(_completeHandler != null) _completeHandler.call(); 
		}

		public function get currProgress():int
		{
			return _currProgress;
		}

		public function set currProgress(value:int):void
		{
			_currProgress = value;
			getNumberCharacterQuadBatch().setChar(value+"");
		}
	}
}