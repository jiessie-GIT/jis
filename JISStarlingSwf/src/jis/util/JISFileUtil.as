package jis.util
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	/**
	 * 文件工具
	 * @author jiessie 2014-11-19
	 */
	public class JISFileUtil
	{
		public static function readFile(file:*,callBackHandler:Function):void{
			file.addEventListener(IOErrorEvent.IO_ERROR,
				function(e:IOErrorEvent):void{
					callBackHandler.call(null,null);
				}
			);
			file.addEventListener(Event.COMPLETE,
				function(e:Event):void{
					callBackHandler.call(null,file.data);
				}
			);
			file.load();
		}
		
		public static function readFileDir(file:*,callBackHandler:Function):void{
			if(file.isDirectory){
				var result:Dictionary = new Dictionary();
				var files:Array = file.getDirectoryListing();
				var currReadFile:*;
				var readFileFun:Function = 
					function(bytes:ByteArray = null):void{
						if(bytes != null){
							result[currReadFile.name] = bytes;
						}
						if(files.length <= 0) callBackHandler.call(null,result);
						else {
							currReadFile = files.shift();
							readFile(currReadFile,readFileFun);
						}
					};
				readFileFun();
			}else{
				callBackHandler.call(null,null);
			}
		}
		
		public static function writeFile(file:*,bytes:ByteArray):void{
			var clazz:Class = getDefinitionByName("flash.filesystem.FileStream") as Class;
			var stream:* = new clazz();
			stream.open(file,"write");
			stream.writeBytes(bytes,0,bytes.length);
			stream.close();
		}
		
	}
}