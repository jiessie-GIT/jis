package jis.ui.component
{
	import jis.ui.JISUIManager;
	
	import starling.animation.Tween;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.extensions.pixelmask.PixelMaskDisplayObject;
	import starling.textures.Texture;
	import starling.core.Starling;
	
	
	/**
	 * 滚动文本，参考系统公告消息
	 * @author jiessie 2014-4-3
	 */
	public class JISRollFlashTextManager extends JISUIManager
	{
		public var _Text:JISFlashTextSpriteManager;
		public var _Back:DisplayObject;
		
		private var maskedDisplayObject:PixelMaskDisplayObject;
		private var maskImage:Image;
		
		private var rollMessages:Array = [];
		private var currRollIndex:int = -1;
		private var moveTween:Tween;
		
		public function JISRollFlashTextManager()
		{
			_Text = new JISFlashTextSpriteManager();
			super();
		}
		
		protected override function init():void
		{
			this.display.touchable = false;
			
			_Text.getTextField().multiline = false;
			_Text.getTextField().wordWrap = false;
			
			maskImage = new Image(Texture.fromColor(this._Text.getTextField().width,this._Text.getTextField().height));
			maskedDisplayObject = new PixelMaskDisplayObject();
			maskedDisplayObject.x = this._Text.getDisplay().x;
			maskedDisplayObject.y = this._Text.getDisplay().y;
			maskedDisplayObject.mask = maskImage;
			this._Text.getDisplay().x = 0;
			this._Text.getDisplay().y = 0;
			maskedDisplayObject.addChild(this._Text.getDisplay());
			_Text.getTextField().width = 0;
			(this.display as DisplayObjectContainer).addChild(maskedDisplayObject);
			
			endRoll();
		}
		
		/** 添加一个滚动文本 */
		public function incRollText(text:String,hasNowPlay:Boolean = false):void
		{
			rollMessages.push(text);
			if(hasNowPlay)
			{
				currRollIndex = rollMessages.length-2;
				nextRollText();
			}else if(rollMessages.length == 1)
			{
				currRollIndex = -1;
				nextRollText();
			}
		}
		
		public function removeRollText(text:String):void
		{
			var index:int = rollMessages.indexOf(text);
			if(index >= 0)
			{
				rollMessages.splice(index,1);
				if(index == currRollIndex)
				{
					currRollIndex = -1;
					nextRollText();
				}
			}
		}
		
		private function nextRollText():void
		{
			if(moveTween)
			{
				Starling.juggler.remove(moveTween);
				moveTween = null;
			}
			if(rollMessages.length <= 0)
			{
				endRoll();
				return;
			}
			if(currRollIndex < 0 || currRollIndex >= rollMessages.length-1)
			{
				currRollIndex = 0;
			}else
			{
				currRollIndex++;
			}
			this.display.visible = true;
			var message:String = rollMessages[currRollIndex];
			_Text.htmlText = message;
			_Text.getDisplay().x = maskImage.width;
			moveTween = new Tween(_Text.getDisplay(),(maskImage.width+_Text.getDisplay().width)/50);
			moveTween.moveTo(0-_Text.getDisplay().width,_Text.getDisplay().y);
			moveTween.onComplete = nextRollText;
			Starling.juggler.add(moveTween);
		}
		
		private function endRoll():void
		{
			currRollIndex = -1;
			this.display.visible = false;
		}
		
		public override function dispose():void
		{
			if(moveTween)
			{
				Starling.juggler.remove(moveTween);
				moveTween = null;
			}
			super.dispose();
		}
	}
}