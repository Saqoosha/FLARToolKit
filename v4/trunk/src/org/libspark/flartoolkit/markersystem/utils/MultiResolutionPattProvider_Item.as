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
package org.libspark.flartoolkit.markersystem.utils 
{
	import org.libspark.flartoolkit.core.types.*;
	import org.libspark.flartoolkit.core.raster.*;
	import org.libspark.flartoolkit.core.raster.rgb.*;
	import org.libspark.flartoolkit.core.rasterdriver.*;
	import org.libspark.flartoolkit.core.match.*;
	/**
	 * ...
	 * @author nyatla
	 */
	public class MultiResolutionPattProvider_Item 
	{
		public var _patt:IFLARRgbRaster;
		public var _patt_d:FLARMatchPattDeviationColorData;
		public var _patt_edge:int;
		public var _patt_resolution:int;
		public function MultiResolutionPattProvider_Item(i_patt_w:int, i_patt_h:int, i_edge_percentage:int)
		{
			var r:int=1;
			//解像度は幅を基準にする。
			while(i_patt_w*r<64){
				r*=2;
			}
			this._patt=new FLARRgbRaster(i_patt_w,i_patt_h,FLARBufferType.INT1D_X8R8G8B8_32,true);
			this._patt_d=new FLARMatchPattDeviationColorData(i_patt_w,i_patt_h);
			this._patt_edge=i_edge_percentage;
			this._patt_resolution=r;
		}
	}

}