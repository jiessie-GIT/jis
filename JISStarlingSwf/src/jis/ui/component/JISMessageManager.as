package jis.ui.component
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import jis.JISConfig;
	import jis.loader.JISLoaderCache;
	
	import lzm.starling.swf.Swf;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.AssetManager;
	
	/**
	 * 消息管理器
	 * @author jiessie 2014-1-15
	 */
	public class JISMessageManager
	{
		private static var _instance:JISMessageManager;
		public static function get instance():JISMessageManager { return _instance; }
		public static function initInstance(swfSource:*,assetGetName:String,backLeftWidth:int,backRightWidth:int):void{
			_instance = new JISMessageManager(swfSource,assetGetName,backLeftWidth,backRightWidth);
		}
		
		private var source:Swf;
		private var onlyId:int;
		private var assetGetName:String;
		private var backLeftWidth:int;
		private var backRightWidth:int;
		private static var fText:flash.text.TextField;
		
		public function JISMessageManager(swfSource:*,assetGetName:String,backLeftWidth:int,backRightWidth:int)
		{
			this.assetGetName = assetGetName;
			this.backLeftWidth = backLeftWidth;
			this.backRightWidth = backRightWidth;
			if(swfSource is Swf)
			{
				source = swfSource;
			}else
			{
				onlyId = JISLoaderCache.startLoader(swfSource,onLoaderCompleteHandler);	
			}
		}
		
		private function onLoaderCompleteHandler(assetManager:AssetManager):void
		{
			source = new Swf(assetManager.getByteArray(assetGetName),assetManager);
		}
		
		/** 创建消息 */
		public function createMessage(messageHerfName:String,message:String,textColor:uint = 0xffffff):Sprite
		{
			var messageSprite:Sprite = source.createSprite(messageHerfName);
			if(messageSprite == null) return null;
			var sText:starling.text.TextField = messageSprite.getChildByName("_Text") as starling.text.TextField;
			if(sText)
			{
				if(fText == null)
				{
					fText = new flash.text.TextField();
					var textFormat:TextFormat = fText.getTextFormat();
					textFormat.font = sText.fontName;
					textFormat.size = sText.fontSize;
					fText.defaultTextFormat = textFormat;
				}
				fText.text = message;
				sText.width = fText.textWidth+10;
				sText.text = message;
				sText.color = textColor;
				var back:DisplayObject = messageSprite.getChildByName("_Back");
				if(back)
				{
					back.width = backLeftWidth + sText.width + backRightWidth;
					sText.x = back.width/2-sText.width/2;
				}
			}
			
			return messageSprite;
		}
		
		/** 
		 * 开始飘动
		 * @param messageHerfName Swf连接名字
		 * @oaram message 消息
		 * @oaram completeHandler 飘动完毕回调
		 * @oaram topMoveRange 向上飘起距离
		 * @oaram scale 缩放
		 * @oaram time 时间
		 * @oaram delay 延迟
		 * @oaram transition 缓动类型
		 * @oaram stageWidth 舞台宽度,居中参考
		 * @oaram stageHeight 舞台高度,居中参考
		 * @oaram owner 容器，如果是starling的root并且没有设置scaleX的话,stageWidth与stageHeight建议使用stage.fullScreenWidth与stage.fullScreenHeight
		 */
		public function showMessage(messageHerfName:String,message:String,completeHandler:Function = null,topMoveRange:int = 50,scale:Number = 1,time:Number = 1,delay:Number = 0,transition:String = Transitions.EASE_IN,stageWidth:int = -1,stageHeight:int = -1,owner:DisplayObjectContainer = null):Sprite
		{
			var messageSprite:Sprite = createMessage(messageHerfName,message);
			if(messageSprite == null) return null;
			
			owner = owner == null ? JISConfig.windowStage:owner;
			stageWidth = stageWidth <= 0 ? owner.width:stageWidth;
			stageHeight = stageHeight <= 0 ? owner.height:stageHeight;
			
			messageSprite.x = stageWidth/2 - (messageSprite.width*scale)/2;
			messageSprite.y = stageHeight/2 - (messageSprite.height*scale)/2;
			
			messageSprite.scaleX = messageSprite.scaleY = scale;
			
			Starling.juggler.tween(messageSprite,time,{"y":messageSprite.y - topMoveRange*scale,"alpha":0.5,"transition":transition,"delay":delay,
				"onStart":
				function():void
				{
					owner.addChild(messageSprite);
				}
				,"onComplete":
				function():void
				{
					if(completeHandler) completeHandler.call();
					messageSprite.removeFromParent(true);
				}
			});
			return messageSprite;
		}
		
		
		
	}
}