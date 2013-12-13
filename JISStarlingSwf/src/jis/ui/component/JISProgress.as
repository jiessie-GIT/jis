package jis.ui.component
{
	import flash.events.ProgressEvent;
	
	import jis.util.JISSpeedProgressUtil;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	
	
	/**
	 * 进度条，该进度条不为UI组件，如果想在UI中使用的话请使用JISUIProgressManager
	 * @author jiessie 2013-11-22
	 */
	public class JISProgress extends Sprite
	{
		private var isManager:Boolean;
		
		private var leftDisplay:DisplayObject;
		private var centerDisplay:DisplayObject;
		private var rightDisplay:DisplayObject;
		private var maxWidth:Number;
		
		private var leftWidth:int;
		
		/** 进度条计算方法，默认为横向计算 */
		private var speedProgressHandler:Function = JISSpeedProgressUtil.rowLeftToRigth;
		
		/**
		 * 进度条分为三部分，前、中、后 
		 * @param isManager 是否管理模式，如果管理模式的话，将不会添加到当前显示对象当中只会当成引用进行操作
		 */
		public function JISProgress(isManager:Boolean = true,leftDisplay:DisplayObject = null,centerDisplay:DisplayObject = null,rightDisplay:DisplayObject = null)
		{
			this.isManager = isManager;
			super();
			setLeftDisplay(leftDisplay);
			setCenterDisplay(centerDisplay);
			setRightDisplay(rightDisplay);
		}
		
		/** 单独设置中间显示部分 */
		public function setCenterDisplay(centerDisplay:DisplayObject):void
		{
			this.centerDisplay = centerDisplay;
			if(!isManager && this.centerDisplay)
			{
				this.addChild(this.centerDisplay);
			}
			
		}
		
		/** 单独设置右边显示部分 */
		public function setRightDisplay(rightDisplay:DisplayObject):void
		{
			this.rightDisplay = rightDisplay;
			if(!isManager && this.rightDisplay)
			{
				this.addChild(this.rightDisplay);
			}
			
		}
		
		/** 单独设置左边显示部分 */
		public function setLeftDisplay(leftDisplay:DisplayObject):void
		{
			this.leftDisplay = leftDisplay;
			if(!isManager && this.leftDisplay)
			{
				leftWidth = this.leftDisplay.width;
				this.addChild(this.leftDisplay);
			}
		}
		
		/** 设置最大宽度，计算进度条长度的时候，最大不会超过该值 */
		public function setMaxWidth(width:Number):void
		{
			maxWidth = width;
		}
		
		/** 获取最大宽度 */
		public function getMaxWidth():Number
		{
			return maxWidth;
		}
		
		/**
		 * 设置进度条长度
		 */ 
		//		public function setCurrWidth(width:int):void
		//		{
		//			width = Math.max(0,Math.min(width,maxWidth));
		//			if(width == 0)
		//			{
		//				if(leftDisplay)
		//				{
		//					leftDisplay.visible = false;
		//				}
		//				centerDisplay.visible = false;
		//				rightDisplay.visible = false;
		//			}else if(leftDisplay && width < leftDisplay.width)
		//			{
		//				leftDisplay.width = width;
		//				centerDisplay.visible = false;
		//				rightDisplay.visible = false;
		//			}else
		//			{
		//				if(leftDisplay)
		//				{
		//					leftDisplay.width = leftWidth;
		//					//					width -= leftWidth;
		//					leftDisplay.visible = true;
		//				}
		//				width -= rightDisplay.width;
		//				this.centerDisplay.width = width;
		//				this.rightDisplay.x = centerDisplay.x+width;
		//				rightDisplay.visible = true;
		//				centerDisplay.visible = true;
		//			}
		//		}
		
		/** 
		 * 设置一个滚动条比例
		 * @param progress 分子
		 * @param maxProgress 分母 
		 */
		public function setCurrWidthForProgress(progress:Number,maxProgress:Number):void
		{
			setCurrWidth((progress/maxProgress)*maxWidth);
		}
		
		/**  设置一个加载事件，将加载事件中的加载进度计算出来 */
		public function setCurrWidthForProgressEvent(e:ProgressEvent):void
		{
			setCurrWidthForProgress(e.bytesLoaded,e.bytesTotal);
		}
		
		
		
		/** 
		 * 设置一个进度条计算方法，该方法参数必须为<br>
		 * (currNum:Number,maxNum:Number,centerDisplay:DisplayObject,leftDisplay:DisplayObject = null,leftNum:Number = 0,rightDisplay:DisplayObject = null):void
		 * @param currNum 当前进度
		 * @oaram maxNum 最大进度
		 * @param centerDisplay 中间的进度条显示对象
		 * @param leftDisplay 左边的进度条显示对象
		 * @param leftNum 左侧的原始大小，因为左侧计算过程中会对其大小进行设置，所以需要原始大小
		 * @param rightDisplay 右侧进度条显示对象
		 */
		public function setSpeedProgressHandler(handler:Function):void
		{
			this.speedProgressHandler = handler;
		}
		
		/**
		 * 设置进度条长度
		 */ 
		public function setCurrWidth(width:int):void
		{
			speedProgressHandler.call(null,width,maxWidth,centerDisplay,leftDisplay,leftWidth,rightDisplay);
		}
		
		public override function dispose():void
		{
			this.leftDisplay = null;
			this.rightDisplay = null;
			this.centerDisplay = null;
			speedProgressHandler = null;
			super.dispose();
		}
	}
}