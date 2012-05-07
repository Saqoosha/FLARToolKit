package jp.nyatla.nyartoolkit.as3.rpf.tracker.nyartk.status
{
	import jp.nyatla.nyartoolkit.as3.core.utils.*;


	/**
	 * TargetStatusの基礎クラスです。TargetStatusは、ステータス毎に異なるターゲットのパラメータを格納します。
	 * @note
	 * ST_から始まるID値は、NyARTrackerのコンストラクタと密接に絡んでいるので、変更するときは気をつけて！
	 *
	 */
	public class NyARTargetStatus extends NyARManagedObject
	{
		public static var ST_IGNORE:int=0;
		public static var ST_NEW:int=1;
		public static var ST_RECT:int=2;
		public static var ST_CONTURE:int=3;
		public static var MAX_OF_ST_KIND:int=3;
		public function NyARTargetStatus(iRefPoolOperator:INyARManagedObjectPoolOperater)
		{
			super(iRefPoolOperator);
		}
	}
}