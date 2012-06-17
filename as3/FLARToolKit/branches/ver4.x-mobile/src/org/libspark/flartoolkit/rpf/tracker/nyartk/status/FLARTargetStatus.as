/* 
 * PROJECT: FLARToolKit
 * --------------------------------------------------------------------------------
 * This work is based on the FLARToolKit developed by
 *   R.Iizuka (nyatla)
 * http://nyatla.jp/nyatoolkit/
 *
 * The FLARToolKit is ActionScript 3.0 version ARToolkit class library.
 * Copyright (C)2008 Saqoosha
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * For further information please contact.
 *	http://www.libspark.org/wiki/saqoosha/FLARToolKit
 *	<saq(at)saqoosha.net>
 * 
 */
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