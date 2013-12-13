package jis.ui.component
{
	import jis.ui.JISUIManager;
	
	import starling.display.DisplayObject;
	import starling.text.TextField;
	
	
	/**
	 * 管理UI中的进度条组件，UI需要具备命名为_Center的Display，当设置进度的时候会改变_Center的width或者height属性，建议_Center为Scale9Image<br>
	 * 可选组建_Text类型为TextField，存在该组件的话，会在设置进度的时候赋值“当前进度/最大进度”
	 * @author jiessie 2013-11-22
	 */
	public class JISUIProgressManager extends JISUIManager
	{
		/** 显示文本 */
		public var _Text:TextField;
		/** 进度条中间位置 */
		public var _Center:DisplayObject;
		/** 进度条管理 */
		protected var progressBar:JISProgress;
		
		public function JISUIProgressManager(speedProgressHandler:Function = null)
		{
			progressBar = new JISProgress(true);
			if(speedProgressHandler != null) progressBar.setSpeedProgressHandler(speedProgressHandler);
			super();
		}
		
		protected override function init():void
		{
			if(_Center == null) _Center = this.display;
			progressBar.setCenterDisplay(_Center);
			setProgressMaxWidth(this._Center.width);
		}
		
		/** 设置进度条最大宽度 */
		public function setProgressMaxWidth(maxNum:int):void
		{
			this.progressBar.setMaxWidth(maxNum);
		}
		
		/** 根据当前值与最大值计算得出最新的长度 */
		public function setProgress(progress:int,maxProgress:int):void
		{
			this.progressBar.setCurrWidthForProgress(progress,maxProgress);
			if(_Text)
			{
				_Text.text = progress+"/"+maxProgress;
			}
		}
		
		public override function dispose():void
		{
			_Text = null;
			_Center = null;
			progressBar.dispose();
			progressBar = null;
			super.dispose();
		}
	}
}