package jis.ui.component
{
	import jis.ui.JISUIManager;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	
	
	/**
	 * 下拉列表菜单
	 * @author jiessie 2013-12-31
	 */
	public class JISDropDownMenu extends JISUIManager
	{
		public var _Btn:JISButton;
		public var _CurrSelect:Sprite;
		public var _Info:Sprite;
		public var _Back:DisplayObject;
		
		public function JISDropDownMenu()
		{
			super();
		}
		
		protected override function init():void
		{
			close();
		}
		
		private function show():void
		{
			_Info.visible = false;
			_Back.visible = false;
		}
		
		private function close():void
		{
			_Info.visible = true;
			_Back.visible = true;
		}
	}
}