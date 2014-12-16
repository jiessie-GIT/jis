package jis.util
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	/**
	 * json数据存储
	 * @author jiessie 2014-11-19
	 */
	public class JISJosnDataSaveUtil
	{
		public static function readJsonFile(file:*,callBackHandler:Function):void{
			JISFileUtil.readFile(file,
				function(bytes:ByteArray):void{	
					if(bytes != null){
						callBackHandler.call(null,JSON.parse(bytes.readMultiByte(bytes.length,"UTF-8")));
						bytes.clear();
					}
					else callBackHandler.call(null,null);
				}
			);
		}
		
		public static function writeJsonFile(file:*,data:*):void{
			var bytes:ByteArray = new ByteArray();
			bytes.writeMultiByte(JSON.stringify(data),"UTF-8");
			JISFileUtil.writeFile(file,bytes);
			bytes.clear();
		}
		
		/**
		 * 将xml数据加载并格式化成Object
		 */
		public static function readXmlToObjectFileDir(file:*,callBackHandler:Function):void{
			JISFileUtil.readFileDir(file,
				function(dic:Dictionary):void{	
					if(dic == null) callBackHandler.call(null,null);
					else{
						var result:Dictionary = new Dictionary();
						for(var name:String in dic){
							var bytes:ByteArray = dic[name];
							var xml:XML = new XML(bytes.readMultiByte(bytes.length,"UTF-8"));
							bytes.clear();
							var clazz:Class = getDefinitionByName(xml.localName()) as Class;
							var datas:Array = [];
							for each (var clazzXml:XML in xml.data)
							{
								var data:Object = new clazz();
								for each(var propertyXml:XML in clazzXml.attributes()){
									data[propertyXml.name()+""] = (data[propertyXml.name()+""] is int) ? parseInt(propertyXml.toString()):propertyXml.toString();
								}
								datas.push(data);
							}
							result[name] = datas;
						}
						callBackHandler.call(null,result);
					}
				}
			);
		}
		
		/** 将"1:50,2:80"这种数据编译成Object，主要针对xml中无法录入json格式数据 */
		public static function stringParseObject(str:String):*{
			var result:* = {};
			for each(var keyValue:String in str.split(",")){
				var infos:Array = keyValue.split(":");
				result[infos[0]] = infos[1];
			}
			return result;
		}
	}
}