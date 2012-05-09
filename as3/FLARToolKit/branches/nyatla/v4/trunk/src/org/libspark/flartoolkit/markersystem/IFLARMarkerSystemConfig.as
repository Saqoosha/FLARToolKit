/* 
 * PROJECT: FLARToolkit(Extension)
 * --------------------------------------------------------------------------------
 * The FLARToolkit is Java edition ARToolKit class library.
 * Copyright (C)2008-2009 Ryo Iizuka
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
package org.libspark.flartoolkit.markersystem
{

	import org.libspark.flartoolkit.core.*;
	import org.libspark.flartoolkit.core.analyzer.histogram.*;
	import org.libspark.flartoolkit.core.param.*;
	import org.libspark.flartoolkit.core.transmat.*;
	import org.libspark.flartoolkit.core.types.*;

	/**
	 * このインタフェイスは、FLARMarkerSystemのコンフィギュレーションオブジェクトに使用します。
	 * {@link FLARMarkerSystem}は、このインタフェイスを継承したクラスから、動作に必要なオブジェクトや定数を取得します。
	 */
	public interface IFLARMarkerSystemConfig
	{
		/**
		 * 姿勢行列計算クラスを生成して返します。
		 * @return
		 * 新しいオブジェクト。
		 * @throws FLARException
		 */
		function createTransmatAlgorism():IFLARTransMat;
		/**
		 * 敷居値決定クラスを生成して返します。
		 * @return
		 * 新しいオブジェクト
		 * @throws FLARException
		 */
		function createAutoThresholdArgorism():IFLARHistogramAnalyzer_Threshold;
		/**
		 * ARToolKitのカメラパラメータのオブジェクトを返します。
		 * @return
		 * [readonly]
		 * 参照値です。
		 */
		function getFLARParam():FLARParam;
		/**
		 * このコンフィギュレーションのスクリーンサイズを返します。
		 * @return
		 * [readonly]
		 * 参照値です。
		 */
		function getScreenSize():FLARIntSize;
	}
}