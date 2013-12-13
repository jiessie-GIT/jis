package jis.ui.component
{
	/**
	 * 数据实现该接口的话可以动态的将数据通过JISDisplayCutting进行赋值
	 * @author jiessie 2013-11-20
	 */
	public interface JISIDisplayCuttingCellData
	{
		/** 切割之后一一对应赋值的依据，比如背包中的格子为：g1、g2、g3......，如果想向g1中赋值的话，依据就是“1” */
		function getSpliceInfo():String;
	}
}