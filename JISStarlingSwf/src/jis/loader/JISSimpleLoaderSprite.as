package jis.loader
{
	import flash.utils.ByteArray;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	
	
	/**
	 * 加载模版，子类可以直接继承该类实现加载资源并显示的功能<br>
	 * 使用方式：通过本类setAssetSource的方式设置加载内容，加载完毕之后会调用子类loadComplete方法
	 * @author jiessie 2013-11-19
	 */
	public class JISSimpleLoaderSprite extends Sprite
	{
		private var assetManager:AssetManager;
		private var loadProgressHandler:Function;
		protected var assetOnlyId:int = -1;
		
		public function JISSimpleLoaderSprite()
		{
			super();
		}
		/** 设置一个资源地址,可以是一个url或者是一个file，也可以是一个Array，具体参考Starling->AssetManager#enqueue */
		public function setAssetSource(source:*):void
		{
			if(assetOnlyId > 0)
			{
				disposeCurrLoaderAsset();
			}
			assetOnlyId = JISLoaderCache.startLoader(source,onLoadComplete,loadProgressHandler == null ? onLoadProgress:loadProgressHandler);
		}
		
		/** 资源加载完毕 */
		private function onLoadComplete(assetManager:AssetManager):void
		{
			this.assetManager = assetManager;
			loadProgressHandler = null;
			loadComplete();
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		/** 该方法是加载完毕之后提供给子类的回调函数，防止父类内容处理不完善所以只提供该方法供子类实现 */
		protected function loadComplete():void { }
		private function onLoadProgress(progress:Number):void { if(loadProgressHandler != null) loadProgressHandler.call(null,progress); }
		/** 设置加载进度回调函数 */
		public function setLoadProgressHandler(handler:Function):void { this.loadProgressHandler = handler; }
		/** 根据资源名字获得ByteArray */
		public function getAssetByteArrayForName(name:String):ByteArray { return this.assetManager.getByteArray(name);}
		/** 根据资源名字获得Texture */
		public function getAssetTextureArrayForName(name:String):Texture { return this.assetManager.getTexture(name);}
		/** 获取资源 */
		public function getAssetManager():AssetManager { return this.assetManager; }
		/** 销毁 */
		public override function dispose():void
		{
			this.removeFromParent();
			super.dispose();
			assetManager = null;
			disposeCurrLoaderAsset();
		}
		
		protected function disposeCurrLoaderAsset():void
		{
			JISLoaderCache.disposeAssetManagerForOnlyId(assetOnlyId);
		}
		/** 是否加载完毕，判断条件为assetManager是否为null */
		public function hasLoadOK():Boolean { return this.assetManager != null; }
	}
}