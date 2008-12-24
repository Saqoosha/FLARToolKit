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
	import org.libspark.flartoolkit.core.FLARSquare;
	import org.libspark.flartoolkit.core.param.FLARParam;
	import org.libspark.flartoolkit.core.raster.rgb.IFLARRgbRaster;
	import org.libspark.flartoolkit.FLARException;
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
			super(src, param, code, markerWidth, confidence, thresh);
			this._model = model;
		}

		override public function update():void 
		{
			try {
				if (this._detector.detectMarkerLite(this._source, this._thresh) &&
					this._detector.getConfidence() > this._confidence) {
					this._detector.getTransformMatrix(this._resultMat);
					this._model.setTransformMatrix(this._resultMat);
					this._model.visible = true;
					
					this.drawSquare();
				} else {
					this._model.visible = false;
				}
			}catch (e:FLARException) {
				this._model.visible = false;
			}
		}
		
		private function drawSquare():void 
		{
			var square:FLARSquare = this._detector.getSquare();
			var v:Array;
			v = square.imvertex;
			this.graphics.clear();
			this.graphics.lineStyle(4,0xFF0000);
			this.graphics.moveTo(v[3].x, v[3].y);
			for (var vi:int = 0; vi < v.length; vi++) {
				this.graphics.lineTo(v[vi].x, v[vi].y);
			}
		}
	}
}