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
		private var imageName:String;
		private var image:Image;
		
		private var w:int;
		private var h:int;
		private var hasCenter:Boolean;
		
		public function JISImageSprite(source:* = null,hasCenter:Boolean = false)
		{
			super();
			this.hasCenter = hasCenter;
			setAssetSource(source);
		}
		
		/** 设置图片路径，该路径只能为一个url或者是一个File */
		public override function setAssetSource(source:*):void
		{
			if(source == null || source == "")
			{
				if(image) image.removeFromParent(true);
				imageName = null;
				return;
			}
			var newImageName:String = getName(source);
			if(newImageName == imageName) return;
			imageName = newImageName;
			if(image) image.removeFromParent(true);
			super.setAssetSource(source);
		}
		
		protected override function loadComplete():void
		{
			var texture:Texture = getAssetTextureArrayForName(imageName);
			if(texture)
			{
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
			if(this.hasCenter)
			{
				image.x = -Math.round(image.width/2);
				image.y = -Math.round(image.height/2);
			}
		}
		
		public override function dispose():void
		{
			if(image) image.dispose();
			image = null;
			super.dispose();
		}
	}
}