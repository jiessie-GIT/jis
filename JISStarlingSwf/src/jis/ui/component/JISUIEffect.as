package jis.ui.component
{
	import jis.ui.JISUIMovieClipManager;
	
	
	/**
	 * 管理UI中的特效，目前只支持特效从xx帧播放到xx帧，每次调用start都会从指定起始帧开始播放
	 * @author jiessie 2013-11-20
	 */
	public class JISUIEffect extends JISUIMovieClipManager
	{
		private var startTotleFrames:int = 1;
		private var maxTotalFrames:int = -1;
		
		/**
		 * @param startTotleFrames 播放的第一帧
		 * @param maxTotalFrames 播放的最后一帧，也就是如果播放到该帧的话将会停止播放
		 */
		public function JISUIEffect(startTotleFrames:int = 1,maxTotalFrames:int = -1)
		{
			this.startTotleFrames = startTotleFrames;
			this.maxTotalFrames = maxTotalFrames;
		}
		
		protected override function init():void
		{
			if(maxTotalFrames == -1 && this.movie)
			{
				this.maxTotalFrames = this.movie.totalFrames;
			}
		}
		
		/** 从指定第一帧播放这个特效 */
		public function start():void
		{
			movie.gotoAndPlay(startTotleFrames);
			movie.completeFunction = onEnterFrame;
		}
		
		private function onEnterFrame(e:*=null):void
		{
			if(movie.currentFrame >= maxTotalFrames)
			{
				stop();
			}
		}
		
		/** 停止这个特效，会停在指定最后一帧 */
		public function stop():void
		{
			movie.gotoAndStop(maxTotalFrames);
			movie.completeFunction = null;
		}
		
		/** 销毁 */
		public override function dispose():void
		{
			stop();
			super.dispose();
		}
		
		/** 设置起始帧 */
		public function setStartTotalFrames(startFrames:int):void
		{
			this.startTotleFrames = startFrames;
		}
		/** 设置结束帧，如果不设置的话，默认为最后一帧 */
		public function setMaxTotalFrames(maxTotalFrames:int):void
		{
			this.maxTotalFrames = maxTotalFrames;
		}
		
		/** 获取指定结束帧 */
		public function getMaxTotalFrames():int
		{
			return this.maxTotalFrames;
		}
	}
}