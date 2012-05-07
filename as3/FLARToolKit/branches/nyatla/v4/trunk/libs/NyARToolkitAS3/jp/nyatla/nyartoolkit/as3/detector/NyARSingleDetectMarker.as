/* 
 * PROJECT: NyARToolkitAS3
 * --------------------------------------------------------------------------------
 * This work is based on the original ARToolKit developed by
 *   Hirokazu Kato
 *   Mark Billinghurst
 *   HITLab, University of Washington, Seattle
 * http://www.hitl.washington.edu/artoolkit/
 *
 * The NyARToolkitAS3 is AS3 edition ARToolKit class library.
 * Copyright (C)2010 Ryo Iizuka
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
package jp.nyatla.nyartoolkit.as3.detector 
{
	import jp.nyatla.nyartoolkit.as3.core.rasterfilter.rgb2gs.*;
	import jp.nyatla.nyartoolkit.as3.core.param.*;
	import jp.nyatla.nyartoolkit.as3.core.match.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.*;
	import jp.nyatla.nyartoolkit.as3.core.raster.rgb.*;
	import jp.nyatla.nyartoolkit.as3.core.*;
	import jp.nyatla.nyartoolkit.as3.*;
	import jp.nyatla.nyartoolkit.as3.core.utils.*;
	import jp.nyatla.nyartoolkit.as3.core.pickup.*;
	import jp.nyatla.nyartoolkit.as3.core.squaredetect.*;
	import jp.nyatla.nyartoolkit.as3.core.transmat.*;
	import jp.nyatla.nyartoolkit.as3.core.labeling.rlelabeling.*;
	import jp.nyatla.nyartoolkit.as3.core.squaredetect.*;
	import jp.nyatla.nyartoolkit.as3.core.types.*;
	import jp.nyatla.nyartoolkit.as3.core.rasterdriver.*;
	
	/**
	 * 画像からARCodeに最も一致するマーカーを1個検出し、その変換行列を計算するクラスです。
	 * 
	 */
	public class NyARSingleDetectMarker
	{
		/**
		 * この関数は、マーカーの画像上の位置を格納する、{@link NyARSquare}への参照値を返します。
		 * 直前に実行した{@link #detectMarkerLite}が成功していないと使えません。
		 * 返却値の内容は、次に{@link #detectMarkerLite}を実行するまで有効です。
		 * @return
		 * 矩形情報への参照値。
		 */
		public function refSquare():NyARSquare
		{
			return this._square;
		}
		/**
		 * この関数は、検出したマーカーと登録済パターンとの、一致度を返します。
		 * 直前に実行した{@link #detectMarkerLite}が成功していないと使えません。
		 * 値は、0&lt;=n<1の間の数値を取ります。
		 * 一般的に、一致度が低い場合は、マーカを誤認識しています。
		 * @return
		 * 一致度の数値。
		 */
		public function getConfidence():Number
		{
			return this._confidence;
		}
		/**
		 * この関数は、変換行列の計算モードを切り替えます。
		 * 通常はtrueを使用します。
		 * transMat互換の計算は、姿勢の初期値を毎回二次元座標から計算するため、負荷が安定します。
		 * transMatCont互換の計算は、姿勢の初期値に前回の結果を流用します。このモードは、姿勢の安定したマーカに対しては
		 * ジッタの減少や負荷減少などの効果がありますが、姿勢の安定しないマーカや複数のマーカを使用する環境では、
		 * 少量の負荷変動があります。
		 * @param i_is_continue
		 * TRUEなら、transMatCont互換の計算をします。 FALSEなら、transMat互換の計算をします。
		 */
		public function setContinueMode(i_is_continue:Boolean):void
		{
			this._is_continue = i_is_continue;
		}
		/**
		 * この関数は、検出したマーカーの変換行列を計算して、o_resultへ値を返します。
		 * 直前に実行した{@link #detectMarkerLite}が成功していないと使えません。
		 * @param o_result
		 * 変換行列を受け取るオブジェクト。
		 * @throws NyARException
		 */
		public function getTransmat(o_result:NyARTransMatResult):void
		{
			// 一番一致したマーカーの位置とかその辺を計算
			if (this._is_continue) {
				this._transmat.transMatContinue(this._square,this._offset,o_result, o_result);
			} else {
				this._transmat.transMat(this._square,this._offset, o_result);
			}
			return;
		}
		/**
		 * @deprecated
		 * {@link #getTransmat}
		 */
		public function getTransmationMatrix(o_result:NyARTransMatResult):void
		{
			this.getTransmat(o_result);
			return;
		}
		/** 参照インスタンス*/
		private var _last_input_raster:INyARRgbRaster=null;
		private var _bin_filter:INyARRgb2GsFilterArtkTh=null;
		/**
		 * この関数は、画像から登録済のマーカ検出を行います。
		 * マーカの検出に成功すると、thisのプロパティにマーカの二次元位置を記録します。
		 * 関数の成功後は、マーカの姿勢行列と、一致度を、それぞれ{@link #getTransmationMatrix}と{@link #getConfidence}から得ることができます。
		 * @param i_raster
		 * マーカーを検出する画像。画像のサイズは、コンストラクタに指定した{@link NyARParam}オブジェクトと一致していなければなりません。
		 * @param i_th
		 * 2値化敷居値。0から256までの値を指定します。
		 * @return
		 * マーカーが検出できたかを、真偽値で返します。
		 * @throws NyARException
		 */	
		public function detectMarkerLite(i_raster:INyARRgbRaster,i_th:int):Boolean
		{
			//サイズチェック
			if(!this._bin_raster.getSize().isEqualSize_2(i_raster.getSize())){
				throw new NyARException();
			}
			//最終入力ラスタを更新
			if(this._last_input_raster!=i_raster){
				this._bin_filter=INyARRgb2GsFilterArtkTh(i_raster.createInterface(INyARRgb2GsFilterArtkTh));
				this._last_input_raster=i_raster;
			}
			//ラスタを２値イメージに変換する.
			this._bin_filter.doFilter(i_th,this._bin_raster);

			//コールバックハンドラの準備
			this._confidence=0;
			this._last_input_raster=i_raster;
			//
			//マーカ検出器をコール
			this.execDetectMarker();
			if(this._confidence==0){
				return false;
			}
			return true;
		}
		
		
		/** 姿勢変換行列の変換器*/
		protected var _transmat:INyARTransMat;
		/** マーカパターンの保持用*/
		protected var _inst_patt:INyARColorPatt;
		private var _offset:NyARRectOffset; 
		private var _deviation_data:NyARMatchPattDeviationColorData;
		private var _match_patt:NyARMatchPatt_Color_WITHOUT_PCA;
		private var _coordline:NyARCoord2Linear;	
		protected var _bin_raster:NyARBinRaster;
		/** 一致率*/
		private var _confidence:Number=0;
		/** 認識矩形の記録用*/
		protected var _square:NyARSquare=new NyARSquare();
		

		protected var _is_continue:Boolean = false;
		private var __detectMarkerLite_mr:NyARMatchPattResult=new NyARMatchPattResult();

		private var __ref_vertex:Vector.<NyARIntPoint2d>=new Vector.<NyARIntPoint2d>(4);
		
		
		
		/**
		 * 内部関数です。
		 * この関数は、thisの二次元矩形情報プロパティを更新します。
		 * @param i_coord
		 * @param i_vertex_index
		 * @throws NyARException
		 */
		public function updateSquareInfo(i_coord:NyARIntCoordinates,i_vertex_index:Vector.<int>):void
		{
			var mr:NyARMatchPattResult=this.__detectMarkerLite_mr;
			//輪郭座標から頂点リストに変換
			var vertex:Vector.<NyARIntPoint2d>=this.__ref_vertex;	//C言語ならポインタ扱いで実装
			vertex[0]=i_coord.items[i_vertex_index[0]];
			vertex[1]=i_coord.items[i_vertex_index[1]];
			vertex[2]=i_coord.items[i_vertex_index[2]];
			vertex[3]=i_coord.items[i_vertex_index[3]];
		
			//画像を取得
			if (!this._inst_patt.pickFromRaster(this._last_input_raster,vertex)){
				return;
			}
			//取得パターンをカラー差分データに変換して評価する。
			this._deviation_data.setRaster(this._inst_patt);
			if(!this._match_patt.evaluate(this._deviation_data,mr)){
				return;
			}
			//現在の一致率より低ければ終了
			if (this._confidence > mr.confidence){
				return;
			}
			//一致率の高い矩形があれば、方位を考慮して頂点情報を作成
			var sq:NyARSquare=this._square;
			this._confidence = mr.confidence;
			//directionを考慮して、squareを更新する。
			var i:int;
			for(i=0;i<4;i++){
				var idx:int=(i+4 - mr.direction) % 4;
				this._coordline.coord2Line(i_vertex_index[idx],i_vertex_index[(idx+1)%4],i_coord,sq.line[i]);
			}
			//ちょっと、ひっくり返してみようか。
			for (i = 0; i < 4; i++) {
				//直線同士の交点計算
				if(!sq.line[i].crossPos(sq.line[(i + 3) % 4],sq.sqvertex[i])){
					throw new NyARException();//ここのエラー復帰するならダブルバッファにすればOK
				}
			}
		}
		/**
		 * このコンストラクタは直接使わないでください。
		 * createInstance_xを使ってください。
		 * @param	...args
		 */
		public function NyARSingleDetectMarker(...args:Array)
		{
			switch(args.length){
			case 3:
				NyARSingleDetectMarker_3oon(NyARParam(args[0]), NyARCode(args[1]),Number(args[2]));
				break;
			default:
				throw new NyARException();
			}
		}
		
		protected function NyARSingleDetectMarker_3oon(i_ref_param:NyARParam,i_ref_code:NyARCode,i_marker_width:Number):void
		{
			this._deviation_data=new NyARMatchPattDeviationColorData(i_ref_code.getWidth(),i_ref_code.getHeight());
			this._match_patt=new NyARMatchPatt_Color_WITHOUT_PCA(i_ref_code);		
			this._offset=new NyARRectOffset();
			this._offset.setSquare(i_marker_width);
			this._coordline=new NyARCoord2Linear(i_ref_param.getScreenSize(),i_ref_param.getDistortionFactor());
			//２値画像バッファを作る		
			var s:NyARIntSize=i_ref_param.getScreenSize();
			this._bin_raster=new NyARBinRaster(s.w,s.h);
		}
		protected function execDetectMarker():void
		{
			throw new NyARException("must be override!");
		}
		
		/** ARToolKit互換のアルゴリズムを選択します。*/
		public static const PF_ARTOOLKIT_COMPATIBLE:int=1;
		/** NyARToolKitのアルゴリズムを選択します。*/
		public static const PF_NYARTOOLKIT:int=2;
		/** ARToolKit互換アルゴリズムと、NyARToolKitのアルゴリズムの混合です。2D系にNyARToolkit,3D系にARToolKitのアルゴリズムを選択します。*/
		public static const PF_NYARTOOLKIT_ARTOOLKIT_FITTING:int=100;
		/** 開発用定数値*/
		public static const PF_TEST2:int=201;	
		/**
		 * 処理プロファイルを指定して、{@link NyARSingleDetectoMarker}オブジェクトを生成します。
		 * @param i_param
		 * カメラパラメータを指定します。このサイズは、{@link #detectMarkerLite}に入力する画像と同じである必要があります。
		 * @param i_code
		 * 検出するマーカパターンを指定します。
		 * @param i_marker_width
		 * 正方形マーカの物理サイズをmm単位で指定します。
		 * @param i_input_raster_type
		 * {@link #detectMarkerLite}に入力するラスタの画素形式を指定します。
		 * この値は、{@link INyARRgbRaster#getBufferType}関数の戻り値を利用します。
		 * @param i_profile_id
		 * 計算アルゴリズムの選択値です。以下の定数のいずれかを指定します。
		 * <ul>
		 * <li>{@link #PF_ARTOOLKIT_COMPATIBLE}
		 * <li>{@link #PF_NYARTOOLKIT}
		 * <li>{@link #PF_NYARTOOLKIT_ARTOOLKIT_FITTING}
		 * </ul>
		 * @throws NyARException 
		 * @throws NyARException
		 */	
		public static function createInstance(i_param:NyARParam, i_code:NyARCode,i_marker_width:Number,i_profile_id:int):NyARSingleDetectMarker
		{
			switch(i_profile_id){
			case PF_NYARTOOLKIT://default
				return new NyARSingleDetectMarker_NyARTK(i_param,i_code,i_marker_width);
			default:
				throw new NyARException();
			}		
		}
		public static function createInstance_2(i_param:NyARParam, i_code:NyARCode, i_marker_width:Number):NyARSingleDetectMarker
		{
			return createInstance(i_param,i_code,i_marker_width,PF_NYARTOOLKIT);
		}
	}
}
import jp.nyatla.nyartoolkit.as3.detector.*;
import jp.nyatla.nyartoolkit.as3.core.squaredetect.*;
import jp.nyatla.nyartoolkit.as3.core.types.*;
import jp.nyatla.nyartoolkit.as3.core.param.*;
import jp.nyatla.nyartoolkit.as3.core.*;
import jp.nyatla.nyartoolkit.as3.core.pickup.*;
import jp.nyatla.nyartoolkit.as3.core.transmat.*;



