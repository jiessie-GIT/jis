package jis.util
{
	import flash.events.ProgressEvent;
	
	/**
	 * @author jiessie
	 */
	public class JISNumericalValueUtil
	{
		
		/**
		 * 获取一个数字的百分比,保留小数点后两位
		 * @param num 分子
		 * @param maxNum 分母
		 */ 
		public static function getScaleNumber(num:Number,maxNum:Number):Number
		{
			return getScaleForNumber(num/maxNum);
		}
		
		/** 将一个number截取小数点后两位 */
		public static function getScaleForNumber(num:Number):Number
		{
			return ((int)(num*10000))/100;
		}
		
		/** 将一个number截取小数点后两位，如果后两位为.1的话会补全为.10 */
		public static function getScaleStrForNumber(num:Number):String
		{
			var result:String = getScaleForNumber(num)+""; 
			if(result.length == 2) result += ".00"; 
			else if(result.length == 4) result += "0";
			return result;
		}
		
		/** 字节转为KB */
		public static function getKB(num:uint):int { return num/1024; }
		/** 获取已加载的kb数 */ 
		public static function getMaxProgress(e:ProgressEvent):Number { return e.bytesLoaded/1024/1024; }
		/** 获取加载事件的总kb数 */
		public static function getCurrProgress(e:ProgressEvent):Number { return e.bytesTotal/1024/1024; }
		/** 
		 * 根据直角三角形定律获得两点之间直线距离，即直角三角形的斜边 <br>
		 * A点<br>
		 * |＼<br>
		 * | ＼<br>
		 * |  ＼<br>
		 * |___＼B点<br>
		 */
		public static function getDistance(startX:Number,startY:Number,endX:Number,endY:Number):Number
		{
			var aHeight:Number = Math.abs(startX - endX);
			var bHeight:Number = Math.abs(startY - endY);
			//斜边长度
			return Math.sqrt((Math.pow(aHeight,2)+Math.pow(bHeight,2)));
		}
		/** 格式化数字：10W以下正常显示，10W以上显示10万、11万、200万等等 */
		public static function formatNum(num:int):String
		{
			if(num < 100000) return num+"";
			return ((int)(num/10000))+"万";
		}
		/** 检测是否在范围内 */
		public static function checkRange(ownerX:int,ownerY:int,x:int,y:int,w:int,h:int):Boolean
		{
			return ownerX >= x && ownerX <= x+w && ownerY >= y && ownerY <= y+h;
		}
		
		/**
		 * 获得直线移动速度与时间
		 * @param speed 移动速度，每秒移动距离
		 * @return {"xSpeed":x移动速度(帧),"ySpeed":y移动速度(帧),"sumFrames":移动到目标所需帧数}
		 */
		public static function getSpeedForTarget(x:Number,y:Number,speed:int,targetX:Number,targetY:Number,stageFrames:int):*
		{
			//移动所需距离
			var endSpace:Number = getDistance(x,y,targetX,targetY);
			//需要几帧移动到目标
			var sumFrames:Number = (endSpace/speed)*stageFrames;
			return {"xSpeed":(targetX - x)/sumFrames,"ySpeed":(targetY - y)/sumFrames,"sumFrames":sumFrames};
		}
	}
}