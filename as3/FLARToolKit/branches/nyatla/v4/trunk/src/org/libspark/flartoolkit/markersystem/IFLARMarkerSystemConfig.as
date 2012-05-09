/* 
 * PROJECT: NyARToolkit(Extension)
 * --------------------------------------------------------------------------------
 * The NyARToolkit is Java edition ARToolKit class library.
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
package jp.nyatla.nyartoolkit.as3.markersystem
{

	import jp.nyatla.nyartoolkit.as3.core.*;
	import jp.nyatla.nyartoolkit.as3.core.analyzer.histogram.*;
	import jp.nyatla.nyartoolkit.as3.core.param.*;
	import jp.nyatla.nyartoolkit.as3.core.transmat.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;

	/**
	 * このインタフェイスは、NyARMarkerSystemのコンフィギュレーションオブジェクトに使用します。
	 * {@link NyARMarkerSystem}は、このインタフェイスを継承したクラスから、動作に必要なオブジェクトや定数を取得します。
	 */
	public interface INyARMarkerSystemConfig
	{
		/**
		 * 姿勢行列計算クラスを生成して返します。
		 * @return
		 * 新しいオブジェクト。
		 * @throws NyARException
		 */
		function createTransmatAlgorism():INyARTransMat;
		/**
		 * 敷居値決定クラスを生成して返します。
		 * @return
		 * 新しいオブジェクト
		 * @throws NyARException
		 */
		function createAutoThresholdArgorism():INyARHistogramAnalyzer_Threshold;
		/**
		 * ARToolKitのカメラパラメータのオブジェクトを返します。
		 * @return
		 * [readonly]
		 * 参照値です。
		 */
		function getNyARParam():NyARParam;
		/**
		 * このコンフィギュレーションのスクリーンサイズを返します。
		 * @return
		 * [readonly]
		 * 参照値です。
		 */
		function getScreenSize():NyARIntSize;
	}
}