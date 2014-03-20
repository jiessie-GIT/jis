package jis.loader
{
	
	/**
	 * 将加载队列加载到JISRepeatLoaderCache中
	 * @author jiessie 2014-3-13
	 */
	public class JISRepeatQueueLoader
	{
		private var maxNum:Number;
		private var queues:Array;
		private var progressHandler:Function;
		private var completeHandler:Function;
		
		public function JISRepeatQueueLoader(queues:Array,completeHandler:Function,progressHandler:Function = null)
		{
			maxNum = queues.length;
			this.queues = queues;
			this.progressHandler = progressHandler;
			this.completeHandler = completeHandler;
			nextQueue();
		}
		
		private function nextQueue():void
		{
			if(queues.length <= 0) loadEnd();
			else
			{
				JISRepeatLoaderCache.startLoader(queues.shift(),onLoadCompleteHandler,onLoadProgressHandler);
			}
		}
		
		private function onLoadProgressHandler(progress:Number):void
		{
			if(progressHandler != null) progressHandler.call(null,(maxNum - this.queues.length - 1 + progress)/maxNum);
		}
		
		private function onLoadCompleteHandler(e:*):void
		{
			nextQueue();
		}
		
		private function loadEnd():void
		{
			completeHandler.call();
			completeHandler = null;
			queues = null;
			progressHandler = null;
		}
	}
}