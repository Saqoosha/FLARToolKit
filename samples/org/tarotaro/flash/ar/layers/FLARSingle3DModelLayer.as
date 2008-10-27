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
	import com.libspark.flartoolkit.core.FLARCode;
	import com.libspark.flartoolkit.core.FLARParam;
	import com.libspark.flartoolkit.core.FLARTransMatResult;
	import com.libspark.flartoolkit.core.raster.FLARBitmapData;
	import com.libspark.flartoolkit.detector.FLARSingleMarkerDetector;
	import com.libspark.flartoolkit.scene.FLARBaseNode;
	import org.libspark.flartoolkit.core.FLARCode;
	import org.libspark.flartoolkit.core.param.FLARParam;
	import org.libspark.flartoolkit.core.raster.rgb.IFLARRgbRaster;
	import org.libspark.flartoolkit.pv3d.FLARBaseNode;
	
	/**
	* ...
	* @author 太郎
	*/
	public class FLARSingle3DModelLayer extends FLARSingleMarkerLayer
	{
		private var _model:FLARBaseNode;

		/**
		 * 
		 * @param	src
		 * @param	param
		 * @param	code
		 * @param	markerWidth
		 * @param	confidence
		 * @param	thresh
		 */
		public function FLARSingle3DModelLayer(src:IFLARRgbRaster, 
												param:FLARParam,
												code:FLARCode,
												markerWidth:Number, 
												model:FLARBaseNode,
												confidence:Number = 0.65,
												thresh:int=100) 
		{
			super(src, param, code, markerWidth, thresh);
			this._model = model;
		}

		override public function update():void 
		{
			if (this._detector.detectMarkerLite(this._source, this._thresh) &&
				this._detector.getConfidence() > this._confidence) {
				this._detector.getTranslationMatrix(this._resultMat);
				this._model.setTranslationMatrix(this._resultMat);
				this._model.visible = true;
			} else {
				this._model.visible = false;
			}
		}
	}
}