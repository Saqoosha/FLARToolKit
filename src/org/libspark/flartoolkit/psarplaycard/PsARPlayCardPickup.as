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
package org.libspark.flartoolkit.psarplaycard{

	import org.libspark.flartoolkit.core.FLARException;
	import org.libspark.flartoolkit.core.pixeldriver.IFLARGsPixelDriver;
	import org.libspark.flartoolkit.core.types.*;
	import org.libspark.flartoolkit.core.utils.*;
	import org.libspark.flartoolkit.psarplaycard.*;



	/**
	 * このクラスは、ラスタ画像に定義したの任意矩形から、PsARPlayCardパターンのデータを読み取ります。
	 *
	 */
	public class PsARPlayCardPickup
	{
		private var _perspective_reader:PerspectivePixelReader;
		private var _decoder:MarkerPattDecoder=new MarkerPattDecoder();

		/**
		 * コンストラクタです。インスタンスを生成します。
		 * @throws FLARException 
		 */
		public function PsARPlayCardPickup()
		{
			this._perspective_reader=new PerspectivePixelReader();
			return;
		}

		/**
		 * この関数は、ラスタドライバから画像を読み出します。
		 * @param i_pix_drv
		 * @param i_size
		 * @param i_vertex
		 * @param o_data
		 * @param o_param
		 * @return
		 * @throws FLARException
		 */
		public function getARPlayCardId(i_pix_drv:IFLARGsPixelDriver,i_vertex:Vector.<FLARIntPoint2d>,i_result:PsARPlayCardPickup_PsArIdParam):Boolean
		{
			if(!this._perspective_reader.setSourceSquare(i_vertex)){
				return false;
			}
			return this._pickFromRaster(i_pix_drv,i_result);
		}
		/**
		 * この関数は、ラスタドライバから画像を読み出します。
		 * @param i_pix_drv
		 * @param i_size
		 * @param i_vertex
		 * @param o_data
		 * @param o_param
		 * @return
		 * @throws FLARException
		 */
		public function getARPlayCardId_2(i_pix_drv:IFLARGsPixelDriver,i_vertex:Vector.<FLARDoublePoint2d>,i_result:PsARPlayCardPickup_PsArIdParam):Boolean
		{
			if(!this._perspective_reader.setSourceSquare_2(i_vertex)){
				return false;
			}
			return this._pickFromRaster(i_pix_drv,i_result);
		}	
		/**
		 * i_imageから、idマーカを読みだします。
		 * o_dataにはマーカデータ、o_paramにはマーカのパラメータを返却します。
		 * @param image
		 * @param i_vertex
		 * @param o_data
		 * @param o_param
		 * @return
		 * @throws FLARException
		 */
		private function _pickFromRaster(i_pix_drv:IFLARGsPixelDriver,i_result:PsARPlayCardPickup_PsArIdParam):Boolean
		{
			if(!this._perspective_reader.readDataBits(i_pix_drv,i_pix_drv.getSize(),this._decoder)){
				return false;
			}
			//敷居値検索
			return this._decoder.decodePatt(i_result);
		}
	}
}

import org.libspark.flartoolkit.core.FLARException;
import org.libspark.flartoolkit.core.pixeldriver.IFLARGsPixelDriver;
import org.libspark.flartoolkit.core.types.*;
import org.libspark.flartoolkit.core.utils.*;
import org.libspark.flartoolkit.psarplaycard.*;


/**
 * PSARIdを100x100画像として読み出す。
 */
class PerspectivePixelReader
{
	private const READ_RESOLUTION:int=100;
	private var _param_gen:FLARPerspectiveParamGenerator=new FLARPerspectiveParamGenerator_O1(1,1);
	private var _cparam:Vector.<Number>=new Vector.<Number>(8);

	/**
	 * コンストラクタです。
	 */
	public function PerspectivePixelReader()
	{
		return;
	}
	/**
	 * この関数は、マーカ四角形をインスタンスにセットします。
	 * @param i_vertex
	 * セットする四角形頂点座標。4要素である必要があります。
	 * @return
	 * 成功するとtrueです。
	 * @throws FLARException
	 */
	public function setSourceSquare(i_vertex:Vector.<FLARIntPoint2d>):Boolean
	{
		return this._param_gen.getParam_4(READ_RESOLUTION,READ_RESOLUTION,i_vertex, this._cparam);
	}
	/**
	 * この関数は、マーカ四角形をインスタンスにセットします。
	 * @param i_vertex
	 * セットする四角形頂点座標。4要素である必要があります。
	 * @return
	 * 成功するとtrueです。
	 * @throws FLARException
	 */
	public function setSourceSquare_2(i_vertex:Vector.<FLARDoublePoint2d>):Boolean
	{
		return this._param_gen.getParam_3(READ_RESOLUTION,READ_RESOLUTION,i_vertex, this._cparam);
	}

	
	//タイミングパターン用のパラメタ(FRQ_POINTS*FRQ_STEPが100を超えないようにすること)

