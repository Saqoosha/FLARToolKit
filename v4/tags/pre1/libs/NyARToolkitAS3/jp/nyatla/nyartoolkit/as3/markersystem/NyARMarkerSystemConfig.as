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

	import flash.utils.*;
	import jp.nyatla.as3utils.*;
	import jp.nyatla.nyartoolkit.as3.core.NyARException;
	import jp.nyatla.nyartoolkit.as3.core.analyzer.histogram.INyARHistogramAnalyzer_Threshold;
	import jp.nyatla.nyartoolkit.as3.core.analyzer.histogram.NyARHistogramAnalyzer_SlidePTile;
	import jp.nyatla.nyartoolkit.as3.core.param.NyARParam;
	import jp.nyatla.nyartoolkit.as3.core.transmat.INyARTransMat;
	import jp.nyatla.nyartoolkit.as3.core.transmat.NyARTransMat;
	import jp.nyatla.nyartoolkit.as3.core.types.NyARIntSize;

	/**
	 * このクラスは、NyARToolkitの姿勢推定アルゴリズムに調整したコンフィギュレーションクラスです。
	 *
	 */
	public class NyARMarkerSystemConfig implements INyARMarkerSystemConfig
	{
		protected var _param:NyARParam;
		public function NyARMarkerSystemConfig(...args:Array)
		{
			switch(args.length) {
			case 1:
				if (args[0] is NyAS3Const_Inherited) {
					break;
					//blank
				}else {
					NyARMarkerSystemConfig_1o(NyARParam(args[0]));
					break;
				}
				throw new NyARException();
			case 2:
				NyARMarkerSystemConfig_2ii(int(args[0]), int(args[1]));
				break;
			case 3:
				NyARMarkerSystemConfig_3oii(ByteArray(args[0]), int(args[1]),int(args[2]));
				break;
			default:
				throw new NyARException();
			}			
		}

		/**
		 * コンストラクタです。
		 * 初期化済カメラパラメータからコンフィギュレーションを生成します。
		 * @param i_param
		 * 初期化に使うカメラパラメータオブジェクト。インスタンスの所有権は、インスタンスに移ります。
		 */
		protected function NyARMarkerSystemConfig_1o(i_param:NyARParam):void
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
		 * @throws NyARException
		 */
		protected function NyARMarkerSystemConfig_3oii(i_ar_param_stream:ByteArray,i_width:int,i_height:int):void
		{
			this._param=new NyARParam();
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
		 * @throws NyARException
		 */
		protected function NyARMarkerSystemConfig_2ii(i_width:int,i_height:int):void
		{
			this._param=new NyARParam();
			this._param.loadDefaultParameter();
			this._param.changeScreenSize(i_width,i_height);		
		}
		/**
		 * この値は、カメラパラメータのスクリーンサイズです。
		 */
		public function getScreenSize():NyARIntSize
		{
			return this._param.getScreenSize();
		}
		/**
		 * @Override
		 */
		public function createTransmatAlgorism():INyARTransMat
		{
			return new NyARTransMat(this._param);
		}
		/**
		 * @Override
		 */
		public function createAutoThresholdArgorism():INyARHistogramAnalyzer_Threshold
		{
			return new NyARHistogramAnalyzer_SlidePTile(15);
		}
		/**
		 * @Override
		 */
		public function getNyARParam():NyARParam
		{
			return 	this._param;
		}
	}
}