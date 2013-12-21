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
		
		/**
		 * 滚动到最下方
		 * @param time 时间(秒)
		 */ 
		public function toBottom(time:Number = 1):void
		{
			var maxWidth:int = Math.max(0,table.width - this.width);
			var maxHeight:int = Math.max(0,table.height - this.height);
			scrollToPosition(maxWidth,maxHeight,time);
		}
		
		/**
		 * 滚动到最上方
		 * @param time 时间(秒)
		 */
		public function toTop(time:Number = 1):void
		{
			scrollToPosition(0,0,time);
		}
		
		/**
		 * 滚动到指定页
		 * @param page 页数，计算方式:scroll显示的范围为一页,0为第一页
		 * @param time 时间(秒)
		 */
		public function toPage(page:int,time:Number = 1):void
		{
			var maxWPage:int = Math.ceil(table.width/this.width);
			var maxHPage:int = Math.ceil(table.height/this.height);
			
			var wPage:int = Math.min(page,maxWPage-1);
			var hPage:int = Math.min(page,maxHPage-1);
			scrollToPosition(this.width*wPage,this.height*hPage,time);
		}
	}
}