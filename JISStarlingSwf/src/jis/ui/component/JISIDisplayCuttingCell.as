package jis.ui.component
{
	
	/**
	 * 只有实现该接口JISIDisplayCutting才能通过setSpliceMovieDatas、setSpliceMovieData、setSpliceMovieDatasForIndex、setSpliceForIndex、setSpliceForLast
	 * 进行动态添加内容
	 * @author jiessie 2013-11-20
	 */
	public interface JISIDisplayCuttingCell
	{
		/** 设置内容 */
		function setData(data:*):void;
	}
}