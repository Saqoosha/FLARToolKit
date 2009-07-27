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
	import jp.nyatla.nyartoolkit.as3.*;
    import flash.display.Sprite; 
    import flash.text.*;
    import 	flash.events.*;
    import flash.utils.*;

	public class idtest extends Sprite
	{
        private var myTextBox:TextField = new TextField(); 
        private var myTextBox2:TextField = new TextField(); 
		
		
		public function msg(i_msg:String):void
		{
            myTextBox.text =i_msg+","+myTextBox.text;			
		}
		//private var cpara:ByteArray;
		private var param:NyARParam;
		private var raster_bgra:NyARRgbRaster_BGRA;
		private var raster_xrgb:NyARRgbRaster_XRGB32;
		public function idtest()
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
 		            param=new NyARParam();
            		param.loadARParamFile(data);
				});
			mf.addTarget(
				"320x240NyId.raw",URLLoaderDataFormat.BINARY,
				function(data:ByteArray):void
				{
					var r:NyARRgbRaster_BGRA=new NyARRgbRaster_BGRA(320,240);
            		r.setFromByteArray(data);
            		raster_bgra=r;
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
			msg("main:-2");
			var enc:NyIdMarkerDataEncoder_RawBit=new NyIdMarkerDataEncoder_RawBit();
			msg("main:-1");
			var idproc:SingleNyIdMarkerProcesser=new SingleNyIdMarkerProcesser(param,enc,NyARRgbRaster.BUFFERFORMAT_BYTE1D_B8G8R8X8_32);
			msg("main:-5");

			idproc.setListener(new TestListener(this));
			idproc.detectMarker(raster_bgra);
/*			msg("main:0");
			idproc.setMarkerWidth(100);
			msg("main:1");
			idproc.reset(true);
			msg("main:2");
			var m:NyARPerspectiveProjectionMatrix=param.getPerspectiveProjectionMatrix();
			var c:Array=new Array(12);
			var v:Array=new Array(12);
			m.decompMat(c,v);
			msg(c.toString());
			

*/			
			msg("main:3");


			return;
		}
	}
}

import jp.nyatla.nyartoolkit.as3.*;
class TestListener extends SingleNyIdMarkerProcesserListener
{
	private var _parent:idtest;
	public function TestListener(i_parent:idtest)
	{
		this._parent=i_parent;
		return;
	}
	public override function onEnterHandler(i_data:INyIdMarkerData):void
	{
		this._parent.msg("enter");
		var raw:NyIdMarkerData_RawBit=i_data as NyIdMarkerData_RawBit;
		var p:Array=new Array();
		raw.getPacket(p);
		for(var i:int;i<p.length;i++){
			this._parent.msg(p[i]);
		}
	}
	public override function onLeaveHandler():void
	{
	}
	public override function onUpdateHandler(i_square:NyARSquare,i_transmat:NyARTransMatResult):void
	{
		this._parent.msg("update");
		var c:Array=new Array(3);
		i_transmat.getAngle(c);
		this._parent.msg(c[0]);
		this._parent.msg(c[1]);
		this._parent.msg(c[2]);
	}
}



