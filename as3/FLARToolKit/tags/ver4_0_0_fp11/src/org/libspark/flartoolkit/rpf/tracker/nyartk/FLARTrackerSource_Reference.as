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

	import flash.display.*;
	import org.libspark.flartoolkit.core.*;
	import org.libspark.flartoolkit.core.param.*;
	import org.libspark.flartoolkit.core.raster.FLARGrayscaleRaster;
	import org.libspark.flartoolkit.core.types.FLARBufferType;
	import org.libspark.flartoolkit.rpf.realitysource.nyartk.*;
	import org.libspark.flartoolkit.rpf.sampler.lrlabel.*;
	import org.libspark.flartoolkit.rpf.tracker.nyartk.*;
	import org.libspark.flartoolkit.core.raster .*;
	import org.libspark.flartoolkit.rpf.sampler.lrlabel.*;
	import org.libspark.flartoolkit.core.squaredetect.*;
	import org.libspark.flartoolkit.rpf.utils.*;

	/**
	 * FLARTrackerSourceのリファレンス実装です。
	 * 全ての画像処理を処理系のソフトウェアで実装します。
	 */
	public class FLARTrackerSource_Reference extends FLARTrackerSource
	{
		/**
		 * 反転RobertsFilter画像のインスタンス
		 */
		private var _sampler:FLARLowResolutionLabelingSampler;
		private var _rb_source:FLARGrayscaleRaster;
		private var _rfilter:FLARNegativeSqRoberts=new FLARNegativeSqRoberts();
		private var _gs_graphics:IFLARGsRasterGraphics;
		/**
		 * @param i_number_of_sample
		 * サンプラが検出する最大数。
		 *　通常100~200以上を指定します。(QVGA画像あたり、100個を基準にします。)
		 * 数が少なすぎると、検出率が低下します。最低でも、FLARTrackerに設定するターゲット数の合計*2以上を指定してください。
		 * @param i_ref_raster_distortion
		 * 歪み矯正の為のオブジェクトを指定します。歪み矯正が必要ない時は、NULLを指定します。
		 * @param i_width
		 * ソース画像のサイズ
		 * @param i_height
		 * ソース画像のサイズ
		 * @param i_depth
		 * 解像度の深さ(1/(2^n))倍の画像として処理する。
		 * @param i_is_alloc
		 * ベースラスタのバッファを内部確保外部参照にするかのフラグです。
		 * trueの場合、バッファは内部に確保され、{@link #wrapBuffer}関数が使用できなくなります。
		 * @throws FLARException
		 */
		public function FLARTrackerSource_Reference(i_number_of_sample:int, i_ref_raster_distortion:FLARCameraDistortionFactor, i_width:int, i_height:int, i_depth:int, i_is_alloc:Boolean)
		{
			super((int)(Math.pow(2,i_depth)));
			//		assert(i_depth>0);
			var div:int=this._rob_resolution;
			//主GSラスタ
			this._base_raster=new FLARGrayscaleRaster(i_width,i_height,FLARBufferType.OBJECT_AS3_BitmapData,i_is_alloc);
			this._gs_graphics=new FLARGsRasterGraphics_ASBitmap(FLARGrayscaleRaster(this._base_raster));
			//Roberts変換ラスタ
			this._rb_source=new FLARGrayscaleRaster(i_width/div,i_height/div,FLARBufferType.OBJECT_AS3_BitmapData, true);
			//Robertsラスタは最も解像度の低いラスタと同じ
			this._rbraster=new FLARGrayscaleRaster(i_width/div,i_height/div,FLARBufferType.OBJECT_AS3_BitmapData,true);
			this._vec_reader=new FLARVectorReader_Bitmapdata(FLARGrayscaleRaster(this._base_raster),i_ref_raster_distortion,this._rbraster);
			//samplerとsampleout
			this._sampler=new FLARLowResolutionLabelingSampler(i_width, i_height,(int)(Math.pow(2,i_depth)));
			this._sample_out=new LowResolutionLabelingSamplerOut(i_number_of_sample);
		}
		/**
		 * GS画像をセットします。
		 * この関数を使ってセットした画像は、インスタンスから参照されます。
		 * @param i_ref_source
		 * @throws FLARException 
		 */
		public function wrapBuffer(i_ref_source:FLARGrayscaleRaster):void
		{
			//バッファのスイッチ
			this._base_raster.wrapBuffer(i_ref_source.getBuffer());
		}


		public override function syncResource():void
		{
			//内部状態の同期
			this._gs_graphics.copyTo(0,0,this._rob_resolution,this._rb_source);
			this._rfilter.doFilter(this._rb_source, this._rbraster);
			
		}
		/**
		 * SampleOutを計算して返します。
		 * この関数は、FLARTrackerが呼び出します。
		 * @param samplerout
		 * @throws FLARException
		 */
		public override function makeSampleOut():LowResolutionLabelingSamplerOut
		{
			syncResource();
			//敷居値自動調整はそのうちね。
			this._sampler.sampling(this._rbraster,220,this._sample_out);
			return this._sample_out;
		}
	}
}

import flash.display.*;
import flash.geom.*;
import jp.nyatla.as3utils.*;
import org.libspark.flartoolkit.rpf.utils.*;
import org.libspark.flartoolkit.core.raster.*;
import org.libspark.flartoolkit.core.raster.rgb.*;
import org.libspark.flartoolkit.core.raster .*;
	
class FLARGsRasterGraphics_ASBitmap implements IFLARGsRasterGraphics
{
	private var _raster:FLARGrayscaleRaster;

	public function FLARGsRasterGraphics_ASBitmap(i_raster:FLARGrayscaleRaster)
	{
		this._raster = i_raster;
	}
	public function fill(i_value:int):void
	{	
		var bm:BitmapData = this._raster.getBitmapData();
		bm.fillRect(bm.rect,i_value);
	}
	public function copyTo(i_left:int,i_top:int,i_skip:int,o_output:IFLARGrayscaleRaster):void
	{
		var d:BitmapData = BitmapData(o_output.getBuffer());
		var s:BitmapData = BitmapData(this._raster.getBuffer());
		var mat:Matrix = new Matrix();
		mat.a = mat.d = (1.0 / (i_skip));
		mat.tx = i_left;
		mat.ty = i_top;
		d.draw(s, mat,null,null,null,false);
		return;
	}
}