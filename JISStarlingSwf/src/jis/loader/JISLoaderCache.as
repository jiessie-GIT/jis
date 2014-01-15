package jis.loader
{
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import starling.utils.AssetManager;
	
	/**
	 * 加载缓存类,该类的职责就是通过AssetsManager进行资源加载并在加载结束后进行管理
	 * @author jiessie 2013-11-19
	 */
	public class JISLoaderCache
	{
		private static var _ID:int = 1;
		private static var _loadCache:Dictionary = new Dictionary();
		/** 加载好的url对应ID的列表 */
		private static var _urlToIdCache:Dictionary = new Dictionary();
		
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
			_urlToIdCache[id] = getAssetUrl(loader);
			var assetManager:AssetManager = new AssetManager();
			assetManager.enqueue(loader);
			assetManager.loadQueue(
				function(progress:Number):void
				{
					if(progress >= 1)
					{
						trace("JISLoaderCache#loadOk-->>id:",id," info:",loader);
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
			if(assetManager)
			{
				trace("JISLoaderCache#dispose-->>id:",_urlToIdCache[onlyId]);
				assetManager.purge();
			}
			delete _loadCache[onlyId];
//			trace("JISLoaderCache#remainnum ------------------------↓");
//			for(var otherOnlyId:* in _loadCache)
//			{
//				trace("JISLoaderCache#dispose remain->",otherOnlyId,_urlToIdCache[otherOnlyId]);
//			}
		}
		
		/**
		 * 获得加载地址信息
		 * @param loader 加载地址，可以是url、File、Array
		 * @return 如果是url直接返回，如果是File会返回File["url"]，如果是Array会进行遍历并将最终结果通过“-”进行拼接
		 */
		private static function getAssetUrl(loader:*):String
		{
			if(loader is Array)
			{
				var newLoaderList:Array = [];
				for each(var loaderInfo:* in loader) newLoaderList.push(getAssetUrl(loaderInfo));
				loader = newLoaderList.join("-");
			}else if(getQualifiedClassName(loader) == "flash.filesystem::File") return loader["url"];
			
			return loader;
		}
	}
}