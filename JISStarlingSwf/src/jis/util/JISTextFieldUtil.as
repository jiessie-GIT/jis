package jis.util
{
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import feathers.controls.TextInput;
	import feathers.controls.text.StageTextTextEditor;
	import feathers.controls.text.TextFieldTextEditor;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.ITextEditor;
	import feathers.core.ITextRenderer;
	
	import starling.text.TextField;
	import starling.textures.Texture;
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
		 * @return 转换完毕的文本框，由于居中对齐会导致文本框变窄，导致无法点击，所以取消居中对齐
		 */
		public static function stlTextConvertFlashInputText(textField:starling.text.TextField,textOwner:DisplayObjectContainer,scale:Number = 1,hasDispose:Boolean = true):flash.text.TextField
		{
			var fInputText:flash.text.TextField = stlTextConvertFlashText(textField,textOwner,scale,hasDispose,false);
			fInputText.type = TextFieldType.INPUT;
			return fInputText;
		}
		
		/** 
		 * 将starling的TextField转换为flash的TextField 
		 * @param textField 将要转换的文本框
		 * @param textOwner 转换完毕后的文本框添加的显示容器
		 * @param scale 文本框的缩放比例
		 * @param hasDispose 是否销毁旧的文本框
		 * @param hasUpdateAutoSize 是否转换starling text对齐方式
		 * @return 转换完毕的文本框，由于居中对齐会导致文本框变窄，导致无法点击，所以取消居中对齐
		 */
		public static function stlTextConvertFlashText(textField:starling.text.TextField,textOwner:DisplayObjectContainer = null,scale:Number = 1,hasDispose:Boolean = true,hasUpdateAutoSize:Boolean = true):flash.text.TextField
		{
			var fInputText:flash.text.TextField = new flash.text.TextField();
			var point:Point = textField.localToGlobal(new Point());
			fInputText.x = textField.stage ? point.x:point.x*scale;
			fInputText.y = textField.stage ? point.y:point.y*scale;
			fInputText.textColor = textField.color;
			fInputText.text = textField.text;
			fInputText.autoSize = hasUpdateAutoSize ? convertSTLAutoSizeToFlash(textField.hAlign):TextFieldAutoSize.NONE;
			fInputText.width = textField.width;
			fInputText.height = textField.height;
			var textFormat:TextFormat = new TextFormat(textField.fontName,textField.fontSize,textField.color,textField.bold,textField.italic,textField.underline);
			fInputText.defaultTextFormat = textFormat;
			fInputText.setTextFormat(textFormat);
			fInputText.scaleX = fInputText.scaleY = scale;
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
		
		public static function stlTextConvertTextInput(textField:starling.text.TextField,hasDispose:Boolean = true,maxChars:int = -1,hasPassWord:Boolean = false):TextInput
		{
			var textInput:TextInput = new TextInput();
			textInput.text = textField.text;
			textInput.width = textField.width;
			textInput.height = textField.height;
			textInput.x = textField.x;
			textInput.y = textField.y;
			textInput.displayAsPassword = hasPassWord;
			textInput.textEditorProperties.textAlign = convertSTLAutoSizeToFlash(textField.hAlign);
			textInput.textEditorProperties.color = textField.color;
			textInput.textEditorProperties.fontSize = textField.fontSize;
			
			if(maxChars > 0) textInput.maxChars = maxChars;
//			textInput.promptFactory = 
//				function():ITextRenderer
//				{
//					var textRenderer:TextFieldTextRenderer = new TextFieldTextRenderer();
//					var textFormat:TextFormat = new TextFormat(textField.fontName,textField.fontSize,0xFFFFFF);
//					textRenderer.displayAsPassword = hasPassWord;
////					textRenderer.disabledTextFormat = textFormat;
////					textRenderer.styleSheet = new StyleSheet();
////					textRenderer.styleSheet.setStyle("textFormat",textFormat);
//					textRenderer.textFormat = textFormat;
//					return textRenderer;
//				};
			textInput.textEditorFactory = 
				function():ITextEditor
				{
					var text:TextFieldTextEditor = new TextFieldTextEditor();
//					text.color = textField.color;
//					text.fontSize = textField.fontSize;
//					text.fontFamily = textField.fontName;
//					text.textAlign = convertSTLAutoSizeToFlash(textField.hAlign);
					var textFormat:TextFormat = new TextFormat(textField.fontName,textField.fontSize,0xFFFFFF);
					text.textFormat = textFormat;
					text.displayAsPassword = hasPassWord;
					if(maxChars > 0) text.maxChars = maxChars;
					return text;
				}
			if(textField.parent) textField.parent.addChild(textInput);
			textField.removeFromParent(hasDispose);
			textInput.text = "";
			return textInput;
		}
		
		/**
		 * 根据传入的时间 返回一个格式为  “XX天XX小时XX分钟XX秒”
		 * @param time 毫秒单位
		 * @param length 最小保留单位 例如：4为秒 3为保留分，不显示秒  2为保留小时  1为保留天
		 */ 
		public static function getTimeStringForTime(time:Number,length:int = 4):String
		{
			return getStringForTimeList(getTimeForNum(time,length));
		}
		
		/** 传入时间信息 */
		public static function getStringForTime(day:int,h:int,m:int,s:int):String
		{
			return getStringForTimeList([s,m,h,day]);
		}
		
		/**
		 * 传入一个数组，数组的格式为  [秒][分][时][天]
		 * @return 返回一个格式为  “XX天XX小时XX分钟XX秒”
		 */ 
		public static function getStringForTimeList(list:Array):String
		{
			var result:String = "";
			
			var day:int = list.length > 3 ? list[3]:0;
			var h:int = list.length > 2 ? list[2]:0;
			var m:int = list.length > 1 ? list[1]:0;
			var s:int = list.length > 0 ? list[0]:0;
			if(day > 0)
			{
				result += day+"天";
			}
			if(h > 0)
			{
				result += h+"时";
			}
			if(m > 0)
			{
				result += m+"分";
			}
			if(s > 0)
			{
				result += s+"秒";
			}
			
			return result;
		}
		
		/**
		 * 传入一个数字返回一个数组，数组的格式为  [秒][分][时][天]
		 * @param length 最小保留单位 例如：4为秒 3为保留分[分][时][天]  2为保留小时[时][天]  1为保留天[天]
		 */ 
		public static function getTimeForNum(time:Number,length:int = 4):Array
		{
			var day:int = time/(24*60*60*1000);
			time = time%(24*60*60*1000);
			var h:int = time/(60*60*1000);
			time = time%(60*60*1000);
			var m:int = time/(60*1000);
			time = time%(60*1000);
			var s:int = time/1000;
			var list:Array = [s,m,h,day];
			for(var i:int = 0;i<list.length - length;i++)
			{
				list.splice(i,1,0);
			}
			return list;
		}
		
		public static function flashTextFieldToTexture(text:flash.text.TextField):Texture
		{
			text.width = Math.max(text.width,text.textWidth);
			text.height = Math.max(text.height,text.textHeight)+3;
			var bitmap:BitmapData = new BitmapData(text.width,text.height,true,0x00);
			bitmap.draw(text);
			return Texture.fromBitmapData(bitmap);
		}
	}
}