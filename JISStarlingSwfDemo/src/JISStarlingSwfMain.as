package
{
	import jis.JISConfig;
	
	import starling.display.Sprite;
	
	
	/**
	 * 
	 * @author jiessie 2013-11-27
	 */
	public class JISStarlingSwfMain extends Sprite
	{
		public function JISStarlingSwfMain()
		{
			super();
			//该参数设置窗口的父级显示对象
			JISConfig.windowStage = this;
			new JISMainUIWindow().show();
		}
	}
}