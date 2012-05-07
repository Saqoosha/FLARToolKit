/* 
 * PROJECT: NyARToolkitAS3
 * --------------------------------------------------------------------------------
 * This work is based on the original ARToolKit developed by
 *   Hirokazu Kato
 *   Mark Billinghurst
 *   HITLab, University of Washington, Seattle
 * http://www.hitl.washington.edu/artoolkit/
 *
 * The NyARToolkitAS3 is AS3 edition ARToolKit class library.
 * Copyright (C)2010 Ryo Iizuka
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
package jp.nyatla.nyartoolkit.as3.core.pickup 
{
	import jp.nyatla.as3utils.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.rgb.*;
	import jp.nyatla.nyartoolkit.as3.core.rasterdriver.*;
	import jp.nyatla.nyartoolkit.as3.core.pixeldriver.*;
	import jp.nyatla.nyartoolkit.as3.core.utils.*;
	import jp.nyatla.nyartoolkit.as3.core.*;
	import jp.nyatla.nyartoolkit.as3.core.match.*;
	public class NyARColorPatt_Perspective implements INyARColorPatt
	{
		private var _edge:NyARIntPoint2d=new NyARIntPoint2d();
		/** パターン格納用のバッファ*/
		protected var _patdata:Vector.<int>;
		/** サンプリング解像度*/
		protected var _sample_per_pixel:int;
		/** このラスタのサイズ*/	
		protected var _size:NyARIntSize;
		private var _pixelreader:INyARRgbPixelDriver;
		private static const BUFFER_FORMAT:int=NyARBufferType.INT1D_X8R8G8B8_32;
		private function initInstance(i_width:int,i_height:int,i_point_per_pix:int):void
		{
			NyAS3Utils.assert(i_width>2 && i_height>2);
			this._sample_per_pixel=i_point_per_pix;	
			this._size=new NyARIntSize(i_width,i_height);
			this._patdata = new Vector.<int>(i_height*i_width);
			this._pixelreader=NyARRgbPixelDriverFactory.createDriver(this);
			return;
		}
		public function NyARColorPatt_Perspective(...args:Array)
		{
			switch(args.length) {
			case 1:
				if (args[0] is NyAS3Const_Inherited) {
					//blank
				}
				break;
			case 3:
				NyARColorPatt_Perspective_3iii(int(args[0]), int(args[1]),int(args[2]));
				break;
			case 4:
				NyARColorPatt_Perspective_4iii(int(args[0]), int(args[1]),int(args[2]),int(args[3]));
				break;
			default:
				throw new NyARException();
			}			
		}

		/**
		 * コンストラクタです。
		 * エッジサイズ0,入力ラスタタイプの制限無しでインスタンスを作成します。
		 *　高速化が必要な時は、入力ラスタタイプを制限するコンストラクタを使ってください。
		 * @param i_width
		 * 取得画像の解像度幅
		 * @param i_height
		 * 取得画像の解像度高さ
		 * @param i_point_per_pix
		 * 1ピクセルあたりの縦横サンプリング数。2なら2x2=4ポイントをサンプリングする。
		 * @throws NyARException 
		 */
		private function NyARColorPatt_Perspective_3iii(i_width:int , i_height:int, i_point_per_pix:int):void
		{
			this.initInstance(i_width,i_height,i_point_per_pix);
			this._edge.setValue_3(0,0);
			return;
		}
		/**
		 * コンストラクタです。
		 * エッジサイズ,入力ラスタタイプの制限を指定してインスタンスを作成します。
		 * @param i_width
		 * 取得画像の解像度幅
		 * @param i_height
		 * 取得画像の解像度高さ
		 * @param i_point_per_pix
		 * 1ピクセルあたりの解像度
		 * @param i_edge_percentage
		 * エッジ幅の割合(ARToolKit標準と同じなら、25)
		 * @throws NyARException 
		 */
		private function NyARColorPatt_Perspective_4iii(i_width:int, i_height:int,i_point_per_pix:int,i_edge_percentage:int):void
		{
			this.initInstance(i_width,i_height,i_point_per_pix);
			this._edge.setValue_3(i_edge_percentage, i_edge_percentage);
			return;
		}
		/**
		 * 矩形領域のエッジ（枠）サイズを、割合で指定します。
		 * @param i_x_percent
		 * 左右のエッジの割合です。0から50の間の数で指定します。
		 * @param i_y_percent
		 * 上下のエッジの割合です。0から50の間の数で指定します。
		 * @param i_sample_per_pixel
		 * 1ピクセルあたりの縦横サンプリング数。2なら2x2=4ポイントをサンプリングする。
		 */
		public function setEdgeSizeByPercent(i_x_percent:int,i_y_percent:int,i_sample_per_pixel:int):void
		{
			NyAS3Utils.assert(i_x_percent>=0);
			NyAS3Utils.assert(i_y_percent>=0);
			this._edge.setValue_3(i_x_percent, i_y_percent);
			this._sample_per_pixel=i_sample_per_pixel;
			return;
		}
		/**
		 * この関数はラスタの幅を返します。
		 */
		public function getWidth():int
		{
			return this._size.w;
		}
		/**
		 * この関数はラスタの高さを返します。
		 */
		public function getHeight():int
		{
			return this._size.h;
		}
		/**
		 * この関数はラスタのサイズの参照値を返します。
		 */
		public function getSize():NyARIntSize
		{
			return 	this._size;
		}
		/**
		 * この関数は、ラスタの画素読み取りオブジェクトの参照値を返します。
		 */	
		public function getRgbPixelDriver():INyARRgbPixelDriver
		{
			return this._pixelreader;
		}
		/**
		 * この関数は、ラスタ画像のバッファを返します。
		 * バッファ形式は、{@link NyARBufferType#INT1D_X8R8G8B8_32}(int[])です。
		 */	
		public function getBuffer():Object
		{
			return this._patdata;
		}
		/**
		 * この関数は、インスタンスがバッファを所有しているかを返します。基本的にtrueです。
		 */	
		public function hasBuffer():Boolean
		{
			return this._patdata!=null;
		}
		/**
		 * この関数は使用不可能です。
		 */
		public function wrapBuffer(i_ref_buf:Object):void
		{
			NyARException.notImplement();
		}
		/**
		 * この関数は、バッファタイプの定数を返します。
		 */
		public function getBufferType():int
		{
			return BUFFER_FORMAT;
		}
		/**
		 * この関数は、インスタンスのバッファタイプが引数のものと一致しているか判定します。
		 */	
		public function isEqualBufferType(i_type_value:int):Boolean
		{
			return BUFFER_FORMAT==i_type_value;
		}
		private var _last_input_raster:INyARRgbRaster=null;
		private var _raster_driver:INyARPerspectiveCopy;
		/**
		 * この関数は、ラスタのi_vertexsで定義される四角形からパターンを取得して、インスタンスに格納します。
		 */
		public function pickFromRaster(image:INyARRgbRaster,i_vertexs:Vector.<NyARIntPoint2d>):Boolean
		{
			if(this._last_input_raster!=image){
				this._raster_driver=INyARPerspectiveCopy(image.createInterface(INyARPerspectiveCopy));
				this._last_input_raster=image;
			}
			//遠近法のパラメータを計算
			return this._raster_driver.copyPatt(i_vertexs,this._edge.x,this._edge.y,this._sample_per_pixel, this);
		}

		public function createInterface(iIid:Class):Object
		{
			if(iIid==INyARPerspectiveCopy){
				return NyARPerspectiveCopyFactory.createDriver(this);
			}
			if(iIid==NyARMatchPattDeviationColorData_IRasterDriver){
				return NyARMatchPattDeviationColorData_RasterDriverFactory.createDriver(this);
			}		
			throw new NyARException();
		}

	}
}
