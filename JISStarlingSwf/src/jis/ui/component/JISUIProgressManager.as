package jis.ui.component
{
	import jis.ui.JISUIManager;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.extensions.pixelmask.PixelMaskDisplayObject;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	
	/**
	 * 管理UI中的进度条组件，UI需要具备命名为_Center的Display，当设置进度的时候会改变_Center的width或者height属性，建议_Center为Scale9Image<br>
	 * 可选组建_Text类型为TextField，存在该组件的话，会在设置进度的时候赋值“当前进度/最大进度”
	 * @author jiessie 2013-11-22
	 */
	public class JISUIProgressManager extends JISUIManager
	{
		/** 显示文本 */
		public var _Text:TextField;
		/** 进度条中间位置 */
		public var _Center:DisplayObject;
		/** 进度条底部位置 */
		public var _Back:DisplayObject;
		/** 进度条管理 */
		protected var progressBar:JISProgress;
		
		private var maskedDisplayObject:PixelMaskDisplayObject;
		private var maskImage:Image;
		private var hasMask:Boolean;
		private var _progressHandler:Function;
		
		public function JISUIProgressManager(speedProgressHandler:Function = null,hasMask:Boolean = true)
		{
			progressBar = new JISProgress(true);
			if(speedProgressHandler != null) progressBar.setSpeedProgressHandler(speedProgressHandler);
			this.hasMask = hasMask;
			super();
		}
		
		protected override function init():void
		{
			if(_Center == null) _Center = this.display;
			
			if(this.hasMask)
			{
				maskImage = new Image(Texture.fromColor(this._Center.width,this._Center.height));
				maskedDisplayObject = new PixelMaskDisplayObject();
				maskedDisplayObject.x = this._Center.x;
				maskedDisplayObject.y = this._Center.y;
				maskedDisplayObject.pivotX = this._Center.pivotX;
				maskedDisplayObject.pivotY = this._Center.pivotY;
				
				//			maskImage.pivotX = this._Center.pivotX;
				//			maskImage.pivotY = this._Center.pivotY;
				
				this._Center.x = 0;
				this._Center.y = 0;
				this._Center.pivotX = 0;
				this._Center.pivotY = 0;
				var childIndex:int = this._Center.parent.getChildIndex(this._Center);
				maskedDisplayObject.name = this._Center.name;
				this._Center.parent.addChildAt(maskedDisplayObject,childIndex);
				this._Center.removeFromParent();
				maskedDisplayObject.mask = maskImage;
				maskedDisplayObject.addChild(this._Center);
				
				if(this._Center == this.display) this.display = maskedDisplayObject;
				progressBar.setCenterDisplay(maskImage);
				setProgressMaxWidth(this.maskImage.width);
			}else
			{
				progressBar.setCenterDisplay(_Center);
				setProgressMaxWidth(this._Center.width);
			}
			
		}
		
		/** 设置进度条最大宽度 */
		public function setProgressMaxWidth(maxNum:int):void
		{
			this.progressBar.setMaxWidth(maxNum);
		}
		
		/** 根据当前值与最大值计算得出最新的长度 */
		public function setProgress(progress:int,maxProgress:int):void
		{
			this.progressBar.setCurrWidthForProgress(progress,maxProgress);
			if(_Text)
			{
				_Text.text = progress+"/"+maxProgress;
			}
			if(_progressHandler != null) _progressHandler.call(null,progress/maxProgress);
		}
		
		public override function dispose():void
		{
			_Text = null;
			_Center = null;
			progressBar.dispose();
			progressBar = null;
			
			if(maskImage)
			{
				maskImage.texture.dispose();
				maskImage.dispose();
			}
			maskImage = null;
			if(maskedDisplayObject) maskedDisplayObject.dispose();
			maskedDisplayObject = null;
			
			super.dispose();
		}

		public function set progressHandler(value:Function):void
		{
			_progressHandler = value;
		}

	}
}