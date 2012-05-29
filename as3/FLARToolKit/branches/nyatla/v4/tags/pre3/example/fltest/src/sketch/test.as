package sketch
{
	import flash.geom.Rectangle;
	import jp.nyatla.as3utils.sketch.*;
	import jp.nyatla.as3utils.*;
	import flash.net.*;
	import flash.text.*;
    import flash.display.*; 
    import flash.events.*;
    import flash.utils.*;
	import org.libspark.flartoolkit.core.*;
	import org.libspark.flartoolkit.markersystem.*;
	import org.libspark.flartoolkit.core.types.*;
	import org.libspark.flartoolkit.core.raster.*;
	import org.libspark.flartoolkit.core.raster.rgb.*;
	import org.libspark.flartoolkit.core.*;
	import org.libspark.flartoolkit.detector.*;
	import org.libspark.flartoolkit.core.types.matrix.*;
	import org.libspark.flartoolkit.core.param.*;
	import org.libspark.flartoolkit.core.types.*;
	import org.libspark.flartoolkit.core.transmat.*;
	import org.libspark.flartoolkit.rpf.reality.nyartk.*;
	import org.libspark.flartoolkit.rpf.realitysource.nyartk.*;
	import org.libspark.flartoolkit.rpf.reality.nyartk.*;	
	import org.libspark.flartoolkit.markersystem.*;

	/**
	 * ...
	 * @author nyatla
	 */
	public class test extends DebugSketch
	{
		public override function setup():void
		{
			//コンテンツのセットアップ
			this.setSketchFile("../../../resources/data/camera_para.dat", URLLoaderDataFormat.BINARY);//0
			this.setSketchFile("../../../resources/data/patt.hiro", URLLoaderDataFormat.TEXT);//1
			this.setSketchFile("../../../resources/data/320x240ABGR.raw", URLLoaderDataFormat.BINARY);//2
			this.setSketchFile("../../../resources/data/320x240NyId.raw", URLLoaderDataFormat.BINARY);//3
		}
		public override function main():void
		{
			param = new FLARParam();
			param.loadARParam(this.getSketchFile(0));
			param.changeScreenSize(320, 240);
			code=new FLARCode(16, 16);
			code.loadARPatt(this.getSketchFile(1));
			
			var b:BitmapData;
			var data:ByteArray;
			var i:int;
			{	
				b=	arimg.getBitmapData();
				data = this.getSketchFile(2);
				data.endian = Endian.LITTLE_ENDIAN;
				for (i = 0; i < 320 * 240; i++) {
					b.setPixel(i % 320, i / 320, data.readInt());
				}
			}
			{
				b =	idimg.getBitmapData();
				data = this.getSketchFile(3);
				data.endian = Endian.LITTLE_ENDIAN;
				for (i = 0; i < 320 * 240; i++) {
					b.setPixel(i%320,i/320,data.readInt());
				}
			}
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
				testFLARSingleDetectMarker();
			}
			{
				msg("<FLARDetectMarker>");
				testFLARDetectMarker();
			}
			
			{
				msg("<FLIdMarkerProcessor>");
				testIdMarkerProcessor();
			}
			{
				msg("<SingleProcessor>");
				testSingleProcessor();
			}
			{
				msg("<FLARReality>");
				testFLARReality();
			}
			{
				msg("<testFLARMarkerSystem>");
				testFLARMarkerSystem();
			}
			msg("#finish!");
			
			
		}
		private	var param:FLARParam;
		private	var code:FLARCode;
		private	var arimg:FLARRgbRaster = new FLARRgbRaster(320,240);
		private	var idimg:FLARRgbRaster = new FLARRgbRaster(320,240);
		private function testFLARMarkerSystem():void
		{
			var ss:FLARSensor = new FLARSensor(new FLARIntSize(320, 240));
			var cf:FLARMarkerSystemConfig = new FLARMarkerSystemConfig(320, 240);
			var ms:FLARMarkerSystem = new FLARMarkerSystem(cf);
			
			var id:int = ms.addARMarker(this.code, 25, 80);
			ss.update(this.arimg);
			ms.update(ss);
			var mat:FLARDoubleMatrix44=ms.getMarkerMatrix(id);

			msg("cf=" + ms.getConfidence(id));
			{
				msg("getTransmationMatrix");
				msg(mat.m00 + "," + mat.m01 + "," + mat.m02 + "," + mat.m03);
				msg(mat.m10 + "," + mat.m11 + "," + mat.m12 + "," + mat.m13);
				msg(mat.m20 + "," + mat.m21 + "," + mat.m22 + "," + mat.m23);
			}
			msg("#benchmark");
			{
				var date : Date = new Date();
				for(var i2:int=0;i2<100;i2++){
					ss.update(this.arimg);
					ms.update(ss);
				}
				var date2 : Date = new Date();
				msg(((date2.valueOf() - date.valueOf()).toString())+"[ms] par 100 frame");
			}
			return;
			
		}
		
		private function testFLARSingleDetectMarker():void
		{
			var mat:FLARTransMatResult=new FLARTransMatResult();
			var ang:FLARDoublePoint3d = new FLARDoublePoint3d();
			var d:FLARSingleMarkerDetector=new FLARSingleMarkerDetector(this.param, this.code, 80.0);
			d.detectMarkerLite(arimg,100);
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
					d.detectMarkerLite(arimg,100);
					d.getTransformMatrix(mat);
				}
				var date2 : Date = new Date();
				msg(((date2.valueOf() - date.valueOf()).toString())+"[ms] par 100 frame");
			}
			return;
		}
		private function testFLARDetectMarker():void
		{
			var mat:FLARTransMatResult=new FLARTransMatResult();
			var ang:FLARDoublePoint3d = new FLARDoublePoint3d();
			var codes:Vector.<FLARCode>=new Vector.<FLARCode>();
			var codes_width:Vector.<Number>=new Vector.<Number>();
			codes[0]=code;
			codes_width[0]=80.0;
			var t:FLARMultiMarkerDetector=new FLARMultiMarkerDetector(param,codes,codes_width,1);
			var num_of_detect:int=t.detectMarkerLite(arimg,100);
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
			t3.detectMarker(arimg);
		}
		private function testIdMarkerProcessor():void
		{
			var t:IdMarkerProcessor=new IdMarkerProcessor(param,this);
			t.detectMarker(this.idimg);
		}
		public function testFLARReality():void 
		{
			var reality:FLARReality=new FLARReality(param.getScreenSize(),10,1000,param.getPerspectiveProjectionMatrix(),null,10,10);
			//var reality_in:FLARRealitySource_BitmapImage = new FLARRealitySource_BitmapImage(320, 240, null, 2, 100);
			var reality_in:FLARRealitySource_BitmapImage = new FLARRealitySource_BitmapImage(320, 240, null, 2, 100,BitmapData(arimg.getBuffer()));
			

			var date : Date = new Date();
			for(var i2:int=0;i2<100;i2++){
				reality.progress(reality_in);
			}
			var date2 : Date = new Date();
			msg(((date2.valueOf() - date.valueOf()).toString())+"[ms] par 100 frame");

			
			msg(reality.getNumberOfKnown().toString());
			msg(reality.getNumberOfUnknown().toString());
			msg(reality.getNumberOfDead().toString());
			var rt:Vector.<FLARRealityTarget>=new Vector.<FLARRealityTarget>(10);
			reality.selectUnKnownTargets(rt);
			reality.changeTargetToKnown(rt[0],2,80);
			msg(rt[0]._transform_matrix.m00+","+rt[0]._transform_matrix.m01+","+rt[0]._transform_matrix.m02+","+rt[0]._transform_matrix.m03);
			msg(rt[0]._transform_matrix.m10+","+rt[0]._transform_matrix.m11+","+rt[0]._transform_matrix.m12+","+rt[0]._transform_matrix.m13);
			msg(rt[0]._transform_matrix.m20+","+rt[0]._transform_matrix.m21+","+rt[0]._transform_matrix.m22+","+rt[0]._transform_matrix.m23);
			msg(rt[0]._transform_matrix.m30 + "," + rt[0]._transform_matrix.m31 + "," + rt[0]._transform_matrix.m32 + "," + rt[0]._transform_matrix.m33);
			bitmap.bitmapData.setPixel(rt[0].refTargetVertex()[0].x, rt[0].refTargetVertex()[0].y, 0xffffff);
			bitmap.bitmapData.setPixel(rt[0].refTargetVertex()[1].x, rt[0].refTargetVertex()[1].y, 0xffffff);
			bitmap.bitmapData.setPixel(rt[0].refTargetVertex()[2].x, rt[0].refTargetVertex()[2].y, 0xffffff);
		}				
	}
}

import org.libspark.flartoolkit.core.raster.*;
import org.libspark.flartoolkit.core.raster.rgb.*;
import org.libspark.flartoolkit.core.param.*;
import org.libspark.flartoolkit.core.*;
import org.libspark.flartoolkit.core.transmat.*;
import org.libspark.flartoolkit.detector.*;
import org.libspark.flartoolkit.processor.*;
import org.libspark.flartoolkit.core.squaredetect.*;

import org.libspark.flartoolkit.nyidmarker.data.*;
import org.libspark.flartoolkit.nyidmarker.*;
import sketch.*;

class SingleProcessor extends FLSingleARMarkerProcesser
{
	public var transmat:FLARTransMatResult=null;
	public var current_code:int=-1;
	private var _parent:test;
	public function SingleProcessor(i_cparam:FLARParam,i_parent:test)
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
	private var _parent:test;
	private var _encoder:NyIdMarkerDataEncoder_RawBit;

	public function IdMarkerProcessor(i_cparam:FLARParam,i_parent:test)
	{
		//アプリケーションフレームワークの初期化
		super();
		this._parent=i_parent;
		this._encoder=new NyIdMarkerDataEncoder_RawBit();
		initInstance(i_cparam,this._encoder,80);
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
