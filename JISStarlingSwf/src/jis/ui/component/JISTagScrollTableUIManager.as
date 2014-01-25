package jis.ui.component
{
	
	/**
	 * 一个按钮对应一个ScrollTable,会自动扫显示列表中名字为_TagBtns下的所有为SwfMovieClip的实例作为btn使用，
	 * 如果_TagBtns是空的话则_TagBtns等于当前管理的sprite，
	 * 也可以通过_TagBtns.setBtnList的方式设置按钮集合，
	 * 外部如果想创建自己独特的JISScrollTable的话，需要通过setCreateTableHandler设置一个创建方法
	 * @author jiessie 2014-1-20
	 */
	public class JISTagScrollTableUIManager extends JISTagUIManager
	{
		private var tableCellDatasHandler:Function;
		private var tableCellCreateParams:Function;
		private var tableSelectHandler:Function;
		
		public function JISTagScrollTableUIManager()
		{
			setTagCreateDisplayHandler(defultCreateTableHandler);
			super();
		}
		
		private function defultCreateTableHandler(btnName:String):JISScrollTable
		{
			return new JISScrollTable;
		}
		
		protected override function onSelectBtnHandler(btn:JISButton):void
		{
			super.onSelectBtnHandler(btn);
			if(tableCellDatasHandler != null)
			{
				getCurrTable().getTable().setCellDatas(tableCellDatasHandler(btn.getDisplay().name),this.tableCellCreateParams.call(),true);
				getCurrTable().getTable().selectHandler = onTableSelectHandler;
			}
		}
		
		private function onTableSelectHandler(selectTableCell:JISITableCell):void
		{
			if(tableSelectHandler != null)
			{
				tableSelectHandler.call(null,selectTableCell);
			}
		}
		
		/** 刷新table数据 */
		public function refreshTableCellDatas():void
		{
			onSelectBtnHandler(_TagBtns.getCurrentSelectBtn());
		}
		
		public function getCurrTable():JISScrollTable { return this.currDisplayObject as JISScrollTable; }
		
		public function setTableCellDatasHandler(handler:Function):void
		{
			tableCellDatasHandler = handler;
		}
		
		public function setTableCellCreateParamsHandler(handler:Function):void
		{
			tableCellCreateParams = handler;
		}

		public function setTableSelectHandler(handler:Function):void
		{
			tableSelectHandler = handler;
		}
		
		public override function dispose():void
		{
			tableCellDatasHandler = null;
			tableCellCreateParams = null;
			tableSelectHandler = null;
			super.dispose();
		}

	}
}