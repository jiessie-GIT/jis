package jis.ui.component
{
	import lzm.starling.swf.Swf;
	
	import starling.display.Image;
	import starling.display.QuadBatch;
	
	
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
		private var hasCenter:Boolean;
		
		public function JISCharQuadBatch(swf:Swf,charName:String,hasCenter:Boolean = true)
		{
			super();
			this.swf = swf;
			this.charName = charName;
			this.hasCenter = hasCenter;
		}
		
		/**
		 * 设置显示的字符串
		 */
		public function setChar(char:String):void
		{
			this.reset();
			var chars:Array = char.split("");
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
			if(this.hasCenter) this.x = -w/2;
		}
		
		public override function dispose():void
		{
			swf = null;
			super.dispose();
		}
	}
}