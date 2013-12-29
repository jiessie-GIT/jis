package jis.ui.component
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	import jis.ui.JISUIManager;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.extensions.pixelmask.PixelMaskDisplayObject;

	/**
	 * 冷却遮罩
	 * @author jiessie 2013-12-29
	 */
	public class JISMaskIntervalUIManager extends JISUIManager
	{
		/** 从上到下 */
		public static const STATE_TOP_BOTTOM:String = "STATE_TOP_BOTTOM";
		/** 从下到上 */
		public static const STATE_BOTTOM_TOP:String = "STATE_BOTTOM_TOP";
		/** 从左到右 */
		public static const STATE_LEFT_RIGHT:String = "STATE_LEFT_RIGHT";
		/** 从右到左 */
		public static const STATE_RIGHT_LEFT:String = "STATE_RIGHT_LEFT";
		
		private var _completeFunction:Function;
		private var maskedDisplayObject:PixelMaskDisplayObject;
		private var maskImage:Image;
		
		private var height:int;
		private var width:int;
		
		private var _state:String = STATE_TOP_BOTTOM;
		private var _transition:String = Transitions.LINEAR;
		
		public function JISMaskIntervalUIManager()
		{
			super();
		}
		
		protected override function init():void
		{
			var sprite:Sprite = new Sprite();
			sprite.graphics.beginFill(0x00);
			sprite.graphics.drawRect(0,0,this.display.width,this.display.height);
			sprite.graphics.endFill();
			var bitmap:BitmapData = new BitmapData(this.display.width,this.display.height,true,0x00);
			bitmap.draw(sprite,null,null,null,null,true);
			maskImage = Image.fromBitmap(new Bitmap(bitmap));
			
			height = this.display.height;
			width = this.display.width;
			
			maskedDisplayObject = new PixelMaskDisplayObject();
			maskedDisplayObject.x = this.display.x;
			maskedDisplayObject.y = this.display.y;
			this.display.x = 0;
			this.display.y = 0;
			this.display.parent.addChild(maskedDisplayObject);
			this.display.removeFromParent();
			maskedDisplayObject.mask = maskImage;
			maskedDisplayObject.addChild(this.display);
			
			maskedDisplayObject.visible = false;
		}
		
		/** 冷却时间，毫秒 */
		public function setIntervalTime(millisecond:Number):void
		{
			maskImage.y = 0;
			maskImage.x = 0;
			maskImage.height = height;
			maskedDisplayObject.visible = true;
			if(_state == STATE_TOP_BOTTOM || _state == STATE_BOTTOM_TOP)
			{
				Starling.juggler.tween(maskImage,millisecond/1000.0,{"height":0,"onComplete":maskEndHandler,"transition":_transition});
				if(_state == STATE_TOP_BOTTOM)
				{
					Starling.juggler.tween(maskImage,millisecond/1000.0,{"y":height,"transition":_transition});
				}
			}else
			{
				Starling.juggler.tween(maskImage,millisecond/1000.0,{"width":0,"onComplete":maskEndHandler,"transition":_transition});
				if(_state == STATE_RIGHT_LEFT)
				{
					Starling.juggler.tween(maskImage,millisecond/1000.0,{"x":width,"transition":_transition});
				}
			}
		}
		
		private function maskEndHandler():void
		{
			maskedDisplayObject.visible = false;
			if(_completeFunction) _completeFunction.call();
		}

		public function set completeFunction(value:Function):void
		{
			_completeFunction = value;
		}

		/** 设置遮罩状态，参考JISMaskIntervalUIManager静态参数 */
		public function set state(value:String):void
		{
			_state = value;
		}

		/** 设置Tween方式，参考Transitions，默认为：Transitions.LINEAR */
		public function set transition(value:String):void
		{
			_transition = value;
		}


	}
}