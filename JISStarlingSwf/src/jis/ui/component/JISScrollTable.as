package jis.ui.component
{
	import lzm.starling.display.ScrollContainer;

	/**
	 * 能够滚动的Table,操作table内容的话请调用getTable()获取JISTable实例
	 * @author jiessie 2013-11-21
	 */
	public class JISScrollTable extends ScrollContainer
	{
		private var table:JISTable;
		public function JISScrollTable(tabbedCellList:Array=null, hasClickListener:Boolean=true)
		{
			super();
			table = new JISTable(tabbedCellList, hasClickListener);
			this.addScrollContainerItem(table);
		}
		
		public function getTable():JISTable { return this.table; }
		
//		/** 停留在最底端 */
//		public function toBottom():void
//		{
//			throwTo(maxHorizontalScrollPosition,maxVerticalScrollPosition,0);
//		}
		
		public override function dispose():void
		{
			if(table) table.removeFromParent(true);
			table = null;
			super.dispose();
		}
	}
}