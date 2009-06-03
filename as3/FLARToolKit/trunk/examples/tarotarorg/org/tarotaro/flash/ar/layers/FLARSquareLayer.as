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
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.PixelSnapping;
	import flash.display.Shape;
	import org.libspark.flartoolkit.core.FLARSquare;
	import org.libspark.flartoolkit.core.FLARSquareDetector;
	import org.libspark.flartoolkit.core.FLARSquareStack;
	import org.libspark.flartoolkit.core.param.FLARParam;
	import org.libspark.flartoolkit.core.raster.FLARRaster_BitmapData;
	import org.libspark.flartoolkit.core.raster.IFLARRaster;
	import org.libspark.flartoolkit.core.raster.rgb.IFLARRgbRaster;
	import org.libspark.flartoolkit.core.rasterfilter.rgb2bin.FLARRasterFilter_BitmapDataThreshold;
	import org.libspark.flartoolkit.core.types.FLARIntSize;
	
	/**
	* 
	* @author 太郎
	*/
	public class FLARSquareLayer extends FLARLayer
	{
		private var _detector:FLARSquareDetector;
		private var _stack:FLARSquareStack;

		private var _thickness:Number=NaN;
		private var _color:uint=0;
		private var _alpha:Number=1.0;
		private var _pixelHinting:Boolean=false;
		private var _scaleMode:String=LineScaleMode.NORMAL;
		private var _caps:String=null;
		private var _joints:String=null;
		private var _miterLimit:Number = 3;
		private var _monoSrc:IFLARRaster;
		private var _filter:FLARRasterFilter_BitmapDataThreshold;

		/**
		 * 
		 * @param	src
		 * @param	param
		 * @param	thresh
		 */
		public function FLARSquareLayer(src:IFLARRgbRaster, param:FLARParam, thresh:int=100) 
		{
			super(src,thresh);
			this._stack = new FLARSquareStack(10);
			this._detector = new FLARSquareDetector(param.getDistortionFactor(), param.getScreenSize());
			this._filter = new FLARRasterFilter_BitmapDataThreshold(thresh);
			this._monoSrc = new FLARRaster_BitmapData(src.getWidth(), src.getHeight());
		}
		
		/**
		 * sourceに対してSquareの検索を行い、発見したSquareを描画する
		 */
		override public function update():void
		{
			this._filter.doFilter(this._source, this._monoSrc);
			this._detector.detectMarker(this._monoSrc, this._stack);
			this.graphics.clear();
			var squareNum:int = this._stack.getLength();
			var square:FLARSquare;
			var v:Array;

			for (var i:int = 0; i < squareNum; i++) {
				square = this._stack.getItem(i) as FLARSquare;
				if (square == null) {
					trace(square, i,"nullです");
					continue;
				}
				v = square.sqvertex;
				this.graphics.lineStyle(this._thickness, 
										this._color, 
										this._alpha, 
										this._pixelHinting, 
										this._scaleMode, 
										this._caps, 
										this._joints, 
										this._miterLimit);
				this.graphics.moveTo(v[3].x, v[3].y);
				for (var vi:int = 0; vi < v.length; vi++) {
					this.graphics.lineTo(v[vi].x, v[vi].y);
				}
			}
			
		}
		
		public function lineStyle(thickness:Number=NaN,color:uint=0,alpha:Number=1.0,pixelHinting:Boolean=false,scaleMode:String=LineScaleMode.NORMAL,caps:String=null,joints:String=null,miterLimit:Number=3) :void
		{
			this._thickness = thickness;
			this._color = color;
			this._alpha = alpha ;
			this._pixelHinting = pixelHinting ;
			this._scaleMode = scaleMode ;
			this._caps = caps ;
			this._joints = joints ;
			this._miterLimit = miterLimit ;
		}

	}
	
}