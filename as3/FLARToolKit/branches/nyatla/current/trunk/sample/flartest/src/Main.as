/* 
 * FLARTest
 * --------------------------------------------------------------------------------
 * Copyright (C)2010 nyatla
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
package{

	import jp.nyatla.as3utils.*;
	import flash.net.*;
	import flash.text.*;
    import flash.display.*; 
    import flash.events.*;
    import flash.utils.*;
	import org.libspark.flartoolkit.core.raster.*;
	import org.libspark.flartoolkit.core.raster.rgb.*;
	import org.libspark.flartoolkit.core.param.*;
	import org.libspark.flartoolkit.core.*;
	import org.libspark.flartoolkit.core.transmat.*;
	import org.libspark.flartoolkit.core.types.*;
	import org.libspark.flartoolkit.detector.*;
	
	public class Main extends Sprite 
	{
		public static var win:Main;
        private var textbox:TextField = new TextField();
		private var param:FLARParam;
		private var code:FLARCode;
		private var raster_bgra:FLARRgbRaster_BitmapData;
		private var id_bgra:FLARRgbRaster_BitmapData;
		public function msg(i_str:String):void
		{
			this.textbox.text = this.textbox.text + "\n" + i_str;
		}

		public function Main():void 
		{
			Main.win = this;
			//デバック用のテキストボックス
			this.textbox.x = 0; this.textbox.y = 0;
			this.textbox.width=640,this.textbox.height=480; 
			this.textbox.condenseWhite = true;
			this.textbox.multiline =   true;
			this.textbox.border = true;
            addChild(textbox);

			//ファイルをメンバ変数にロードする。
			var mf:NyMultiFileLoader=new NyMultiFileLoader();
			mf.addTarget(
				"../../../data/camera_para.dat",URLLoaderDataFormat.BINARY,
				function(data:ByteArray):void
				{
 		            param=new FLARParam();
            		param.loadARParam(data);
            		param.changeScreenSize(320,240);
				});
			mf.addTarget(
				"../../../data/patt.hiro",URLLoaderDataFormat.TEXT,
				function(data:String):void
				{
					code=new FLARCode(16, 16);
					code.loadARPattFromFile(data);
				}
			);
			mf.addTarget(
				"../../../data/320x240ABGR.raw",URLLoaderDataFormat.BINARY,
				function(data:ByteArray):void
				{
					var r:FLARRgbRaster_BitmapData = new FLARRgbRaster_BitmapData(320,240);
					var b:BitmapData =	BitmapData(r.getBufferReader().getBuffer());
					data.endian = Endian.LITTLE_ENDIAN;
					for (var i:int = 0; i < 320 * 240; i++) {
						b.setPixel(i%320,i/320,data.readInt());
					}
            		raster_bgra = r;
				});

			mf.addTarget(
				"../../../data/320x240NyId.raw",URLLoaderDataFormat.BINARY,
				function(data:ByteArray):void
				{
					var r:FLARRgbRaster_BitmapData = new FLARRgbRaster_BitmapData(320, 240);
					var b:BitmapData =	BitmapData(r.getBufferReader().getBuffer());
					data.endian = Endian.LITTLE_ENDIAN;
					for (var i:int = 0; i < 320 * 240; i++) {
						b.setPixel(i%320,i/320,data.readInt());
					}
            		id_bgra=r;
				});
            //終了後mainに遷移するよ―に設定
			mf.addEventListener(Event.COMPLETE,main);
            mf.multiLoad();//ロード開始
            return;//dispatch event*/
		}
		private function testNyARSingleDetectMarker():void
		{
			var mat:FLARTransMatResult=new FLARTransMatResult();
			var ang:FLARDoublePoint3d = new FLARDoublePoint3d();
			var d:FLARSingleMarkerDetector=new FLARSingleMarkerDetector(this.param, this.code, 80.0);
			d.detectMarkerLite(raster_bgra,100);
			msg("cf=" + d.getConfidence());
			{
				d.getTransformMatrix(mat);
				msg("getTransmationMatrix");
				msg(mat.m00 + "," + mat.m01 + "," + mat.m02 + "," + mat.m03);
				msg(mat.m10 + "," + mat.m11 + "," + mat.m12 + "," + mat.m13);
				msg(mat.m20 + "," + mat.m21 + "," + mat.m22 + "," + mat.m23);
				msg("getZXYAngle");
				mat.getZXYAngle(ang);
				msg(ang.x + "," + ang.y + "," + ang.z);
			}
			msg("#benchmark");
			{
				var date : Date = new Date();
				for(var i2:int=0;i2<100;i2++){
					d.detectMarkerLite(raster_bgra,100);
					d.getTransformMatrix(mat);
				}
				var date2 : Date = new Date();
				msg(((date2.valueOf() - date.valueOf()).toString())+"[ms] par 100 frame");
			}
			return;
		}
		private function testNyARDetectMarker():void
		{
			var mat:FLARTransMatResult=new FLARTransMatResult();
			var ang:FLARDoublePoint3d = new FLARDoublePoint3d();
			var codes:Vector.<FLARCode>=new Vector.<FLARCode>();
			var codes_width:Vector.<Number>=new Vector.<Number>();
			codes[0]=code;
			codes_width[0]=80.0;
			var t:FLARMultiMarkerDetector=new FLARMultiMarkerDetector(param,codes,codes_width,1);
			var num_of_detect:int=t.detectMarkerLite(raster_bgra,100);
			msg("found="+num_of_detect);
			for(var i:int=0;i<num_of_detect;i++){
				msg("no="+i);
				t.getConfidence(i);
				t.getTransformMatrix(i,mat);
				msg("getTransmationMatrix");
				msg(mat.m00 + "," + mat.m01 + "," + mat.m02 + "," + mat.m03);
				msg(mat.m10 + "," + mat.m11 + "," + mat.m12 + "," + mat.m13);
				msg(mat.m20 + "," + mat.m21 + "," + mat.m22 + "," + mat.m23);
				msg("getZXYAngle");
				mat.getZXYAngle(ang);
				msg(ang.x + "," + ang.y + "," + ang.z);
			}		
		}
		private function testSingleProcessor():void
		{
			var codes:Vector.<FLARCode>=new Vector.<FLARCode>();
			var codes_width:Vector.<Number>=new Vector.<Number>();
			codes[0]=code;
			codes_width[0]=80.0;
			var t3:SingleProcessor=new SingleProcessor(param,this);
			t3.setARCodeTable(codes,16,80.0);
			t3.detectMarker(raster_bgra);
		}
		private function testIdMarkerProcessor():void
		{
			var t:IdMarkerProcessor=new IdMarkerProcessor(param,this);
			t.detectMarker(id_bgra);
		}	
		private function main(e:Event):void
		{
//			addChild(new Bitmap(BitmapData(this.id_bgra.getBufferReader().getBuffer())));
			

			var mat:FLARTransMatResult=new FLARTransMatResult();
			var ang:FLARDoublePoint3d = new FLARDoublePoint3d();
			msg(
			"FLARToolKit check program.\n"+
			"Copyright (C) 2010 nyatla\n"+
			"This program is free software: you can redistribute it and/or modify\n"+
			"it under the terms of the GNU General Public License as published by\n"+
			"the Free Software Foundation, either version 3 of the License, or\n"+
			"(at your option) any later version.\n"+
			"\n"+
			"This program is distributed in the hope that it will be useful,\n"+
			"but WITHOUT ANY WARRANTY; without even the implied warranty of\n"+
			"MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the\n"+
			"GNU General Public License for more details.\n"+
			"You should have received a copy of the GNU General Public License\n"+
			"along with this program.  If not, see <http://www.gnu.org/licenses/>.\n");
			msg("#ready!");
			{
				msg("<FLARSingleDetectMarker>");
				testNyARSingleDetectMarker();
			}
			{
				msg("<FLARDetectMarker>");
				testNyARDetectMarker();
			}
			
			{
				msg("<FLIdMarkerProcessor>");
				testIdMarkerProcessor();
			}
			{
				msg("<SingleProcessor>");
				testSingleProcessor();
			}
			msg("#finish!");
			return;
		}
		
	}

}

