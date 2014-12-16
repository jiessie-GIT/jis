package jis.util
{
	import flash.geom.Point;
	
	/**
	 * 随机数据工具
	 * @author jiessie 2014-11-18
	 */
	public class JISRandomUtil
	{
		public static function hasTure(random:int = 50):Boolean{
			return Math.random()*100 <= random;
		}
		
		public static function getRandomNumForRange(min:int,max:int):int{
			return min+Math.random()*(max-min);
		}
		
		public static function getRandomPointForRange(x:int,y:int,w:int,h:int):Point{
			return new Point(getRandomNumForRange(x,x+w),getRandomNumForRange(y,y+h));
		}
		
		public static function getObjectForDic(dic:*):*{
			var maxRandom:int = 0;
			for each(var num:int in dic) maxRandom += num;
			var random:int = Math.random() * maxRandom;
			for(var key:* in dic){
				if(random <= dic[key]) return key;
				else random -= dic[key];
			}
			return key;
		}
	}
}