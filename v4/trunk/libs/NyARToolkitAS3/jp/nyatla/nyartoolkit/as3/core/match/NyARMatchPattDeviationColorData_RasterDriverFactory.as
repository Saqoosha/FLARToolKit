package jp.nyatla.nyartoolkit.as3.core.match 
{
	import jp.nyatla.nyartoolkit.as3.core.raster.rgb.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	/**
	 * ...
	 * @author nyatla
	 */
	public class NyARMatchPattDeviationColorData_RasterDriverFactory 
	{
		public static function createDriver(i_raster:INyARRgbRaster):NyARMatchPattDeviationColorData_IRasterDriver
		{
			switch(i_raster.getBufferType())
			{
			case NyARBufferType.INT1D_X8R8G8B8_32:
				return new NyARMatchPattDeviationDataDriver_INT1D_X8R8G8B8_32(i_raster);
			default:
				break;
			}
			return new NyARMatchPattDeviationDataDriver_RGBAny(i_raster);
		}
	}

}


import jp.nyatla.nyartoolkit.as3.core.types.*;
import jp.nyatla.nyartoolkit.as3.core.raster.*;
import jp.nyatla.nyartoolkit.as3.core.raster.rgb.*;
import jp.nyatla.nyartoolkit.as3.core.rasterdriver.*;
import jp.nyatla.nyartoolkit.as3.core.pixeldriver.*;
import jp.nyatla.nyartoolkit.as3.core.match.*;

/**
 * Rasterからデータを生成するインタフェイス。
 */


//
//	画像ドライバ
//