import org.libspark.flartoolkit.core.raster.*;
import org.libspark.flartoolkit.core.raster.rgb.*;
import org.libspark.flartoolkit.core.param.*;
import org.libspark.flartoolkit.core.*;
import org.libspark.flartoolkit.core.transmat.*;
import org.libspark.flartoolkit.core.types.*;
import org.libspark.flartoolkit.detector.*;
import org.libspark.flartoolkit.processor.*;
import org.libspark.flartoolkit.core.squaredetect.*;

import jp.nyatla.nyartoolkit.as3.nyidmarker.data.*;
import jp.nyatla.nyartoolkit.as3.nyidmarker.*;

class SingleProcessor extends FLSingleARMarkerProcesser
{
	public var transmat:FLARTransMatResult=null;
	public var current_code:int=-1;
	private var _parent:Main;
	public function SingleProcessor(i_cparam:FLARParam,i_parent:Main)
	{
		super();
		this._parent=i_parent;
		initInstance(i_cparam);
	}
	
	protected override function onEnterHandler(i_code:int):void
	{
		current_code=i_code;
		_parent.msg("onEnterHandler:"+i_code);
	}

	protected override function onLeaveHandler():void
	{
	}

	protected override function onUpdateHandler(i_square:FLARSquare,result:FLARTransMatResult):void
	{
		_parent.msg("onUpdateHandler:" + current_code);
		_parent.msg(result.m00 + "," + result.m01 + "," + result.m02 + "," + result.m03);
		_parent.msg(result.m10 + "," + result.m11 + "," + result.m12 + "," + result.m13);
		_parent.msg(result.m20 + "," + result.m21 + "," + result.m22 + "," + result.m23);
		this.transmat=result;
	}	
}

