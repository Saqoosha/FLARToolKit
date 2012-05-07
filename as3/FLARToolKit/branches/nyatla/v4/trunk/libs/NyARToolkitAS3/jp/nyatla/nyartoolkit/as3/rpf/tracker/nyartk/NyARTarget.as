package jp.nyatla.nyartoolkit.as3.rpf.tracker.nyartk
{

	import jp.nyatla.nyartoolkit.as3.core.types.NyARDoublePoint2d;
	import jp.nyatla.nyartoolkit.as3.core.types.NyARIntRect;
	import jp.nyatla.nyartoolkit.as3.core.utils.*;
	import jp.nyatla.nyartoolkit.as3.rpf.sampler.lrlabel.*;
	import jp.nyatla.nyartoolkit.as3.rpf.tracker.nyartk.status.NyARTargetStatus;

	/**
	 * トラッキングターゲットのクラスです。
	 * {@link #tag}以外の要素については、ユーザからの直接アクセスを推奨しません。
	 *
	 */
	public class NyARTarget extends NyARManagedObject
	{
		/**
		 * システム動作中に一意なシリアル番号
		 */
		private static var _serial_counter:Number=0;
		/**
		 * 新しいシリアルIDを返します。この値は、NyARTargetを新規に作成したときに、Poolクラスがserialプロパティに設定します。
		 * @return
		 */
		public static function createSerialId():Number
		{
			//マルチスレッドをサポートする環境では、排他ロックをかけること。
			return NyARTarget._serial_counter++;
		}
		////////////////////////
		//targetの基本情報
		/**
		 * ステータスのタイプを表します。この値はref_statusの型と同期しています。
		 */
		public var _st_type:int;
		/**
		 * Targetを識別するID値
		 */
		public var _serial:Number;
		/**
		 * 認識サイクルの遅延値。更新ミスの回数と同じ。
		 */
		public var _delay_tick:int;

		/**
		 * 現在のステータスの最大寿命。
		 */
		public var _status_life:int;

		////////////////////////
		//targetの情報
		public var _ref_status:NyARTargetStatus;
		
		/**
		 * ユーザオブジェクトを配置するポインタータグです。リリース時にNULL初期化されます。
		 */
		public var tag:Object;
	//	//Samplerからの基本情報
		
		/**
		 * サンプリングエリアを格納する変数です。
		 */
		public var _sample_area:NyARIntRect=new NyARIntRect();
		//アクセス用関数
		
		/**
		 * Constructor
		 */
		public function NyARTarget(iRefPoolOperator:INyARManagedObjectPoolOperater)
		{
			super(iRefPoolOperator);
			this.tag=null;
		}
		/**
		 * この関数は、ref_statusの内容を安全に削除します。
		 */
		public override function releaseObject():int
		{
			var ret:int=super.releaseObject();
			if(ret==0 && this._ref_status!=null)
			{
				this._ref_status.releaseObject();
			}
			return ret;
		}
		
		/**
		 * 頂点情報を元に、sampleAreaにRECTを設定します。
		 * @param i_vertex
		 */
		public function setSampleArea(i_vertex:Vector.<NyARDoublePoint2d>):void
		{
			this._sample_area.setAreaRect(i_vertex,4);
		}	

		/**
		 * LowResolutionLabelingSamplerOut.Itemの値をを元に、sample_areaにRECTを設定します。
		 * @param i_item
		 * 設定する値です。
		 */
		public function setSampleArea_2(i_item:LowResolutionLabelingSamplerOut_Item):void
		{
			this._sample_area.setValue(i_item.base_area);
		}
	}
}
