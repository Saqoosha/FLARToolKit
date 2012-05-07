/* 
 * PROJECT: NyARToolkit(Extension)
 * --------------------------------------------------------------------------------
 * The NyARToolkit is Java edition ARToolKit class library.
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
package jp.nyatla.nyartoolkit.as3.markersystem.utils
{

	import jp.nyatla.nyartoolkit.as3.core.transmat.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;

	/**
	 * このクラスは、マーカ情報を格納するためのクラスです。
	 */
	public class TMarkerData
	{
		/** 最後に認識したタイムスタンプ。*/
		public var time_stamp:int;
		/** ライフ値
		 * マーカ検出時にリセットされ、1フレームごとに1づつインクリメントされる値です。
		 */
		public var life:int;
		/** MK情報。マーカのオフセット位置。*/
		public var marker_offset:NyARRectOffset=new NyARRectOffset();			
		/** 検出した矩形の格納変数。理想形二次元座標を格納します。*/
		public var sq:SquareStack_Item;
		/** 検出した矩形の格納変数。マーカの姿勢行列を格納します。*/
		public var tmat:NyARTransMatResult=new NyARTransMatResult();
		/** 矩形の検出状態の格納変数。 連続して見失った回数を格納します。*/
		public var lost_count:int=int.MAX_VALUE;
		/** トラッキングログ用の領域*/
		public var tl_vertex:Vector.<NyARIntPoint2d>=NyARIntPoint2d.createArray(4);
		public var tl_center:NyARIntPoint2d=new NyARIntPoint2d();
		public var tl_rect_area:int;
		public function TMarkerData()
		{
			this.life=0;
		}
	}
}