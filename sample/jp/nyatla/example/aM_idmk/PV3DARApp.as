package jp.nyatla.example.aM_idmk{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.*;
	import org.libspark.flartoolkit.alchemy.core.transmat.*;
	import org.libspark.flartoolkit.alchemy.pv3d.*;
	import org.libspark.flartoolkit.alchemy.*;
	import org.papervision3d.render.LazyRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;
	import org.papervision3d.view.stats.StatsView;
	import flash.utils.*;
	

	[SWF(width=640,height=480,frameRate=60,backgroundColor=0x0)]

	public class PV3DARApp extends ARAppBase{
		
		private static const PATTERN_FILE:String = "Data/patt.hiro";
		private static const CAMERA_FILE:String = "Data/camera_para.dat";
		
		protected var _base:Sprite;
		protected var _viewport:Viewport3D;
		protected var _camera3d:FLxARCamera3D;//FLxAR
		protected var _scene:Scene3D;
		protected var _renderer:LazyRenderEngine;
		protected var _baseNode:FLxARBaseNode;//FLxAR
		protected var _resultMat:FLxARTransMatResult;
		private var _listener:TestListener;
		
		public function PV3DARApp()
		{
			this._resultMat = new FLxARTransMatResult();
		}
		
		protected override function init(cameraFile:String, codeFile:String, canvasWidth:int=320, canvasHeight:int=240, codeWidth:int=80):void {
			this.addEventListener(Event.INIT, this._onInit, false, int.MAX_VALUE);
			super.init(cameraFile, codeFile);
		}
		
		private function _onInit(e:Event):void {
			this.removeEventListener(Event.INIT, this._onInit);
			
			this._base = this.addChild(new Sprite()) as Sprite;
			
			this._capture.width = 640;
			this._capture.height = 480;
			this._base.addChild(this._capture);
			
			this._viewport = this._base.addChild(new Viewport3D(320, 240)) as Viewport3D;
			this._viewport.scaleX = 640 / 320;
			this._viewport.scaleY = 480 / 240;
			this._viewport.x = -4; // 4pix ???
			
			this._camera3d = new FLxARCamera3D(this._param);
			
			this._scene = new Scene3D();
			this._baseNode = this._scene.addChild(new FLxARBaseNode()) as FLxARBaseNode;
			//イベントリスナ作成
			this._listener = new TestListener(this._baseNode);
			//リスナセット
			this._detector.setListener(this._listener);	
			
			this._renderer = new LazyRenderEngine(this._scene, this._camera3d, this._viewport);
			
			this.stage.addChild(new StatsView(this._renderer));
			
			this.addEventListener(Event.ENTER_FRAME, this._onEnterFrame);
		}
		
		private function _onEnterFrame(e:Event = null):void
		{
			this._capture.bitmapData.draw(this._video);
			this._raster.setBitmapData(this._capture.bitmapData);
			this._detector.detectMarker(this._raster);

			this._baseNode.visible =this._listener.active;
			this._renderer.render();
		}
		
		public function set mirror(value:Boolean):void
		{
			if (value) {
				this._base.scaleX = -1;
				this._base.x = 640;
			} else {
				this._base.scaleX = 1;
				this._base.x = 0;
			}
		}
		
		public function get mirror():Boolean {
			return this._base.scaleX < 0;
		}
		
	}
}
import org.libspark.flartoolkit.alchemy.pv3d.*;
import jp.nyatla.nyartoolkit.as3.*;
class TestListener extends SingleNyIdMarkerProcesserListener
{
	private var _baseNode:FLxARBaseNode;
	public var active:Boolean;
	public function TestListener(i_baseNode:FLxARBaseNode)
	{
		this._baseNode = i_baseNode;
		this.active = false;
		return;
	}
	public override function onEnterHandler(i_data:INyIdMarkerData):void
	{
		this.active = true;
		var raw:NyIdMarkerData_RawBit=i_data as NyIdMarkerData_RawBit;
		var p:Array=new Array();
		raw.getPacket(p);
		//pにIDのデータグラムが入ってる。
		this.active = true;
	}
	public override function onLeaveHandler():void
	{
		this.active = false;
	}
	public override function onUpdateHandler(i_square:NyARSquare,i_transmat:NyARTransMatResult):void
	{
		var c:Array=new Array(3);
		i_transmat.getAngle(c);
		//cにはangleのデータが取れますよ。

		//座標を更新
		this._baseNode.setTransformMatrix(i_transmat);
	}
}
