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
	import flash.display.Graphics;
	import org.libspark.flartoolkit.core.param.FLARParam;
	import org.libspark.flartoolkit.core.raster.rgb.IFLARRgbRaster;
	import org.libspark.flartoolkit.core.transmat.FLARTransMatResult;
	import org.libspark.flartoolkit.detector.CubeMarkerDetector;
	import org.libspark.flartoolkit.detector.FLARMultiMarkerDetectorResult;
	
	/**
	 * ...
	 * @author 太郎(tarotaro.org)
	 */
	public class FLARMultiMarkerLayer extends FLARLayer
	{
		protected var _detector:CubeMarkerDetector;
		protected var _resultMat:FLARTransMatResult;
		protected var _confidence:Number;
		
		private var colors:Array = [
			0xFF0000,0x00FF00,0x0000FF,0xFFFF00,0xFF00FF
		];
		public function FLARMultiMarkerLayer(src:IFLARRgbRaster, 
												param:FLARParam, 
												codeList:Array, 
												markerWidthList:Array, 
												confidence:Number = 0.65,
												thresh:int = 100) 
		{
			super(src, thresh);
			this._detector = new CubeMarkerDetector(param, codeList, markerWidthList, codeList.length);
			this._detector.sizeCheckEnabled = false;
			this._resultMat = new FLARTransMatResult();
			this._confidence = confidence;
		}
		
		override public function update():void 
		{
			var g:Graphics = this.graphics;
			g.clear();

			//var numDetected:int = this._detector.detectMarkerLite(this._source, this._thresh);
			var r:FLARMultiMarkerDetectorResult = this._detector.detectMarkerLite(this._source, this._thresh);
			if (r != null) {
			//if (numDetected > 0) {
				//trace(numDetected);
				//for (var i:uint = 0; i < numDetected; i++) {
					//var r:FLARMultiMarkerDetectorResult = this._detector.getResult(i);
					trace(r.codeId,":",r.confidence);
					//if (r.confidence <= this._confidence) {
						//continue;
					//}
					var v:Array = r.square.sqvertex;
					g.lineStyle(2, colors[r.codeId]);
					g.moveTo(v[3].x, v[3].y);
					for (var vi:int = 0; vi < v.length; vi++) {
						g.lineTo(v[vi].x, v[vi].y);
					}
				//}
			}
		}
		
	}
	
}