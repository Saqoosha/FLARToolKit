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
 */

package org.libspark.flartoolkit.core {
	
	import org.libspark.flartoolkit.core.raster.FLARBitmapData;
	import org.libspark.flartoolkit.core.raster.IFLARRaster;
	
	import flash.display.BitmapData;
	
	public interface IFLARLabeling {
	
	    /**
	     * 検出したラベルの数を返す
	     * @return
	     */
	    function getLabelNum():int;
	    /**
	     * 
	     * @return
	     * @throws NyARException
	     */
	    function getLabelRef():Array;
	    /**
	     * 検出したラベル配列
	     * @return
	     * @throws NyARException
	     */
	    function getLabel():Array;
	    /**
	     * ラベリング済みイメージを返す
	     * @return
	     * @throws NyARException
	     */
	    function getLabelImg():BitmapData;
	    /**
	     * static ARInt16 *labeling2( ARUint8 *image, int thresh,int *label_num, int **area, double **pos, int **clip,int **label_ref, int LorR )
	     * 関数の代替品
	     * ラスタimageをラベリングして、結果を保存します。
	     * Optimize:STEP[1514->1493]
	     * @param image
	     * @param thresh
	     * @throws NyARException
	     */
	    function labeling(image:FLARBitmapData, thresh:int):void;	
	    
	}
	
}