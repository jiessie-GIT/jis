package jis.ui.component
{
	import flash.utils.Dictionary;
	
	import jis.ui.JISUIManager;
	
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
		}
		
		protected override function init():void
		{
			if(_TagBtns.getDisplay() == null) _TagBtns.setCurrDisplay(this.getDisplay());
			if(_TagBtns.getCurrentSelectBtn())
			{
				onSelectBtnHandler(_TagBtns.getCurrentSelectBtn());
			}
			_TagBtns.setSelectBtnHandler(onSelectBtnHandler);
		}
		
		public function setBtnList(btnList:Array):void
		{
			_TagBtns.setBtnList(btnList);
			_TagBtns.setSelectBtnHandler(onSelectBtnHandler);
		}
		
		public function setContainerDisplay(display:DisplayObject):void
		{
			if(currDisplayObject && _InfoContainer.contains(currDisplayObject))
			{
				_InfoContainer.removeChild(currDisplayObject);
				if(currDisplayObject is JISITagCell) (currDisplayObject as JISITagCell).closeToTag();
			}
			currDisplayObject = display;
			if(currDisplayObject)
			{
				_InfoContainer.addChild(currDisplayObject);
				if(currDisplayObject is JISITagCell) (currDisplayObject as JISITagCell).showToTag();
			}
		}
		
		public function setSelectBtnForName(name:String):void
		{
			onSelectBtnHandler(_TagBtns.getButtonForDisplayName(name));
		}
		
		public function onSelectBtnHandler(btn:JISButton):void
		{
			var display:DisplayObject = btnNameClassInfos[btn.getDisplay().name];
			if(display == null && this.createTagDisplayHandler != null)
			{
				display = this.createTagDisplayHandler.call(null,btn.getDisplay().name);
				btnNameClassInfos[btn.getDisplay().name] = display;
			}
			setContainerDisplay(display);
		}
		
		public function getDisplayForType(type:String):DisplayObject
		{
			if(btnNameClassInfos[type] == null)
			{
				if(_TagBtns.getButtonForDisplayName(type) != null && this.createTagDisplayHandler != null)
				{
					btnNameClassInfos[type] = this.createTagDisplayHandler.call(null,type);
				}
			}
			return btnNameClassInfos[type];
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