package jis.ui.component
{
	
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * 菜单Tips
	 * @author jiessie 2014-1-3
	 */
	public class JISMenuTips extends JISUIWindow
	{
		public var _Back:DisplayObject;
		public var _Info:Sprite;
		
		private var table:JISTable;
		private var selectHandler:Function;
		private var datas:Array;
		
		public function JISMenuTips(swfHrefName:String, assetGetName:String,menuTableCellClass:Class = null,scale:Number = 1)
		{
			super(swfHrefName, assetGetName);
			table = new JISTable();
			table.setCellInstanceClass(menuTableCellClass == null ? JISTextTableCell:menuTableCellClass);
			table.setIsRow(false);
			table.addEventListener(JISTable.TABBED_SELECTED,onTableSelectHandler);
			this.scaleX = this.scaleY = scale;
		}
		
		protected override function init():void
		{
			if(_Info) _Info.addChild(table);
			else (this.display as DisplayObjectContainer).addChild(table);
			showForDatas(datas,selectHandler);
		}
		
		/**
		 * @param datas 数据源，你可以在选中的时候JISITableCell#getValue()的方式获得该列表的值
		 * @param selectHandler 选中回调，会传入一个JISITableCell
		 * @param stageX menu出现的位置，如果是-1的话将会自动检索当前鼠标位置
		 * @param stageY meny出现的位置，如果是-1的话将会自动检索当前鼠标位置
		 */
		public function showForDatas(datas:Array,selectHandler:Function,stageX:int = -1,stageY:int = -1):void
		{
			this.datas = datas;
			this.selectHandler = selectHandler;
			if(!this.hasLoadOK()) return;
			
			table.setCellDatas(datas,this.getSourceSwf(),true,true);
			_Back.width = table.width;
			_Back.height = table.height;
			
			if(stageX < 0) stageX = Starling.current.nativeStage.mouseX;
			if(stageY < 0) stageY = Starling.current.nativeStage.mouseY;
			
			stageX *= this.scaleX;
			stageY *= this.scaleY;
			
			if(stageX+_Back.width > Starling.current.nativeStage.fullScreenWidth) stageX -= _Back.width;
			if(stageY+_Back.height > Starling.current.nativeStage.fullScreenHeight) stageY -= _Back.height;
			
			this.x = stageX/this.scaleX;
			this.y = stageY/this.scaleX;
			
			show();
			Starling.current.root.addEventListener(TouchEvent.TOUCH,touchStageHandler);
		}
		
		private function touchStageHandler(e:TouchEvent):void
		{
			if(e.getTouch(Starling.current.root,TouchPhase.BEGAN) != null 
				&& e.getTouch(this,TouchPhase.BEGAN) == null)
			{
				close();
			}
		}
		
		public override function close(e:*=null):void
		{
			Starling.current.root.removeEventListener(TouchEvent.TOUCH,touchStageHandler);
			super.close();
		}
		
		private function onTableSelectHandler(e:Event):void
		{
			close();
			if(this.selectHandler != null)
			{
				this.selectHandler.call(null,table.getSelected());
			}
		}
		
		public override function dispose():void
		{
			table.removeFromParent(true);
			table = null;
			selectHandler = null;
			datas = null;
			super.dispose();
		}
	}
}