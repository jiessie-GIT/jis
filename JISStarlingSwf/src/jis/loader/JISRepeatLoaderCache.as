package jis.loader
{
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import starling.utils.AssetManager;
	
	/**
	 * 多次加载同一个地址资源的话，只会加载一次，<br>
	 * 加载缓存类,该类的职责就是通过AssetsManager进行资源加载并在加载结束后进行管理
	 * @author jiessie 2013-11-19
	 */
	public class JISRepeatLoaderCache
	{
		private static var _ID:int = 1;
		/** 已加载完毕的资源 */
		private static var _loadCache:Dictionary = new Dictionary();
		/** 正在加载的资源，格式：ID=[[进度回调，加载完毕回调]] */
		private static var _currLoadCache:Dictionary = new Dictionary();
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
			var id:int = getAssetIDForLoader(loader);
			if(id > 0)
			{
				if(id in _loadCache) loadComplentHandler.call(null,_loadCache[id]);
				else if(id in _currLoadCache) (_currLoadCache[id] as Array).push([loadComplentHandler,loadProgressHandler]);
			}else
			{
				id = addLoaderUrlAndIdCache(loader);
				_currLoadCache[id] = [[loadComplentHandler,loadProgressHandler]];
				trace("loader-->>",getAssetUrl(loader));
				var assetManager:AssetManager = new AssetManager();
				assetManager.enqueue(loader);
				assetManager.loadQueue(
					function(progress:Number):void
					{
						if(progress >= 1)
						{
							addLoaderOKAssetCache(id,assetManager);
						}
						else
						{
							for each(var loadHandlerList:Array in _currLoadCache[id]) 
							{
								if(loadHandlerList[1] != null) loadHandlerList[1](progress);
							}
						}
					}
				);
			}
			return id;
		}
		
		/** 加载成功之后将资源加入缓存 */
		private static function addLoaderOKAssetCache(id:int,assetManager:AssetManager):void
		{
			_loadCache[id] = assetManager;
			for each(var loadHandler:Array in _currLoadCache[id]) if(loadHandler[0] != null) loadHandler[0](assetManager);
			delete _currLoadCache[id];
		}
		
		/** 添加ID与加载地址对应缓存 */
		private static function addLoaderUrlAndIdCache(loader:*):int
		{
			var id:int = _ID++;
			var url:String = getAssetUrl(loader);
			_urlToIdCache[id] = url;
			_urlToIdCache[url] = id;
			return id;
		}
		/** 根据加载时获得的唯一标识ID获得加载资源 */
		public static function getAssetManagerForOnlyId(onlyId:int):AssetManager { return _loadCache[onlyId]; }
		public static function getAssetManagerForLoaderInfo(loader:*):AssetManager { return getAssetManagerForOnlyId(getAssetIDForLoader(loader)) }
		/** 根据加载时获得的唯一标识ID销毁资源 */
		public static function disposeAssetManagerForOnlyId(onlyId:int):void
		{
			var assetManager:AssetManager = getAssetManagerForOnlyId(onlyId);
			if(assetManager) assetManager.purge();
			trace("dispose-->>",_urlToIdCache[onlyId]);
			delete _urlToIdCache[_urlToIdCache[onlyId]];
			delete _urlToIdCache[onlyId];
			delete _loadCache[onlyId];
		}
		
		/** 获得加载地址对应的ID，如果已加载则会返回大于0的数字，否则返回0 */ 
		public static function getAssetIDForLoader(loader:*):int
		{
			return _urlToIdCache[getAssetUrl(loader)];
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