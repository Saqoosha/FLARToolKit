package jp.nyatla.nyartoolkit.as3
{
	import jp.nyatla.alchemymaster.*;
	import flash.utils.ByteArray;
	import jp.nyatla.as3utils.*;	
	import jp.nyatla.nyartoolkit.as3.proxy.*;
	import jp.nyatla.nyartoolkit.as3.type.*;
	
	/**
	 * 画像からARCodeに最も一致するマーカーを1個検出し、その変換行列を計算するクラスです。
	 * 変換行列を求めるには、detectMarkerLite関数にラスタイメージを入力して、計算対象の矩形を特定します。
	 * detectMarkerLiteが成功すると、getTransmationMatrix等の関数が使用可能な状態になり、変換行列を求めることができます。
	 * 
	 * 
	 */
public class NyARSingleDetectMarkerAS extends NyARCustomSingleDetectMarkerAS
{
	public static const PF_ARTOOLKIT_COMPATIBLE:int=1;
	public static const PF_NYARTOOLKIT:int=2;
	public static const PF_NYARTOOLKIT_ARTOOLKIT_FITTING:int=100;
	public static const PF_TEST2:int=201;
	
	private var _threshold:NyARRasterFilter_ARToolkitThreshold;
	
	/**
	 * 検出するARCodeとカメラパラメータから、1個のARCodeを検出するNyARSingleDetectMarkerインスタンスを作ります。
	 * 
	 * @param i_param
	 * カメラパラメータを指定します。
	 * @param i_code
	 * 検出するARCodeを指定します。
	 * @param i_marker_width
	 * ARコードの物理サイズを、ミリメートルで指定します。
	 * @param i_input_raster_type
	 * 入力ラスタのピクセルタイプを指定します。この値は、INyARBufferReaderインタフェイスのgetBufferTypeの戻り値を指定します。
	 * @throws NyARException
	 */
	public function NyARSingleDetectMarkerAS(i_param:NyARParam,i_code:NyARCode,i_marker_width:Number,i_input_raster_type:int)
	{
		super();
		initInstance(i_param,i_code,i_marker_width,i_input_raster_type,PF_NYARTOOLKIT);
		return;
	}
	/**
	 * コンストラクタから呼び出す関数です。
	 * @param i_ref_param
	 * @param i_ref_code
	 * @param i_marker_width
	 * @param i_input_raster_type
	 * @param i_profile_id
	 * @throws NyARException
	 */
	protected override function initInstance(
		...args:Array):void
	{
		var i_ref_param:NyARParam  =args[0];
		var i_ref_code:NyARCode    =args[1];
		var i_marker_width:Number  =args[2];
		var i_input_raster_type:int=args[3];
		var i_profile_id:int       =args[4];
		//
		this._threshold=new NyARRasterFilter_ARToolkitThreshold(100,i_input_raster_type);
		var patt_inst:INyARColorPatt;
		var sqdetect_inst:INyARSquareDetector;
		var transmat_inst:INyARTransMat;

		switch(i_profile_id){
		case PF_NYARTOOLKIT://default
			patt_inst=new NyARColorPatt_Perspective_O2(i_ref_code.getWidth(), i_ref_code.getHeight(),4,25);
			sqdetect_inst=new NyARSquareDetector_Rle(i_ref_param.getDistortionFactor(),i_ref_param.getScreenSize());
			transmat_inst=new NyARTransMat(i_ref_param);
			break;
		default:
			throw new Error("NyARSingleDetectMarker::initInstance");
		}
		super.initInstance(patt_inst,sqdetect_inst,transmat_inst,this._threshold,i_ref_param,i_ref_code,i_marker_width);
	}

	public override function dispose():void
	{		
		super.dispose();
		this._threshold.dispose();
		return;
	}

	/**
	 * i_imageにマーカー検出処理を実行し、結果を記録します。
	 * 
	 * @param i_raster
	 * マーカーを検出するイメージを指定します。イメージサイズは、コンストラクタで指定i_paramの
	 * スクリーンサイズと一致し、かつi_input_raster_typeに指定した形式でなければいけません。
	 * @return マーカーが検出できたかを真偽値で返します。
	 * @throws NyARException
	 */
	public override function detectMarkerLite(...args:Array):Boolean
	{
		var i_raster:INyARRgbRaster=args[0];
		var i_threshold:int=args[1];
		//
		this._threshold.setThreshold(i_threshold);
		return super.detectMarkerLite(i_raster);
	}
}

	
};