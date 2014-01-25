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
	import starling.textures.Texture;
	
	/**
	 * 会把flash的TextField制作成一个Image添加到管理的Sprite中
	 * @author jiessie 2014-1-17
	 */
	public class JISFlashTextSpriteManager extends JISUIManager
	{
		private var textField:TextField;
		private var image:Image;
		
		public function JISFlashTextSpriteManager()
		{
			super();
		}
		
		public function setTextField(textField:TextField):void
		{
			this.textField = textField;
		}
		
		public function createTextField(fontName:String = null,fontSize:int = 12,color:uint = 0x00,autoSize:String = TextFieldAutoSize.LEFT,leading:Object = null):void
		{
			textField = new TextField();
			textField.textColor = color;
			textField.autoSize = autoSize;
			var textFormat:TextFormat = new TextFormat(fontName,fontSize,color);
			textFormat.leading = leading;
			textField.defaultTextFormat = textFormat;
			textField.setTextFormat(textFormat);
			textField.multiline = true;
			textField.wordWrap = true;
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
		}
		
		public function getTextField():TextField
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
	}
}