class NyARMatchPattDeviationDataDriver_INT1D_X8R8G8B8_32 implements NyARMatchPattDeviationColorData_IRasterDriver
{
	private var _ref_raster:INyARRgbRaster;
	public function NyARMatchPattDeviationDataDriver_INT1D_X8R8G8B8_32(i_raster:INyARRgbRaster)
	{
		this._ref_raster=i_raster;
	}
	public function makeColorData(o_out:Vector.<int>):Number
	{
		//i_buffer[XRGB]→差分[R,G,B]変換			
		var i:int;
		var rgb:int;//<PV/>
		//<平均値計算(FORの1/8展開)>
		var ave:int;//<PV/>
		var buf:Vector.<int>=(Vector.<int>)(this._ref_raster.getBuffer());
		var size:NyARIntSize=this._ref_raster.getSize();
		var number_of_pix:int=size.w*size.h;
		var optimize_mod:int=number_of_pix-(number_of_pix%8);
		ave=0;
		for(i=number_of_pix-1;i>=optimize_mod;i--){
			rgb = buf[i];ave += ((rgb >> 16) & 0xff) + ((rgb >> 8) & 0xff) + (rgb & 0xff);
		}
		for (;i>=0;) {
			rgb = buf[i];ave += ((rgb >> 16) & 0xff) + ((rgb >> 8) & 0xff) + (rgb & 0xff);i--;
			rgb = buf[i];ave += ((rgb >> 16) & 0xff) + ((rgb >> 8) & 0xff) + (rgb & 0xff);i--;
			rgb = buf[i];ave += ((rgb >> 16) & 0xff) + ((rgb >> 8) & 0xff) + (rgb & 0xff);i--;
			rgb = buf[i];ave += ((rgb >> 16) & 0xff) + ((rgb >> 8) & 0xff) + (rgb & 0xff);i--;
			rgb = buf[i];ave += ((rgb >> 16) & 0xff) + ((rgb >> 8) & 0xff) + (rgb & 0xff);i--;
			rgb = buf[i];ave += ((rgb >> 16) & 0xff) + ((rgb >> 8) & 0xff) + (rgb & 0xff);i--;
			rgb = buf[i];ave += ((rgb >> 16) & 0xff) + ((rgb >> 8) & 0xff) + (rgb & 0xff);i--;
			rgb = buf[i];ave += ((rgb >> 16) & 0xff) + ((rgb >> 8) & 0xff) + (rgb & 0xff);i--;
		}
		//<平均値計算(FORの1/8展開)/>
		ave=number_of_pix*255*3-ave;
		ave =255-(ave/ (number_of_pix * 3));//(255-R)-ave を分解するための事前計算

		var sum:int = 0,w_sum:int;
		var input_ptr:int=number_of_pix*3-1;
		//<差分値計算(FORの1/8展開)>
		for (i = number_of_pix-1; i >=optimize_mod;i--) {
			rgb = buf[i];
			w_sum = (ave - (rgb & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//B
			w_sum = (ave - ((rgb >> 8) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//G
			w_sum = (ave - ((rgb >> 16) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//R
		}
		for (; i >=0;) {
			rgb = buf[i];i--;
			w_sum = (ave - (rgb & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//B
			w_sum = (ave - ((rgb >> 8) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//G
			w_sum = (ave - ((rgb >> 16) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//R
			rgb = buf[i];i--;
			w_sum = (ave - (rgb & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//B
			w_sum = (ave - ((rgb >> 8) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//G
			w_sum = (ave - ((rgb >> 16) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//R
			rgb = buf[i];i--;
			w_sum = (ave - (rgb & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//B
			w_sum = (ave - ((rgb >> 8) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//G
			w_sum = (ave - ((rgb >> 16) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//R
			rgb = buf[i];i--;
			w_sum = (ave - (rgb & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//B
			w_sum = (ave - ((rgb >> 8) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//G
			w_sum = (ave - ((rgb >> 16) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//R
			rgb = buf[i];i--;
			w_sum = (ave - (rgb & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//B
			w_sum = (ave - ((rgb >> 8) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//G
			w_sum = (ave - ((rgb >> 16) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//R
			rgb = buf[i];i--;
			w_sum = (ave - (rgb & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//B
			w_sum = (ave - ((rgb >> 8) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//G
			w_sum = (ave - ((rgb >> 16) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//R
			rgb = buf[i];i--;
			w_sum = (ave - (rgb & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//B
			w_sum = (ave - ((rgb >> 8) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//G
			w_sum = (ave - ((rgb >> 16) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//R
			rgb = buf[i];i--;
			w_sum = (ave - (rgb & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//B
			w_sum = (ave - ((rgb >> 8) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//G
			w_sum = (ave - ((rgb >> 16) & 0xff)) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//R
		}
		//<差分値計算(FORの1/8展開)/>
		var p:Number=Math.sqrt(Number(sum));
		return p!=0.0?p:0.0000001;
	}
}
class NyARMatchPattDeviationDataDriver_RGBAny implements NyARMatchPattDeviationColorData_IRasterDriver
{
	private var _ref_raster:INyARRgbRaster;
	public function NyARMatchPattDeviationDataDriver_RGBAny(i_raster:INyARRgbRaster)
	{
		this._ref_raster=i_raster;
	}
	private var __rgb:Vector.<int>=new Vector.<int>(3);
	public function makeColorData(o_out:Vector.<int>):Number
	{
		var size:NyARIntSize=this._ref_raster.getSize();
		var pixdev:INyARRgbPixelDriver=this._ref_raster.getRgbPixelDriver();
		var rgb:Vector.<int>=this.__rgb;
		var width:int=size.w;
		//<平均値計算>
		var x:int,y:int;
		var ave:int = 0;//<PV/>		
		for(y=size.h-1;y>=0;y--){
			for(x=width-1;x>=0;x--){
				pixdev.getPixel(x,y,rgb);
				ave += rgb[0]+rgb[1]+rgb[2];
			}
		}
		//<平均値計算>
		var number_of_pix:int=size.w*size.h;
		ave=number_of_pix*255*3-ave;
		ave =255-(ave/ (number_of_pix * 3));//(255-R)-ave を分解するための事前計算

		var sum:int = 0,w_sum:int;
		var input_ptr:int=number_of_pix*3-1;
		//<差分値計算>
		for(y=size.h-1;y>=0;y--){
			for(x=width-1;x>=0;x--){
				pixdev.getPixel(x,y,rgb);
				w_sum = (ave - rgb[2]) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//B
				w_sum = (ave - rgb[1]) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//G
				w_sum = (ave - rgb[0]) ;o_out[input_ptr--] = w_sum;sum += w_sum * w_sum;//R
			}
		}
		//<差分値計算(FORの1/8展開)/>
		var p:Number=Math.sqrt(Number(sum));
		return p!=0.0?p:0.0000001;
		
	}
}	