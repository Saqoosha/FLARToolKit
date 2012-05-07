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

	import jp.nyatla.nyartoolkit.as3.core.*;
	import jp.nyatla.nyartoolkit.as3.core.match.*;


	/**
	 * このクラスは、ARマーカの検出結果を保存するデータクラスです。
	 */
	public class MarkerInfoARMarker extends TMarkerData
	{
		/** MK_ARの情報。比較のための、ARToolKitマーカを格納します。*/
		public var matchpatt:NyARMatchPatt_Color_WITHOUT_PCA;
		/** MK_ARの情報。検出した矩形の格納変数。マーカの一致度を格納します。*/
		public var cf:Number;
		public var patt_w:int;
		public var patt_h:int;
		/** MK_ARの情報。パターンのエッジ割合。*/
		public var patt_edge_percentage:int;
		/** */
		public function MarkerInfoARMarker(i_patt:NyARCode,i_patt_edge_percentage:int,i_patt_size:Number)
		{
			super();
			this.matchpatt=new NyARMatchPatt_Color_WITHOUT_PCA(i_patt);
			this.patt_edge_percentage=i_patt_edge_percentage;
			this.marker_offset.setSquare(i_patt_size);
			this.patt_w=i_patt.getWidth();
			this.patt_h=i_patt.getHeight();
			return;
		}		
	}
}