package org.libspark.flartoolkit.core.raster.rgb
{
	import flash.display.BitmapData;
	
	import org.libspark.flartoolkit.core.FLARException;
	import org.libspark.flartoolkit.core.pixeldriver.IFLARRgbPixelDriver;
	import org.libspark.flartoolkit.core.types.FLARIntSize;
	
	internal class FLARRgbPixelDriver_AsBitmap implements IFLARRgbPixelDriver
	{
		/** 参照する外部バッファ */
		private var _ref_raster:FLARRgbRaster;
		private var _ref_size:FLARIntSize;
		public function getSize():FLARIntSize
		{
			return this._ref_size;
		}
		/**
		 * この関数は、指定した座標の1ピクセル分のRGBデータを、配列に格納して返します。
		 */
		public function getPixel(i_x:int,i_y:int,o_rgb:Vector.<int>):void
		{
			var c:int = this._ref_raster.getBitmapData().getPixel(i_x, i_y);
			o_rgb[0] = (c >> 16) & 0xff;// R
			o_rgb[1] = (c >> 8) & 0xff;// G
			o_rgb[2] = c & 0xff;// B
			return;
		}
		
		/**
		 * この関数は、座標群から、ピクセルごとのRGBデータを、配列に格納して返します。
		 */
		public function getPixelSet(i_x:Vector.<int>,i_y:Vector.<int>,i_num:int,o_rgb:Vector.<int>):void
		{
			var bm:BitmapData = this._ref_raster.getBitmapData();
			for (var i:int = i_num - 1; i >= 0; i--)
			{
				var c:int = bm.getPixel(i_x[i], i_y[i]);
				o_rgb[0] = (c >> 16) & 0xff;// R
				o_rgb[1] = (c >> 8) & 0xff;// G
				o_rgb[2] = c & 0xff;// B
			}
			return;
		}
		public function setPixel_2(i_x:int, i_y:int, i_rgb:Vector.<int>):void
		{
			var bm:BitmapData = this._ref_raster.getBitmapData();
			var pix:int = (0x00ff0000 & (i_rgb[0] << 16)) | (0x0000ff00 & (i_rgb[1] << 8)) | (0x0000ff & (i_rgb[2]));
			bm.setPixel(i_x,i_y,pix);
			return;
		}
		public function setPixel(i_x:int, i_y:int, i_r:int, i_g:int, i_b:int):void
		{
			var bm:BitmapData = this._ref_raster.getBitmapData();
			var pix:int = (0x00ff0000 & (i_r << 16)) | (0x0000ff00 & (i_g << 8)) | (0x0000ff & (i_b));
			bm.setPixel(i_x,i_y,pix);
			return;
		}
		
		public function setPixels(i_x:Vector.<int>, i_y:Vector.<int>, i_num:int, i_intrgb:Vector.<int>):void
		{
			FLARException.notImplement();
		}
		
		public function switchRaster( i_raster:IFLARRgbRaster):void
		{
			this._ref_raster = FLARRgbRaster(i_raster);
			this._ref_size = i_raster.getSize();
		}
	}
}