package
{
	import flash.filesystem.File;
	
	import jis.ui.component.JISButton;
	import jis.ui.component.JISCuttingButtonGroup;
	import jis.ui.component.JISScrollTable;
	import jis.ui.component.JISUIWindow;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	
	/**
	 * 
	 * @author jiessie 2013-11-27
	 */
	public class JISMainUIWindow extends JISUIWindow
	{
		public var _ProgressTest:JISProgressTestUIManager;
		public var _BtnList:JISCuttingButtonGroup;
		public var _ScrollTable:Sprite;
		
		public var _AddTableCellBtn:JISButton = new JISButton();
		public var _TopBtn:JISButton = new JISButton();
		public var _TopPageBtn:JISButton = new JISButton();
		public var _BottomPageBtn:JISButton = new JISButton();
		public var _BottomBtn:JISButton = new JISButton();
		
		private var tableScroll:JISScrollTable;
		
		private var btnIndex:int = 0;
		
		private var currPage:int = 0;
		
		public function JISMainUIWindow()
		{
			//自定义管理类需要在setAssetSource之前初始化
			_BtnList = new JISCuttingButtonGroup("_Btn_",JISButton);
			_ProgressTest = new JISProgressTestUIManager();
			
			super("spr_TestWindow", "test");
			setAssetSource(File.applicationDirectory.resolvePath("assets/ui/test/"));
		}
		
		/** init会在资源加载完毕并且建立引用之后调用 */
		protected override function init():void
		{
			//会滚动的表格
			tableScroll = new JISScrollTable();
			_ScrollTable.addChild(tableScroll);
			tableScroll.getTable().setCellInstanceClass(JISTableTestCell);
			tableScroll.getTable().setPreferredWidth(100);
			tableScroll.getTable().setPreferredCellWidth(48);
			tableScroll.getTable().setPreferredCellHeight(35);
			var cellList:Array = [];
			for(;btnIndex<100;btnIndex++) cellList.push(btnIndex);
			tableScroll.width = 100;
			tableScroll.height = 200;
			tableScroll.getTable().setCellDatas(cellList,this.getSourceSwf());
			
			_TopBtn.addEventListener(JISButton.BOTTON_CLICK,onTopBtnHandler);
			_TopPageBtn.addEventListener(JISButton.BOTTON_CLICK,onTopPageBtnHandler);
			_BottomBtn.addEventListener(JISButton.BOTTON_CLICK,onBottomBtnHandler);
			_BottomPageBtn.addEventListener(JISButton.BOTTON_CLICK,onBottomPageBtnHandler);
			_AddTableCellBtn.addEventListener(JISButton.BOTTON_CLICK,onBtnClickHandler);
		}
		
		private function onBtnClickHandler(e:Event):void
		{
			tableScroll.getTable().addCellData(btnIndex++,this.getSourceSwf());
			tableScroll.toBottom();
		}
		
		private function onTopBtnHandler(e:Event):void
		{
			tableScroll.toTop();
		}
		
		private function onBottomBtnHandler(e:Event):void
		{
			tableScroll.toBottom();
		}
		
		private function onTopPageBtnHandler(e:Event):void
		{
			if(currPage <= 0) return;
			currPage--;
			tableScroll.toPage(currPage);
		}
		
		private function onBottomPageBtnHandler(e:Event):void
		{
			currPage++;
			tableScroll.toPage(currPage);
		}
	}
}