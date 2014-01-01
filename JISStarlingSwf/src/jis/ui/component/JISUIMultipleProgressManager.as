package jis.ui.component
{
	import jis.ui.JISUIManager;
	import jis.util.JISDisplayUtil;
	
	import starling.core.Starling;
	import starling.events.Event;
	import starling.text.TextField;

	/**
	 * 支持多条进度条的组件，进度条顺序为Display#name顺序
	 * @author jiessie 2013-12-6
	 */
	public class JISUIMultipleProgressManager extends JISDisplayCutting
	{
		public var _ProgressNumText:TextField;
		
		private var progressNum:Number;
		private var maxProgressNum:Number;
		
		private var maxMultiple:int = 0;
		private var currMultiple:Number = 0;
		
		private var bottomMovie:JISUIProgressManager
		private var topMovie:JISUIProgressManager;
		
		private var _currProgress:Number;
		
		/**
		 * @param spliceChar 切割字符串
		 * @param clazz 必须为JISUIProgressManager的子类，如果不传的话默认为JISUIProgressManager
		 */
		public function JISUIMultipleProgressManager(spliceChar:String, clazz:Class=null)
		{
			super(spliceChar, clazz);
		}
		
		protected override function getClassInstance():JISUIManager
		{
			return clazz != null ? super.getClassInstance() : new JISUIProgressManager();
		}
		
		protected override function init():void
		{
			super.init();	
			getInstanceArray().sortOn("plus");
			for each(var movie:JISUIProgressManager in getInstanceArray())
			{
				movie.getDisplay().visible = false;
			}
		}
		
		/**
		 * 设置进度条内容
		 * @param maxProgressNum 最大进度，会根据该进度计算总共有多少条
		 * @param progressNum 一条进度条的参考值
		 */
		public function setMaxProgressNum(maxProgressNum:Number,progressNum:Number = 5000.0):void
		{
			this.progressNum = progressNum;
			this.maxProgressNum = maxProgressNum;
			maxMultiple = Math.ceil(maxProgressNum/progressNum);
			setProgressNum(maxProgressNum,false);
		}
		
		/** 设置当前值 */
		public function setProgressNum(currProgress:Number,hasUpdate:Boolean = true):void
		{
			if(!hasUpdate)
			{
				this.currProgress = currProgress;
			}else
			{
				tweenProgress(currProgress);
			}
		}
		
		protected function tweenProgress(progress:int):void
		{
			Starling.juggler.tween(this,0.6,{"currProgress":progress,"onComplete":onTweenCompleteHandler});
		}
		
		private function onTweenCompleteHandler():void
		{
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function getProgressForIndex(index:int):JISUIProgressManager
		{
			return getInstanceArray()[index];
		}
		
		public function get currProgress():Number
		{
			return _currProgress;
		}
		
		public function set currProgress(value:Number):void
		{
			_currProgress = value;
			
			//当前剩余条数
			currMultiple = _currProgress/progressNum;
			
			var mulitiple:int = Math.floor(currMultiple);
			//最上面的一条的索引
			var topMovieIndex:int = mulitiple%getInstanceArray().length;
			
			if(topMovie) topMovie.getDisplay().visible = false;
			
			if(mulitiple > 0)
			{
				var bottomMovieIndex:int = (mulitiple-1)%getInstanceArray().length;
				bottomMovie = getProgressForIndex(bottomMovieIndex);
				//将下面的一条补满
				JISDisplayUtil.setDisplayToTop(bottomMovie.getDisplay());
				bottomMovie.setProgress(1,1);
				bottomMovie.getDisplay().visible = true;
			}else if(bottomMovie)
			{
				bottomMovie.getDisplay().visible = false;
			}
			
			topMovie = getProgressForIndex(topMovieIndex);
			JISDisplayUtil.setDisplayToTop(topMovie.getDisplay());
			topMovie.setProgress((currMultiple-mulitiple)*100,100);
			topMovie.getDisplay().visible = true;
			
			if(_ProgressNumText)
			{
				JISDisplayUtil.setDisplayToTop(_ProgressNumText);
				_ProgressNumText.text = "x"+mulitiple;
			}
		}
	}
}