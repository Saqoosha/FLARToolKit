/* 
 * PROJECT: FLARToolKit
 * --------------------------------------------------------------------------------
 * This work is based on the NyARToolKit developed by
 *   R.Iizuka (nyatla)
 * http://nyatla.jp/nyatoolkit/
 *
 * The FLARToolKit is ActionScript 3.0 version ARToolkit class library.
 * Copyright (C)2008 Saqoosha
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this framework; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 * 
 * For further information please contact.
 *	http://www.libspark.org/wiki/saqoosha/FLARToolKit
 *	<saq(at)saqoosha.net>
 * 
 * For further information of this Class please contact.
 *	http://www.libspark.org/wiki/saqoosha/FLARToolKit
 *	<taro(at)tarotaro.org>
 *
 */
package org.tarotaro.flash.ar.layers 
{
	import org.libspark.flartoolkit.core.FLARCode;
	import org.libspark.flartoolkit.core.param.FLARParam;
	import org.libspark.flartoolkit.core.raster.IFLARRaster;
	import org.libspark.flartoolkit.core.raster.rgb.IFLARRgbRaster;
	import org.libspark.flartoolkit.core.transmat.FLARTransMatResult;
	import org.libspark.flartoolkit.detector.FLARSingleMarkerDetector;
	
	/**
	* ...
	* @author 太郎
	*/
	public class FLARSingleMarkerLayer extends FLARLayer
	{
		protected var _detector:FLARSingleMarkerDetector;
		protected var _resultMat:FLARTransMatResult;
		
		/**
		 * 単一マーカ用レイヤ
		 * @param	src
		 * @param	param
		 * @param	code
		 * @param	markerWidth
		 * @param	thresh
		 */
		public function FLARSingleMarkerLayer(src:IFLARRgbRaster, 
												param:FLARParam, 
												code:FLARCode, 
												markerWidth:Number, 
												thresh:int = 100) 
		{
			super(src, thresh);
			this._detector = new FLARSingleMarkerDetector(param, code, markerWidth);
			this._resultMat = new FLARTransMatResult();
		}
	}
	
}