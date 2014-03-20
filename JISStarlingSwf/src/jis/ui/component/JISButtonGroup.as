package jis.ui.component
{
	import jis.ui.JISUIManager;
	
	import lzm.starling.swf.display.SwfMovieClip;
	
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	
	/**
	 * JISButton集合管理，该集合管理的按钮同一时间只能选择一个<br>
	 * 用法：初始化传入JISButton集合或者是通过setBtnList设置集合<br>
	 * 当设置集合或者是选中按钮的时候会抛出CLICK_BTN事件和调用selectHandler函数
	 * @author jiessie 2013-11-20
	 */
	public class JISButtonGroup extends JISUIManager
	{
		/** 单选模式 */
		public static const STAGE_RADIO:String = "radio";
		/** 多选模式 */
		public static const STAGE_MULTI:String = "multi";
		/** 普通模式 */
		public static const STAGE_NORMAL:String = "normal";
		
		/** 点击了管理列表中的按钮 */
		public static const CLICK_BTN:String = "CLICK_BTN";
		
		private var btnList:Array = [];
		//当前选择按钮
		private var currSelectBtn:JISButton;
		/** 选中回调函数 */
		private var selectHandler:Function;
		
		private var state:String = STAGE_RADIO;
		
		private var createBtnClass:Class;
		
		public function JISButtonGroup(list:Array = null,btnClass:Class = null)
		{
			createBtnClass = btnClass;
			if(list)
			{
				setBtnList(list);
			}
		}
		
		protected override function init():void
		{
			var container:DisplayObjectContainer = this.display as DisplayObjectContainer;
			var btnList:Array = [];
			//所有movieClip中的成员都做为按钮进行管理
			for(var i:int = 0;i<container.numChildren;i++)
			{
				var btn:JISButton = createBtn(container.getChildAt(i));
				if(btn) btnList.push(btn);
			}
			setBtnList(btnList);
		}
		
		protected function createBtn(display:DisplayObject):JISButton
		{
			var result:JISButton;
			if(createBtnClass) result = new createBtnClass();
			else result = new JISButton();
			if(!result.checkHasButton(display)) return null;
			result.setCurrDisplay(display);
			return result;
		}
		
		/** 设置按钮列表，按钮必须是LButton或者他的子类 */
		public function setBtnList(list:*):void
		{
			if(this.btnList)
			{
				for each(var oldBtn:JISButton in this.btnList)
				{
					oldBtn.removeEventListener(JISButton.BUTTON_CLICK,onBtnClickHandler);
				}
			}
			
			this.btnList = [];
			
			for each(var btn:JISButton in list)
			{
				btn.addEventListener(JISButton.BUTTON_CLICK,onBtnClickHandler);
				this.btnList.push(btn);
			}
			setSelectBtn(btnList[0])
		}
		
		/** 在原来的基础上追加按钮列表 */
		public function incBtnList(list:Array):void
		{
			for each(var btn:JISButton in list)
			{
				btn.addEventListener(JISButton.BUTTON_CLICK,onBtnClickHandler);
				this.btnList.push(btn);
			}
		}
		
		private function onBtnClickHandler(e:Event):void
		{
			setSelectBtn(e.currentTarget as JISButton);
		}
		
		/** 获取当前选中按钮 */
		public function getCurrentSelectBtn():JISButton
		{
			return this.currSelectBtn;
		}
		
		/** 设置选中按钮回调函数，在选中按钮的时候将会调用该函数，并传入选中的按钮 */
		public function setSelectBtnHandler(handler:Function):void
		{
			selectHandler = handler;
		}
		
//		/** 会与列表中的显示对象的name进行比较 */
//		public function setSelectBtnForName(name:String):void
//		{
//			for each(var btn:JISButton in this.btnList)
//			{
//				if(btn.getMovieChlip().name == name)
//				{
//					setSelectBtn(btn);
//					return;
//				}
//			}
//		}
		
		/** 设置选中按钮 */
		public function setSelectBtn(btn:JISButton):void
		{
			if(isRadio() && currSelectBtn == btn) return;
			if(isRadio() && currSelectBtn)
			{
				currSelectBtn.setSelected(false);
			}
			currSelectBtn = btn;
			//单选
			if(isRadio()) currSelectBtn.setSelected(true);
			//复选
			else if(isMulti()) currSelectBtn.setSelected(!currSelectBtn.isSelected());
			
			this.dispatchEvent(new Event(CLICK_BTN));
			if(selectHandler != null)
			{
				selectHandler.call(null,currSelectBtn);
			}
		}
		
		public override function dispose():void
		{
			for each(var oldBtn:JISButton in this.btnList)
			{
				oldBtn.removeEventListener(JISButton.BUTTON_CLICK,onBtnClickHandler);
			}
			btnList = null;
			currSelectBtn = null;
			selectHandler = null;
			super.dispose();
		}
		/** 是否单选模式 */
		public function isRadio():Boolean { return this.state == STAGE_RADIO; }
		/** 是否多选模式 */
		public function isMulti():Boolean { return this.state == STAGE_MULTI; }
		/** 是否普通模式 */
		public function isNormal():Boolean { return this.state == STAGE_NORMAL; }
		/** 设置按钮组模式，参考JISButtonGroup静态参数 */
		public function setState(state:String):void { this.state = state; }
		/** 根据名字获取JISButton */
		public function getButtonForDisplayName(name:String):JISButton
		{
			for each(var btn:JISButton in btnList)
			{
				if(btn.getDisplay().name == name) return btn;
			}
			return null;
		}
		
		/** 获得选择的按钮列表，如果是单选模式返回为当前选中，如果是复选则返回选中列表，普通模式返回null */
		public function getSelectBtnList():Array
		{
			if(isMulti())
			{
				var result:Array = [];
				for each(var btn:JISButton in btnList)
				{
					if(btn.isSelected()) result.push(btn);
				}
				return result;
			}else if(isRadio()) return [currSelectBtn];
			else return null;
		}
	}
}