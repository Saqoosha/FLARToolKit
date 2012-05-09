package jp.nyatla.nyartoolkit.as3.core.labeling.rlelabeling 
{
	import jp.nyatla.nyartoolkit.as3.core.raster.*;
	import jp.nyatla.nyartoolkit.as3.core.rasterdriver.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.core.*;
	/**
	 * Labeling用の画像ドライバを構築します。
	 */
	public class NyARLabeling_Rle_RasterDriverFactory
	{
		/**
		 * この関数はラスタから呼ばれる。
		 * @param i_raster
		 * @return
		 */
		public static function createDriver(i_raster:INyARGrayscaleRaster):NyARLabeling_Rle_IRasterDriver
		{
			switch(i_raster.getBufferType()){
			case NyARBufferType.INT1D_GRAY_8:
			case NyARBufferType.INT1D_BIN_8:
				return new NyARRlePixelDriver_BIN_GS8(i_raster);
			default:
				if(i_raster is INyARGrayscaleRaster){
					return new NyARRlePixelDriver_GSReader(INyARGrayscaleRaster(i_raster));
				}
				throw new NyARException();
			}
		}		
	}

}



import jp.nyatla.nyartoolkit.as3.core.raster.*;
import jp.nyatla.nyartoolkit.as3.core.rasterdriver.*;
import jp.nyatla.nyartoolkit.as3.core.pixeldriver.*;
import jp.nyatla.nyartoolkit.as3.core.labeling.rlelabeling.*;



//
//画像ドライバ
//

class NyARRlePixelDriver_BIN_GS8 implements NyARLabeling_Rle_IRasterDriver
{
	private var _ref_raster:INyARRaster;
	public function NyARRlePixelDriver_BIN_GS8(i_ref_raster:INyARRaster)
	{
		this._ref_raster=i_ref_raster;
	}
	public function xLineToRle(i_x:int, i_y:int, i_len:int,i_th:int,i_out:Vector.<NyARLabeling_Rle_RleElement>):int
	{
		var buf:Vector.<int>=Vector.<int>(this._ref_raster.getBuffer());
		var current:int = 0;
		var r:int = -1;
		// 行確定開始
		var st:int=i_x+this._ref_raster.getWidth()*i_y;
		var x:int = st;
		var right_edge:int = st + i_len - 1;
		while (x < right_edge) {
			// 暗点(0)スキャン
			if (buf[x] > i_th) {
				x++;//明点
				continue;
			}
			// 暗点発見→暗点長を調べる
			r = (x - st);
			i_out[current].l = r;
			r++;// 暗点+1
			x++;
			while (x < right_edge) {
				if (buf[x] > i_th) {
					// 明点(1)→暗点(0)配列終了>登録
					i_out[current].r = r;
					current++;
					x++;// 次点の確認。
					r = -1;// 右端の位置を0に。
					break;
				} else {
					// 暗点(0)長追加
					r++;
					x++;
				}
			}
		}
		// 最後の1点だけ判定方法が少し違うの。
		if (buf[x] > i_th) {
			// 明点→rカウント中なら暗点配列終了>登録
			if (r >= 0) {
				i_out[current].r = r;
				current++;
			}
		} else {
			// 暗点→カウント中でなければl1で追加
			if (r >= 0) {
				i_out[current].r = (r + 1);
			} else {
				// 最後の1点の場合
				i_out[current].l = (i_len - 1);
				i_out[current].r = (i_len);
			}
			current++;
		}
		// 行確定
		return current;
	}
}

/**
 * GSPixelDriverを使ったクラス
 */
class NyARRlePixelDriver_GSReader implements NyARLabeling_Rle_IRasterDriver
{
	private var _ref_driver:INyARGsPixelDriver;
	public function NyARRlePixelDriver_GSReader(i_raster:INyARGrayscaleRaster)
	{
		this._ref_driver=i_raster.getGsPixelDriver();
	}	
	public function xLineToRle(i_x:int,i_y:int,i_len:int,i_th:int,i_out:Vector.<NyARLabeling_Rle_RleElement>):int
	{
		var current:int = 0;
		var r:int = -1;
		// 行確定開始
		var st:int=i_x;
		var x:int = st;
		var right_edge:int = st + i_len - 1;
		while (x < right_edge) {
			// 暗点(0)スキャン
			if (this._ref_driver.getPixel(x,i_y) > i_th) {
				x++;//明点
				continue;
			}
			// 暗点発見→暗点長を調べる
			r = (x - st);
			i_out[current].l = r;
			r++;// 暗点+1
			x++;
			while (x < right_edge) {
				if (this._ref_driver.getPixel(x,i_y) > i_th) {
					// 明点(1)→暗点(0)配列終了>登録
					i_out[current].r = r;
					current++;
					x++;// 次点の確認。
					r = -1;// 右端の位置を0に。
					break;
				} else {
					// 暗点(0)長追加
					r++;
					x++;
				}
			}
		}
		// 最後の1点だけ判定方法が少し違うの。
		if (this._ref_driver.getPixel(x,i_y) > i_th) {
			// 明点→rカウント中なら暗点配列終了>登録
			if (r >= 0) {
				i_out[current].r = r;
				current++;
			}
		} else {
			// 暗点→カウント中でなければl1で追加
			if (r >= 0) {
				i_out[current].r = (r + 1);
			} else {
				// 最後の1点の場合
				i_out[current].l = (i_len - 1);
				i_out[current].r = (i_len);
			}
			current++;
		}
		// 行確定
		return current;
	}
}