	private static const MAX_FREQ:int=10;
	private static const MAX_DATA_BITS:int=MAX_FREQ+MAX_FREQ-1;

	private var _ref_x:Vector.<int>=new Vector.<int>(108);
	private var _ref_y:Vector.<int>=new Vector.<int>(108);
	//(model+1)*4とTHRESHOLD_PIXELのどちらか大きい方
	private var _pixcel_temp:Vector.<int>=new Vector.<int>(108);


	private function detectDataBitsIndex(o_index_row:Vector.<Number>,o_index_col:Vector.<Number>):void
	{
		for(var i:int=0;i<3;i++){
			o_index_row[i*2]  =25+i*20;
			o_index_row[i*2+1]=35+i*20;
			o_index_col[i*2]  =25+i*20;
			o_index_col[i*2+1]=35+i*20;
		}	
	}	
	private var __readDataBits_index_bit_x:Vector.<Number>=new Vector.<Number>(MAX_DATA_BITS*2);
	private var __readDataBits_index_bit_y:Vector.<Number>=new Vector.<Number>(MAX_DATA_BITS*2);
	/**
	 * この関数は、マーカパターンからデータを読み取ります。
	 * @param i_reader
	 * ラスタリーダ
	 * @param i_raster_size
	 * ラスタのサイズ
	 * @param o_bitbuffer
	 * データビットの出力先
	 * @return
	 * 成功するとtrue
	 * @throws FLARException
	 */
	public function readDataBits(i_reader:IFLARGsPixelDriver,i_raster_size:FLARIntSize,o_bitbuffer:MarkerPattDecoder):Boolean
	{
		var raster_width:int=i_raster_size.w;
		var raster_height:int=i_raster_size.h;
		
		var index_x:Vector.<Number>=this.__readDataBits_index_bit_x;
		var index_y:Vector.<Number>=this.__readDataBits_index_bit_y;
		

		//読み出し位置を取得
		detectDataBitsIndex(index_x,index_y);
		var resolution:int=3;
		
		var cpara:Vector.<Number>=this._cparam;
		var ref_x:Vector.<int>=this._ref_x;
		var ref_y:Vector.<int>=this._ref_y;
		var pixcel_temp:Vector.<int>=this._pixcel_temp;
		
		var cpara_0:Number=cpara[0];
		var cpara_1:Number=cpara[1];
		var cpara_3:Number=cpara[3];
		var cpara_6:Number=cpara[6];
		
		var i2:int;
		var p:int=0;
		for(var i:int=0;i<resolution;i++){
			//1列分のピクセルのインデックス値を計算する。
			var cy0:Number=1+index_y[i*2+0];
			var cy1:Number=1+index_y[i*2+1];			
			var cpy0_12:Number=cpara_1*cy0+cpara[2];
			var cpy0_45:Number=cpara[4]*cy0+cpara[5];
			var cpy0_7:Number=cpara[7]*cy0+1.0;
			var cpy1_12:Number=cpara_1*cy1+cpara[2];
			var cpy1_45:Number=cpara[4]*cy1+cpara[5];
			var cpy1_7:Number=cpara[7]*cy1+1.0;
			
			var pt:int=0;
			for(i2=0;i2<resolution;i2++)
			{
				var xx:int,yy:int;
				var d:Number;
				var cx0:Number=1+index_x[i2*2+0];
				var cx1:Number=1+index_x[i2*2+1];

				var cp6_0:Number=cpara_6*cx0;
				var cpx0_0:Number=cpara_0*cx0;
				var cpx3_0:Number=cpara_3*cx0;

				var cp6_1:Number=cpara_6*cx1;
				var cpx0_1:Number=cpara_0*cx1;
				var cpx3_1:Number=cpara_3*cx1;
				
				d=cp6_0+cpy0_7;
				ref_x[pt]=xx=int((cpx0_0+cpy0_12)/d);
				ref_y[pt]=yy=int((cpx3_0+cpy0_45)/d);
				if(xx<0 || xx>=raster_width || yy<0 || yy>=raster_height)
				{
					ref_x[pt]=xx<0?0:(xx>=raster_width?raster_width-1:xx);
					ref_y[pt]=yy<0?0:(yy>=raster_height?raster_height-1:yy);
				}
				pt++;

				d=cp6_0+cpy1_7;
				ref_x[pt]=xx=int((cpx0_0+cpy1_12)/d);
				ref_y[pt]=yy=int((cpx3_0+cpy1_45)/d);
				if(xx<0 || xx>=raster_width || yy<0 || yy>=raster_height)
				{
					ref_x[pt]=xx<0?0:(xx>=raster_width?raster_width-1:xx);
					ref_y[pt]=yy<0?0:(yy>=raster_height?raster_height-1:yy);
				}
				pt++;

				d=cp6_1+cpy0_7;
				ref_x[pt]=xx=int((cpx0_1+cpy0_12)/d);
				ref_y[pt]=yy=int((cpx3_1+cpy0_45)/d);
				if(xx<0 || xx>=raster_width || yy<0 || yy>=raster_height)
				{
					ref_x[pt]=xx<0?0:(xx>=raster_width?raster_width-1:xx);
					ref_y[pt]=yy<0?0:(yy>=raster_height?raster_height-1:yy);
				}
				pt++;

				d=cp6_1+cpy1_7;
				ref_x[pt]=xx=int((cpx0_1+cpy1_12)/d);
				ref_y[pt]=yy=int((cpx3_1+cpy1_45)/d);
				if(xx<0 || xx>=raster_width || yy<0 || yy>=raster_height)
				{
					ref_x[pt]=xx<0?0:(xx>=raster_width?raster_width-1:xx);
					ref_y[pt]=yy<0?0:(yy>=raster_height?raster_height-1:yy);
				}
				pt++;
			}
			//1行分のピクセルを取得(場合によっては専用アクセサを書いた方がいい)
			i_reader.getPixelSet(ref_x,ref_y,resolution*4,pixcel_temp,0);
			//グレースケールにしながら、line→mapへの転写
			for(i2=0;i2<resolution;i2++){
				var index:int=i2*4;
				o_bitbuffer.setBit(p,(	pixcel_temp[index+0]+pixcel_temp[index+1]+pixcel_temp[index+2]+pixcel_temp[index+3])/4);
				p++;
			}
		}
		return true;
	}


}
/**
 * ARPlayCard patt decoder
 */
