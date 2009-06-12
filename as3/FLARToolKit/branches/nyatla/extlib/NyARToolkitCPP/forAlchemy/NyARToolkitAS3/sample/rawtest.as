/**
 * Eclipseで動かない？そんな時は…
 * 
 * 1.パッケージエクスプローラで、.swfのプロパティを見てみよう。UseHtmlTemplateは使っちゃダメだよ。
 * 2.FlashPlayerのローカルファイルアクセスのセキュリティ解除してみよう。場所は、
 * C:\WINDOWS\system32\Macromed\Flash\FlashPlayerTrust
 * 
 * 
 *  */


package{
	import 	flash.net.*;
	import jp.nyatla.as3utils.*;
	import jp.nyatla.nyartoolkit.as3.*;
    import flash.display.Sprite; 
    import flash.text.*;
    import 	flash.events.*;
    import flash.utils.*;

	public class rawtest extends Sprite
	{
        private var myTextBox:TextField = new TextField(); 
        private var myTextBox2:TextField = new TextField(); 
		
		
		public function msg(i_msg:String):void
		{
            myTextBox.text =i_msg;			
		}
		//private var cpara:ByteArray;
		private var code:NyARCode;
		private var param:NyARParam;
		private var raster_bgra:NyARRgbRaster_BGRA;
		private var raster_xrgb:NyARRgbRaster_XRGB32;
		public function rawtest()
		{
			myTextBox.y=0;
			myTextBox2.y=30;
            addChild(myTextBox);
            addChild(myTextBox2);
            //システムを初期化
            NyARToolkitAS3.initialize();
 

			//ファイルをメンバ変数にロードする。
			var mf:NyMultiFileLoader=new NyMultiFileLoader();
			mf.addTarget(
				"camera_para.dat",URLLoaderDataFormat.BINARY,
				function(data:ByteArray):void
				{
 		            param=NyARParam.createInstance();
            		param.loadARParamFile(data);
				});
			mf.addTarget(
				"patt.hiro",URLLoaderDataFormat.TEXT,
				function(data:String):void
				{
					code=NyARCode.createInstance(16, 16);
					code.loadARPattFromFile(data);
				}
			);
			mf.addTarget(
				"320x240ABGR.raw",URLLoaderDataFormat.BINARY,
				function(data:ByteArray):void
				{
					var r:NyARRgbRaster_BGRA=NyARRgbRaster_BGRA.createInstance(320,240);
            		r.setFromByteArray(data);
            		raster_bgra=r;
            		var r2:NyARRgbRaster_XRGB32=NyARRgbRaster_XRGB32.createInstance(320,240);
            		r2.setFromByteArray(data);
//            		var b:ByteArray=new ByteArray();
//            		for(var i:int=0;i<320*240;i++){
//            			b.writeInt(0);
//            		}
//            		b.position=0;
//            		r2.setFromByteArray(b);
            		raster_xrgb=r2;
				});
            //終了後mainに遷移するよ―に設定
			mf.addEventListener(Event.COMPLETE,main);
            mf.multiLoad();//ロード開始
            return;//dispatch event
		}
		private function main(e:Event):void
		{
			msg("ready!");
			param.changeScreenSize(320,240);
			msg("main:-1");			
			var detector:NyARSingleDetectMarker=NyARSingleDetectMarker.createInstance(param,code,80.0,NyARRgbRaster.BUFFERFORMAT_BYTE1D_X8R8G8B8_32);
			code=null;//所有権移転
			msg("main:0");
			
			
			var m:NyARPerspectiveProjectionMatrix=param.getPerspectiveProjectionMatrix();
			var c:Array=new Array(12);
			var v:Array=new Array(12);
			m.decompMat(c,v);
			msg(c.toString());
			
			
			
			msg("main:1");
			msg(detector.detectMarkerLite(raster_xrgb,100).toString());
			msg(detector.getConfidence().toString());

/*
			var ss:NyARIntSize=param.getScreenSize();
			var sss:Array=new Array(2);
			ss.getValue(sss);
			msg(sss.toString());
			var m:NyARPerspectiveProjectionMatrix=param.getPerspectiveProjectionMatrix();
			var c:Array=new Array(12);
			var v:Array=new Array(12);
			m.decompMat(c,v);
			msg(v.toString());

			
			var start:int=getTimer();
			for(var i:int=0;i<100;i++){
				detector.detectMarkerLite(raster,100);
				detector.getTransmationMatrix(result);
			}
			var end:Number=getTimer()-start;
			//アンマネージオブジェクトを破棄(dispose読んでからGCのカウントを下げること。)
			detector.dispose();
			detector=null;
			raster.dispose();
			raster=null;
			param.dispose();
			param=null;
			msg(end.toString());*/
			return;
		}
	}
}



