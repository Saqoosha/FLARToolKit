package org.libspark.flartoolkit.core.utils 
{
	/**
	 * FLARManagedObjectPoolの要素クラスです。
	 *
	 */
	public class FLARManagedObject
	{
		/**
		 * オブジェクトの参照カウンタ
		 */
		private var _count:int;
		/**
		 * オブジェクトの解放関数へのポインタ
		 */
		private var _pool_operater:IFLARManagedObjectPoolOperater;
		/**
		 * FLARManagedObjectPoolのcreateElement関数が呼び出すコンストラクタです。
		 * @param i_ref_pool_operator
		 * Pool操作の為のインタフェイス
		 */
		public function FLARManagedObject(i_ref_pool_operator:IFLARManagedObjectPoolOperater)
		{
			this._count=0;
			this._pool_operater=i_ref_pool_operator;
		}
		public function initObject():FLARManagedObject
		{
			//assert(this._count==0);
			this._count=1;
			return this;
		}
		/**
		 * このオブジェクトに対する、新しい参照オブジェクトを返します。
		 * @return
		 */
		public function referenceObject():FLARManagedObject
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