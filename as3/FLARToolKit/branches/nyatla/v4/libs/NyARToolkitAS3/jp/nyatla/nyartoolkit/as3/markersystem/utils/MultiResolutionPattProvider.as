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

	import jp.nyatla.as3utils.*;
	import jp.nyatla.nyartoolkit.as3.core.NyARException;
	import jp.nyatla.nyartoolkit.as3.core.match.NyARMatchPattDeviationColorData;
	import jp.nyatla.nyartoolkit.as3.core.raster.rgb.*;
	import jp.nyatla.nyartoolkit.as3.core.rasterdriver.INyARPerspectiveCopy;
	import jp.nyatla.nyartoolkit.as3.core.types.*;


	/**
	 * このクラスは、複数の異なる解像度の比較画像を保持します。
	 * ARマーカの検出に使用します。
	 */
	public class MultiResolutionPattProvider
	{
		/**
		 * インスタンスのキャッシュ
		 */
		private var items:Vector.<MultiResolutionPattProvider_Item>=new Vector.<MultiResolutionPattProvider_Item>();
		/**
		 * [readonly]マーカにマッチした{@link NyARMatchPattDeviationColorData}インスタンスを得る。
		 * @throws NyARException 
		 */
		public function getDeviationColorData(i_marker:MarkerInfoARMarker,i_pix_drv:INyARPerspectiveCopy,i_vertex:Vector.<NyARIntPoint2d>):NyARMatchPattDeviationColorData
		{
			var mk_edge:int=i_marker.patt_edge_percentage;
			for(var i:int=this.items.length-1;i>=0;i--)
			{
				var ptr:MultiResolutionPattProvider_Item=this.items[i];//this.items.get(i);
				if(!ptr._patt.getSize().isEqualSize(i_marker.patt_w,i_marker.patt_h) || ptr._patt_edge!=mk_edge)
				{
					//サイズとエッジサイズが合致しない物はスルー
					continue;
				}
				//古かったら更新
				i_pix_drv.copyPatt(i_vertex,ptr._patt_edge,ptr._patt_edge,ptr._patt_resolution,ptr._patt);
				ptr._patt_d.setRaster(ptr._patt);
				return ptr._patt_d;
			}
			//無い。新しく生成
			var item:MultiResolutionPattProvider_Item=new MultiResolutionPattProvider_Item(i_marker.patt_w,i_marker.patt_h,mk_edge);
			//タイムスタンプの更新とデータの生成
			i_pix_drv.copyPatt(i_vertex,item._patt_edge,item._patt_edge,item._patt_resolution,item._patt);
			item._patt_d.setRaster(item._patt);
			this.items.push(item);
			return item._patt_d;
		}
		
	}
}