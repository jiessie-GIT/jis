package
{
	import jis.ui.JISUISprite;
	import jis.ui.component.JISITableCell;
	
	import lzm.starling.swf.Swf;
	
	import starling.display.DisplayObject;
	import starling.text.TextField;
	
	
	/**
	 * 
	 * @author jiessie 2013-11-27
	 */
	public class JISTableTestCell extends JISUISprite implements JISITableCell
	{
		public var _Text:TextField;
		public function JISTableTestCell(swf:Swf)
		{
			super("","");
			setCurrDisplay(swf.createSprite("spr_TableCell"));
		}
		
		public function setValue(value:*):void
		{
			_Text.text = value;
		}
		
		public override function getDisplay():DisplayObject
		{
			return this;
		}
		
		public function selected(select:Boolean=false):void
		{
		}
		
		public function getValue():*
		{
			return _Text.text;
		}
		
		public override function dispose():void
		{
		}
	}
}