class MarkerPattDecoder
{
	/**
	 * ビット位置のテーブル(0の位置が1-4象限で反時計回り)
	 */
	private static var _bit_index:Vector.<Vector.<int>>=Vector.<Vector.<int>>([
		Vector.<int>([	6,3,0,
			7,4,1,
			8,5,2]),
		Vector.<int>([	0,1,2,
			3,4,5,
			6,7,8]),
		Vector.<int>([	2,5,8,
			1,4,7,
			0,3,6]),
		Vector.<int>([	8,7,6,
			5,4,3,
			2,1,0])
	]);
	/**
	 * マーカパターン
	 */
	private static var _mk_patt:Vector.<Vector.<int>>=Vector.<Vector.<int>>([
		Vector.<int>([	0,0,1,
			1,0,1,
			1,1,0]),
		Vector.<int>([	0,0,0,
			1,1,1,
			0,0,1]),
		Vector.<int>([	0,0,0,
			1,0,1,
			0,1,0]),
		Vector.<int>([	1,0,1,
			1,1,1,
			1,1,1]),
		Vector.<int>([	1,0,0,
			1,1,1,
			1,0,1]),
		Vector.<int>([	0,0,1,
			1,0,0,
			1,0,1])
	]);
	private var _bits:Vector.<int>=new Vector.<int>(9);
	/**
	 * この関数は、ビットイメージ{@link #_bits}のnビット目に、値をセットします。
	 * @param i_bit_no
	 * ビットイメージのインデクス
	 * @param i_value
	 * セットする値。
	 */
	public function setBit(i_bit_no:int,i_value:int):void
	{
		this._bits[i_bit_no]=i_value;
		return;
	}
	private static function isMatchBits(i_in_bits:Vector.<int>,i_bit_map:Vector.<int>,i_bit_index:Vector.<int>,i_th:int):Boolean
	{
		for(var i:int=8;i>=0;i--){
			
			if(((i_in_bits[i]>i_th)?1:0)!=i_bit_map[i_bit_index[i]]){
				return false;
			}
		}
		return true;
	}
	private static function getThreshold(i_in_bits:Vector.<int>):int
	{
		var min:int=i_in_bits[0];
		var max:int=i_in_bits[0];
		for(var i:int=i_in_bits.length-1;i>0;i--){
			if(min>i_in_bits[i]){
				min=i_in_bits[i];
			}else if(max<i_in_bits[i]){
				max=i_in_bits[i];
			}
		}
		return (max+min)/2;
	}
	public function decodePatt(i_result:PsARPlayCardPickup_PsArIdParam):Boolean
	{
		var th:int=getThreshold(this._bits);
		for(var i:int=_mk_patt.length-1;i>=0;i--){
			for(var i2:int=_bit_index.length-1;i2>=0;i2--){
				if(isMatchBits(this._bits,_mk_patt[i],_bit_index[i2],th)){
					i_result.direction=i2;
					i_result.id=i+1;
					return true;
				}
			}
		}
		return false;
	}
}