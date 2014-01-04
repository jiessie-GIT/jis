package jis.ui.component
{
	import jis.ui.JISUIManager;
	
	import lzm.starling.swf.Swf;
	
	import starling.display.DisplayObject;
	import starling.text.TextField;
	
	
	/**
	 * 普通的只有一个Text的JISITableCell,TextField命名为_Text
	 * @author jiessie 2014-1-3
	 */
	public class JISTextTableCell extends JISUIManager implements JISITableCell
	{
		public var _Text:TextField;
		
		private var data:*;
		
		public function JISTextTableCell(swf:Swf)
		{
			super();
			this.setCurrDisplay(getCurrDisplayForSwf(swf));
		}
		
		protected function getCurrDisplayForSwf(swf:Swf):DisplayObject
		{
			return swf.createSprite("spr_Cell");
		}
		
		public function setValue(value:*):void
		{
			data = value;
			if(_Text) _Text.text = data;
		}
		
		public function selected(select:Boolean=false):void
		{
		}
		
		public function getValue():*
		{
			return data;
		}
		
		public override function dispose():void
		{
			data = null;
			super.dispose();
		}
	}
}