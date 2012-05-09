package jp.nyatla.nyartoolkit.as3.rpf.mklib 
{
	import jp.nyatla.nyartoolkit.as3.nyidmarker.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.*;
	import jp.nyatla.nyartoolkit.as3.core.pixeldriver.*;
	import jp.nyatla.nyartoolkit.as3.core.rasterfilter.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.rgb.*;
	import jp.nyatla.nyartoolkit.as3.nyidmarker.data.*;
	import jp.nyatla.nyartoolkit.as3.rpf.realitysource.nyartk.*;
	import jp.nyatla.nyartoolkit.as3.rpf.tracker.nyartk.status.*;
	import jp.nyatla.nyartoolkit.as3.rpf.reality.nyartk.*;
	/**
	 * 簡易な同期型NyIdマーカIDテーブルです。
	 * このクラスは、RawBitフォーマットドメインのNyIdマーカのIdとメタデータセットテーブルを定義します。
	 * SerialIDは、RawBitマーカのデータパケットを、[0][1]...[n]の順に並べて、64bitの整数値に変換した値です。
	 * 判別できるIdマーカは、domain=0(rawbit),model&lt;5,mask=0のもののみです。
	 * <p>
	 * このクラスは、NyRealityTargetをRawBitフォーマットドメインのSerialNumberマーカにエンコードする
	 * 機能を提供します。
	 * 使い方は、ユーザは、このクラスにIDマーカのSerialNumberとそのサイズを登録します。その後に、
	 * NyRealityTargetをキーに、登録したデータからそのSerialNumberをサイズを得ることができます。
	 * </p>
	 * 
	 * NyIdRawBitSerialNumberTable
	 */
	public class RawbitSerialIdTable
	{
		private var _table:SerialTable;
		private var _id_pickup:NyIdMarkerPickup;
		private var _temp_nyid_info:NyIdMarkerPattern=new NyIdMarkerPattern();
		private var _temp_nyid_param:NyIdMarkerParam =new NyIdMarkerParam();
		
		private var _rb:NyIdMarkerDataEncoder_RawBit=new NyIdMarkerDataEncoder_RawBit();
		private var _rb_dest:NyIdMarkerData_RawBit=new NyIdMarkerData_RawBit();

		/**
		 * コンストラクタです。
		 * @param i_max
		 * 登録するアイテムの最大数です。
		 * @throws NyARException 
		 */
		public function RawbitSerialIdTable(i_max:int)
		{
			this._id_pickup= new NyIdMarkerPickup();
			this._table=new SerialTable(i_max);
		}
		/**
		 * IDの範囲に対するメタデータセットを、テーブルに追加します。
		 * この要素にヒットする範囲は,i_st&lt;=n&lt;=i_edになります。
		 * @param i_name
		 * このID範囲の名前を指定します。不要な場合はnullを指定します。
		 * @param i_st
		 * ヒット範囲の開始値です。
		 * @param i_ed
		 * ヒット範囲の終了値です。
		 * @param　i_width
		 * ヒットしたマーカのサイズ値を指定します。
		 */
		public function addSerialIdRangeItem(i_name:String,i_st:Number,i_ed:Number,i_width:Number):Boolean
		{
			var d:SerialTableRow=SerialTableRow(this._table.prePush());
			if(d==null){
				return false;
			}
			d.setValue(i_name,i_st,i_ed,i_width);
			return true;
		}
		/**
		 * SerialIDに対するメタデータセットを、テーブルに追加します。
		 * @param i_serial
		 * ヒットさせるシリアルidです。
		 * @param i_width
		 * ヒットしたマーカのサイズ値です。
		 * @return
		 * 登録に成功するとtrueを返します。
		 */
		public function addSerialIdItem(i_name:String,i_serial:Number,i_width:Number):Boolean
		{
			var d:SerialTableRow=SerialTableRow(this._table.prePush());
			if(d==null){
				return false;
			}
			d.setValue(i_name,i_serial,i_serial,i_width);
			return true;
		}
		/**
		 * 全てのSerialIDにヒットするメタデータセットを、テーブルに追加します。
		 * @param i_width
		 * ヒットしたマーカのサイズ値です。
		 * @return
		 * 登録に成功するとtrueです。
		 */
		public function addAnyItem(i_name:String,i_width:Number):Boolean
		{
			var d:SerialTableRow=SerialTableRow(this._table.prePush());
			if(d==null){
				return false;
			}
			d.setValue(i_name,0,Number.MAX_VALUE,i_width);
			return true;
		}
		private var _last_laster:INyARRaster=null;
		private var _gs_pix_reader:INyARGsPixelDriver;
		/**
		 * i_raster上にあるi_vertexの頂点で定義される四角形のパターンから、一致するID値を特定します。
		 * @param i_vertex
		 * 4頂点の座標
		 * @param i_raster
		 * @param o_result
		 * @return
		 * @throws NyARException
		 */
		public function identifyId(i_vertex:Vector.<NyARDoublePoint2d>,i_raster:INyARRgbRaster,o_result:RawbitSerialIdTable_IdentifyIdResult):Boolean
		{
			if(this._last_laster!=i_raster){
				this._gs_pix_reader=NyARGsPixelDriverFactory.createDriver_2(i_raster);
				this._last_laster=i_raster;
			}
			if(!this._id_pickup.pickFromRaster(this._gs_pix_reader,i_vertex,this._temp_nyid_info,this._temp_nyid_param))
			{
				return false;
			}
			//受け付けられるControlDomainは0のみ
			if(this._temp_nyid_info.ctrl_domain!=0)
			{
				return false;
			}
			//受け入れられるMaskは0のみ
			if(this._temp_nyid_info.ctrl_mask!=0)
			{
				return false;
			}
			//受け入れられるModelは5未満
			if(this._temp_nyid_info.model>=5)
			{
				return false;
			}

			this._rb.createDataInstance();
			if(!this._rb.encode(this._temp_nyid_info,this._rb_dest)){
				return false;
			}
			//SerialIDの再構成
			var s:Number=0;
			//最大4バイト繋げて１個のint値に変換
			for (var i:int = 0; i < this._rb_dest.length; i++)
			{
				s= (s << 8) | this._rb_dest.packet[i];
			}		
			//SerialID引きする。
			var d:SerialTableRow=this._table.getItembySerialId(s);
			if(d==null){
				return false;
			}
			//戻り値を設定
			o_result.marker_width=d.marker_width;
			o_result.id=s;
			o_result.artk_direction=this._temp_nyid_param.direction;
			o_result.name=d.name;
			return true;		
		}
		/**
		 * RealityTargetに一致するID値を特定します。
		 * 複数のパターンにヒットしたときは、一番初めにヒットした項目を返します。
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
		 * @throws NyARException 
		 */
		public function identifyId_2(i_target:NyARRealityTarget,i_rtsorce:NyARRealitySource,o_result:RawbitSerialIdTable_IdentifyIdResult):Boolean
		{
			//NyARDoublePoint2d[] i_vertex,NyARRgbRaster i_raster,SelectResult o_result
			return this.identifyId(
				((NyARRectTargetStatus)(i_target._ref_tracktarget._ref_status)).vertex,
				i_rtsorce.refRgbSource(),
				o_result);
		}
		//指定したIDとパターンが一致するか確認するAPIも用意するか？
	}

}
import jp.nyatla.nyartoolkit.as3.core.types.stack.*;

class SerialTableRow
{
	public var id_st:Number;
	public var id_ed:Number;
	public var marker_width:Number;
	public var name:String;
	public function setValue(i_name:String,i_st:Number,i_ed:Number,i_width:Number):void
	{
		this.id_ed=i_ed;
		this.id_st=i_st;
		this.marker_width=i_width;
		this.name=i_name;
	}
}

class SerialTable extends NyARObjectStack
{
	public function SerialTable(i_length:int)
	{
		super();
		super.initInstance(i_length);
	}
	protected override function createElement():Object
	{
		return new SerialTableRow();
	}
	public function getItembySerialId(i_serial:Number):SerialTableRow
	{
		for(var i:int=this._length-1;i>=0;i--)
		{
			var s:SerialTableRow=SerialTableRow(this._items[i]);
			if(i_serial<s.id_st || i_serial>s.id_ed){
				continue;
			}
			return s;
		}
		return null;
	}
}