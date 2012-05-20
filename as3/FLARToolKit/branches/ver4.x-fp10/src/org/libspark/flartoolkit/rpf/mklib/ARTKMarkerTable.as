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
package org.libspark.flartoolkit.rpf.mklib 
{
	import org.libspark.flartoolkit.core.match.*;

	import org.libspark.flartoolkit.core.*;
	import org.libspark.flartoolkit.core.types.*;
	import org.libspark.flartoolkit.core.raster.rgb.*;
	import org.libspark.flartoolkit.core.rasterfilter.rgb2gs.*;
	import org.libspark.flartoolkit.core.rasterdriver.*;	
	import org.libspark.flartoolkit.rpf.reality.nyartk.*;
	import org.libspark.flartoolkit.rpf.realitysource.nyartk.*;
	/**
	 * 簡易なARToolKitパターンテーブルです。
	 * このクラスは、ARToolKitスタイルのパターンファイルとIdとメタデータセットテーブルを定義します。
	 */
	public class ARTKMarkerTable
	{

		private var _resolution_width:int;
		private var _resolution_height:int;
		private var _edge_x:int;
		private var _edge_y:int;
		private var _sample_per_pix:int;
		private var _tmp_raster:FLARRgbRaster;
		private var _match_patt:FLARMatchPatt_Color_WITHOUT_PCA;
		private var _deviation_data:FLARMatchPattDeviationColorData;
		private var _table:MarkerTable;
		/**
		 * コンストラクタです。
		 * @param i_max
		 * 登録するアイテムの最大数です。
		 * @param i_resolution_x
		 * 登録するパターンの解像度です。
		 * ARToolKit互換の標準値は16です。
		 * @param i_resolution_y
		 * 登録するパターンの解像度です。
		 * ARToolKit互換の標準値は16です。
		 * @param i_edge_x
		 * エッジ部分の割合です。ARToolKit互換の標準値は25です。
		 * @param i_edge_y
		 * エッジ部分の割合です。ARToolKit互換の標準値は25です。
		 * @param i_sample_per_pix
		 * パターン取得の1ピクセルあたりのサンプリング数です。1なら1Pixel=1,2なら1Pixel=4のサンプリングをします。
		 * ARToolKit互換の標準値は4です。
		 * 高解像度(64以上)のパターンを用いるときは、サンプリング数を低く設定してください。
		 * @throws FLARException 
		 */
		public function ARTKMarkerTable(i_max:int,i_resolution_x:int,i_resolution_y:int,i_edge_x:int,i_edge_y:int,i_sample_per_pix:int)
		{
			this._resolution_width=i_resolution_x;
			this._resolution_height=i_resolution_y;
			this._edge_x=i_edge_x;
			this._edge_y=i_edge_y;
			this._sample_per_pix=i_sample_per_pix;
			this._tmp_raster=new FLARRgbRaster(i_resolution_x,i_resolution_y,FLARBufferType.INT1D_X8R8G8B8_32);
			this._table=new MarkerTable(i_max);
			this._deviation_data=new FLARMatchPattDeviationColorData(i_resolution_x,i_resolution_y);		
			this._match_patt=new FLARMatchPatt_Color_WITHOUT_PCA(i_resolution_x,i_resolution_y);
		}
		/**
		 * ARTKパターンコードを、テーブルに追加します。このパターンコードのメタデータとして、IDと名前を指定できます。
		 * @param i_code
		 * ARToolKit形式のパターンコードを格納したオブジェクト。このオブジェクトは、関数成功後はインスタンスに所有されます。
		 * パターンコードの解像度は、コンストラクタに指定した高さと幅である必要があります。
		 * @param i_id
		 * このマーカを識別するユーザ定義のID値です。任意の値を指定できます。不要な場合は0を指定してください。
		 * @param i_name
		 * ユーザ定義の名前です。任意の値を指定できます。不要な場合はnullを指定して下さい。
		 * @param i_width
		 * マーカの高さ[通常mm単位]
		 * @param i_height
		 * マーカの幅[通常mm単位]
		 * @return
		 */
		public function addMarker(i_code:FLARCode,i_id:int,i_name:String,i_width:Number,i_height:Number):Boolean
		{
			//assert(i_code.getHeight()== this._resolution_height && i_code.getHeight()== this._resolution_width);
			var d:SerialTableRow=SerialTableRow(this._table.prePush());
			if(d==null){
				return false;
			}
			d.setValue(i_code,i_id,i_name,i_width,i_height);
			return true;
		}
		/**
		 * i_rasterからパターンコードを生成して、テーブルへ追加します。
		 * @param i_raster
		 * @param i_id
		 * このマーカを識別するユーザ定義のID値です。任意の値を指定できます。不要な場合は0を指定してください。
		 * @param i_name
		 * ユーザ定義の名前です。任意の値を指定できます。不要な場合はnullを指定して下さい。
		 * @param i_width
		 * マーカの高さ[通常mm単位]
		 * @param i_height
		 * マーカの幅[通常mm単位]
		 * @return
		 * @throws FLARException
		 */
		public function addMarker_2(i_raster:FLARRgbRaster,i_id:int,i_name:String,i_width:Number,i_height:Number):Boolean
		{
			var d:SerialTableRow=SerialTableRow(this._table.prePush());
			if(d==null){
				return false;
			}
			var c:FLARCode=new FLARCode(this._resolution_width,this._resolution_height);
			c.setRaster_2(i_raster);
			d.setValue(c,i_id,i_name,i_width,i_height);
			return true;
		}
		/**
		 * ARToolkit準拠のパターンファイルからパターンコードを生成して、テーブルへ追加します。
		 * @param i_filename
		 * @param i_id
		 * このマーカを識別するユーザ定義のID値です。任意の値を指定できます。不要な場合は0を指定してください。
		 * @param i_name
		 * ユーザ定義の名前です。任意の値を指定できます。不要な場合はnullを指定して下さい。
		 * @param i_width
		 * マーカの高さ[通常mm単位]
		 * @param i_height
		 * マーカの幅[通常mm単位]
		 * @return
		 * @throws FLARException
		 */
		public function addMarkerFromARPattFile(i_stream:String,i_id:int,i_name:String,i_width:Number,i_height:Number):Boolean
		{
			var d:SerialTableRow=SerialTableRow(this._table.prePush());
			if(d==null){
				return false;
			}
			var c:FLARCode=new FLARCode(this._resolution_width,this._resolution_height);
			c.loadARPatt(i_stream);
			d.setValue(c,i_id,i_name,i_width,i_height);
			return true;
		}	
		
		private var __tmp_patt_result:FLARMatchPattResult=new FLARMatchPattResult();
		/**
		 * RealityTargetに最も一致するパターンをテーブルから検索して、メタデータを返します。
		 * @param i_target
		 * Realityが検出したターゲット。
		 * Unknownターゲットを指定すること。
		 * @param i_rtsorce
		 * i_targetを検出したRealitySourceインスタンス。
		 * @param o_result
		 * 返却値を格納するインスタンスを設定します。
		 * 返却値がtrueの場合のみ、内容が更新されています。
		 * @return
		 * 特定に成功すると、trueを返します。
		 * @throws FLARException 
		 */
		public function getBestMatchTarget(i_target:FLARRealityTarget,i_rtsorce:FLARRealitySource,o_result:ARTKMarkerTable_GetBestMatchTargetResult):Boolean
		{
			//パターン抽出
			var tmp_patt_result:FLARMatchPattResult=this.__tmp_patt_result;
			var r:IFLARPerspectiveCopy=i_rtsorce.refPerspectiveRasterReader();
			r.copyPatt_2(i_target.refTargetVertex(),this._edge_x,this._edge_y,this._sample_per_pix,this._tmp_raster);
			//比較パターン生成
			this._deviation_data.setRaster(this._tmp_raster);
			var ret:int=-1;
			var dir:int=-1;
			var cf:Number=0;
			for(var i:int=this._table.getLength()-1;i>=0;i--){
				this._match_patt.setARCode(this._table.getItem(i).code);
				this._match_patt.evaluate(this._deviation_data, tmp_patt_result);
				if(cf<tmp_patt_result.confidence){
					ret=i;
					cf=tmp_patt_result.confidence;
					dir=tmp_patt_result.direction;
				}
			}
			if(ret<0){
				return false;
			}
			//戻り値を設定
			var row:SerialTableRow=SerialTableRow(this._table.getItem(ret));
			o_result.artk_direction=dir;
			o_result.confidence=cf;
			o_result.idtag=row.idtag;
			o_result.marker_height=row.marker_height;
			o_result.marker_width=row.marker_width;
			o_result.name=row.name;
			return true;
		}
	}

}

import org.libspark.flartoolkit.core.types.stack.*;
import org.libspark.flartoolkit.core.*;
class SerialTableRow
{
	public var idtag:int;
	public var name:String;
	public var code:FLARCode;
	public var marker_width:Number;
	public var marker_height:Number;
	public function setValue(i_code:FLARCode,i_idtag:int,i_name:String,i_width:Number,i_height:Number):void
	{
		this.code=i_code;
		this.marker_height=i_height;
		this.marker_width=i_width;
		this.name=i_name;
		this.idtag=i_idtag;
	}
}

class MarkerTable extends FLARObjectStack
{
	public function MarkerTable(i_length:int)
	{
		super.initInstance(i_length);
	}
	protected override function createElement():Object
	{
		return new SerialTableRow();
	}
}