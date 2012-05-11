package{	import away3d.audio.Sound3D;	import away3d.containers.*;	import away3d.lights.LightBase;	import away3d.lights.PointLight;	import away3d.materials.lightpickers.StaticLightPicker;		import flash.display.*;	import flash.events.Event;	import flash.geom.*;	import flash.utils.getTimer;	import flash.net.*;	import flash.media.*;	import jp.nyatla.as3utils.sketch.*;	import org.libspark.flartoolkit.away3d4.*;	import org.libspark.flartoolkit.core.types.*;	import org.libspark.flartoolkit.core.*;	import org.libspark.flartoolkit.markersystem.*;		public class AMain extends FLSketch	{		protected var _bgm:Sound;		protected var _view:View3D;		protected var _light:LightBase;		protected var _lightPicker:StaticLightPicker;						private static const _CAM_W:int = 320;		private static const _CAM_H:int = 240;		private var _ss:FLARSensor;		private var _ms:FLARAway3DMarkerSystem;		private var _video:Video;		private var marker_id:int;		private var marker_node:ObjectContainer3D;				private var motions:Array;		public function AMain() {		}				public override function setup():void		{			/* You need to download datafiles from http://www.perfume-global.com/			 * Download bvh data from http://www.perfume-global.com/ and add to bin directory.			 * (aachan.bvh,kashiyuka.bvh,nocchi.bvh)		     * Download wav data from http://www.perfume-global.com/ and convert to mp3, add to bin directory.			 * (Perfume_globalsite_sound.mp3)			 */			this.setSketchFile("aachan.bvh", URLLoaderDataFormat.TEXT);			this.setSketchFile("kashiyuka.bvh", URLLoaderDataFormat.TEXT);			this.setSketchFile("nocchi.bvh", URLLoaderDataFormat.TEXT);			this.setSketchFile("camera_para.dat", URLLoaderDataFormat.BINARY);			this.setSketchFile("flar.png", FLSketch.DATAFORMAT_AS_OBJECT);			this.setSketchFile("nowebcam.jpg", FLSketch.DATAFORMAT_AS_OBJECT);					}		public override function main():void		{			var webcam:Camera = Camera.getCamera();			if (webcam) {				webcam.setMode(_CAM_W, _CAM_H, 30);				this._video = new Video(_CAM_W, _CAM_H);				this._video.attachCamera(webcam);						}else {				this._video = null;			}			//FLMarkerSystem			var cf:FLARMarkerSystemConfig = new FLARMarkerSystemConfig(this.getSketchFile(3),_CAM_W, _CAM_H);//make configlation			this._ss = new FLARSensor(new FLARIntSize(_CAM_W, _CAM_H));			this._ms = new FLARAway3DMarkerSystem(cf);			this.marker_id = this._ms.addARMarker_5(this.getSketchFile(4), 16, 25, 80); //register AR Marker						// init view			this._view = new View3D();			this._view.x = 0;			this._view.y = 0;			this._view.width = stage.width;			this._view.height = stage.height;			this._view.scene=new Scene3D();			this._view.background = new FLARWebCamTexture(_CAM_W, _CAM_H);			this.addChild(this._view);			this.setChildIndex(_view, 0);			// init light			_light = new PointLight();			_light.y = 1000;			_light.z = -1000;			_light.lookAt(new Vector3D());			_lightPicker = new StaticLightPicker([ _light ]);			_view.scene.addChild(_light);			// init camera			this._view.camera =  this._ms.getAway3DCamera();			//bvh			this.marker_node = 	new ObjectContainer3D();			this.marker_node.visible = true;			this._view.scene.addChild(this.marker_node);						this.motions = [];			this.motions.push( new MotionManContainer(this.getSketchFile(0),_lightPicker));			this.motions.push( new MotionManContainer(this.getSketchFile(1),_lightPicker));			this.motions.push( new MotionManContainer(this.getSketchFile(2),_lightPicker));			for (var i:int = 0; i < motions.length; i++){				this.marker_node.addChild(motions[i]);			}			this._ftime = MotionManContainer(this.motions[0]).getBvh().frameTime*MotionManContainer(this.motions[0]).getBvh().numFrames;			this._bgm = new Sound(new URLRequest("Perfume_globalsite_sound.mp3"));			this.addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);		}		private var _ftime:Number;		private var _init_time:Number;		private var _is_start:Boolean = false;		private function onEnterFrameHandler(e:Event):void		{			var back:IBitmapDrawable;			if (this._video) {				back = this._video;			}else {				back = Bitmap(this.getSketchFile(5));			}									//ARTK			this._ss.update_2(back);//update sensor status			this._ms.update(this._ss);//update markersystem status						if (!this._is_start){				this._init_time= flash.utils.getTimer();				if (!this._ms.isExistMarker(marker_id)) {					FLARWebCamTexture(this._view.background).update(back); //update background					_view.render();					return;				}				this._is_start = true;				this._init_time = -99999999;			}			var n_timer:Number = flash.utils.getTimer()-this._init_time;						//フレームタイム>n_timerでリセット			if (n_timer > this._ftime*1000) {				this._bgm.play(0);				this._init_time = flash.utils.getTimer();				n_timer = flash.utils.getTimer() - this._init_time;			}			//update motions			for each ( var motion:MotionManContainer in motions ) {				motion.update(n_timer);			}			FLARWebCamTexture(this._view.background).update(back); //update background			if (this._ms.isExistMarker(marker_id)) {				var m:Matrix3D = new Matrix3D();				this._ms.getAway3dMarkerMatrix(this.marker_id,m);				this.marker_node.transform = m;				this.marker_node.rotate(new Vector3D(1, 0, 0), 90);				this.marker_node.scale(0.20);								this.marker_node.visible = true;			}else {				this.marker_node.visible = false;			}			// render 3D			_view.render();		}	}}