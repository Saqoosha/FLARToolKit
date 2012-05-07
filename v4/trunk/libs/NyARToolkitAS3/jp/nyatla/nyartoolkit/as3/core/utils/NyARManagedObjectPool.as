package jp.nyatla.nyartoolkit.as3.core.utils 
{
	import jp.nyatla.nyartoolkit.as3.core.*;
	/**
	 * 参照カウンタ付きのobjectPoolです。NyARManagedObjectから派生したオブジェクトを管理します。
	 * このクラスは、参照カウンタ付きのオブジェクト型Tのオブジェクトプールを実現します。
	 * 
	 * このクラスは、NyARManagedObjectと密接に関連して動作することに注意してください。
	 * 要素の作成関数はこのクラスで公開しますが、要素の解放関数は要素側に公開します。
	 * @param <T>
	 */
	public class NyARManagedObjectPool
	{

		/**
		 * 公開するオペレータオブジェクトです。
		 * このプールに所属する要素以外からは参照しないでください。
		 */
		public var _op_interface:Operator=new Operator();

		/**
		 * プールから型Tのオブジェクトを割り当てて返します。
		 * @return
		 * 新しいオブジェクト
		 */
		public function newObject():NyARManagedObject
		{
			var pool:Operator=this._op_interface;
			if(pool._pool_stock<1){
				return null;
			}
			pool._pool_stock--;
			//参照オブジェクトを作成して返す。
			return (NyARManagedObject)(pool._pool[pool._pool_stock].initObject());
		}
		/**
		 * 実体化の拒否の為に、コンストラクタを隠蔽します。
		 * 継承クラスを作成して、初期化処理を実装してください。
		 */
		public function NyARManagedObjectPool()
		{
		}
		/**
		 * オブジェクトを初期化します。この関数は、このクラスを継承したクラスを公開するときに、コンストラクタから呼び出します。
		 * @param i_length
		 * @param i_element_type
		 * @throws NyARException
		 */
		protected function initInstance(i_length:int):void
		{
			var pool:Operator=this._op_interface;
			//領域確保
			pool._buffer = new Vector.<NyARManagedObject>(i_length);
			pool._pool = new Vector.<NyARManagedObject>(i_length);
			//使用中個数をリセット
			pool._pool_stock=i_length;
			//オブジェクトを作成
			for(var i:int=pool._pool.length-1;i>=0;i--)
			{
				pool._buffer[i]=pool._pool[i]=createElement();
			}
			return;		
		}


		protected function initInstance_2(i_length:int,i_param:Object):void
		{
			var pool:Operator=this._op_interface;
			//領域確保
			pool._buffer = new Vector.<NyARManagedObject>(i_length);
			pool._pool = new Vector.<NyARManagedObject>(i_length);
			//使用中個数をリセット
			pool._pool_stock=i_length;
			//オブジェクトを作成
			for(var i:int=pool._pool.length-1;i>=0;i--)
			{
				pool._buffer[i]=pool._pool[i]=createElement_2(i_param);
			}
			return;		
		}
		/**
		 * オブジェクトを作成します。継承クラス内で、型Tのオブジェクトを作成して下さい。
		 * @return
		 * @throws NyARException
		 */
		protected function createElement():NyARManagedObject
		{
			throw new NyARException();
		}
		protected function createElement_2(i_param:Object):NyARManagedObject
		{
			throw new NyARException();
		}
	}
}
import jp.nyatla.nyartoolkit.as3.core.utils.*;
/**
 * Javaの都合でバッファを所有させていますが、別にこの形で実装しなくてもかまいません。
 */
class Operator implements INyARManagedObjectPoolOperater
{
	public var _buffer:Vector.<NyARManagedObject>;
	public var _pool:Vector.<NyARManagedObject>;
	public var _pool_stock:int;
	public function deleteObject(i_object:NyARManagedObject):void
	{
		//assert(i_object!=null);
		//assert(this._pool_stock<this._pool.length);
		this._pool[this._pool_stock]=i_object;
		this._pool_stock++;
	}
}