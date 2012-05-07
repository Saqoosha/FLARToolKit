package jp.nyatla.nyartoolkit.as3.rpf.tracker.nyartk.status
{

import jp.nyatla.nyartoolkit.as3.core.*;
import jp.nyatla.nyartoolkit.as3.core.types.*;
import jp.nyatla.nyartoolkit.as3.core.utils.NyARMath;
import jp.nyatla.nyartoolkit.as3.rpf.sampler.lrlabel.*;
import jp.nyatla.nyartoolkit.as3.rpf.tracker.nyartk.*;
import jp.nyatla.nyartoolkit.as3.rpf.utils.*;




public class NyARRectTargetStatus extends NyARTargetStatus
{
	private var _ref_my_pool:NyARRectTargetStatusPool;
	
	
	/**
	 * 現在の矩形情報
	 */
	public var vertex:Vector.<NyARDoublePoint2d>=NyARDoublePoint2d.createArray(4);

	/**
	 * 予想した頂点速度の二乗値の合計
	 */
	public var estimate_sum_sq_vertex_velocity_ave:int;

	/**
	 * 予想頂点範囲
	 */
	public var estimate_rect:NyARIntRect=new NyARIntRect();
	/**
	 * 予想頂点位置
	 */
	public var estimate_vertex:Vector.<NyARDoublePoint2d>=NyARDoublePoint2d.createArray(4);

	/**
	 * 最後に使われた検出タイプの値です。DT_xxxの値をとります。
	 */
	public var detect_type:int;
	/**
	 * 初期矩形検出で検出を実行した。
	 */
	public static const DT_SQINIT:int=0;
	/**
	 * 定常矩形検出で検出を実行した。
	 */
	public static const DT_SQDAILY:int=1;
	/**
	 * 定常直線検出で検出を実行した。
	 */
	public static const DT_LIDAILY:int=2;
	/**
	 * みつからなかったよ。
	 */
	public static const DT_FAILED:int=-1;
	
	//
	//制御部
	
	/**
	 * @Override
	 */
	public function NyARRectTargetStatus(i_pool:NyARRectTargetStatusPool)
	{
		super(i_pool._op_interface);
		this._ref_my_pool=i_pool;
		this.detect_type=DT_SQINIT;
	}

	/**
	 * 前回のステータスと予想パラメータを計算してセットします。
	 * @param i_prev_param
	 */
	private function setEstimateParam(i_prev_param:NyARRectTargetStatus):void
	{
		var vc_ptr:Vector.<NyARDoublePoint2d>=this.vertex;
		var ve_ptr:Vector.<NyARDoublePoint2d>=this.estimate_vertex;
		var sum_of_vertex_sq_dist:int = 0;
		var i:int;
		if(i_prev_param!=null){
			//差分パラメータをセット
			var vp:Vector.<NyARDoublePoint2d>=i_prev_param.vertex;
			//頂点速度の計測
			for(i=3;i>=0;i--){
				var x:int=(int)((vc_ptr[i].x-vp[i].x));
				var y:int=(int)((vc_ptr[i].y-vp[i].y));
				//予想位置
				ve_ptr[i].x=(int)(vc_ptr[i].x+x);
				ve_ptr[i].y=(int)(vc_ptr[i].y+y);
				sum_of_vertex_sq_dist+=x*x+y*y;
			}
		}else{
			//頂点速度のリセット
			for(i=3;i>=0;i--){
				ve_ptr[i].x=(int)(vc_ptr[i].x);
				ve_ptr[i].y=(int)(vc_ptr[i].y);
			}
		}
		//頂点予測と範囲予測
		this.estimate_sum_sq_vertex_velocity_ave=sum_of_vertex_sq_dist/4;
		this.estimate_rect.setAreaRect(ve_ptr,4);
//		this.estimate_rect.clip(i_left, i_top, i_right, i_bottom);
		return;
	}
	
	/**
	 * 輪郭情報を元に矩形パラメータを推定し、値をセットします。
	 * この関数は、処理の成功失敗に関わらず、内容変更を行います。
	 * @param i_contour_status
	 * 関数を実行すると、このオブジェクトの内容は破壊されます。
	 * @return
	 * @throws NyARException
	 */
	public function setValueWithInitialCheck(i_contour_status:NyARContourTargetStatus,i_sample_area:NyARIntRect):Boolean
	{
		//ベクトルのマージ(マージするときに、3,4象限方向のベクトルは1,2象限のベクトルに変換する。)
		i_contour_status.vecpos.limitQuadrantTo12();
		this._ref_my_pool._vecpos_op.margeResembleCoords(i_contour_status.vecpos);
		if(i_contour_status.vecpos.length<4){
			return false;
		}
		//キーベクトルを取得
		i_contour_status.vecpos.getKeyCoord(this._ref_my_pool._indexbuf);
		//点に変換
		var this_vx:Vector.<NyARDoublePoint2d>=this.vertex;
		if(!this._ref_my_pool._line_detect.line2SquareVertex(this._ref_my_pool._indexbuf,this_vx)){
			return false;
		}
//		//点から直線を再計算
//		for(int i=3;i>=0;i--){
//			this_sq.line[i].makeLinearWithNormalize(this_sq.sqvertex[i],this_sq.sqvertex[(i+1)%4]);
//		}
		this.setEstimateParam(null);
		if(!checkInitialRectCondition(i_sample_area))
		{
			return false;
		}
		this.detect_type=DT_SQINIT;
		return true;
	}
	/**
	 * 値をセットします。この関数は、処理の成功失敗に関わらず、内容変更を行います。
	 * @param i_sampler_in
	 * @param i_source
	 * @param i_prev_status
	 * @return
	 * @throws NyARException
	 */
	public function setValueWithDeilyCheck(i_vec_reader:INyARVectorReader,i_source:LowResolutionLabelingSamplerOut_Item,i_prev_status:NyARRectTargetStatus):Boolean
	{
		var vecpos:VecLinearCoordinates=this._ref_my_pool._vecpos;
		//輪郭線を取る
		if(!i_vec_reader.traceConture(i_source.lebeling_th,i_source.entry_pos,vecpos)){
			return false;
		}
		//3,4象限方向のベクトルは1,2象限のベクトルに変換する。
		vecpos.limitQuadrantTo12();
		//ベクトルのマージ
		this._ref_my_pool._vecpos_op.margeResembleCoords(vecpos);
		if(vecpos.length<4){
			return false;
		}
		//キーベクトルを取得
		vecpos.getKeyCoord(this._ref_my_pool._indexbuf);
		//点に変換
		var this_vx:Vector.<NyARDoublePoint2d>=this.vertex;
		if(!this._ref_my_pool._line_detect.line2SquareVertex(this._ref_my_pool._indexbuf,this_vx)){
			return false;
		}
		//頂点並び順の調整
		rotateVertexL(this.vertex,checkVertexShiftValue(i_prev_status.vertex,this.vertex));	

		//パラメタチェック
		if(!checkDeilyRectCondition(i_prev_status)){
			return false;
		}
		//次回の予測
		setEstimateParam(i_prev_status);
		return true;
	}
	/**
	 * 輪郭からの単独検出
	 * @param i_raster
	 * @param i_prev_status
	 * @return
	 * @throws NyARException
	 */
	public function setValueByLineLog(i_vec_reader:INyARVectorReader,i_prev_status:NyARRectTargetStatus):Boolean
	{
		//検出範囲からカーネルサイズの2乗値を計算。検出領域の二乗距離の1/(40*40) (元距離の1/40)
		var d:int=((int)(i_prev_status.estimate_rect.getDiagonalSqDist()/(NyARMath.SQ_40)));
		//二乗移動速度からカーネルサイズを計算。
		var v_ave_limit:int=i_prev_status.estimate_sum_sq_vertex_velocity_ave;
		//
		if(v_ave_limit>d){
			//移動カーネルサイズより、検出範囲カーネルのほうが大きかったらエラー(動きすぎ)
			return false;
		}
		d=(int)(Math.sqrt(d));
		//最低でも2だよね。
		if(d<2){
			d=2;
		}
		//最大カーネルサイズ(5)を超える場合は5にする。
		if(d>5){
			d=5;
		}
		
		//ライントレースの試行

		var sh_l:Vector.<NyARLinear>=this._ref_my_pool._line;
		if(!traceSquareLine(i_vec_reader,d,i_prev_status,sh_l)){
			return false;
		}else{
		}
		//4点抽出
		for(var i:int=3;i>=0;i--){
			if(!sh_l[i].crossPos(sh_l[(i + 3) % 4],this.vertex[i])){
				//四角が作れない。
				return false;
			}
		}		

		//頂点並び順の調整
		rotateVertexL(this.vertex,checkVertexShiftValue(i_prev_status.vertex,this.vertex));	
		//差分パラメータのセット
		setEstimateParam(i_prev_status);
		return true;
	}
	/**
	 * 状況に応じて矩形選択手法を切り替えます。
	 * @param i_vec_reader
	 * サンプリングデータの基本画像にリンクしたVectorReader
	 * @param i_source
	 * サンプリングデータ
	 * @param i_prev_status
	 * 前回の状態を格納したオブジェクト
	 * @return
	 * @throws NyARException
	 */
	public function setValueByAutoSelect(i_vec_reader:INyARVectorReader,i_source:LowResolutionLabelingSamplerOut_Item,i_prev_status:NyARRectTargetStatus):Boolean
	{
		var current_detect_type:int=DT_SQDAILY;
		//移動速度による手段の切り替え
		var sq_v_ave_limit:int=i_prev_status.estimate_sum_sq_vertex_velocity_ave/4;
		//速度が小さい時か、前回LineLogが成功したときはDT_LIDAILY
		if(((sq_v_ave_limit<10) && (i_prev_status.detect_type==DT_SQDAILY)) || (i_prev_status.detect_type==DT_LIDAILY)){
			current_detect_type=DT_LIDAILY;
		}
		
		//前回の動作ログによる手段の切り替え
		switch(current_detect_type)
		{
		case DT_LIDAILY:
			//LineLog->
			if(setValueByLineLog(i_vec_reader,i_prev_status))
			{
				//うまくいった。
				this.detect_type=DT_LIDAILY;
				return true;
			}
			if(i_source!=null){
				if(setValueWithDeilyCheck(i_vec_reader,i_source,i_prev_status))
				{
					//うまくいった
					this.detect_type=DT_SQDAILY;
					return true;
				}
			}
			break;
		case DT_SQDAILY:
			if(i_source!=null){
				if(setValueWithDeilyCheck(i_vec_reader,i_source,i_prev_status))
				{
					this.detect_type=DT_SQDAILY;
					return true;
				}
			}
			break;
		default:
			break;
		}
		//前回の動作ログを書き換え
		i_prev_status.detect_type=DT_FAILED;
		return false;
	}
	

	/**
	 * このデータが初期チェック(CoordからRectへの遷移)をパスするかチェックします。
	 * 条件は、
	 *  1.検出四角形の対角点は元の検出矩形内か？
	 *  2.一番長い辺と短い辺の比は、0.1~10の範囲か？
	 *  3.位置倍長い辺、短い辺が短すぎないか？
	 * @param i_sample_area
	 * この矩形を検出するために使った元データの範囲(ターゲット検出範囲)
	 */
	private function checkInitialRectCondition(i_sample_area:NyARIntRect):Boolean
	{
		var this_vx:Vector.<NyARDoublePoint2d>=this.vertex;

		//検出した四角形の対角点が検出エリア内か？
		var cx:int=(int)(this_vx[0].x+this_vx[1].x+this_vx[2].x+this_vx[3].x)/4;
		var cy:int=(int)(this_vx[0].y+this_vx[1].y+this_vx[2].y+this_vx[3].y)/4;
		if(!i_sample_area.isInnerPoint(cx,cy)){
			return false;
		}
		//一番長い辺と短い辺の比を確認(10倍の比があったらなんか変)
		var max:int=int.MIN_VALUE;
		var min:int=int.MAX_VALUE;
		for(var i:int=0;i<4;i++){
			var t:int=(int)(this_vx[i].sqDist(this_vx[(i+1)%4]));
			if(t>max){max=t;}
			if(t<min){min=t;}
		}
		//比率係数の確認
		if(max<(5*5) ||min<(5*5)){
			return false;
		}
		//10倍スケールの2乗
		if((10*10)*min/max<(3*3)){
			return false;
		}
		return true;
	}
	/**
	 * 2回目以降の履歴を使ったデータチェック。
	 * 条件は、
	 *  1.一番長い辺と短い辺の比は、0.1~10の範囲か？
	 *  2.位置倍長い辺、短い辺が短すぎないか？
	 *  3.移動距離が極端に大きなものは無いか？(他の物の3倍動いてたらおかしい)

	 * @param i_sample_area
	 */
	private function checkDeilyRectCondition( i_prev_st:NyARRectTargetStatus):Boolean
	{
		var this_vx:Vector.<NyARDoublePoint2d>=this.vertex;

		//一番長い辺と短い辺の比を確認(10倍の比があったらなんか変)
		var max:int=int.MIN_VALUE;
		var min:int=int.MAX_VALUE;
		for(var i:int=0;i<4;i++){
			var t:int=(int)(this_vx[i].sqDist(this_vx[(i+1)%4]));
			if(t>max){max=t;}
			if(t<min){min=t;}
		}
		//比率係数の確認
		if(max<(5*5) ||min<(5*5)){
			return false;
		}
		//10倍スケールの2乗
		if((10*10)*min/max<(3*3)){
			return false;
		}
		//移動距離平均より大きく剥離した点が無いか確認
		return this._ref_my_pool.checkLargeDiff(this_vx,i_prev_st.vertex);
	}

	/**
	 * 予想位置を基準に四角形をトレースして、一定の基準をクリアするかを評価します。
	 * @param i_reader
	 * @param i_edge_size
	 * @param i_prevsq
	 * @return
	 * @throws NyARException
	 */
	private function traceSquareLine(i_reader:INyARVectorReader , i_edge_size:int,i_prevsq: NyARRectTargetStatus,o_line:Vector.<NyARLinear>):Boolean
	{
		var p1:NyARDoublePoint2d,p2:NyARDoublePoint2d;
		var vecpos:VecLinearCoordinates=this._ref_my_pool._vecpos;
		//NyARIntRect i_rect
		p1=i_prevsq.estimate_vertex[0];
		var dist_limit:int=i_edge_size*i_edge_size;
		//強度敷居値(セルサイズ-1)
//		int min_th=i_edge_size*2+1;
//		min_th=(min_th*min_th);
		for(var i:int=0;i<4;i++)
		{
			p2=i_prevsq.estimate_vertex[(i+1)%4];
			
			//クリップ付きで予想位置周辺の直線のトレース
			i_reader.traceLineWithClip(p1,p2,i_edge_size,vecpos);

			//クラスタリングして、傾きの近いベクトルを探す。(限界は10度)
			this._ref_my_pool._vecpos_op.margeResembleCoords(vecpos);
			//基本的には1番でかいベクトルだよね。だって、直線状に取るんだもの。

			var vid:int=vecpos.getMaxCoordIndex();
			//データ品質規制(強度が多少強くないと。)
//			if(vecpos.items[vid].sq_dist<(min_th)){
//				return false;
//			}
//@todo:パラメタ調整
			//角度規制(元の線分との角度を確認)
			if(vecpos.items[vid].getAbsVecCos_3(i_prevsq.vertex[i],i_prevsq.vertex[(i+1)%4])<NyARMath.COS_DEG_5){
				//System.out.println("CODE1");
				return false;
			}
//@todo:パラメタ調整
			//予想点からさほど外れていない点であるか。(検出点の移動距離を計算する。)
			var dist:Number;
			dist=vecpos.items[vid].sqDistBySegmentLineEdge(i_prevsq.vertex[i],i_prevsq.vertex[i]);
			if(dist<dist_limit){
				o_line[i].setVectorWithNormalize(vecpos.items[vid]);
			}else{
				//System.out.println("CODE2:"+dist+","+dist_limit);
				return false;
			}
			//頂点ポインタの移動
			p1=p2;
		}
		return true;
	}
    /**
     * 頂点同士の距離から、頂点のシフト量を返します。この関数は、よく似た２つの矩形の頂点同士の対応を取るために使用します。
     * @param i_square
     * 比較対象の矩形
     * @return
     * シフト量を数値で返します。
     * シフト量はthis-i_squareです。1の場合、this.sqvertex[0]とi_square.sqvertex[1]が対応点になる(shift量1)であることを示します。
     */
    private static function checkVertexShiftValue(i_vertex1:Vector.<NyARDoublePoint2d>,i_vertex2:Vector.<NyARDoublePoint2d>):int
    {
    	//assert(i_vertex1.length==4 && i_vertex2.length==4);
    	//3-0番目
    	var min_dist:int=int.MAX_VALUE;
    	var min_index:int=0;
    	var xd:int,yd:int;
    	for(var i:int=3;i>=0;i--){
    		var d:int=0;
    		for(var i2:int=3;i2>=0;i2--){
    			xd= (int)(i_vertex1[i2].x-i_vertex2[(i2+i)%4].x);
    			yd= (int)(i_vertex1[i2].y-i_vertex2[(i2+i)%4].y);
    			d+=xd*xd+yd*yd;
    		}
    		if(min_dist>d){
    			min_dist=d;
    			min_index=i;
    		}
    	}
    	return min_index;
    }
    /**
     * 4とnの最大公約数テーブル
     */
    private static const _gcd_table4:Vector.<int>=Vector.<int>([-1,1,2,1]);
    /**
     * 頂点を左回転して、矩形を回転させます。
     * @param i_shift
     */
    private static function rotateVertexL(i_vertex:Vector.<NyARDoublePoint2d>,i_shift:int):void
    {
    	//assert(i_shift<4);
    	var vertext:NyARDoublePoint2d;
    	if(i_shift==0){
    		return;
    	}
    	var t1:int,t2:int;
    	var d:int, i:int, j:int, mk:int;
	    var ll:int=4-i_shift;
	    d = _gcd_table4[ll];//NyMath.gcn(4,ll);
	    mk = (4-ll) % 4;
	    for (i = 0; i < d; i++) {
	    	vertext=i_vertex[i];
	        for (j = 1; j < 4/d; j++) {
	            t1=(i + (j-1)*mk) % 4;
	            t2=(i + j*mk) % 4;
	            i_vertex[t1]=i_vertex[t2];
	        }
	        t1=(i + ll) % 4;
	        i_vertex[t1]=vertext;
	    }
    }
    /**
     * ARToolKitのdirectionモデルに従って、頂点をシフトします。
     * @param i_dir
     */
    public function shiftByArtkDirection(i_dir:int):void
    {
    	rotateVertexL(this.estimate_vertex,i_dir);
    	rotateVertexL(this.vertex,i_dir);
    }
}
}