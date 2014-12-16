package jis.ui.component
{
	
	/**
	 * 
	 * @author jiessie 2014-11-26
	 */
	public class JISCuttingPageButtonGroup extends JISCuttingButtonGroup
	{
		public var _TopPageBtn:JISButton;
		public var _NextPageBtn:JISButton;
		
		private var datas:Array;
		private var currPage:int = 0;
		
		public function JISCuttingPageButtonGroup(spliceChar:String, clazz:Class=null)
		{
			_TopPageBtn = new JISButton();
			_NextPageBtn = new JISButton();
			super(spliceChar, clazz);
		}
		
		protected override function init():void{
			super.init();
			_TopPageBtn.setClickHandler(onClickTopPage);
			_NextPageBtn.setClickHandler(onClickNextPage);
		}
		
		public function setDatas(datas:Array):void{
			this.datas = datas;
			currPage = 0;
			update();
		}
		
		public function update():void{
			setSpliceForIndex(datas.slice(currPage*this.getInstanceArray().length,Math.min(datas.length,(currPage+1)*this.getInstanceArray().length)));
		}
		
		private function onClickTopPage():void{
			if(currPage > 0){
				currPage--;
				update();
			}
		}
		
		private function onClickNextPage():void{
			var maxPage:Number = datas.length/this.getInstanceArray().length;
			if(currPage < maxPage-1){
				currPage++;
				update();
			}
		}
	}
}