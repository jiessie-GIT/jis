package jis.ui.component
{
	import jis.ui.JISUIManager;
	import jis.ui.JISUISprite;
	import jis.util.JISEventUtil;
	
	import lzm.starling.swf.display.SwfSprite;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	
	
	/**
	 * 下拉列表菜单
	 * @author jiessie 2013-12-31
	 */
	public class JISDropDownMenu extends JISUIManager
	{
		public var _Btn:JISButton;
		public var _Selected:SwfSprite;
		public var _Info:Sprite;
		public var _Back:DisplayObject;
		
		private var selectTableCell:JISITableCell;
		private var swfSource:JISUISprite;
		private var table:JISScrollTable;
		private var cellClass:Class;
		private var _selectHandler:Function;
		private var _enable:Boolean = true;
		
		public function JISDropDownMenu(menuHeight:int,swfSource:JISUISprite,cellClass:Class = null)
		{
			super();
			_Btn = new JISButton();
			this.swfSource = swfSource;
			this.cellClass = cellClass == null ? JISTextTableCell:cellClass;
			table = new JISScrollTable();
			table.getTable().setCellInstanceClass(this.cellClass);
			table.getTable().setIsRow(false);
			table.getTable().selectHandler = onTableSelectHandler;
			table.height = menuHeight;
		}
		
		private function onTableSelectHandler(cell:JISITableCell):void
		{
			selectTableCell.setValue(cell.getValue());
			if(this._selectHandler)
			{
				this._selectHandler.call(null,cell.getValue());
			}
			close();
		}
		
		protected override function init():void
		{
			selectTableCell = new cellClass(swfSource.getSourceSwf());
			table.width = _Selected.width;
			_Info.addChild(table);
			if(_Back) _Back.height = table.height;
			if(selectTableCell is JISUIManager)
			{
				(selectTableCell as JISUIManager).setCurrDisplay(_Selected);
			}
			_Btn.setClickHandler(show);
			JISEventUtil.addDisplayClickHandler(_Selected,show);
			close();
		}
		
		/** 设置下拉列表数据 */
		public function setDropDatas(datas:*):void
		{
			table.getTable().setCellDatas(datas,swfSource.getSourceSwf());
		}
		
		/** 获得选中的内容 */
		public function getSelectTableValue():* { return selectTableCell.getValue(); }
		public function getTable():JISScrollTable { return table; }
		
		public function set selectHandler(handler:Function):void
		{
			this._selectHandler = handler;
		}
		
		private function show(e:* = null):void
		{
			if(!_enable) return;
			if(_Info.visible)
			{
				close();
				return;
			}
				
			_Info.visible = true;
			if(_Back) _Back.visible = true;
			_Btn.setState(JISButton.SELECTED);
		}
		
		private function close():void
		{
			_Info.visible = false;
			if(_Back) _Back.visible = false;
			_Btn.setState(JISButton.DEFULT,true);
		}
		
		public override function dispose():void
		{
			JISEventUtil.removeDisplayClickEventHandler(_Selected);
			selectTableCell.dispose();
			selectTableCell = null;
			table.removeFromParent(true);
			table = null;
			swfSource = null;
			super.dispose();
		}

		public function get enable():Boolean { return _enable; }
		public function set enable(value:Boolean):void { _enable = value; }
	}
}