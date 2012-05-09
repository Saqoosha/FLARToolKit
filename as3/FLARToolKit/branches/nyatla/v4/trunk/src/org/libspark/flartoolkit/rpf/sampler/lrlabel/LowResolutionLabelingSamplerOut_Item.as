package jp.nyatla.nyartoolkit.as3.rpf.sampler.lrlabel 
{
	import jp.nyatla.nyartoolkit.as3.core.utils.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*
	/**
	 * クラス内定義ができない処理系では、LowResolutionLabelingSamplerOutItemで定義してください。
	 *
	 */
	public class LowResolutionLabelingSamplerOut_Item extends NyARManagedObject
	{
		/**
		 * ラべリング対象のエントリポイントです。
		 */
		public var entry_pos:NyARIntPoint2d=new NyARIntPoint2d();
		/**
		 * ラべリング対象の範囲を、トップレベル換算した値です。クリップ情報から計算されます。
		 */
		public var base_area:NyARIntRect =new NyARIntRect();
		/**
		 * ラべリング対象の範囲中心を、トップレベルに換算した値です。クリップ情報から計算されます。
		 */
		public var base_area_center:NyARIntPoint2d=new NyARIntPoint2d();
		/**
		 * エリア矩形の対角距離の2乗値
		 */
		public var base_area_sq_diagonal:int;
		
		public var lebeling_th:int;
		
		public function LowResolutionLabelingSamplerOut_Item(i_pool:INyARManagedObjectPoolOperater)
		{
			super(i_pool);
		}
	}

}