//
//各プロファイル毎のクラス
//



/**
 * NyARToolkitのアルゴリズムを使用するSingleDetectMarker
 * @author nyatla
 *
 */
class NyARSingleDetectMarker_NyARTK extends NyARSingleDetectMarker
{
	private var _square_detect:RleDetector;
	/**
	 * RleLabelingを使った矩形検出機
	 */	
	public function NyARSingleDetectMarker_NyARTK(i_ref_param:NyARParam, i_ref_code:NyARCode, i_marker_width:Number)
	{
		super(i_ref_param,i_ref_code,i_marker_width);
		this._inst_patt=new NyARColorPatt_Perspective(i_ref_code.getWidth(), i_ref_code.getHeight(),4,25);
		this._transmat=new NyARTransMat(i_ref_param);
		this._square_detect=new RleDetector(this,i_ref_param.getScreenSize());
	}	
	protected override function execDetectMarker():void
	{
		//矩形を探す(戻り値はコールバック関数で受け取る。)
		this._square_detect.detectMarker_2(this._bin_raster,0,this._square_detect);
		
	}
}


/**
 * Rleラ矩形Detectorのブリッジ
 *
 */
class RleDetector extends NyARSquareContourDetector_Rle implements NyARSquareContourDetector_CbHandler
{
	private var _parent:NyARSingleDetectMarker;
	public function RleDetector(i_parent:NyARSingleDetectMarker,i_size:NyARIntSize):void
	{
		super(i_size);
		this._parent=i_parent;
	}
	public function detectMarkerCallback(i_coord:NyARIntCoordinates, i_vertex_index:Vector.<int>):void
	{

		this._parent.updateSquareInfo(i_coord, i_vertex_index);
	}	
}
