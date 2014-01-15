package jis.util
{
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import feathers.controls.TextInput;
	import feathers.controls.text.StageTextTextEditor;
	import feathers.core.ITextEditor;
	
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
		 * @return 转换完毕的文本框，由于居中对齐会导致文本框变窄，导致无法点击，所以取消居中对齐
		 */
		public static function stlTextConvertFlashText(textField:starling.text.TextField,textOwner:DisplayObjectContainer,scale:Number = 1,hasDispose:Boolean = true,hasUpdateAutoSize:Boolean = true):flash.text.TextField
		{
			var fInputText:flash.text.TextField = new flash.text.TextField();
			var point:Point = textField.localToGlobal(new Point());
			fInputText.x = point.x*scale;
			fInputText.y = point.y*scale;
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
		
		public static function stlTextConvertTextInput(textField:starling.text.TextField,hasDispose:Boolean = true):TextInput
		{
			var textInput:TextInput = new TextInput();
			textInput.text = textField.text;
			textInput.width = textField.width;
			textInput.height = textField.height;
			textInput.x = textField.x;
			textInput.y = textField.y;
			textInput.textEditorFactory = 
				function():ITextEditor
				{
					var text:StageTextTextEditor = new StageTextTextEditor();
					text.color = textField.color;
					text.fontSize = textField.fontSize;
					text.fontFamily = textField.fontName;
					text.textAlign = convertSTLAutoSizeToFlash(textField.hAlign);
					return text;
				}
			if(textField.parent) textField.parent.addChild(textInput);
			textField.removeFromParent(hasDispose);
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
			
	}
}