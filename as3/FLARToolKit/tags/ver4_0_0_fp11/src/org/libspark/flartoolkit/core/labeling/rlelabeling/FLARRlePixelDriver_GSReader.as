/* 
* PROJECT: FLARToolKit
* --------------------------------------------------------------------------------
* This work is based on the FLARToolKit developed by
*   R.Iizuka (nyatla)
* http://nyatla.jp/nyatoolkit/
*
* The FLARToolKit is ActionScript 3.0 version ARToolkit class library.
* Copyright (C)2008 Saqoosha
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
*	http://www.libspark.org/wiki/saqoosha/FLARToolKit
*	<saq(at)saqoosha.net>
* 
*/
package org.libspark.flartoolkit.core.labeling.rlelabeling
{
	import org.libspark.flartoolkit.core.pixeldriver.IFLARGsPixelDriver;
	import org.libspark.flartoolkit.core.raster.IFLARGrayscaleRaster;

	/**
	 * GSPixelDriverを使った画像ドライバクラス
	 */
	internal class FLARRlePixelDriver_GSReader implements FLARLabeling_Rle_IRasterDriver
	{
		private var _ref_driver:IFLARGsPixelDriver;
		public function FLARRlePixelDriver_GSReader(i_raster:IFLARGrayscaleRaster)
		{
			this._ref_driver=i_raster.getGsPixelDriver();
		}	
		public function xLineToRle(i_x:int,i_y:int,i_len:int,i_th:int,i_out:Vector.<FLARLabeling_Rle_RleElement>):int
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
}