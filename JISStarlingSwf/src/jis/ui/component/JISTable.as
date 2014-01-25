package jis.ui.component
{
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import feathers.events.FeathersEventType;
	
	import jis.util.JISEventUtil;
	
	import lzm.starling.display.ScrollContainerItem;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	
	/**
	 * 表格
	 * @author jiessie 2013-11-20
	 */
	public class JISTable extends ScrollContainerItem
	{
		/** 表格中单元格点击事件 */
		public static const TABBED_SELECTED:String = "TABBED_SELECTED";
		/** 单元格列表 */
		private var tabbedCellList:Array = [];
		
		/** 是否横排显示，横排：数据将以从左到右的方式进行排列，竖排：讲义从上到下的方式进行排列 */
		private var isRow:Boolean = true;
		/** 每一行之间的空隙，即为换行的空隙 */
		private var rowSpace:Number = 0;
		/** 每一列之间的空隙，即为换列的空隙 */
		private var colSpace:Number = 0;
		/** 如果指定了该值，那么单元格将会忽略显示对象实际大小 */
		private var cellPreferredWidth:Number = 0;
		/** 如果指定了该值，那么单元格将会忽略显示对象实际大小 */
		private var cellPreferredHeight:Number = 0;
		/** 如果指定了该值，表格将会忽略实际内容大小，进行换行 */
		private var preferredWidth:Number = 0;
		/** 如果指定了该值，表格将会忽略实际内容大小，进行换列 */
		private var preferredHeight:Number = 0;
		/** 当前选中的单元格 */
		private var currSelect:JISITableCell;
		/** 是否允许重复选中，如果不是，则选中相同的一个的话相当于取消选中 */
		private var allowRepeatSelect:Boolean = true;
		/** 选中回调 */
		private var _selectHandler:Function;
		
		/**
		 * @param tabbedCellList 初始化格子列表，列表中的项需要实现JISITableCell接口或者是DisplayObject的子类
		 * @param hasClickListener 是否会触发点击事件
		 */
		public function JISTable(tabbedCellList:Array = null,hasClickListener:Boolean = true)
		{
			super();
			if(tabbedCellList)
			{
				setTabbedCellList(tabbedCellList);
			}
			if(hasClickListener)
			{
				this.addEventListener(TouchEvent.TOUCH,onTouchHandler);
			}
		}
		
		private function onTouchHandler(e:TouchEvent):void
		{
			//滑动中
			if(scrollContainer && scrollContainer.scrolling) return;
			var touch:Touch = e.getTouch(this,TouchPhase.ENDED);
			if(touch)
			{
				if(touch.phase == TouchPhase.ENDED)
				{
					for each(var tabbedCell:JISITableCell in tabbedCellList)
					{
						if(tabbedCell is JISITableMultiCell)
						{
							for each(var cellClid:JISITableCell in (tabbedCell as JISITableMultiCell).getCells())
							{
								var cellClidTouch:Touch = e.getTouch(cellClid.getDisplay(),TouchPhase.ENDED);
								if(cellClidTouch)
								{
									(tabbedCell as JISITableMultiCell).setSelectCell(cellClid);
									break;
								}
							}
						}
						var cellTouch:Touch = e.getTouch(tabbedCell.getDisplay(),TouchPhase.ENDED);
						if(cellTouch)
						{
							setSelected(tabbedCell);
							return;
						}
					}
				}
			}
		}
//		
//		
//		//点击选中事件
//		protected function onMouseClickHandler(e:* = null):void
//		{
//			for each(var tabbedCell:JISITableCell in tabbedCellList)
//			{
//				var display:DisplayObject = tabbedCell.getDisplay();
//				if(display.mouseX > 0 && display.mouseX <= getDisplayWidth(display) && display.mouseY > 0 && display.mouseY < getDisplayHeight(display))
//				{
//					setSelected(tabbedCell);
//					return;
//				}
//			}
//		}
		
		/** 获取当前选中项 */
		public function getSelected():JISITableCell
		{
			return this.currSelect;
		}
		
		/** 
		 * 设置显示列表，列表中可以是显示对象，也可以是实现了ITabbedCell的对象，其他则不<br>
		 * @param flag 是否设置默认选中选项  false 设置默认选中数组下标为0  true 不设置
		 */
		public function setTabbedCellList(list:Array , flag:Boolean = false):void
		{
			if(tabbedCellList)
			{
				for each(var tabbedCell1:* in tabbedCellList)
				{
					if(tabbedCell1 is JISITableCell)
					{
						if(tabbedCell1.getDisplay()) tabbedCell1.getDisplay().removeFromParent();
						tabbedCell1.dispose();
					}
				}
			}
			
			tabbedCellList = list;
			if(tabbedCellList == null) return;
			for each(var tabbedCell:* in tabbedCellList)
			{
				if(tabbedCell is JISITableCell)
				{
					this.addChild(tabbedCell.getDisplay());
				}else if(tabbedCell is DisplayObject)
				{
					this.addChild(tabbedCell);
				}
			}
			if(!flag && tabbedCellList.length > 0)
			{
				//设置默认选中
				setSelected(tabbedCellList[0]);
			}
			//更新坐标
			updateTabbdeCellLocation();
			
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		/** 设置当前选中项 */
		public function setSelected(tabbedCell:*):void
		{
			if(tabbedCell == currSelect && !allowRepeatSelect)
			{
				//不允许重复选中
				currSelect.selected();
				currSelect = null;
				return;
			}
			if(tabbedCell is JISITableCell)
			{
				if(currSelect && tabbedCellList.indexOf(currSelect) >= 0)
				{
					currSelect.selected();
				}
			}
			currSelect = tabbedCell;
			if(currSelect)
			{
				currSelect.selected(true);
			}
			if(_selectHandler) _selectHandler.call(null,currSelect);
			this.dispatchEvent(new Event(TABBED_SELECTED));
		}
		/**
		 * 更新列表中的显示对象的坐标
		 */ 
		public function updateTabbdeCellLocation():void
		{
			if(!tabbedCellList)
			{
				return;
			}
			var currY:Number = 0;//当前行的坐标
			var currX:Number = 0;//当前列的坐标
			var currWidth:Number = 0;//当前行内容的宽度
			var currHeight:Number = 0;//当前列内容的高度
			var currIndex:int = 0;//当前行或列已添加显示对象的数量
			
			for(var i:int=0;i<tabbedCellList.length;i++)
			{
				var display:DisplayObject = tabbedCellList[i] is JISITableCell ? tabbedCellList[i].getDisplay():tabbedCellList[i];
				if(isRow)
				{
					//横向排列
					var newColSpace:int = currIndex*colSpace;
					display.y = currY;
					display.x = currWidth;//currIndex*getDisplayWidth(display)+newColSpace;
					currWidth += getDisplayWidth(display)+colSpace;
				}else
				{
					//竖向排列
					var newRowSpace:int = currIndex*rowSpace;
					display.x = currX;
					display.y = currHeight;//currIndex*getDisplayHeight(display)+newRowSpace;
					currHeight += getDisplayHeight(display)+rowSpace;
				}
				currIndex++;
				//不是最后一个
				if(i <= tabbedCellList.length-2)
				{
					var nextDisplay:DisplayObject = tabbedCellList[i+1] is JISITableCell ? tabbedCellList[i+1].getDisplay():tabbedCellList[i+1];
					//换行显示
					if(isRow && hasNewLine(currWidth+getDisplayWidth(nextDisplay)+rowSpace))
					{
						currY += getDisplayHeight(display)+colSpace;
						currIndex = 0;
						
						currWidth = 0;
					}
					//换列显示
					if(!isRow && hasNewCol(currHeight+getDisplayHeight(nextDisplay)+colSpace))
					{
						currX += getDisplayWidth(display)+rowSpace;
						currIndex = 0;
						currHeight = 0;
					}
				}
				
				
			}
			addToStage(null);
		}
		
		/** 移除指定单元格 */
		public function removeTableCell(tableCell:JISITableCell):void
		{
			removeTableCellForIndex(tabbedCellList.indexOf(tableCell));
		}
		
		/** 移除指定索引 */
		public function removeTableCellForIndex(index:int):void
		{
			if(index < 0 || index >= tabbedCellList.length)
			{
				return;
			}
			var tableCell:* = tabbedCellList[index];
			if(tableCell)
			{
				tabbedCellList.splice(index,1);
				if(tableCell is JISITableCell)
				{
					if((tableCell as JISITableCell).getDisplay()) (tableCell as JISITableCell).getDisplay().removeFromParent();
					(tableCell as JISITableCell).dispose();
				}
				updateTabbdeCellLocation();
				this.dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		/** 添加单元格，可以设置顺序 */
		public function addTableCell(tableCell:*,index:int = -1):void
		{
			if(index >= 0)
			{
				tabbedCellList.splice(index,0,tableCell);
			}else
			{
				tabbedCellList.push(tableCell);
			}
			this.addChild(tableCell is JISITableCell ? tableCell.getDisplay():tableCell);
			updateTabbdeCellLocation();
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		/** 
		 * ==========================================================================================================
		 * ==========================================================================================================
		 * ==========================================================================================================
		 * ==========================================================================================================
		 * =====================================此行之下代码，均为简单逻辑===========================================
		 * ==========================================================================================================
		 * ==========================================================================================================
		 * ==========================================================================================================
		 * ==========================================================================================================
		 */
		/** 获取表格内容 */
		public function getTabbedList():Array
		{
			return this.tabbedCellList;
		}
		
		/** 是否换行 */
		private function hasNewLine(width:Number):Boolean
		{
			return  preferredWidth != 0 ? width>=preferredWidth:false;
		}
		
		/** 是否换列 */
		private function hasNewCol(h:Number):Boolean
		{
			return preferredHeight != 0 ? h>=preferredHeight:false;
		}
		
		/** 设置单元格期望宽度 */
		public function setPreferredCellWidth(w:Number):void
		{
			this.cellPreferredWidth = w;
			updateTabbdeCellLocation();
		}
		/** 设置单元格期望高度 */
		public function setPreferredCellHeight(h:Number):void
		{
			this.cellPreferredHeight = h;
			updateTabbdeCellLocation();
		}
		/** 是否横排显示 */
		public function setIsRow(isRow:Boolean = true):void
		{
			this.isRow = isRow;
			updateTabbdeCellLocation();
		}
		/** 设置单元格行与行之间的间距 */
		public function setRowSpace(rowSpace:Number):void
		{
			this.rowSpace = rowSpace;
			updateTabbdeCellLocation();
		}
		
		/** 设置单元格列与列之间的间距 */
		public function setColSpace(colSpace:Number):void
		{
			this.colSpace = colSpace;
			updateTabbdeCellLocation();
		}
		
		/** 设置表格期望宽度 */
		public function setPreferredWidth(w:Number):void
		{
			this.preferredWidth = w;
			updateTabbdeCellLocation();
		}
		
		/** 设置表格期望高度 */
		public function setPreferredHeight(h:Number):void
		{
			this.preferredHeight = h;
			updateTabbdeCellLocation();
		}
		
		/**获取显示对象的宽度*/
		protected function getDisplayWidth(display:DisplayObject):Number
		{
			return cellPreferredWidth == 0 ? display.width:cellPreferredWidth;
		}
		
		/**获取显示对象的高度*/
		protected function getDisplayHeight(display:DisplayObject):Number
		{
			return cellPreferredHeight == 0 ? display.height:cellPreferredHeight;
		}
		
		/** 销毁 */
		public override function dispose():void
		{
			for each(var tableCell:JISITableCell in tabbedCellList)
			{
				tableCell.getDisplay().removeFromParent();
				tableCell.dispose();
			}
			tabbedCellList = null;
			currSelect = null;
			_selectHandler = null;
			super.dispose();
		}
		
		private var cellInstanceClass:Class;
		private var instanceDataDic:Dictionary = new Dictionary(); 
		
		/** 设置数据类型，后面可以直接设置Model来进行生成显示对象,注意,此处必须实现ITabbleCell */
		public function setCellInstanceClass(clazz:Class):void
		{
			cellInstanceClass = clazz;
		}
		
		/** 
		 * 将数据当成Model的形式，根据setCellInstanceClass设置的类型创建对应的显示对象 
		 * @param datas 数据列表，有多少数据就创建多少个cell
		 * @param createParams 创建cell的参数，会将该参数传递到cell的构造函数中
		 * @param hasCheckOld 是否检查已存在数据源对应的对象，如果存在该数据源对应的cell的话，将不会再去重新创建
		 * @param flag 是否设置默认选中选项  false 设置默认选中数组下标为0  true 不设置
		 */
		public function setCellDatas(datas:*,createParams:* = null,hasCheckOld:Boolean = false , flag:Boolean = false):Array
		{
			if(cellInstanceClass == null)
			{
				return null;
			}
			
			var cellList:Array = [];
			var oldDic:Dictionary = instanceDataDic;
			instanceDataDic = new Dictionary();
			for each(var data:* in datas)
			{
				var cell:JISITableCell = hasCheckOld ? oldDic[data]:null;
				if(cell == null)
				{
					if(createParams != null)
					{
						cell = new cellInstanceClass(createParams);
					}else
					{
						cell = new cellInstanceClass();
					}
					if(cell is JISITableMultiCell && data is Array)
					{
						//将集合数据分散给列表子级
						var i:int = 0;
						for each(var cellClid:JISITableCell in (cell as JISITableMultiCell).getCells())
						{
							cellClid.setValue(data[i++]);
						}
					}
					cell.setValue(data);
				}else
				{
					//如果旧的已存在，则使用旧的,将旧的从已有的删除，放置到新的列表当中。
					tabbedCellList.splice(tabbedCellList.indexOf(cell),1);
				}
				instanceDataDic[data] = cell;
				cellList.push(cell);
			}
			setTabbedCellList(cellList,flag);
			return cellList;
		}
		
		/** 将数据当成Model的形式，根据setCellInstanceClass设置的类型创建对应的显示对象 */
		public function addCellData(data:*,createParams:* = null,flag:Boolean = false):void
		{
			if(cellInstanceClass == null)
			{
				return;
			}
			
			var cell:JISITableCell;
			if(createParams != null)
			{
				cell = new cellInstanceClass(createParams);
			}else
			{
				cell = new cellInstanceClass();
			}
			cell.setValue(data);
			instanceDataDic[data] = cell;
			addTableCell(cell);
			if(!flag && this.tabbedCellList.length == 1)
			{
				setSelected(this.tabbedCellList[0]);
			}
			addToStage(null);
		}
		
		/** 根据Model删除对应的值的内容，该值必须为通过setCellInstanceClass或者是setCellInstanceClass进行设置的，并且中间不可以有更改 */
		public function removeForCellData(data:*,flag:Boolean = false):void
		{
			if(instanceDataDic[data] != null)
			{
				var tabbelCell:JISITableCell = instanceDataDic[data];
				removeTableCell(instanceDataDic[data]);
				delete instanceDataDic[data];
				if(flag) return;
				//如果是当前选择的话，重新选择一个
				if(tabbelCell == getSelected() && this.tabbedCellList.length > 0)
				{
					setSelected(this.tabbedCellList[0]);
				}else
				{
					setSelected(null);
				}
			}
			
		}
		
		/** 选中指定的数据对应的格子 */
		public function setSelectedForData(data:*):void
		{
			setSelected(instanceDataDic[data]);
		}
		
		
		/** 获取单元格期望高度 */
		public function getPreferredCellHeight():int
		{
			return cellPreferredHeight;
		}
		
		/** 获取单元格期望宽度 */
		public function getPreferredCellWidth():int
		{
			return cellPreferredWidth;
		}
		
		public function getTableCellForData(data:*):JISITableCell { return instanceDataDic[data]; }
		public function setTableCellVisableForData(data:*,visable:Boolean):void
		{
			var cell:JISITableCell = getTableCellForData(data);
			if(cell)
			{
				cell.getDisplay().visible = visable;
				updateTabbdeCellLocation();
			}
		}
		
		/** 是否允许重复选中，如果不是，则选中相同的一个的话相当于取消选中 */
		public function setAllowRepeatSelect(value:Boolean):void
		{
			allowRepeatSelect = value;
		}
		
		/** 设置选中回调，会传入选中的JISITableCell */
		public function set selectHandler(value:Function):void
		{
			_selectHandler = value;
		}

	}
}