package jis.ui.component
{
	import jis.ui.JISUIManager;
	import jis.ui.JISUISprite;
	
	
	/**
	 * 日期选择组件
	 * @author jiessie 2014-6-12
	 */
	public class JISDateDropDownMenus extends JISUIManager
	{
		public var _Year:JISDropDownMenu;
		public var _Month:JISDropDownMenu;
		public var _Day:JISDropDownMenu;
		public var _Hour:JISDropDownMenu;
		public var _Minute:JISDropDownMenu;
		
		private var date:Date;
		
		public function JISDateDropDownMenus(menuHeight:int,swfSource:JISUISprite,cellClass:Class = null)
		{
			_Year = new JISDropDownMenu(menuHeight,swfSource,cellClass);
			_Month = new JISDropDownMenu(menuHeight,swfSource,cellClass);
			_Day = new JISDropDownMenu(menuHeight,swfSource,cellClass);
			_Hour = new JISDropDownMenu(menuHeight,swfSource,cellClass);
			_Minute = new JISDropDownMenu(menuHeight,swfSource,cellClass);
			
			super();
		}
		
		protected override function init():void
		{
			if(_Month.getDisplay())
			{
				_Month.setDropDatas([1,2,3,4,5,6,7,8,9,10,11,12]);
				_Month.selectHandler = updateDays;
			}
			if(_Hour.getDisplay())
			{
				var hours:Array = [];
				for(var hour:int = 0;hour <= 23;hour ++) hours.push(hour);
				_Hour.setDropDatas(hours);
			}
			if(_Minute.getDisplay())
			{
				var minuets:Array = [];
				for(var minuet:int = 0;minuet <= 59;minuet ++) minuets.push(minuet);
				_Minute.setDropDatas(minuets);
			}
				
		}
		
		/** 设置日期 */
		public function setDate(date:Date):void
		{
			this.date = date;
			if(_Year.getDisplay())
			{
				_Year.setDropDatas([date.getFullYear(),date.getFullYear()+1,date.getFullYear()+2]);
			}
			if(_Month.getDisplay())
			{
				_Month.getTable().getTable().setSelectIndex(date.getMonth());
			}
			updateDays();
			if(_Day.getDisplay())
			{
				_Day.getTable().getTable().setSelectIndex(date.date-1);
			}
			if(_Hour.getDisplay())
			{
				_Hour.getTable().getTable().setSelectIndex(date.hours);
			}
			if(_Minute.getDisplay())
			{
				_Minute.getTable().getTable().setSelectIndex(date.minutes);
			}
		}
		
		private function updateDays(e:* = null):void
		{
			if(date && _Day.getDisplay() && _Month.getDisplay())
			{
				var month:int = _Month.getSelectTableValue();
				month = month >= 12 ? 0:month;
				var monthDate:Date = new Date(date.getFullYear(),month);
				monthDate.time -= 1000;
				//当前月的天数
				var monthDay:int = monthDate.date;
				var days:Array = [];
				for(var day:int = 1;day <= monthDay;day ++) days.push(day);
				_Day.setDropDatas(days);
			}
		}
		
		/** 获得选择的时间 */
		public function getSelectDate():Date
		{
			var result:Date = new Date();
			if(_Year.getDisplay()) result.setFullYear(_Year.getSelectTableValue());
			else result.setFullYear(this.date.fullYear);
			
			if(_Month.getDisplay()) result.setMonth(_Month.getSelectTableValue());
			else result.setMonth(this.date.month);
			
			if(_Day.getDisplay()) result.setDate(_Day.getSelectTableValue());
			else result.setDate(this.date.date);
			
			if(_Hour.getDisplay()) result.setHours(_Hour.getSelectTableValue());
			else result.setHours(this.date.hours);
			
			if(_Minute.getDisplay()) result.setMinutes(_Minute.getSelectTableValue());
			else result.setMinutes(this.date.minutes);
			
			return result;
		}
	}
}