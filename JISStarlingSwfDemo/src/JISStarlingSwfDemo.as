package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageOrientation;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import lzm.starling.swf.Swf;
	
	import starling.core.Starling;
	
	
	[SWF(width="960", height="640", backgroundColor="#0000000")]
	/**
	 * 
	 * @author jiessie 2013-11-27
	 */
	public class JISStarlingSwfDemo extends Sprite
	{
		public function JISStarlingSwfDemo()
		{
			super();
			
			// 支持 autoOrient
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			//设置线性布局的朝向，可取horizontal（水平）和vertical（垂直）两种排列方式
			stage.setOrientation(StageOrientation.ROTATED_RIGHT);
			
			this.addEventListener(Event.ADDED_TO_STAGE,onAddToStage);
		}
		
		private function onAddToStage(e:Event):void
		{
			Swf.init(this.stage);
			var star:Starling = new Starling(JISStarlingSwfMain,this.stage);
			star.start();
		}
	}
}