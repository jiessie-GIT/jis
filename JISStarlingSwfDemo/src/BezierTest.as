package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.TextField;
	
	import avmplus.getQualifiedClassName;
	
	import lzm.util.Bezier;
	
	[SWF(width="960", height="640", backgroundColor="#0000000")]
	/**
	 * 
	 * @author jiessie
	 */
	public class BezierTest extends Sprite
	{
		private var sprite:Sprite;
		
		private var currStep:int = 0;
		private var bezier:Bezier;
		
		public function BezierTest()
		{
			super();
			
			var text:TextField;// = new TextField();
			
			trace(getQualifiedClassName(text));
			
			sprite = new Sprite();
			sprite.graphics.beginFill(0xfffff);
			sprite.graphics.drawRect(0,0,150,20);
			sprite.x = 100;
			sprite.y = 300;
			this.addChild(sprite);
			
			startRun();
			this.addEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void
		{
			if(bezier && currStep < bezier.bezierStep)
			{
				var point:Array = bezier.getAnchorPoint(currStep);
				sprite.x = point[0];
				sprite.y = point[1];
				sprite.rotation = point[2];
				currStep++;
			}else
			{
				startRun();
			}
		}
		
		private function startRun():void
		{
			bezier = new Bezier(new Point(100,300),new Point(500,100),new Point(800,300),50);
			currStep = 0;
		}
	}
}