package jis.loader
{
	import flash.utils.Dictionary;
	
	import starling.utils.AssetManager;
	
	/**
	 * 加载缓存类,该类的职责就是通过AssetsManager进行资源加载并在加载结束后进行管理
	 * @author jiessie 2013-11-19
	 */
	public class JISLoaderCache
	{
		private static var _ID:int = 1;
		private static var _loadCache:Dictionary = new Dictionary();
		
		/**
		 * 加载资源
		 * @param loader 可以是一个url或者是一个file，也可以是一个Array，具体参考Starling->AssetManager#enqueue
		 * @param loadComplentHandler 加载完毕的回调，会传入AssetManager
		 * @param loadProgressHandler 加载进度回调
		 * @return 唯一标识，可以通过该标识销毁资源
		 */
		public static function startLoader(loader:*,loadComplentHandler:Function,loadProgressHandler:Function = null):int
		{
			var id:int;
			id = _ID++;
			var assetManager:AssetManager = new AssetManager();
			assetManager.enqueue(loader);
			assetManager.loadQueue(
				function(progress:Number):void
				{
					if(progress >= 1)
					{
						_loadCache[id] = assetManager;
						if(loadComplentHandler != null) loadComplentHandler.call(null,assetManager)
					}
					else if(loadProgressHandler != null) loadProgressHandler.call(null,progress);
				}
			);
			return id;
		}
		/** 根据加载时获得的唯一标识ID获得加载资源 */
		public static function getAssetManagerForOnlyId(onlyId:int):AssetManager { return _loadCache[onlyId]; }
		/** 根据加载时获得的唯一标识ID销毁资源 */
		public static function disposeAssetManagerForOnlyId(onlyId:int):void
		{
			var assetManager:AssetManager = getAssetManagerForOnlyId(onlyId);
			if(assetManager) assetManager.purge();
			delete _loadCache[onlyId];
		}
	}
}