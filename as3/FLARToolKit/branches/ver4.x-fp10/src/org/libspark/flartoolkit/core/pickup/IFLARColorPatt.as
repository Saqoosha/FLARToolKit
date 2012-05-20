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
package org.libspark.flartoolkit.core.pickup {

	import org.libspark.flartoolkit.core.raster.rgb.*;
	import org.libspark.flartoolkit.core.types.*;
	
	public interface IFLARColorPatt extends IFLARRgbRaster
	{
		/**
		 * ラスタイメージからi_square部分のカラーパターンを抽出して、thisメンバに格納します。
		 * 
		 * @param image
		 * Source raster object.
		 * ----
		 * 抽出元のラスタオブジェクト
		 * @param i_vertexs
		 * Vertexes of the square. Number of element must be 4.
		 * ----
		 * 射影変換元の４角形を構成する頂点群頂群。要素数は4であること。
		 * @return
		 * True if sucessfull; otherwise false.
		 * ----
		 * ラスターの取得に成功するとTRUE/失敗するとFALSE
		 * @throws FLARException
		 */
		function pickFromRaster(image:IFLARRgbRaster,i_vertexs:Vector.<FLARIntPoint2d>):Boolean;
	}
}