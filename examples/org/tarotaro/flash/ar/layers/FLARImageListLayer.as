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
	import caurina.transitions.AuxFunctions;
	import com.libspark.flartoolkit.core.FLARCode;
	import com.libspark.flartoolkit.core.FLARParam;
	import com.libspark.flartoolkit.core.FLARSquare;
	import com.libspark.flartoolkit.core.raster.FLARBitmapData;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import org.flashsandy.display.DistortImage;
	import org.tarotaro.flash.display.ImageList;
	
	/**
	* ...
	* @author 太郎
	*/
	public class FLARImageListLayer extends FLARSingleMarkerLayer
	{
		private var _comics:ImageList;
		private var _timer:Timer;
		private var _currentCount:int;
		private var _distort:DistortImage;
		private var _square:FLARSquare;
		private var _bitmap:BitmapData;

		public function FLARImageListLayer(src:FLARBitmapData,param:FLARParam,code:FLARCode,markerWidth:Number,comic:ImageList,thresh:int = 100) 
		{
			super(src, param, code, markerWidth, thresh);
			//checkComic(comic);
			this._comics = comic;
			this._timer = new Timer(3000, 0);
			this._bitmap = new BitmapData(200, 163);
			this._distort = new DistortImage(200, 163, 4, 4);
			this._timer.addEventListener(TimerEvent.TIMER, function(e:TimerEvent):void {
				trace("reset go");
				_currentCount = 0;
			});
			this._timer.start();
			this._currentCount = 0;
		}

		override public function update():void 
		{
			this.graphics.clear();
			if (this._detector.detectMarkerLite(this._source, this._thresh) && this._detector.getConfidence() >= 0.5) {
				this._timer.reset();
				this._timer.start();
				this._detector.getTranslationMatrix(this._resultMat);
				this._square = this._detector.getSquare();
				var image:IBitmapDrawable = this._comics.getImage(this._currentCount);
				trace(this._currentCount+1, "枚目のイメージ");
				this._bitmap.draw(image);
				var points:Array = new Array();
				for (var i:uint = 0; i < 4; i++) {
					points.push(new Point(this._square.sqvertex[i][0], this._square.sqvertex[i][1]));
				}
				this._distort.setTransform(this.graphics, this._bitmap, points[2], points[3], points[0], points[1]);
				this.visible = true;
			} else {
				trace("発見できず");
				if (this.visible) {
					this._currentCount = (this._currentCount + 1) % this._comics.length;
				}
				this.visible = false;
			}
		}
	}
	
}