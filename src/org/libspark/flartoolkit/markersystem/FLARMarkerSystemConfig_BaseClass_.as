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
package org.libspark.flartoolkit.markersystem
{

	import flash.utils.*;
	import jp.nyatla.as3utils.*;
	import org.libspark.flartoolkit.core.FLARException;
	import org.libspark.flartoolkit.core.analyzer.histogram.IFLARHistogramAnalyzer_Threshold;
	import org.libspark.flartoolkit.core.analyzer.histogram.FLARHistogramAnalyzer_SlidePTile;
	import org.libspark.flartoolkit.core.param.FLARParam;
	import org.libspark.flartoolkit.core.transmat.IFLARTransMat;
	import org.libspark.flartoolkit.core.transmat.FLARTransMat;
	import org.libspark.flartoolkit.core.types.FLARIntSize;

	/**
	 * このクラスは、FLARToolkitの姿勢推定アルゴリズムに調整したコンフィギュレーションクラスです。
	 *
	 */
	public class FLARMarkerSystemConfig_BaseClass_ implements IFLARMarkerSystemConfig
	{
		protected var _param:FLARParam;
		public function FLARMarkerSystemConfig_BaseClass_(...args:Array)
		{
			switch(args.length) {
			case 1:
				if (args[0] is NyAS3Const_Inherited) {
					break;
					//blank
				} else {
					FLARMarkerSystemConfig_1o(FLARParam(args[0]));
					break;
				}
				throw new FLARException();
			case 2:
				FLARMarkerSystemConfig_2ii(int(args[0]), int(args[1]));
				break;
			case 3:
				FLARMarkerSystemConfig_3oii(ByteArray(args[0]), int(args[1]),int(args[2]));
				break;
			default:
				throw new FLARException();
			}			
		}

		/**
		 * コンストラクタです。
		 * 初期化済カメラパラメータからコンフィギュレーションを生成します。
		 * @param i_param
		 * 初期化に使うカメラパラメータオブジェクト。インスタンスの所有権は、インスタンスに移ります。
		 */
		protected function FLARMarkerSystemConfig_1o(i_param:FLARParam):void
		{
			this._param=i_param;
		}
		/**
		 * コンストラクタです。
		 * i_ar_parama_streamからカメラパラメータファイルを読み出して、スクリーンサイズをi_width,i_heightに変形してから、
		 * コンフィギュレーションを生成します。
		 * @param i_ar_param_stream
		 * カメラパラメータファイルを読み出すストリーム
		 * @param i_width
		 * スクリーンサイズ
		 * @param i_height
		 * スクリーンサイズ
		 * @throws FLARException
		 */
		protected function FLARMarkerSystemConfig_3oii(i_ar_param_stream:ByteArray,i_width:int,i_height:int):void
		{
			this._param=new FLARParam();
			this._param.loadARParam(i_ar_param_stream);
			this._param.changeScreenSize(i_width,i_height);
		}
		/**
		 * コンストラクタです。カメラパラメータにサンプル値(../Data/camera_para.dat)の値をロードして、
		 * コンフィギュレーションを生成します。
		 * @param i_width
		 * スクリーンサイズ
		 * @param i_height
		 * スクリーンサイズ
		 * @throws FLARException
		 */
		protected function FLARMarkerSystemConfig_2ii(i_width:int,i_height:int):void
		{
			this._param=new FLARParam();
			this._param.loadDefaultParameter();
			this._param.changeScreenSize(i_width,i_height);		
		}
		/**
		 * この値は、カメラパラメータのスクリーンサイズです。
		 */
		public function getScreenSize():FLARIntSize
		{
			return this._param.getScreenSize();
		}
		/**
		 * @Override
		 */
		public function createTransmatAlgorism():IFLARTransMat
		{
			return new FLARTransMat(this._param);
		}
		/**
		 * @Override
		 */
		public function createAutoThresholdArgorism():IFLARHistogramAnalyzer_Threshold
		{
			return new FLARHistogramAnalyzer_SlidePTile(15);
		}
		/**
		 * @Override
		 */
		public function getFLARParam():FLARParam
		{
			return 	this._param;
		}
	}
}