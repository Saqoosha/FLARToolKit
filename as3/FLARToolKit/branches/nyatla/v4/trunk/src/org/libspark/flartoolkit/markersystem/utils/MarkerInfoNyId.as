/* 
 * PROJECT: FLARToolkit(Extension)
 * --------------------------------------------------------------------------------
 * The FLARToolkit is Java edition ARToolKit class library.
 * Copyright (C)2008-2009 Ryo Iizuka
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
 *	http://nyatla.jp/nyatoolkit/
 *	<airmail(at)ebony.plala.or.jp> or <nyatla(at)nyatla.jp>
 * 
 */
package org.libspark.flartoolkit.markersystem.utils
{

	import org.libspark.flartoolkit.core.*;

	/**
	 * このクラスは、NyIdマーカの検出結果を保存するデータクラスです。
	 */
	public class MarkerInfoNyId extends TMarkerData
	{
		/** MK_NyIdの情報。 反応するidの開始レンジ*/
		public var nyid_range_s:Number;
		/** MK_NyIdの情報。 反応するidの終了レンジ*/
		public var nyid_range_e:Number;
		/** MK_NyIdの情報。 実際のid値*/
		public var nyid:Number;
		public var dir:int;
		/**
		 * コンストラクタです。初期値から、Idマーカのインスタンスを生成します。
		 * @param i_range_s
		 * @param i_range_e
		 * @param i_patt_size
		 * @throws FLARException
		 */
		public function MarkerInfoNyId(i_nyid_range_s:Number,i_nyid_range_e:Number,i_patt_size:Number)
		{
			super();
			this.marker_offset.setSquare(i_patt_size);
			this.nyid_range_s=i_nyid_range_s;
			this.nyid_range_e=i_nyid_range_e;
			return;
		}		
	}
}