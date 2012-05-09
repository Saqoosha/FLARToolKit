package org.libspark.flartoolkit.core.raster.rgb 
{
	import org.libspark.flartoolkit.core.pixeldriver.*;
	import org.libspark.flartoolkit.core.rasterdriver.*;
	import org.libspark.flartoolkit.core.rasterfilter.rgb2gs.*;
	import org.libspark.flartoolkit.core.match.*;
	import org.libspark.flartoolkit.core.types.*;
	import org.libspark.flartoolkit.core.*;
	import jp.nyatla.as3utils.*;
	
	public class FLARRgbRaster_BaseClass_ extends FLARRgbRaster_BasicClass
	{
		protected var _buf:Object;
		/** ピクセルリーダ*/
		protected var _rgb_pixel_driver:IFLARRgbPixelDriver;
		/**
		 * バッファオブジェクトがアタッチされていればtrue
		 */
		protected var _is_attached_buffer:Boolean;

		
		public function FLARRgbRaster_BaseClass_(...args:Array)
		{
			super(NyAS3Const_Inherited);
			switch(args.length){
			case 1:
				if (args[0] is NyAS3Const_Inherited) {
					//blank
				}
				break;
			case 2:
				overload_FLARRgbRaster_2ii(int(args[0]), int(args[1]));
				break;
			case 3:
				overload_FLARRgbRaster_3iii(int(args[0]), int(args[1]),int(args[2]));
				break;
			case 4:
				overload_FLARRgbRaster_4iiib(int(args[0]), int(args[1]),int(args[2]),Boolean(args[3]));
				break;
			default:
				throw new FLARException();
			}			
		}
		/**
		 * コンストラクタです。
		 * 画像サイズを指定してインスタンスを生成します。
		 * @param i_width
		 * ラスタのサイズ
		 * @param i_height
		 * ラスタのサイズ
		 * @throws FLARException
		 */
		protected function overload_FLARRgbRaster_2ii(i_width:int,i_height:int):void
		{
			super.overload_FLARRgbRaster_BasicClass(i_width,i_height,FLARBufferType.INT1D_X8R8G8B8_32);
			if(!initInstance(this._size,FLARBufferType.INT1D_X8R8G8B8_32,true)){
				throw new FLARException();
			}
		}		
		/**
		 * 
		 * @param i_width
		 * @param i_height
		 * @param i_raster_type
		 * FLARBufferTypeに定義された定数値を指定してください。
		 * @param i_is_alloc
		 * @throws FLARException
		 */
		protected function overload_FLARRgbRaster_4iiib(i_width:int,i_height:int,i_raster_type:int,i_is_alloc:Boolean):void
		{
			super.overload_FLARRgbRaster_BasicClass(i_width,i_height,i_raster_type);
			if(!initInstance(this._size,i_raster_type,i_is_alloc)){
				throw new FLARException();
			}
		}
		/**
		 * 
		 * @param i_width
		 * @param i_height
		 * @param i_raster_type
		 * FLARBufferTypeに定義された定数値を指定してください。
		 * @throws FLARException
		 */
		protected function overload_FLARRgbRaster_3iii(i_width:int, i_height:int, i_raster_type:int):void
		{
			super.overload_FLARRgbRaster_BasicClass(i_width,i_height,i_raster_type);
			if(!initInstance(this._size,i_raster_type,true)){
				throw new FLARException();
			}
		}
		
		/**
		 * Readerとbufferを初期化する関数です。コンストラクタから呼び出します。
		 * 継承クラスでこの関数を拡張することで、対応するバッファタイプの種類を増やせます。
		 * @param i_size
		 * @param i_raster_type
		 * @param i_is_alloc
		 * @return
		 */
		protected function initInstance(i_size:FLARIntSize,i_raster_type:int,i_is_alloc:Boolean):Boolean
		{
			//バッファの構築
			switch(i_raster_type)
			{
				case FLARBufferType.INT1D_X8R8G8B8_32:
					this._buf=i_is_alloc?new Vector.<int>(i_size.w*i_size.h):null;
					break;
				default:
					return false;
			}
			//readerの構築
			this._rgb_pixel_driver=FLARRgbPixelDriverFactory.createDriver(this);
			this._is_attached_buffer=i_is_alloc;
			return true;
		}
		public override function getRgbPixelDriver():IFLARRgbPixelDriver
		{
			return this._rgb_pixel_driver;
		}
		public override function getBuffer():Object
		{
			return this._buf;
		}
		public override function hasBuffer():Boolean
		{
			return this._buf!=null;
		}
		public override function wrapBuffer(i_ref_buf:Object):void
		{
			NyAS3Utils.assert(!this._is_attached_buffer);//バッファがアタッチされていたら機能しない。
			this._buf=i_ref_buf;
			//ピクセルリーダーの参照バッファを切り替える。
			this._rgb_pixel_driver.switchRaster(this);
		}
		public override function createInterface(iIid:Class):Object
		{
			if(iIid==IFLARPerspectiveCopy){
				return FLARPerspectiveCopyFactory.createDriver(this);
			}
			if(iIid==FLARMatchPattDeviationColorData_IRasterDriver){
				return FLARMatchPattDeviationColorData_RasterDriverFactory.createDriver(this);
			}
			if(iIid==IFLARRgb2GsFilter){
				//デフォルトのインタフェイス
				return FLARRgb2GsFilterFactory.createRgbAveDriver(this);
			}else if(iIid==IFLARRgb2GsFilterRgbAve){
				return FLARRgb2GsFilterFactory.createRgbAveDriver(this);
//			}else if(iIid==IFLARRgb2GsFilterRgbCube){
//				return FLARRgb2GsFilterFactory.createRgbCubeDriver(this);
//			}else if(iIid==IFLARRgb2GsFilterYCbCr){
//				return FLARRgb2GsFilterFactory.createYCbCrDriver(this);
			}
			if(iIid==IFLARRgb2GsFilterArtkTh){
				return FLARRgb2GsFilterArtkThFactory.createDriver(this);
			}
			throw new FLARException();
		}		
	}



}