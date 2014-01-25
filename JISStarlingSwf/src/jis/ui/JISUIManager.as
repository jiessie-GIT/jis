package jis.ui
{
	import jis.util.JISManagerSpriteUtil;
	
	import lzm.starling.swf.components.ISwfComponent;
	import lzm.starling.swf.display.SwfSprite;
	
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.events.EventDispatcher;
	
	
	/**
	 * ui管理，该类管理的UI不会进行addChild操作，只会当作引用来进行管理
	 * @author jiessie 2013-11-19
	 */
	public class JISUIManager extends EventDispatcher implements JISISpriteManager,ISwfComponent
	{
		protected var display:DisplayObject;
		/** 附带参数，无实际意义，只是方便使用 */
		public var plus:*;
		/** 设置显示对象 */
		public function setCurrDisplay(display:DisplayObject):void
		{
			this.display = display;
			JISManagerSpriteUtil.syncManagerSprite(this,display as DisplayObjectContainer);
			init();
		}
		
		public function initialization(componetContent:SwfSprite):void
		{
			setCurrDisplay(componetContent);
		}
		
		public function get editableProperties():Object{ return {} }
		
		public function set editableProperties(properties:Object):void{ }
		
		protected function init():void {}
		public function dispose():void 
		{
			if(this.display)
			{
				JISManagerSpriteUtil.disposeSyncManagerSprite(this,this.display);
				//没有负责添加创建就不负责移除销毁了
//				this.display.removeFromParent(true);
			}
			this.display = null;
		}
		/** 将一个显示对象的子对象交给该类进行管理 */
		public function syncPropertyForDisplayContainer(displayContainer:DisplayObjectContainer):void
		{
			JISManagerSpriteUtil.syncManagerSprite(this,displayContainer);
		}
		/** 获取当前类的显示对象 */
		public function getDisplay():DisplayObject { return this.display; }
	}
}