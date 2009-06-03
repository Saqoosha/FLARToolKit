package org.tarotaro.flash.pv3d
{
	import flash.display.*;
	import flash.events.*;
	
	import org.papervision3d.cameras.*;
	import org.papervision3d.view.*;
	import org.papervision3d.materials.*;
	import org.papervision3d.objects.*;
	import org.papervision3d.objects.primitives.*
	import org.papervision3d.materials.utils.*;
	
	[SWF(width = "800", height = "450", frameRate = "60", backgroundColor = "#000000")]
	
	public class PanoramaSample extends BasicView 
	{	
		// 3Dオブジェクト
		private var sphere:Sphere;
		private var wire:Sphere;

		/**
		 * コンストラクタ
		 */
		public function PanoramaSample()
		{
			// BasicViewの初期化
			super(0, 0, true, false, CameraType.FREE);
			
			// init swf
			stage.quality = StageQuality.LOW;
			
			// カメラ
			camera.x = camera.y = camera.z = 0;
			camera.focus = 300;
			camera.zoom = 1;
			
			// 定数
			var size :Number = 25000;
			var quality :Number = 30;
			
			var sphereMaterial:BitmapFileMaterial = new BitmapFileMaterial("Data/pano2_o.jpg", false);
			sphereMaterial.opposite = true;
			sphereMaterial.smooth = true;
			
			var wireMaterial:WireframeMaterial = new WireframeMaterial(0xFF0000);
			wireMaterial.opposite = true;
			
			// キューブを作成
			sphere = new Sphere(
				sphereMaterial,
				size, 
				quality, 
				quality);
			wire = new Sphere(
				wireMaterial,
				size,
				quality,
				quality);
			wire.visible = false;
			
			// シーンに追加
			scene.addChild(sphere);
			scene.addChild(wire);
			
			// マウスのインタラクティブを設定しています
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, zoomHandler);
			// レンダリングを開始します
			startRendering();
		}
		
		/**
		 * ズームイン/アウト
		 * @param	e
		 */
		private function zoomHandler(e:MouseEvent):void 
		{
			var newZoom:Number = this.camera.zoom + 0.1 * e.delta / Math.abs(e.delta);
			if (newZoom >= 1 && newZoom <= 5.0) {
				this.camera.zoom = newZoom;
			}
		}
		
		/**
		 * マウスの位置に応じてインタラクティブを設定しています
		 * @param	event
		 */
		private function enterFrameHandler(event:Event):void
		{
			// Pan
			camera.rotationY += (480 * mouseX/(stage.stageWidth) - camera.rotationY) * .1;
			camera.rotationX += (180 * mouseY/(stage.stageHeight) - 90 - camera.rotationX) * .1;
		}
		
	}
}
