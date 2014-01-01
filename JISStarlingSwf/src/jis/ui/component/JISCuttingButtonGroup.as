package jis.ui.component
{
	/**
	 * 集成JISButtonGroup的JISDisplayCutting，会将切割的管理对象交由JISButtonGroup进行管理
	 * @author jiessie 2013-11-20
	 */
	public class JISCuttingButtonGroup extends JISDisplayCutting
	{
		private var btnGroup:JISButtonGroup;
		
		public function JISCuttingButtonGroup(spliceChar:String, clazz:Class=null)
		{
			btnGroup = new JISButtonGroup();
			super(spliceChar, clazz);
		}
		
		protected override function init():void
		{
			super.init();
			btnGroup.setBtnList(this.getInstanceArray());
		}
		
		/** 设置选中按钮回调函数，在选中按钮的时候将会调用该函数，并传入选中的按钮 */
		public function setSelectBtnHandler(handler:Function):void { this.btnGroup.setSelectBtnHandler(handler); }
		/** 获取按钮分组容器 */
		public function getButtonGroup():JISButtonGroup { return this.btnGroup }
		
		public override function dispose():void
		{
			btnGroup.dispose();
			btnGroup = null;
			super.dispose();
		}
	}
}