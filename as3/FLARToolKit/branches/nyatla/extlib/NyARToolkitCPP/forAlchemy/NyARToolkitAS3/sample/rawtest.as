/**
 * Eclipseで動かない？そんな時は…
 * 
 * 1.パッケージエクスプローラで、.swfのプロパティを見てみよう。UseHtmlTemplateは使っちゃダメだよ。
 * 2.FlashPlayerのローカルファイルアクセスのセキュリティ解除してみよう。場所は、
 * C:\WINDOWS\system32\Macromed\Flash\FlashPlayerTrust
 * 
 * 
 * 
 */


package{
	import 	flash.net.*;
	import jp.nyatla.as3utils.*;
	import jp.nyatla.alchemymaster.*;
	import jp.nyatla.nyartoolkit.as3.proxy.*;
	import jp.nyatla.nyartoolkit.as3.*;
    import flash.display.Sprite; 
    import flash.text.*;
    import flash.events.*;
    import flash.utils.*;

	public class rawtest extends Sprite
	{
        private var myTextBox:TextField = new TextField(); 
        private var myTextBox2:TextField = new TextField(); 
		
		
		public function msg(i_msg:String):void
		{
            myTextBox.text =myTextBox.text+","+i_msg;			
		}
		//private var cpara:ByteArray;
		private var code:NyARCode;
		private var param:NyARParam;
		private var raster_bgra:NyARRgbRaster_BGRA;
		private var id_bgra:NyARRgbRaster_BGRA;
//		private var raster_xrgb:NyARRgbRaster_XRGB32;
		public function rawtest()
		{
			myTextBox.y=0;
			myTextBox2.y=30;
            addChild(myTextBox);
            addChild(myTextBox2);
 

			//ファイルをメンバ変数にロードする。
			var mf:NyMultiFileLoader=new NyMultiFileLoader();
			mf.addTarget(
				"camera_para.dat",URLLoaderDataFormat.BINARY,
				function(data:ByteArray):void
				{
 		            param=new NyARParam();
            		param.loadARParamFile(data);
            		param.changeScreenSize(320,240);
				});
			mf.addTarget(
				"patt.hiro",URLLoaderDataFormat.TEXT,
				function(data:String):void
				{
					code=new NyARCode(16, 16);
					code.loadARPattFromFile(data);
				}
			);
			mf.addTarget(
				"320x240ABGR.raw",URLLoaderDataFormat.BINARY,
				function(data:ByteArray):void
				{
					var r:NyARRgbRaster_BGRA=new NyARRgbRaster_BGRA(320,240);
            		r.setFromByteArray(data);
            		raster_bgra=r;
				});
			mf.addTarget(
				"320x240NyId.raw",URLLoaderDataFormat.BINARY,
				function(data:ByteArray):void
				{
					var r:NyARRgbRaster_BGRA=new NyARRgbRaster_BGRA(320,240);
            		r.setFromByteArray(data);
            		id_bgra=r;
				});				
            //終了後mainに遷移するよ―に設定
			mf.addEventListener(Event.COMPLETE,main);
            mf.multiLoad();//ロード開始
            return;//dispatch event*/
        }
		private function testNyARIntSize():void
		{
			var ma:Marshal=new Marshal();
			msg("<NyARIntSize>");
			var result:NyARIntSize=new NyARIntSize();
			msg("create");
			ma.prepareWrite();
			ma.writeInt(999);
			ma.writeInt(998);
			result.setValue(ma);
			result.getValue(ma);
			ma.prepareRead();
			
			msg("(setVale,getValue):"+(ma.readInt()==999 && ma.readInt()==998)?"OK":"NG");
			result.dispose();
			msg("</NyARIntSize>");
		}
		private function testNyARCode():void
		{
			msg("<NyARCode>");
			var test:NyARCode=new NyARCode(16,16);
			msg("create");
			msg("w,h:"+test.getWidth()+","+test.getHeight());
			test.dispose();
			msg("</NyARCode>");
		}
		private function testNyARPerspectiveProjectionMatrix():void
		{
			var ma:Marshal=new Marshal();
			msg("<NyARPerspectiveProjectionMatrix>");
			var t2:NyARPerspectiveProjectionMatrix=new NyARPerspectiveProjectionMatrix();
			msg("create");
			t2.getValue(ma);
			ma.prepareRead();
			t2.dispose();
			msg("</NyARPerspectiveProjectionMatrix>");
		}			
		private function testNyARParam():void
		{
			msg("<NyARParam>");
			var t2:NyARParam=new NyARParam();
			msg("create");
			t2.getPerspectiveProjectionMatrix();
			msg("getPerspectiveProjectionMatrix");
			t2.getScreenSize();
			msg("getScreenSize");
			t2.dispose();
			msg("</NyARParam>");
		}
		private function testNyARMatchPatt_Color_WITHOUT_PCA():void
		{
			var code:NyARCode=new NyARCode(16,16);
			msg("<NyARMatchPatt_Color_WITHOUT_PCA>");
			var t:NyARMatchPatt_Color_WITHOUT_PCA=new NyARMatchPatt_Color_WITHOUT_PCA(code);
			msg("create");
			t.dispose();
			msg("</NyARMatchPatt_Color_WITHOUT_PCA>");
			code.dispose();			
		}
		private function testNyARSquareDetector_Rle():void
		{/*
			var code:NyARCode=new NyARCode(16,16);
			msg("<NyARSquareDetector_Rle>");
			var t:NyARSquareDetector_Rle=new NyARSquareDetector_Rle(dist,size);
			msg("create");
			t.getValue(new Array());
			t.dispose();
			msg("</NyARSquareDetector_Rle>");
			code.dispose();			*/
		}
		private function testIdMarkerProcessor():void
		{
			msg("<IdMarkerProcessor>");
			var t:IdMarkerProcessor=new IdMarkerProcessor(param,INyARBufferReader.BUFFERFORMAT_BYTE1D_B8G8R8X8_32,this);
			t.detectMarker(id_bgra);
			t.dispose();
			msg("</IdMarkerProcessor>");
		}
		private function testNyARSingleDetectMarkerAS():void
		{
			var mret:NyARTransMatResult=new NyARTransMatResult();
			msg("<NyARSingleDetectMarkerAS>");
			var d:NyARSingleDetectMarkerAS=new NyARSingleDetectMarkerAS(param,code,80.0,INyARBufferReader.BUFFERFORMAT_BYTE1D_B8G8R8X8_32);
			var ma:Marshal=new Marshal();
			param.getPerspectiveProjectionMatrix().getValue(ma);
			ma.prepareRead();
			for(var i:int=0;i<12;i++){
				msg(String(ma.readDouble()));
			}
			d.detectMarkerLite(raster_bgra,100);
			msg("cf="+d.getConfidence());
			mret.getValue(ma);
			d.getTransformMatrix(mret);
			mret.getValue(ma);
			ma.prepareRead();
			for(var i2:int=0;i2<12;i2++){
				msg(String(ma.readDouble()));
			}
			msg("zxy="+d.getConfidence());
			mret.getZXYAngle(ma);
			ma.prepareRead();
			for(i2=0;i2<3;i2++){
				msg(String(ma.readDouble()));
			}
			msg("pickup image");
			var patt_data:ByteArray=new ByteArray();
			patt_data.endian=Endian.LITTLE_ENDIAN;
			NyARColorPatt_Perspective_O2(d._patt).getData(patt_data);
			//Pixel format XRGB(int)
			for(i2=0;i2<16*16;i2++){
				msg(String(patt_data.readInt()));
			}
			msg("performance test..."+d.getConfidence());
			
			var date : Date = new Date();
			for(i2=0;i2<1000;i2++){
				d.detectMarkerLite(raster_bgra,100);
				d.getTransformMatrix(mret);
			}
			var date2 : Date = new Date();
			msg((date2.valueOf()-date.valueOf()).toString());
			
			d.dispose();
			msg("</NyARSingleDetectMarkerAS>");
			mret.dispose();
		}
		
		private function testNyARDetectMarkerAS():void
		{
			var mret:NyARTransMatResult=new NyARTransMatResult();
			msg("<NyARDetectMarkerAS>");
			var codes:Vector.<NyARCode>=new Vector.<NyARCode>();
			var codes_width:Vector.<Number>=new Vector.<Number>();
			codes[0]=code;
			codes_width[0]=80.0;
			var t:NyARDetectMarkerAS=new NyARDetectMarkerAS(param,codes,codes_width,1,INyARBufferReader.BUFFERFORMAT_BYTE1D_B8G8R8X8_32);

			var num_of_detect:int=t.detectMarkerLite(raster_bgra,100);
			msg("found="+num_of_detect);
			var ma:Marshal=new Marshal();
			for(var i:int=0;i<num_of_detect;i++){
				msg("no="+i);
				t.getConfidence(i);
				t.getDirection(i);
				t.getTransformMatrix(i,mret);
				mret.getValue(ma);
				ma.prepareRead();
				for(var i2:int=0;i2<12;i2++){
					msg(String(ma.readDouble()));
				}				
			}
			
			t.dispose();
			msg("</NyARDetectMarker>");
			mret.dispose();			
		}		
		private function testSingleProcessorAS():void
		{
			var mret:NyARTransMatResult=new NyARTransMatResult();
			msg("<SingleProcessorAS>");
			var codes:Vector.<NyARCode>=new Vector.<NyARCode>();
			var codes_width:Vector.<Number>=new Vector.<Number>();
			codes[0]=code;
			codes_width[0]=80.0;
			var t:SingleProcessor=new SingleProcessor(param,INyARBufferReader.BUFFERFORMAT_BYTE1D_B8G8R8X8_32,this);
	        t.setARCodeTable(codes,16,80.0);
	        t.detectMarker(raster_bgra);
			t.dispose();
			msg("</SingleProcessorAS>");
			mret.dispose();			
		}				
		private function main(e:Event):void
		{
			msg("ready!");
//			testNyARIntSize();
//			testNyARCode();
//			testNyARPerspectiveProjectionMatrix();
//			testNyARParam();
//			testNyARMatchPatt_Color_WITHOUT_PCA();
//			testNyARSquareDetector_Rle();
			testIdMarkerProcessor();
			testNyARSingleDetectMarkerAS();
			testNyARDetectMarkerAS();
			testSingleProcessorAS();
			//Test NyARIntSize class

			msg("end");
			return;
		}
	}
}
	import jp.nyatla.alchemymaster.*;
	import jp.nyatla.nyartoolkit.as3.proxy.*;
	import jp.nyatla.nyartoolkit.as3.*;


