package jis.ui.component
{
	import starling.animation.DelayedCall;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	/**
	 * 消息队列,队列都是从0,0向上显示
	 * @author jiessie 2014-3-28
	 */
	public class JISMessageQueue extends Sprite
	{
		private var messageManager:JISMessageManager;
		private var messageHerfName:String;
		
		private var vAlign:String;
		private var hAlign:String;
		
		private var maxNum:int;
		private var cellTime:Number;
		private var cellHeight:int;
		
		private var messages:Array = [];
		
		public function JISMessageQueue(messageManager:JISMessageManager,messageHerfName:String,cellHeight:int,cellTime:Number = 1,maxNum:int = 5,vAlign:String = VAlign.TOP,hAlign:String = HAlign.CENTER)
		{
			this.messageManager = messageManager;
			this.messageHerfName = messageHerfName;
			this.maxNum = maxNum;
			this.vAlign = vAlign;
			this.hAlign = hAlign;
			this.cellTime = cellTime;
			this.cellHeight = cellHeight;
		}
		
		/** 显示消息 */
		public function showMessage(message:String,textColor:uint = 0xffffff):void
		{
			var index:int = messages.length;
			var sprite:Sprite = messageManager.createMessage(messageHerfName,message,textColor);
			if(vAlign == VAlign.TOP) sprite.y = -sprite.height;
			else if(vAlign == VAlign.CENTER) sprite.y = -sprite.height/2;
			
			if(hAlign == HAlign.RIGHT) sprite.x = -sprite.width;
			else if(hAlign == HAlign.CENTER) sprite.x = -sprite.width/2;
			
			for each(var sprInfo:Array in messages) sprInfo[0].y -= cellHeight;
			if(messages.length >= maxNum)
			{
				var removeInfo:Array = messages.shift();
				(removeInfo[0] as Sprite).removeFromParent(true);
				Starling.juggler.remove(removeInfo[1]);
			}
			this.addChild(sprite);
			var currSpriteInfo:Array = [sprite];
			currSpriteInfo.push(
				Starling.juggler.delayCall(
				function():void
				{
					var spriteIndex:int = messages.indexOf(currSpriteInfo);
					messages.splice(spriteIndex,1);
					removeChildMessage(currSpriteInfo[0]);
				},cellTime)
			);
			
			messages.push(currSpriteInfo);
		}
		
		protected function removeChildMessage(spr:Sprite):void
		{
			var tween:Tween = new Tween(spr,0.1);
			
			var scale:Number = 0.5;
			tween.scaleTo(scale);
			tween.moveTo(spr.x + spr.width/2*scale,spr.y + spr.height/2*scale);
			tween.onComplete = 
				function():void
				{
					spr.removeFromParent(true);
				}
			Starling.juggler.add(tween);
		}
	}
}