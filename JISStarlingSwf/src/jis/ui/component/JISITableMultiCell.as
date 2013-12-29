package jis.ui.component
{
	
	/**
	 * 该接口意味着其下有多个JISITableCell组成
	 * @author jiessie 2013-12-27
	 */
	public interface JISITableMultiCell extends JISITableCell
	{
		/** 返回内部的cell列表 */
		function getCells():Array;
		/** 设置选中子项 */
		function setSelectCell(cell:JISITableCell):void;
	}
}