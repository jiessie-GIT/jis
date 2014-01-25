package jis.ui.component
{
	import flash.utils.Dictionary;
	
	import jis.ui.JISUIManager;
	import jis.ui.JISUISprite;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	
	
	/**
	 * 标签
	 * @author jiessie 2014-1-20
	 */
	public class JISTagUIManager extends JISUIManager
	{
		public var _TagBtns:JISButtonGroup;
		public var _InfoContainer:Sprite;
		
		private var btnNameClassInfos:Dictionary = new Dictionary();
		private var createTagDisplayHandler:Function;
		protected var currDisplayObject:DisplayObject;
		
		public function JISTagUIManager()
		{
			super();
			_TagBtns = new JISButtonGroup();
			_TagBtns.setSelectBtnHandler(onSelectBtnHandler);
		}
		
		protected override function init():void
		{
			if(_TagBtns.getDisplay() == null) _TagBtns.setCurrDisplay(this.getDisplay());
			if(_TagBtns.getCurrentSelectBtn())
			{
				onSelectBtnHandler(_TagBtns.getCurrentSelectBtn());
			}
		}
		
		protected function onSelectBtnHandler(btn:JISButton):void
		{
			if(currDisplayObject && _InfoContainer.contains(currDisplayObject)) _InfoContainer.removeChild(currDisplayObject);
			currDisplayObject = btnNameClassInfos[btn.getDisplay().name];
			if(currDisplayObject == null && this.createTagDisplayHandler != null)
			{
				currDisplayObject = this.createTagDisplayHandler.call(null,btn.getDisplay().name);
				btnNameClassInfos[btn.getDisplay().name] = currDisplayObject;
			}
			if(currDisplayObject)
			{
				_InfoContainer.addChild(currDisplayObject);
			}
		}
		
		public function getCurrDisplayObject():DisplayObject { return this.currDisplayObject; }
		
		public function setTagCreateDisplayHandler(handler:Function):void
		{
			this.createTagDisplayHandler = handler;
		}
		
		public override function dispose():void
		{
			for each(var display:DisplayObject in btnNameClassInfos)
			{
				if(display) display.removeFromParent(true);
			}
			btnNameClassInfos = null;
			createTagDisplayHandler = null;
			currDisplayObject = null;
			super.dispose();
		}
	}
}