class IdMarkerProcessor extends FLSingleNyIdMarkerProcesser
{	
	public var transmat:FLARTransMatResult=null;
	public var current_id:int=-1;
	private var _parent:Main;
	private var _encoder:NyIdMarkerDataEncoder_RawBit;

	public function IdMarkerProcessor(i_cparam:FLARParam,i_parent:Main)
	{
		//アプリケーションフレームワークの初期化
		super();
		this._parent=i_parent;
		this._encoder=new NyIdMarkerDataEncoder_RawBit();
		initInstance(i_cparam,this._encoder,100);
		return;
	}
	
	/**
	 * アプリケーションフレームワークのハンドラ（マーカ出現）
	 */
	protected override function onEnterHandler(i_code:INyIdMarkerData):void
	{
		var code:NyIdMarkerData_RawBit=i_code as NyIdMarkerData_RawBit;
		
		//read data from i_code via Marsial--Marshal経由で読み出す
		var i:int;
		if(code.length>4){
			//4バイト以上の時はint変換しない。
			this.current_id=-1;//undefined_id
		}else{
			this.current_id=0;
			//最大4バイト繋げて１個のint値に変換
			for(i=0;i<code.length;i++){
				this.current_id=(this.current_id<<8)|code.packet[i];
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
	protected override function onUpdateHandler(i_square:FLARSquare,result:FLARTransMatResult):void
	{
		_parent.msg("onUpdateHandler:"+this.current_id);
		_parent.msg(result.m00 + "," + result.m01 + "," + result.m02 + "," + result.m03);
		_parent.msg(result.m10 + "," + result.m11 + "," + result.m12 + "," + result.m13);
		_parent.msg(result.m20 + "," + result.m21 + "," + result.m22 + "," + result.m23);
		this.transmat=result;
	}
}
