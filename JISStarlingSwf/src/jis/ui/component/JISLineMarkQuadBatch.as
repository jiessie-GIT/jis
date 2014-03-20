package jis.ui.component
{
	import jis.ui.JISUISprite;
	import jis.util.JISNumericalValueUtil;
	
	import starling.display.Image;
	import starling.display.QuadBatch;
	
	
	/**
	 * 直线斑点标识
	 * @author jiessie 2014-3-16
	 */
	public class JISLineMarkQuadBatch extends QuadBatch
	{
		private var source:JISUISprite;
		private var imageName:String;
		private var image:Image;
		
		public function JISLineMarkQuadBatch(source:JISUISprite,imageName:String)
		{
			super();
			this.source = source;
			this.imageName = imageName;
		}
		
		/** 
		 * 设置直线脚印
		 * @param startX 开始x
		 * @param startY 开始y
		 * @param endX 结束x
		 * @param endY 结束y 
		 * @param markSpacing 每个的距离
		 */
		public function setLineMark(startX:Number,startY:Number,endX:Number,endY:Number,markSpacing:Number):void
		{
			this.reset();
			var lineLength:Number = JISNumericalValueUtil.getDistance(startX,startY,endX,endY);
			var sumNum:int = Math.ceil(lineLength/markSpacing);
			/** 一步的比例 */
			var oneMarkScale:Number = markSpacing/lineLength;
			var xSpeed:Number = (endX - startX)*oneMarkScale;
			var ySpeed:Number = (endY - startY)*oneMarkScale;
			
			for(var i:int=0;i<sumNum;i++)
			{
				insertImageToPoint(startX+xSpeed*i,startY+ySpeed*i);
			}
			insertImageToPoint(endX,endY);
		}
		
		private function insertImageToPoint(x:Number,y:Number):void
		{
			if(image == null)
			{
				image = source.getSourceSwf().createImage(imageName);
			}
			image.x = x;
			image.y = y;
			this.addImage(image);
		}
	}
}