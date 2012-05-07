package jp.nyatla.nyartoolkit.as3.rpf.mklib 
{
	/**
	 * 未知の矩形を認識するサンプル。
	 * 絶対的な寸法は求められないので、矩形の辺比率を推定して返します。
	 * 既知のカードを認識したいのならば、比率推定後にターゲットの模様からその絶対サイズを特定すると良いかもしれません。
	 *
	 */
	public class CardDetect
	{

		public static const MORE_FRONT_CENTER:int=0;
		public static const ESTIMATE_NOW:int=1;
		public static const ESTIMATE_COMPLETE:int=2;
		public static const FAILED_ESTIMATE:int=3;
		public static const FAILED_TARGET_MISSMATCH:int=4;
		/**
		 * i_targetの大きさを推定して、{@link UnknownRectInfo}に結果を保存します。この関数は{@link UnknownRectInfo}の状態を変化させるだけです。
		 * @param i_target
		 * 大きさを推定するターゲット。
		 * @param io_result
		 * 入出力パラメータ。前段までの推定結果と現在の推定値をマージして返します。
		 * はじめてターゲットの推定をするときは、リセットした{@link UnknownRectInfo}を入力してください。
		 * @return
		 * 認識状況を返します。
		 * @throws NyARException
		 */
		public function detectCardDirection(i_target:NyARRealityTarget, io_result:UnknownRectInfo):void
		{
			//成功点数が20点を超えたら推定完了。
			if(io_result._success_point>20){
				io_result.last_status=CardDetect.ESTIMATE_COMPLETE;
				return;
			}
			//10回失敗したら推定失敗
			if(io_result._failed>10){
				io_result.last_status=CardDetect.FAILED_ESTIMATE;
				return;
			}
			var pos:Vector.<NyARDoublePoint2d>=i_target.refTargetVertex();
			//正面から一回認識させてほしい。
			for(var i:int=0;i<4;i++){
				//正面判定。辺のなす角が90、または-90度の10度以内であること。
				if(getAbsSin(pos[0+i],pos[(1+i)%4],pos[(2+i)%4])<0.984){
					io_result.last_status=CardDetect.MORE_FRONT_CENTER;
					return;
				}
			}
			//線の長さを4本計算
			var d1:Number=Math.sqrt(pos[0].sqDist(pos[1]));
			var d2:Number=Math.sqrt(pos[1].sqDist(pos[2]));
			var d3:Number=Math.sqrt(pos[2].sqDist(pos[3]));
			var d4:Number=Math.sqrt(pos[3].sqDist(pos[0]));
			//現在の比率を計算
			var t:Number,t2:Number,t3:Number;
			t=d1+d3*0.5;
			t2=d2+d4*0.5;
			t3=t/t2;
			t3=t3<1?1/t3:t3;
			if(io_result._target_serial==NyARRealityTarget.INVALID_REALITY_TARGET_ID){
				//サイクルをリセット
				io_result._target_serial=i_target.getSerialId();
				io_result.rate=t3;
				io_result._success_point=0;
				io_result._failed=0;
				io_result.artk_direction=t<t2?1:0;
			}else{
				if(io_result._target_serial!=i_target.getSerialId()){
					//ターゲットが一致しない。
					io_result.last_status=FAILED_TARGET_MISSMATCH;
					return;
				}
				if(t3/io_result.rate>0.98 && t3/io_result.rate<1.02)
				{
					io_result.rate=(io_result.rate+t3)*0.5;
					io_result._success_point++;
				}else{
					io_result._failed++;
				}
			}
			//推定中
			io_result.last_status=ESTIMATE_NOW;
			return;
		}
		/**
		 * p1->p2とp2->p3の作る角のsin値の絶対値を得ます。
		 * @param p1
		 * @param p2
		 * @param p3
		 * @return
		 */
		public final static function getAbsSin(p1:NyARDoublePoint2d,p2:NyARDoublePoint2d,p3:NyARDoublePoint2d):Number
		{
			var cp:Number=NyARDoublePoint2d.crossProduct3Point(p1,p2,p3);
			cp/=(Math.sqrt(p1.sqDist(p2))*Math.sqrt(p2.sqDist(p3)));
			return cp>0?cp:-cp;
		}	
	}
}

class UnknownRectInfo
{
	/** 内部使用。推定しているターゲットのシリアルID*/
	public var _target_serial:Number;
	/**　内部使用。成功回数のカウンタ*/
	public var _success_point:int;
	/**　内部使用。失敗回数のカウンタ*/
	public var _failed:int;
	/** 検出した矩形の縦横非推定値。%表記。*/
	public var rate:Number;
	/** ARToolKitスタイルのdirection値*/
	public var artk_direction:int;
	
	/**
	 * 現在の認識状況。
	 * <ul>
	 * <li>{@link #MORE_FRONT_CENTER}このターゲットを推定するには、より正面から撮影が必要です。</li>
	 * <li>{@link #ESTIMATE_NOW}大きさを推定中です。引き続き、次のサイクルのi_targetとio_resultペアを入力してください。</li>
	 * <li>{@link #ESTIMATE_COMPLETE}推定完了。io_resultのメンバ変数が利用可能です。</li>
	 * <li>{@link #ESTIMATE_FAILED}推定に失敗しました。変な形のRECTだったのかも。</li>
	 * <li>{@link #FAILED_TARGET_MISSMATCH}推定に失敗しました。i_targetとio_resultペアが間違っている。</li>
	 * </ul>
	 */
	public var last_status:int;
	public function UnknownRectInfo()
	{
		this._target_serial=NyARRealityTarget.INVALID_REALITY_TARGET_ID;
	}
}