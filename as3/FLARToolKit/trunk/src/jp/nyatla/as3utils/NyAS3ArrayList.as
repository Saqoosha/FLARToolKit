package jp.nyatla.as3utils 
{
	/**
	 * ...
	 * @author nyatla
	 */
	public class NyAS3ArrayList 
	{
		private var _items:Vector.<Object>=new Vector.<Object>();
		public function NyAS3ArrayList()
		{
			
		}
		public function getItem(i_index:int):Object
		{
			return this._items[i_index];
		}
		public function size():int
		{
			return this._items.length;
		}
		public function add(i_item:Object):Boolean
		{
			this._items.push(i_item);
			return true;
		}
	}

}