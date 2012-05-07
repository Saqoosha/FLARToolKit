package jp.nyatla.nyartoolkit.as3.core.utils 
{
	/**
	 * NyARManagedObjectPoolの要素クラスです。
	 *
	 */
	public class NyARManagedObject
	{
		/**
		 * オブジェクトの参照カウンタ
		 */
		private var _count:int;
		/**
		 * オブジェクトの解放関数へのポインタ
		 */
		private var _pool_operater:INyARManagedObjectPoolOperater;
		/**
		 * NyARManagedObjectPoolのcreateElement関数が呼び出すコンストラクタです。
		 * @param i_ref_pool_operator
		 * Pool操作の為のインタフェイス
		 */
		public function NyARManagedObject(i_ref_pool_operator:INyARManagedObjectPoolOperater)
		{
			this._count=0;
			this._pool_operater=i_ref_pool_operator;
		}
		public function initObject():NyARManagedObject
		{
			//assert(this._count==0);
			this._count=1;
			return this;
		}
		/**
		 * このオブジェクトに対する、新しい参照オブジェクトを返します。
		 * @return
		 */
		public function referenceObject():NyARManagedObject
		{
			//assert(this._count>0);
			this._count++;
			return this;
		}
		/**
		 * 参照オブジェクトを開放します。
		 * @return
		 */
		public function releaseObject():int
		{
			//assert(this._count>0);
			this._count--;
			if(this._count==0){
				this._pool_operater.deleteObject(this);
			}
			return this._count;
		}
		/**
		 * 現在の参照カウンタを返します。
		 * @return
		 */
		public function getCount():int
		{
			return this._count;
		}
	}
}