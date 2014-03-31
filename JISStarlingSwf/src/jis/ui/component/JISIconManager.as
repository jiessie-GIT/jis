package jis.ui.component
{
	import jis.ui.JISImageSprite;
	import jis.ui.JISUIManager;
	
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.extensions.pixelmask.PixelMaskDisplayObject;
	
	
	/**
	 * 图标管理类,内部封装了JISImageSprite，使用该类的话Sprite中必须包含一个命名为_IconMovie的Sprite
	 * @author jiessie 2013-11-21
	 */
	public class JISIconManager extends JISUIManager
	{
		
		/** 加载的图片会添加到该显示对象中 */
		public var _IconMovie:Sprite;
		/** 遮罩图片 */
		public var _MaskImage:DisplayObject;
		
		private var image:JISImageSprite;
		public function JISIconManager(imageDir:String = JISImageSprite.DIRECTION_LEFT)
		{
			image = new JISImageSprite(null,imageDir);
			super();
		}
		
		protected override function init():void
		{
			if(_IconMovie == null) _IconMovie = this.display as Sprite;
			if(_MaskImage)
			{
				_MaskImage.removeFromParent();
				var maskedDisplayObject:PixelMaskDisplayObject = new PixelMaskDisplayObject();
				_MaskImage.x = 0;
				_MaskImage.y = 0;
				_IconMovie.addChild(maskedDisplayObject);
				maskedDisplayObject.mask = _MaskImage;
				maskedDisplayObject.addChild(image);
			}else
			{
				_IconMovie.addChild(image);
			}
		}
		
		/** 设置图片地址 */
		public function setImageSource(source:*):void
		{
			image.setAssetSource(source);
		}
		
		/** 设置图片大小，通过该方法进行设置图片大小之后图片在加载完毕之后会强制修改为该大小，否则的话为原始大小 */
		public function setIconWH(w:int,h:int):void
		{
			image.setIconWH(w,h);
		}
		
		/** 设置对其方向 */
		public function setImageDirection(direction:String):void
		{
			image.setImageDirection(direction);
		}
		
		public override function dispose():void
		{
			image.removeFromParent(true);
			image = null;
			_IconMovie = null;
			super.dispose();
		}
		
		public function getImage():JISImageSprite { return image; }
	}
}