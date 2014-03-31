package jis.ui
{
	import flash.net.FileReference;
	import flash.utils.getQualifiedClassName;
	
	import jis.loader.JISSimpleLoaderSprite;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * 图片容器，可以加载一个图片进行显示
	 * @author jiessie 2013-11-21
	 */
	public class JISImageSprite extends JISSimpleLoaderSprite
	{
		/** 左上角为0,0 */
		public static const DIRECTION_LEFT:String = "left";
		/** 右上角为0,0 */
		public static const DIRECTION_RIGHT:String = "right";
		/** 左下角为0,0 */
		public static const DIRECTION_BOTTOM_LEFT:String = "bottom_left";
		/** 右下角为0,0 */
		public static const DIRECTION_BOTTOM_RIGHT:String = "bottom_right";
		/** 中心为0,0 */
		public static const DIRECTION_CENTER:String = "center";
		private var imageName:String;
		private var image:Image;
		
		private var w:int;
		private var h:int;
		private var imageDirection:String;
		
		public function JISImageSprite(source:* = null,imageDir:String = DIRECTION_LEFT)
		{
			super();
			setImageDirection(imageDir);
			setAssetSource(source);
		}
		
		/** 设置图片路径，该路径只能为一个url或者是一个File */
		public override function setAssetSource(source:*):void
		{
			if(source == null || source == "")
			{
				disposeImage();
				imageName = null;
				return;
			}
			var newImageName:String = getName(source);
			if(newImageName == imageName) return;
			imageName = newImageName;
			disposeImage();
			super.setAssetSource(source);
		}
		
		protected override function loadComplete():void
		{
			var texture:Texture = getAssetTextureArrayForName(imageName);
			if(texture)
			{
				disposeImage();
				image = new Image(texture);
				this.addChild(image);
				setIconWH(w,h);
				this.dispatchEvent(new Event(Event.COMPLETE));
			}
		}
			
		protected function getName(rawAsset:Object):String
		{
			if (getQualifiedClassName(rawAsset) == "flash.filesystem::File")
				rawAsset = rawAsset["url"];
			
			var matches:Array;
			var name:String;
			
			if (rawAsset is String || rawAsset is FileReference)
			{
				name = rawAsset is String ? rawAsset as String : (rawAsset as FileReference).name;
				name = name.replace(/%20/g, " "); // URLs use '%20' for spaces
				matches = /(.*[\\\/])?(.+)(\.[\w]{1,4})/.exec(name);
				
				if (matches && matches.length == 4) return matches[2];
				else throw new ArgumentError("Could not extract name from String '" + rawAsset + "'");
			}
			else
			{
				name = getQualifiedClassName(rawAsset);
				throw new ArgumentError("Cannot extract names for objects of type '" + name + "'");
			}
		}
		
		/** 设置图片大小，会强制修改加载的图片为该大小 */
		public function setIconWH(w:int,h:int):void
		{
			this.w = w;
			this.h = h;
			if(image && w > 0 && h > 0)
			{
				image.width = w;
				image.height = h;
			}
			setImageDirection(this.imageDirection);
		}
		
		/** 设置图像方式 */
		public function setImageDirection(direction:String):void
		{
			this.imageDirection = direction;
			if(this.image)
			{
				if(direction == DIRECTION_LEFT) image.x = image.y = 0;
				else if(direction == DIRECTION_RIGHT)
				{
					//右上角为0，0
					image.x = -image.width;
					image.y = 0;
				}else if(direction == DIRECTION_CENTER)
				{
					//中心为0，0
					image.x = -Math.round(image.width/2);
					image.y = -Math.round(image.height/2);
				}else if(direction == DIRECTION_BOTTOM_LEFT)
				{
					//左下角为0,0
					image.x = 0;
					image.y = -image.height
				}else if(direction == DIRECTION_BOTTOM_RIGHT)
				{
					//右下角为0，0
					image.x = -image.width;
					image.y = -image.height;
				}
			}
		}
		
		public override function dispose():void
		{
			disposeImage();
			super.dispose();
		}
		
		private function disposeImage():void
		{
			if(image)
			{
				image.texture.dispose();
				image.removeFromParent(true);
			}
			image = null;
		}
	}
}