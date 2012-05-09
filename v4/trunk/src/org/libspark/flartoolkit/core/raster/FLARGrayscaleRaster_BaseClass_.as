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
package jp.nyatla.nyartoolkit.as3.core.raster 
{
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.utils.as3.*;
	import jp.nyatla.nyartoolkit.as3.core.rasterdriver.*;
	import jp.nyatla.nyartoolkit.as3.core.labeling.rlelabeling.*;
	import jp.nyatla.nyartoolkit.as3.core.pixeldriver.*;
	import jp.nyatla.nyartoolkit.as3.core.squaredetect.*;
	import jp.nyatla.nyartoolkit.as3.*;
	import jp.nyatla.nyartoolkit.as3.core.*;
	import jp.nyatla.as3utils.*;

	
	
	
	
	/**
	 * このクラスは、グレースケース画像を格納するラスタクラスです。
	 * 外部バッファ、内部バッファの両方に対応します。
	 */
	public class NyARGrayscaleRaster implements INyARGrayscaleRaster
	{

		protected var _size:NyARIntSize;
		protected var _buffer_type:int;
		/**
		 * この関数は、ラスタの幅を返します。
		 */
		public function getWidth():int
		{
			return this._size.w;
		}
		/**
		 * この関数は、ラスタの高さを返します。
		 */
		public function getHeight():int
		{
			return this._size.h;
		}
		/**
		 * この関数は、ラスタのサイズを格納したオブジェクトを返します。
		 */
		public function getSize():NyARIntSize
		{
			return this._size;
		}
		/**
		 * この関数は、ラスタのバッファへの参照値を返します。
		 * バッファの形式は、コンストラクタに指定した形式と同じです。
		 */	
		public function getBufferType():int
		{
			return _buffer_type;
		}
		/**
		 * この関数は、ラスタの幅を返します。
		 */
		public function isEqualBufferType(i_type_value:int):Boolean
		{
			return this._buffer_type==i_type_value;
		}
		public function getGsPixelDriver():INyARGsPixelDriver
		{
			return this._pixdrv;
		}
		
		/** バッファオブジェクト*/
		protected var _buf:Object;
		/** バッファオブジェクトがアタッチされていればtrue*/
		protected var _is_attached_buffer:Boolean;
		protected var _pixdrv:INyARGsPixelDriver;

		
		public function NyARGrayscaleRaster(...args:Array)
		{
			switch(args.length) {
			case 1:
				if (args[0] is NyAS3Const_Inherited) {
					//blank
				}
				break;
			case 2:
				overload_NyARGrayscaleRaster_2ii(int(args[0]), int(args[1]));
				break;
			case 3:
				overload_NyARGrayscaleRaster_3iib(int(args[0]), int(args[1]),Boolean(args[2]));
				break;
			case 4:
				overload_NyARGrayscaleRaster_4iiib(int(args[0]), int(args[1]), int(args[2]),Boolean(args[3]));
				break;
			default:
				throw new NyARException();
			}			
		}
		
		/**
		 * コンストラクタです。
		 * 内部参照のバッファ（{@link NyARBufferType#INT1D_GRAY_8}形式）を持つインスタンスを生成します。
		 * @param i_width
		 * ラスタのサイズ
		 * @param i_height
		 * ラスタのサイズ
		 * @throws NyARException
		 */
		protected function overload_NyARGrayscaleRaster_2ii(i_width:int,i_height:int):void
		{
			this._size= new NyARIntSize(i_width,i_height);
			this._buffer_type=NyARBufferType.INT1D_GRAY_8;		
			initInstance(this._size, NyARBufferType.INT1D_GRAY_8, true);
		}
		/**
		 * コンストラクタです。
		 * 画像のサイズパラメータとバッファ参照方式を指定して、インスタンスを生成します。
		 * バッファの形式は、{@link NyARBufferType#INT1D_GRAY_8}です。
		 * @param i_width
		 * ラスタのサイズ
		 * @param i_height
		 * ラスタのサイズ
		 * @param i_is_alloc
		 * バッファを外部参照にするかのフラグ値。
		 * trueなら内部バッファ、falseなら外部バッファを使用します。
		 * falseの場合、初期のバッファはnullになります。インスタンスを生成したのちに、{@link #wrapBuffer}を使って割り当ててください。
		 * @throws NyARException
		 */
		protected function overload_NyARGrayscaleRaster_3iib(i_width:int,i_height:int,i_is_alloc:Boolean):void
		{
			this._size= new NyARIntSize(i_width,i_height);
			this._buffer_type=NyARBufferType.INT1D_GRAY_8;		
			initInstance(this._size, NyARBufferType.INT1D_GRAY_8, i_is_alloc);
		}

		/**
		 * コンストラクタです。
		 * 画像のサイズパラメータとバッファ形式を指定して、インスタンスを生成します。
		 * @param i_width
		 * ラスタのサイズ
		 * @param i_height
		 * ラスタのサイズ
		 * @param i_raster_type
		 * ラスタのバッファ形式。
		 * {@link NyARBufferType}に定義された定数値を指定してください。指定できる値は、以下の通りです。
		 * <ul>
		 * <li>{@link NyARBufferType#INT1D_GRAY_8}
		 * <ul>
		 * @param i_is_alloc
		 * バッファを外部参照にするかのフラグ値。
		 * trueなら内部バッファ、falseなら外部バッファを使用します。
		 * falseの場合、初期のバッファはnullになります。インスタンスを生成したのちに、{@link #wrapBuffer}を使って割り当ててください。
		 * @throws NyARException
		 */
		protected function overload_NyARGrayscaleRaster_4iiib(i_width:int,i_height:int,i_raster_type:int,i_is_alloc:Boolean):void
		{
			this._size= new NyARIntSize(i_width,i_height);
			this._buffer_type=i_raster_type;
			initInstance(this._size, i_raster_type, i_is_alloc);
		}

		/**
		 * このクラスの初期化シーケンスです。コンストラクタから呼び出します。初期化に失敗すると、例外を発生します。
		 * @param i_size
		 * ラスタサイズ
		 * @param i_raster_type
		 * バッファ形式
		 * @param i_is_alloc
		 * バッファ参照方法値
		 * @throws NyARException 
		 */
		protected function initInstance(i_size:NyARIntSize,i_raster_type:int,i_is_alloc:Boolean):void
		{
			switch (i_raster_type) {
			case NyARBufferType.INT1D_GRAY_8:
				this._buf = i_is_alloc ? new Vector.<int>(i_size.w * i_size.h) : null;
				break;
			default:
				throw new NyARException();
			}
			this._is_attached_buffer = i_is_alloc;
			//ピクセルドライバの生成
			this._pixdrv=NyARGsPixelDriverFactory.createDriver(this);
		}
		public function createInterface(i_iid:Class):Object
		{
			if(i_iid==NyARLabeling_Rle_IRasterDriver){
				return NyARLabeling_Rle_RasterDriverFactory.createDriver(this);
			}
			if(i_iid==NyARContourPickup_IRasterDriver){
				return NyARContourPickup_ImageDriverFactory.createDriver(this);
			}
			if(i_iid==INyARHistogramFromRaster){
				return NyARHistogramFromRasterFactory.createInstance(this);
			}
			throw new NyARException();
		}	
		/**
		 * この関数は、ラスタのバッファへの参照値を返します。
		 * バッファの形式は、コンストラクタに指定した形式と同じです。
		 */	
		public function getBuffer():Object
		{
			return this._buf;
		}

		/**
		 * この関数は、インスタンスがバッファを所有するかを返します。
		 * 内部参照バッファの場合は、常にtrueです。
		 * 外部参照バッファの場合は、バッファにアクセスする前に、このパラメタを確認してください。
		 */
		public function hasBuffer():Boolean
		{
			return this._buf != null;
		}
		/**
		 * この関数は、ラスタに外部参照バッファをセットします。
		 * 外部参照バッファを持つインスタンスでのみ使用できます。内部参照バッファを持つインスタンスでは使用できません。
		 */
		public function wrapBuffer(i_ref_buf:Object):void
		{
			NyAS3Utils.assert (!this._is_attached_buffer);// バッファがアタッチされていたら機能しない。
			//ラスタの形式は省略。
			this._pixdrv.switchRaster(this);
			this._buf = i_ref_buf;
		}
	}
}