class SingleProcessor extends SingleARMarkerProcesserAS
{
	public var transmat:NyARTransMatResult=null;
	public var current_code:int=-1;
	private var _parent:rawtest;
	private var _ma:Marshal=new Marshal();
	public function SingleProcessor(i_cparam:NyARParam,i_raster_format:int,i_parent:rawtest)
	{
		super();
		this._parent=i_parent;
		initInstance(i_cparam,i_raster_format);
	}
	
	protected override function onEnterHandler(i_code:int):void
	{
		current_code=i_code;
		_parent.msg("onEnterHandler:"+i_code);
	}

	protected override function onLeaveHandler():void
	{
	}

	protected override function onUpdateHandler(i_square:NyARSquare,result:NyARTransMatResult):void
	{
		_parent.msg("onUpdateHandler:"+current_code);
		result.getValue(_ma);
		_ma.prepareRead();
		for(var i2:int=0;i2<12;i2++){
			_parent.msg(String(_ma.readDouble()));
		}		
		this.transmat=result;
	}	
}

class IdMarkerProcessor extends SingleNyIdMarkerProcesserAS
{	
	public var transmat:NyARTransMatResult=null;
	public var current_id:int=-1;
	private var _parent:rawtest;
	private var _encoder:NyIdMarkerDataEncoder_RawBit;

