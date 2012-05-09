package org.libspark.flartoolkit.rpf.tracker.nyartk.status
{
	import org.libspark.flartoolkit.core.utils.*;


	/**
	 * TargetStatusの基礎クラスです。TargetStatusは、ステータス毎に異なるターゲットのパラメータを格納します。
	 * @note
	 * ST_から始まるID値は、FLARTrackerのコンストラクタと密接に絡んでいるので、変更するときは気をつけて！
	 *
	 */
	public class FLARTargetStatus extends FLARManagedObject
	{
		public static var ST_IGNORE:int=0;
		public static var ST_NEW:int=1;
		public static var ST_RECT:int=2;
		public static var ST_CONTURE:int=3;
		public static var MAX_OF_ST_KIND:int=3;
		public function FLARTargetStatus(iRefPoolOperator:IFLARManagedObjectPoolOperater)
		{
			super(iRefPoolOperator);
		}
	}
}