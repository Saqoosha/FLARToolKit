package jp.nyatla.nyartoolkit.as3.core.raster.rgb 
{
	import jp.nyatla.nyartoolkit.as3.core.NyARException;
	import jp.nyatla.nyartoolkit.as3.core.raster.*;
	import jp.nyatla.nyartoolkit.as3.core.pixeldriver.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.*;
	import jp.nyatla.as3utils.*;

	/**
	 * NyARRasterインタフェイスの基本関数/メンバを実装したクラス
	 * 
	 * 
	 */
	public class NyARRgbRaster_BasicClass implements INyARRgbRaster
	{
		protected var _size:NyARIntSize;
		protected var _buffer_type:int;
		public function NyARRgbRaster_BasicClass(...args:Array)
		{
			switch(args.length) {
			case 1:
				if (args[0] is NyAS3Const_Inherited) {
					//blank
				}
				break;
			case 3:
				//(int,int,int)
				if ((args[0] is int)&& (args[1] is int)&& (args[2] is int)){
					overload_NyARRgbRaster_BasicClass(int(args[0]),int(args[1]),int(args[2]));
				}
				break;
			default:
				throw new NyARException();
			}
		}
		protected function overload_NyARRgbRaster_BasicClass(i_width:int,i_height:int,i_buffer_type:int):void
		{
			this._size= new NyARIntSize(i_width,i_height);
			this._buffer_type=i_buffer_type;
		}
		final public function getWidth():int
		{
			return this._size.w;
		}
		final public function getHeight():int
		{
			return this._size.h;
		}

		final public function getSize():NyARIntSize
		{
			return this._size;
		}
		final public function getBufferType():int
		{
			return _buffer_type;
		}
		final public function isEqualBufferType(i_type_value:int):Boolean
		{
			return this._buffer_type==i_type_value;
		}
		/**
		 * ラスタのコピーを実行します。
		 * この関数は暫定です。低速なので注意してください。
		 * @param i_input
		 * @param o_output
		 * @throws NyARException 
		 */
		public static function copy(i_input:INyARRgbRaster,o_output:INyARRgbRaster):void
		{
			//assert(i_input.getSize().isEqualSize(o_output.getSize()));
			var width:int=i_input.getWidth();
			var height:int=i_input.getHeight();
			var rgb:Vector.<int>=new int[3];
			var inr:INyARRgbPixelDriver=i_input.getRgbPixelDriver();
			var outr:INyARRgbPixelDriver=o_output.getRgbPixelDriver();
			for(var i:int=height-1;i>=0;i--){
				for(var i2:int=width-1;i2>=0;i2--){
					inr.getPixel(i2,i,rgb);
					outr.setPixel_2(i2,i,rgb);
				}
			}
		}		
		public function getRgbPixelReader():INyARRgbPixelDriver
		{
			throw new NyARException();
		}
		public function getBuffer():Object
		{
			throw new NyARException();
		}
		public function hasBuffer():Boolean
		{
			throw new NyARException();
		}
		public function wrapBuffer(i_ref_buf:Object):void
		{
			throw new NyARException();
		}
		// abstract functions
		public function getRgbPixelDriver():INyARRgbPixelDriver
		{
			throw new NyARException("Should be override!");
		};
		public function createInterface(i_iid:Class):Object
		{
			throw new NyARException("Should be override!");
		};
		
	}
}