	public function IdMarkerProcessor(i_cparam:NyARParam,i_raster_format:int,i_parent:rawtest)
	{
		//アプリケーションフレームワークの初期化
		super();
		this._parent=i_parent;
		this._encoder=new NyIdMarkerDataEncoder_RawBit();
		initInstance(i_cparam,this._encoder,i_raster_format);
		return;
	}
	public override function dispose():void
	{		
		super.dispose();
		this._encoder.dispose();
		return;
	}	
	private var _ma:Marshal=new Marshal();
	/**
	 * アプリケーションフレームワークのハンドラ（マーカ出現）
	 */
	protected override function onEnterHandler(i_code:INyIdMarkerData):void
	{
		var code:NyIdMarkerData_RawBit=i_code as NyIdMarkerData_RawBit;
		
		//read data from i_code via Marsial--Marshal経由で読み出す
		code.getValue(this._ma);
		this._ma.prepareRead();
		var len:int =this._ma.readInt();
		var data:Array=new Array();
		
		var i:int;
		for(i=0;i<len;i++){
			data[i]=this._ma.readInt();
		}
		if(len>4){
			//4バイト以上の時はint変換しない。
			this.current_id=-1;//undefined_id
		}else{
			this.current_id=0;
			//最大4バイト繋げて１個のint値に変換
			for(i=0;i<len;i++){
				this.current_id=(this.current_id<<8)|data[i];
			}
		}
		_parent.msg("onEnterHandler:"+this.current_id);
		this.transmat=null;
	}
	/**
	 * アプリケーションフレームワークのハンドラ（マーカ消滅）
	 */
	protected override function onLeaveHandler():void
	{
		this.current_id=-1;
		this.transmat=null;
		return;
	}
	/**
	 * アプリケーションフレームワークのハンドラ（マーカ更新）
	 */
	protected override function onUpdateHandler(i_square:NyARSquare,result:NyARTransMatResult):void
	{
		_parent.msg("onUpdateHandler:"+this.current_id);
		result.getValue(_ma);
		_ma.prepareRead();
		for(var i2:int=0;i2<12;i2++){
			_parent.msg(String(_ma.readDouble()));
		}
		this.transmat=result;
	}
}
