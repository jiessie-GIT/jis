package jis.ui.component
{
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import jis.ui.JISUIManager;
	import jis.util.JISTextFieldUtil;
	
	import starling.display.DisplayObjectContainer;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	/**
	 * 会把flash的TextField制作成一个Image添加到管理的Sprite中
	 * @author jiessie 2014-1-17
	 */
	public class JISFlashTextSpriteManager extends JISUIManager
	{
		private var textField:flash.text.TextField;
		private var image:Image;
		
		public function JISFlashTextSpriteManager()
		{
			super();
		}
		
		protected override function init():void
		{
			if(this.display is starling.text.TextField)
			{
				var sprite:Sprite = new Sprite();
				sprite.name = this.display.name;
				sprite.x = this.display.x;
				sprite.y = this.display.y;
				this.display.parent.addChildAt(sprite,this.display.parent.getChildIndex(this.display));
				setTextField(JISTextFieldUtil.stlTextConvertFlashText(this.display as starling.text.TextField,null,1,true,false));
				this.display = sprite;
			}
		}
		
		public function setTextField(textField:flash.text.TextField):void
		{
			this.textField = textField;
			this.textField.multiline = true;
			this.textField.wordWrap = true;
		}
		
		public function createTextField(fontName:String = null,fontSize:int = 12,color:uint = 0x00,autoSize:String = TextFieldAutoSize.LEFT,leading:Object = null,w:int = -1,h:int = -1):void
		{
			var textField:flash.text.TextField = new flash.text.TextField();
			textField.textColor = color;
			textField.autoSize = autoSize;
			var textFormat:TextFormat = new TextFormat(fontName,fontSize,color);
			textFormat.leading = leading;
			textField.defaultTextFormat = textFormat;
			textField.setTextFormat(textFormat);
			if(w > 0) textField.width = w;
			if(h > 0) textField.height = h;
			setTextField(textField);
		}
		
		public function set htmlText(value:String):void
		{
			getTextField().htmlText = value;
			updateImage();
		}
		
		public function set text(value:String):void
		{
			getTextField().text = value;
			updateImage();
		}
		
		private function updateImage():void
		{
			var texture:Texture = JISTextFieldUtil.flashTextFieldToTexture(this.textField);
			if(image == null)
			{
				image = new Image(texture);
				(this.display as DisplayObjectContainer).addChild(image);
			}else
			{
				image.texture.dispose();
				image.texture = texture;
				image.readjustSize();
			}
			trace(this.getDisplay().height,image.height,getTextHeight());
		}
		
		public function getTextField():flash.text.TextField
		{
			if(this.textField == null)
			{
				createTextField();
			}
			return this.textField;
		}
		
		public override function dispose():void
		{
			if(image)
			{
				image.texture.dispose();
				image.removeFromParent(true);
			}
			image = null;
			textField = null;
			super.dispose();
		}
		
		public function getTextHeight():int
		{
			return Math.max(textField.height,textField.textHeight);
		}
	}
}