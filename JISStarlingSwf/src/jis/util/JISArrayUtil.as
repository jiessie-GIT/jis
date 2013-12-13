package jis.util
{
	/**
	 * 数组工具
	 * @author jiessie
	 */
	public class JISArrayUtil
	{
		/** 复制一个新的数组 */
		public static function cloneArray(arr:Array):Array
		{
			var result:Array = [];
			for each(var obj:Object in arr)
			{
				result.push(obj);
			}
			
			return result;
		}
		
		/** 将一个数组复制到另外一个数组当中 */
		public static function copyToArray(source:Array,target:Array):void
		{
			for each(var obj:* in source)
			{
				target.push(obj);
			}
		}
		
		/** 将一个String字符串列表转换成一个{"x":1,"y":1}类型列表 */
		public static function transitionStringArrayToPointArray(source:Array):Array
		{
			var result:Array = [];
			
			for each(var str:String in source)
			{
				var points:Array = str.split(",");
				result.push({"x":parseInt(points[0]+""),"y":parseInt(points[1]+"")});
			}
			
			return result;
		}
		
		/** 将object转换为数组 */
		public static function objectToArray(obj:*):Array
		{
			var result:Array = [];
			
			for each(var info:* in obj)
			{
				result.push(info);
			}
			
			return result;
		}
	}
}