package
{
	import flash.filesystem.File;
	
	import jis.ui.component.JISButton;
	import jis.ui.component.JISButtonGroup;
	import jis.ui.component.JISCuttingButtonGroup;
	import jis.ui.component.JISDisplayCutting;
	import jis.ui.component.JISMaskIntervalUIManager;
	import jis.ui.component.JISScrollTable;
	import jis.ui.component.JISTweenSwitchCuttingButtonGroup;
	import jis.ui.component.JISUIMultipleProgressManager;
	import jis.ui.component.JISUIWindow;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	
	
	/**
	 * 
	 * @author jiessie 2013-11-27
	 */
	public class JISMainUIWindow extends JISUIWindow
	{
		public var _ProgressTest:JISProgressTestUIManager;//进度条
		public var _RadioBtnList:JISButtonGroup;//按钮列表管理
		public var _MultikBtnList:JISButtonGroup;//按钮列表管理
		public var _NormalBtnList:JISCuttingButtonGroup;//按钮列表管理
		public var _ScrollTable:Sprite;
		public var _MultipleProgress:JISUIMultipleProgressManager;//多条进度条
		public var _TweenSwitchCutting:JISTweenSwitchCuttingButtonGroup;//动态切换
		
		public var _AddTableCellBtn:JISButton = new JISButton();
		public var _TopBtn:JISButton = new JISButton();
		public var _TopPageBtn:JISButton = new JISButton();
		public var _BottomPageBtn:JISButton = new JISButton();
		public var _BottomBtn:JISButton = new JISButton();
		
		public var _MaskIntervalList:JISDisplayCutting;
		
		private var tableScroll:JISScrollTable;
		
		private var btnIndex:int = 0;
		
		private var currPage:int = 0;
		
		public function JISMainUIWindow()
		{
			//自定义管理类需要在setAssetSource之前初始化
			_RadioBtnList = new JISButtonGroup();
			_MultikBtnList = new JISButtonGroup();
			_NormalBtnList = new JISCuttingButtonGroup("_Btn_",JISButton);
			_TweenSwitchCutting = new JISTweenSwitchCuttingButtonGroup();
			
			_RadioBtnList.setState(JISButtonGroup.STAGE_RADIO);
			_MultikBtnList.setState(JISButtonGroup.STAGE_MULTI);
			_NormalBtnList.getButtonGroup().setState(JISButtonGroup.STAGE_NORMAL);
			
			_ProgressTest = new JISProgressTestUIManager();
			_MaskIntervalList = new JISDisplayCutting("_MaskInterval_",JISMaskIntervalUIManager);
			
			_MultipleProgress = new JISUIMultipleProgressManager("_Progress_");
			
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
			for(;btnIndex<15;btnIndex++) cellList.push(btnIndex);
			tableScroll.width = 100;
			tableScroll.height = 200;
			tableScroll.getTable().setCellDatas(cellList,this.getSourceSwf());
			
			_TopBtn.addEventListener(JISButton.BUTTON_CLICK,onTopBtnHandler);
			_TopPageBtn.addEventListener(JISButton.BUTTON_CLICK,onTopPageBtnHandler);
			_BottomBtn.addEventListener(JISButton.BUTTON_CLICK,onBottomBtnHandler);
			_BottomPageBtn.addEventListener(JISButton.BUTTON_CLICK,onBottomPageBtnHandler);
			_AddTableCellBtn.addEventListener(JISButton.BUTTON_CLICK,onBtnClickHandler);
			
			var maskTypes:Array = [JISMaskIntervalUIManager.STATE_RIGHT_LEFT,JISMaskIntervalUIManager.STATE_LEFT_RIGHT,JISMaskIntervalUIManager.STATE_BOTTOM_TOP,JISMaskIntervalUIManager.STATE_TOP_BOTTOM];
			for each(var maskManager:JISMaskIntervalUIManager in _MaskIntervalList.getInstanceArray())
			{
				maskManager.state = maskTypes.shift();
				maskManager.completeFunction = onMaskIntervalCompleteHandler;
				onMaskIntervalCompleteHandler(maskManager);
			}
			
			_MultipleProgress.setMaxProgressNum(15000,3000);
			_MultipleProgress.addEventListener(Event.COMPLETE,onMultiProgressHandler);
			_MultipleProgress.setProgressNum(14000);
			
			_TweenSwitchCutting.setIdentificationForName("_TweenSwitch_4");
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
		
		private function onMaskIntervalCompleteHandler(maskManager:JISMaskIntervalUIManager):void
		{
			maskManager.setIntervalTime(1000);
		}
		
		private var nextIncProgress:int = -1000;
		private function onMultiProgressHandler(e:Event):void
		{
			if(_MultipleProgress.currProgress <= 0)
			{
				nextIncProgress = 1000;
			}else if(_MultipleProgress.currProgress >= 10000)
			{
				nextIncProgress = -1000;
			}
			
			_MultipleProgress.setProgressNum(_MultipleProgress.currProgress + nextIncProgress);
		}
	}
}