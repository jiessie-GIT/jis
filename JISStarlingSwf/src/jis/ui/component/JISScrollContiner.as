package jis.ui.component
{
	import flash.geom.Rectangle;
	
	import lzm.starling.display.ScrollContainer;
	import lzm.util.CollisionUtils;
	
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * 滚动容器
	 * @author jiessie 2014-7-11
	 */
	public class JISScrollContiner extends ScrollContainer
	{
		/** 水平滚动 */
		public static const SCROLL_HORIZONTAL:String = "horizontal";
		/** 垂直滚动 */
		public static const SCROLL_VERTICAL:String = "vertical";
		/** 自动检测滚动方向，方式：比较垂直与水平哪个超出的范围多 */
		public static const SCROLL_AUTO:String = "auto";
		
		/** 滚动方式，正常滚动方式 */
		public static const SCROLL_ROLL_NORMAL:String = "normal";
		/** 滚动方式，每次滚动都为翻页滚动 */
		public static const SCROLL_ROLL_PAGE:String = "page";
		/** 滚动方式，每次滚动都为停靠在当前单条中 */
		public static const SCROLL_ROLL_ITEM:String = "item";
		
		private var initScrollType:String;
		private var scrollType:String;
		private var scrollState:String;
		private var displayList:Array;
		
		public function JISScrollContiner(scrollType:String = SCROLL_AUTO,scrollState:String = SCROLL_ROLL_NORMAL)
		{
			super();
			this.initScrollType = scrollType;
			this.scrollState = scrollState;
			addEventListener(TouchEvent.TOUCH,onTouchHandler);
		}
		private function onTouchHandler(e:TouchEvent):void{
			var touch:Touch = e.getTouch(this);
			if(touch)
			{
				if(touch.phase == TouchPhase.ENDED){
					if(scrollState == SCROLL_ROLL_PAGE) toPageForCurr();
					else if(scrollState == SCROLL_ROLL_ITEM){
						var display:DisplayObject = getContainer().getChildAt(getCurrItemIndex());
						if(this.scrollType == SCROLL_HORIZONTAL){
							scrollToPosition(display.x,verticalScrollPosition,0.5);
						}else{
							scrollToPosition(horizontalScrollPosition,display.y,0.5);
						}
					}
				}
			}
		}
		
		public function initDisplayList():void{
			displayList = [];
			var container:DisplayObjectContainer = getContainer();
			container.sortChildren(onDisplaySortHandler);
			for(var index:int = 0;index < container.numChildren;index++){
				displayList.push(container.getChildAt(index));
			}
		}
		
		public override function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			var result:DisplayObject = super.addChildAt(child,index);
			updateScrollType();
			initDisplayList();
			return result;
		}
		
		/**
		 * 更新显示的对象
		 * */
		public override function updateShowItems():void{
			_viewPort2.x = _horizontalScrollPosition;
			_viewPort2.y = _verticalScrollPosition;
			_viewPort2.width = width;
			_viewPort2.height = height;
			
			var itemViewPort:Rectangle = new Rectangle();
			
			if(displayList == null) initDisplayList();
			
			var container:DisplayObjectContainer = getContainer();
			for(var index:int = 0;index < displayList.length;index++){
				var display:DisplayObject = displayList[index];
				itemViewPort.x = display.x;
				itemViewPort.y = display.y;
				itemViewPort.width = display.width;
				itemViewPort.height = display.height;
				
				if(CollisionUtils.isIntersectingRect(_viewPort2,itemViewPort))
				{
					if(display.parent == null)
					{
						container.addChild(display);
					}
				}else
				{
					//第一个与最后一个不会移除
					if(index > 0 && index < displayList.length-1)
					{
						container.removeQuickChild(display);
					}
				}
			}
		}
		
		/** 获取滚动容器真实显示列表 */
		private function getContainer():DisplayObjectContainer{
			var container:DisplayObjectContainer = this;
			while(true){
				if(container.numChildren == 1 && container.getChildAt(0) is DisplayObjectContainer){
					container = container.getChildAt(0) as DisplayObjectContainer;
				}else {
					break;
				}
			}
			return container;
		}
		
		/** 根据滚动方向刷新显示列表排列顺序，该顺序影响单个停靠模式 */
		public function updateScrollType():void {
			if(this.initScrollType == SCROLL_AUTO)
			{
				this.scrollType = maxVerticalScrollPosition - this.height > maxHorizontalScrollPosition - this.width ? SCROLL_VERTICAL:SCROLL_HORIZONTAL;
			}else{
				this.scrollType = this.initScrollType;
			}
			getContainer().sortChildren(onDisplaySortHandler);
		}
		
		/** 第二个是否应该在第一个前面，第一个依旧在前<=0，第二个在前，>0 */
		private function onDisplaySortHandler(dis1:DisplayObject,dis2:DisplayObject):int{
			if(this.scrollType == SCROLL_HORIZONTAL) return 	dis1.x - dis2.x;
			else return dis1.y - dis2.y;
		}
		
		/** 到第一页 */
		public function toPageForFirst():void { toPageForAuto(0); }
		/** 到最后一页 */
		public function toPageForBottom():void{
			if(this.scrollType == SCROLL_HORIZONTAL){
				toPageForHorizontal(Math.ceil(maxHorizontalScrollPosition/this.width));
			}else{
				toPageForVertical(Math.ceil(maxVerticalScrollPosition/this.height));
			}
		}
		
		/** 到上一页 */
		public function toPageForTop():void { toPageForCurr(-1); }
		/** 到下一页 */
		public function toPageForNext():void{ toPageForCurr(1); }
		/** 到当前页 */
		public function toPageForCurr(page:int = 0):void{
			if(this.scrollType == SCROLL_HORIZONTAL){
				toPageForHorizontal(Math.round(horizontalScrollPosition/this.width)+page);
			}else{
				toPageForVertical(Math.round(verticalScrollPosition/this.height)+page);
			}
		}
		
		/** 根据自动识别模式进行翻页,0为第一页 */
		public function toPageForAuto(page:int,time:Number = 1):void{
			if(this.scrollType == SCROLL_HORIZONTAL) toPageForHorizontal(page,time);
			else toPageForVertical(page,time);
		}
		
		/** 水平翻页,0为第一页 */
		public function toPageForHorizontal(page:int,time:Number = 1):void{
			var target:int = Math.max(0,Math.min(page*this.width,maxHorizontalScrollPosition));
			scrollToPosition(target,verticalScrollPosition,time);
		}
		
		/** 垂直翻页,0为第一页 */
		public function toPageForVertical(page:int,time:Number = 1):void{
			var target:int = Math.max(0,Math.min(page*this.height,maxVerticalScrollPosition));
			scrollToPosition(horizontalScrollPosition,target,time);
		}
		
		/** 获得当前应该停靠的Display */
		private function getCurrItemIndex():int
		{
			if(_horizontalScrollPosition < 0 || _verticalScrollPosition < 0) return 0;
			if(_horizontalScrollPosition > _maxHorizontalScrollPosition || _verticalScrollPosition > _maxVerticalScrollPosition) return 1;
			var index:int = 0;
			var container:DisplayObjectContainer = getContainer();
			container.sortChildren(onDisplaySortHandler);
			var display:DisplayObject = container.getChildAt(index);
			_viewPort2.x = display.x;
			_viewPort2.y = display.y;
			_viewPort2.width = display.width;
			_viewPort2.height = display.height;
			if(_viewPort2.contains(_horizontalScrollPosition,_verticalScrollPosition)){
				return 0;
			}else 
			{
				return 1;
			}
			return index;
		}
	}
}