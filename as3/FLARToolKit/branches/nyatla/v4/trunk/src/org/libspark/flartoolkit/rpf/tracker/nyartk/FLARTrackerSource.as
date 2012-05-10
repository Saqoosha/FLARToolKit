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
package org.libspark.flartoolkit.rpf.tracker.nyartk
{

	import org.libspark.flartoolkit.core.*;
	import org.libspark.flartoolkit.core.raster.FLARGrayscaleRaster;
	import org.libspark.flartoolkit.rpf.sampler.lrlabel.LowResolutionLabelingSamplerOut;

	/**
	 * LowResolutionLabelingSamplerへの入力コンテナの抽象クラスです。
	 * 基本GS画像と、1/nサイズのRobertsエッジ検出画像を持ち、これらに対する同期APIとアクセサを定義します。
	 * <p>
	 * 継承クラスでは、_rbraster,_base_raster,_vec_readerメンバ変数の実体と、abstract関数を実装してください。
	 * </p>
	 */
	public class FLARTrackerSource
	{
		protected var _rob_resolution:int;
		//継承クラスで設定されるべきオブジェクト
		protected var _rbraster:FLARGrayscaleRaster;
		protected var _base_raster:FLARGrayscaleRaster;
		protected var _vec_reader:IFLARVectorReader;	
		protected var _sample_out:LowResolutionLabelingSamplerOut;
		/**
		 * Robertsエッジ画像の解像度を指定する。
		 * @param i_rob_resolution
		 */
		public function FLARTrackerSource(i_rob_resolution:int)
		{
			this._rob_resolution=i_rob_resolution;
		}
		/**
		 * 基本GS画像に対するVector読み取り機を返します。
		 * このインスタンスは、基本GS画像と同期していないことがあります。
		 * 基本GS画像に変更を加えた場合は、getSampleOut,またはsyncResource関数を実行して同期してから実行してください。
		 * @return
		 */
		public function getBaseVectorReader():IFLARVectorReader
		{
			return this._vec_reader;
		}

		/**
		 * エッジ画像を返します。
		 * このインスタンスは、基本GS画像と同期していないことがあります。
		 * 基本GS画像に変更を加えた場合は、makeSampleOut,またはsyncResource関数を実行して同期してから実行してください。
		 * 継承クラスでは、エッジ画像を返却してください。
		 * @return
		 */
		public function refEdgeRaster():FLARGrayscaleRaster
		{
			return this._rbraster;
		}
		/**
		 * 基準画像を返します。
		 * 継承クラスでは、基本画像を返却してください。
		 * @return
		 */
		public function refBaseRaster():FLARGrayscaleRaster
		{
			return this._base_raster;
		}
		/**
		 * 最後に作成した{@link LowResolutionLabelingSamplerOut}へのポインタを返します。
		 * この関数は、{@link FLARTracker#progress}、または{@link #syncResource}の後に呼び出すことを想定しています。
		 * それ以外のタイミングでは、返却値の内容が同期していないことがあるので注意してください。
		 * @return
		 */
		public function refLastSamplerOut():LowResolutionLabelingSamplerOut
		{
			return this._sample_out;
		}
		/**
		 * 基準画像と内部状態を同期します。(通常、アプリケーションからこの関数を使用することはありません。)
		 * エッジ画像から{@link _sample_out}を更新する関数を実装してください。
		 * @throws FLARException
		 */
		public function syncResource():void
		{
			throw new FLARException("makeSampleOut not override");
		}
		
		/**
		 * SampleOutを計算して、参照値を返します。
		 * この関数は、{@link FLARTracker#progress}が呼び出します。
		 * 継承クラスでは、エッジ画像{@link _rbraster}から{@link _sample_out}を更新して、返却する関数を実装してください。
		 * @throws FLARException
		 */
		public function makeSampleOut():LowResolutionLabelingSamplerOut
		{
			throw new FLARException("makeSampleOut not override");
		}
	}
}
