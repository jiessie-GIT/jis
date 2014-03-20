package jis.ui.component
{
	import flash.utils.Dictionary;
	
	import jis.ui.JISISpriteManager;
	import jis.ui.JISUIManager;
	import jis.ui.JISUIMovieClipManager;
	import jis.util.JISArrayUtil;
	import jis.util.JISManagerSpriteUtil;
	
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	
	
	/**
	 * 切割显示对象管理，管理一个sprite中命名规则如：g1、g2、g3...这种以固定标识开头的显示对象<br>
	 * 你可以通过初始化的时候传入标识字符和切割后进行管理的类，程序会在切割的时候自动创建对应的管理类，然后交由管理类来进行管理该显示对象<br>
	 * 管理类必须为JISUIManager的子类<br>
	 * 通过该类进行管理子对象的话，子对象必须实现JISIDisplayCuttingCell接口
	 * @author jiessie 2013-11-20
	 */
	public class JISDisplayCutting extends JISUIManager
	{
		/** 
		 * 对应截取字符后的索引与显示对象对照<br>
		 * 如果显示对象的name是generals_1<br>
		 * 那么该Dictionary中存储的就是:显示对象=1
		 */
		private var displayDic:Dictionary = new Dictionary();
		
		/** 
		 * 对应截取字符后的索引与显示对象对照<br>
		 * 如果显示对象的name是generals_1<br>
		 * 那么该Dictionary中存储的就是:1=显示对象
		 */
		private var charDic:Dictionary = new Dictionary();
		/**
		 * 如果在设置了Class类型的话，那么Dictionary将会进行display与实例进行保存
		 */ 
		private var displayForInstanceDic:Dictionary = new Dictionary();
		
		/** 会根据截取之后的剩余字母进行升序排序 */
		private var displayInstanceArray:Array = [];
		
		private var spliceChar:String;//截取字符
		protected var clazz:Class;//生成实例
		/** 通过setSpliceForIndex赋值的最大索引，方便添加新的数据到结尾 */
		private var currDataIndex:int = 0;
		
		public function JISDisplayCutting(spliceChar:String,clazz:Class = null)
		{
			super();
			this.spliceChar = spliceChar;
			this.clazz = clazz;
		}
		
		//初始化根据指定截取字符将设置的MovieClip中成员进行截取成单个对象
		protected override function init():void
		{
			displayInstanceArray = [];
			
			for each(var displayChild:DisplayObject in JISManagerSpriteUtil.getDisplayCOntainerChlids(this.display as DisplayObjectContainer))
			{
				if(displayChild.name != null && (spliceChar == "" || displayChild.name.indexOf(spliceChar) >= 0))
				{
					var displaySpliceChar:String = displayChild.name.substring(spliceChar.length);
					var movieClip:JISUIManager = getClassInstance();
					//如果设置了类型将会创建出来
					if(movieClip)
					{
						//将索引保存
						movieClip.plus = displaySpliceChar;
						movieClip.setCurrDisplay(displayChild);
						displayInstanceArray.push(movieClip);
						//						displayChild = movieClip;
						displayForInstanceDic[displayChild] = movieClip;
					}
					displayDic[displayChild] = displaySpliceChar;
					charDic[displaySpliceChar] = displayChild;
				}
			}
			
			displayInstanceArray.sortOn("plus",Array.NUMERIC);
		}
		
		//创建一个已设置的类，
		protected function getClassInstance():JISUIManager
		{
			if(clazz == null)
			{
				return new JISUIManager();
			}
			return new clazz();
		}
		
		/** 获取格式化好的显示对应与索引,存储的格式为:显示对象=1 */
		public function getDisplayDictionary():Dictionary
		{
			return this.displayDic;
		}
		/** 获取格式化好的显示对应与索引,存储的格式为:1=显示对象 */
		public function getCharDictionary():Dictionary
		{
			return this.charDic;
		}
		
		/** 根据char获取显示对象 */
		public function getDisplayForSpliceChar(char:*):DisplayObject
		{
			return this.charDic[char+""];
		}
		
		/** 根据显示对象获取对应char */
		public function getCharForDisplay(display:DisplayObject):String
		{
			return this.displayDic[display];
		}
		
		/** 获取显示对象对应创建的JISUIManager的子类 */
		public function getInstanceForDisplay(display:DisplayObject):JISISpriteManager
		{
			return this.displayForInstanceDic[display];
		}
		
		/** 根据索引获取显示对象对应创建的JISUIManager的子类 */
		public function getInstanceForCharIndex(char:*):JISISpriteManager
		{
			return this.displayForInstanceDic[getDisplayForSpliceChar(char)];
		}
		
		/** 获取实例Dictionary  DisplayObject=JISUIManager */
		public function getInstanceDictionary():Dictionary
		{
			return this.displayForInstanceDic;
		}
		
		/** 获取实例列表 */
		public function getInstanceArray():Array
		{
			return this.displayInstanceArray;
		}
		
		/** 
		 * 批量向切割好的列表中插入数据，该功能要求该组件创建的显示对象管理类必须实现JISIDisplayCuttingCell接口，
		 * 传入的数据必须实现JISIDisplayCuttingCellData接口，如果不满足条件，将会被忽略<br>
		 * 每次设置数据都会清空旧的数据 
		 */
		public function setSpliceMovieDatas(datas:Array):void
		{
			var dataDic:Dictionary = new Dictionary();
			for each(var data:* in datas)
			{
				if(data is JISIDisplayCuttingCellData)
				{
					dataDic[(data as JISIDisplayCuttingCellData).getSpliceInfo()] = data;
				}
			}
			for(var display:* in displayForInstanceDic)
			{
				var movie:JISIDisplayCuttingCell = displayForInstanceDic[display] as JISIDisplayCuttingCell;
				if(movie == null)
				{
					continue;
				}
				var key:String = displayDic[display];
				movie.setData(dataDic[key]);
			}
		}
		
		/** 设置对应位置显示内容 */
		public function setSpliceMovieData(data:JISIDisplayCuttingCellData):void
		{
			var movie:JISIDisplayCuttingCell = displayForInstanceDic[charDic[data.getSpliceInfo()]] as JISIDisplayCuttingCell;
			if(movie)
			{
				movie.setData(data);
			}
		}
		
		/** 
		 * 将会将信息根据Array的索引进行一对一赋值，如果没有则会被滞空,显示对象必须实现JISIDisplayCuttingCell接口
		 */
		public function setSpliceMovieDatasForIndex(datas:Array):void
		{
			for(var i:int = 0;i<displayInstanceArray.length;i++)
			{
				var movie:JISIDisplayCuttingCell = displayInstanceArray[i] as JISIDisplayCuttingCell;
				if(movie)
				{
					movie.setData(i < datas.length ? datas[i]:null);
				}
			}
		}
		
		/** 根据数组的索引一一对应赋值，如果超出了则赋值为null */
		public function setSpliceForIndex(datas:*):void
		{
			if(!(datas is Array))
			{
				datas = JISArrayUtil.objectToArray(datas);
			}
			for(var i:int = 0;i<displayInstanceArray.length;i++)
			{
				var movie:JISIDisplayCuttingCell = displayInstanceArray[i];
				var data:* = null;
				if(datas && (!(datas is Array) || i < datas.length))
				{
					data = datas[i];
					currDataIndex++;
				}
				movie.setData(data);
			}
		}
		
		/** 设置数据到拆分组件的设置到之前通过setSpliceForIndex的最后一个 */
		public function setSpliceForLast(data:*):void
		{
			var movie:JISIDisplayCuttingCell = displayInstanceArray[currDataIndex];
			if(movie)
			{
				movie.setData(data);
			}
			currDataIndex++;
		}
		
		public override function dispose():void
		{
			displayDic = null;
			charDic = null;
			displayForInstanceDic = null;
			for each(var uiManager:JISUIManager in displayInstanceArray)
			{
				uiManager.dispose();
			}
			displayInstanceArray = null;
			super.dispose();
		}
	}
}