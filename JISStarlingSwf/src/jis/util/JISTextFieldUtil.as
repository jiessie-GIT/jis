package jis.util
{
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import starling.text.TextField;
	import starling.utils.HAlign;
	
	/**
	 * 文本框工具
	 * @author jiessie 2013-12-11
	 */
	public class JISTextFieldUtil
	{
		/** 
		 * 将starling的TextField转换为flash的TextField 
		 * @param textField 将要转换的文本框
		 * @param textOwner 转换完毕后的文本框添加的显示容器
		 * @param scale 文本框的缩放比例
		 * @param hasDispose 是否销毁旧的文本框
		 * @return 转换完毕的文本框
		 */
		public static function stlTextConvertFlashInputText(textField:starling.text.TextField,textOwner:DisplayObjectContainer,scale:Number = 1,hasDispose:Boolean = true):flash.text.TextField
		{
			var fInputText:flash.text.TextField = new flash.text.TextField();
			fInputText.textColor = textField.color;
			fInputText.text = textField.text;
			fInputText.autoSize = convertSTLAutoSizeToFlash(textField.hAlign);
			fInputText.width = textField.width;
			fInputText.height = textField.height;
			fInputText.setTextFormat(new TextFormat(textField.fontName,textField.fontSize,textField.color,textField.bold,textField.italic,textField.underline));
			fInputText.type = TextFieldType.INPUT;
			fInputText.scaleX = fInputText.scaleY = scale;
			var point:Point = textField.localToGlobal(new Point());
			fInputText.x = point.x;
			fInputText.y = point.y;
			if(textOwner) textOwner.addChild(fInputText);
			if(hasDispose) textField.removeFromParent(true);
			return fInputText;
		}
		
		/**
		 * 将starling的对齐模式转换为flash传统对齐模式
		 * @param hAlign 横向对齐模式 
		 */
		private static function convertSTLAutoSizeToFlash(hAlign:String):String
		{
			if(hAlign == HAlign.LEFT) return TextFieldAutoSize.LEFT;
			else if(hAlign == HAlign.RIGHT) return TextFieldAutoSize.RIGHT;
			else return TextFieldAutoSize.CENTER;
		}
			
	}
}