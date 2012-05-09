package org.libspark.flartoolkit.rpf.sampler.lrlabel 
{
	import org.libspark.flartoolkit.core.utils.*;
	import org.libspark.flartoolkit.core.types.*
	/**
	 * クラス内定義ができない処理系では、LowResolutionLabelingSamplerOutItemで定義してください。
	 *
	 */
	public class LowResolutionLabelingSamplerOut_Item extends FLARManagedObject
	{
		/**
		 * ラべリング対象のエントリポイントです。
		 */
		public var entry_pos:FLARIntPoint2d=new FLARIntPoint2d();
		/**
		 * ラべリング対象の範囲を、トップレベル換算した値です。クリップ情報から計算されます。
		 */
		public var base_area:FLARIntRect =new FLARIntRect();
		/**
		 * ラべリング対象の範囲中心を、トップレベルに換算した値です。クリップ情報から計算されます。
		 */
		public var base_area_center:FLARIntPoint2d=new FLARIntPoint2d();
		/**
		 * エリア矩形の対角距離の2乗値
		 */
		public var base_area_sq_diagonal:int;
		
		public var lebeling_th:int;
		
		public function LowResolutionLabelingSamplerOut_Item(i_pool:IFLARManagedObjectPoolOperater)
		{
			super(i_pool);
		}
	}

}