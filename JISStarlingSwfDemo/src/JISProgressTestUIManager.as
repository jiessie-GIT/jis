package
{
	import jis.ui.JISUIManager;
	import jis.ui.component.JISButton;
	import jis.ui.component.JISUIProgressManager;
	
	import starling.events.Event;
	import starling.text.TextField;
	
	
	/**
	 * 
	 * @author jiessie 2013-11-27
	 */
	public class JISProgressTestUIManager extends JISUIManager
	{
		public var _RowProgress:JISUIProgressManager;
		public var _AddBtn:JISButton;
		public var _DecBtn:JISButton;
		public var _ProgressText:TextField;
		
		private var currProgress:int = 0;
		
		public function JISProgressTestUIManager()
		{
			_RowProgress = new JISUIProgressManager();
			_AddBtn = new JISButton();
			_DecBtn = new JISButton();
			super();
		}
		
		protected override function init():void
		{
			_AddBtn.addEventListener(JISButton.BOTTON_CLICK,onClickAddHandler);
			_DecBtn.addEventListener(JISButton.BOTTON_CLICK,onClickDecHandler);
			updateProgress();
		}
		
		private function onClickAddHandler(e:Event):void
		{
			if(currProgress < 100)
			{
				currProgress ++;
				updateProgress();
			}
		}
		
		private function onClickDecHandler(e:Event):void
		{
			if(currProgress > 0)
			{
				currProgress --;
				updateProgress();
			}
		}
		
		private function updateProgress():void
		{
			_RowProgress.setProgress(currProgress,100);
			_ProgressText.text = currProgress+"/100";
		}
	}
}