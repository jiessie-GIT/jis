package jis.ui.component
{
	import lzm.starling.swf.Swf;
	
	import starling.display.Image;
	import starling.display.QuadBatch;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	
	/**
	 * 字符集合处理<br>
	 * 工作原理，需要在初始化的时候传入数据源以及导出连接依据<br>
	 * 实例，swf中存在如下连接：img_num_1、img_num_2、img_num_3、img_num_4、img_num_-、img_num_+<br>
	 * 初始化的时候就需要传入“img_num_”<br>
	 * 程序通过setChar("+333")设置内容的话，该显示对象就会显示对应的图片
	 * @author jiessie 2013-12-18
	 */
	public class JISCharQuadBatch extends QuadBatch
	{
		private var swf:Swf;
		private var charName:String;
		/** 垂直方向 */
		private var vAlign:String;
		/** 水平方向 */
		private var hAlign:String;
		
		public function JISCharQuadBatch(swf:Swf,charName:String,vAlign:String = VAlign.TOP,hAlign:String = HAlign.CENTER)
		{
			super();
			this.swf = swf;
			this.charName = charName;
			this.vAlign = vAlign;
			this.hAlign = hAlign;
		}
		
		/**
		 * 设置显示的字符串
		 */
		public function setChar(char:*):void
		{
			this.reset();
			if(char == "" || char == null) return;
			var chars:Array = (char+"").split("");
			var w:int = 0;
			for each(var str:String in chars)
			{
				var image:Image = swf.createImage(charName+str);
				if(image)
				{
					image.x = w;
					w += image.width;
					this.addImage(image);
				}
			}
			if(this.vAlign == VAlign.CENTER) this.y = -height/2;
			else if(this.vAlign == VAlign.BOTTOM) this.y = -height;
			else this.y = 0;
			
			if(this.hAlign == HAlign.CENTER) this.x = -w/2;
			else if(this.hAlign == HAlign.RIGHT) this.x = -w;
			else this.y = 0;
		}
		
		public override function dispose():void
		{
			swf = null;
			super.dispose();
		}
	}
}