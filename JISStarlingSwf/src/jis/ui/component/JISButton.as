package jis.ui.component
{
	import flash.text.TextField;
	
	import jis.ui.JISUIMovieClipManager;
	import jis.util.JISEventUtil;
	
	import lzm.starling.swf.display.SwfMovieClip;
	
	import starling.events.Event;
	import starling.events.TouchPhase;
	
	/**
	 * 按钮，实际上就是包装了一个SwfMovieClip，每帧代表的含义参考静态DEFULT、GLIDE、CLICK、SELECTED、ENABLE所代表的帧数
	 * @author jiessie 2013-11-19
	 */
	public class JISButton extends JISUIMovieClipManager
	{
		/** 按钮点击时间 */
		public static const BUTTON_CLICK:String = "click";
		
		/** 默认状态 */
		public static const DEFULT:int = 1;
		/** 鼠标划过 */
		public static const GLIDE:int = 2;
		/** 鼠标按下 */
		public static const CLICK:int = 3;
		/** 选中状态 */
		public static const SELECTED:int = 4;
		/** 不可用状态 */
		public static const ENABLE:int = 5;
		public var _Text:TextField;
		/** 当前状态 */
		private var state:int = DEFULT;
		private var lock:Boolean = false;
		
		private var isDown:Boolean = false;
		
		public function JISButton(movie:SwfMovieClip = null)
		{
			super();
			if(movie) setCurrDisplay(movie);
		}
		
		protected override function init():void
		{
			setState(DEFULT);
			JISEventUtil.addDisplayMouseEventHandler(display,onMouseHandler,TouchPhase.BEGAN,TouchPhase.ENDED);
		}
		
		private function onMouseHandler(type:String):void
		{
			if(type == TouchPhase.BEGAN)
			{
				setState(CLICK);
				isDown = true;
			}else
			{
				setState(DEFULT);
				if(isDown) this.dispatchEvent(new Event(BUTTON_CLICK));
				isDown = false;
			}
		}
		
		/** 设置显示文本 */
		public function setText(text:String):void
		{
			if(this._Text) this._Text.text =text;
		}
		
		/** 是否启用按钮 */
		public function setEnable(value:Boolean,hasUpdateBtn:Boolean = true):void
		{
			if(hasUpdateBtn)
			{
				setState(value ? DEFULT:ENABLE,true);
			}
			if(value)
			{
				JISEventUtil.addDisplayMouseEventHandler(display,onMouseHandler,TouchPhase.BEGAN,TouchPhase.ENDED);
			}else
			{
				JISEventUtil.removeDisplayClickEventHandler(display);
			}
		}
		
		/** 设置选中状态，如果为选中状态的时候，点击与切换将不会改变按钮状态 */
		public function setSelected(selected:Boolean):void
		{
			setState(selected ? SELECTED:DEFULT,true);
		}	
		
		/** 
		 * 设置按钮状态，参考LButton静态成员，如果当前为选中状态的话，将不会切换 
		 * @param state 状态
		 * @param hasCoerce 是否强制切换，如果为true，将会忽略选中状态，否则如果为选中状态将会不执行
		 */
		public function setState(state:int,hasCoerce:Boolean = false):void
		{
			if(!lock)
			{
				//不忽略选中状态的话，将会
				if((this.state == SELECTED || this.state == ENABLE) && !hasCoerce)
				{
					return;
				}
				
				if(this.movie) this.movie.gotoAndStop(Math.min(state-1,this.movie.totalFrames-1));
				this.state = state;
			}
		}
		
		/** 设置锁定状态 */
		public function setLockState(state:int,lock:Boolean):void
		{
			if(!this.lock || lock)
			{
				if(this.movie) this.movie.gotoAndStop(state);
				this.state = state;
			}
			this.lock = lock;
		}
		
		/** 获取按钮当前状态 */
		public function getState():int
		{
			return this.state;
		}
		
		/** 是否选中状态 */
		public function isSelected():Boolean { return this.state == SELECTED; }
		
		public override function dispose():void
		{
			JISEventUtil.removeDisplayClickEventHandler(display);
			_Text = null;
			super.dispose();
		}
	}
}