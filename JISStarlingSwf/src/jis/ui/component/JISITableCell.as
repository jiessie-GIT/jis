package jis.ui.component
{
	import starling.display.DisplayObject;

	/**
	 * 添加表格中显示内容的话必须实现该接口
	 * @author jiessie 2013-11-20
	 */
	public interface JISITableCell
	{
		/** 设置值 */ 
		function setValue(value:*):void;
		/** 获取显示对象 */  
		function getDisplay():DisplayObject;
		/** 设置选中状态与未选中状态 */ 
		function selected(select:Boolean = false):void;
		/** 获取设置的值 */ 
		function getValue():*;
		/** 销毁 */ 
		function dispose():void;
	}
}