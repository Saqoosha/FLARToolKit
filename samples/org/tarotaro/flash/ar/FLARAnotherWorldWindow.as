/*
 *  Copyright 2008 tarotarorg(http://tarotaro.org)
 * 
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 * 
 *      http://www.apache.org/licenses/LICENSE-2.0
 * 
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */
package org.tarotaro.flash.ar 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.utils.ByteArray;
	import org.libspark.flartoolkit.core.FLARCode;
	import org.libspark.flartoolkit.core.FLARParam;
	import org.libspark.flartoolkit.core.raster.FLARBitmapData;
	import org.libspark.pv3d.Metasequoia;
	import org.papervision3d.core.culling.FrustumTestMethod;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.materials.BitmapFileMaterial;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.materials.shadematerials.FlatShadeMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.materials.WireframeMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Cube;
	import org.papervision3d.objects.primitives.Sphere;
	
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class FLARAnotherWorldWindow extends Sprite
	{
		//フォルダ構造の変更に注意すること！！
		[Embed(source = "../../../../Data/camera_para.dat", mimeType = "application/octet-stream")]
		private var CParam:Class;
		[Embed(source = "../../../../Data/patt.hiro", mimeType = "application/octet-stream")]
		private var CodeData:Class;
		[Embed(source = '../../../../Data/tex3.jpg')]private var TexBitmap:Class;

		private var _capture:Bitmap;
		private var _video:Video;
		private var _layer:FLARAnotherWorldWindowLayer;

		public function FLARAnotherWorldWindow() 
		{
			//AR部分の設定
			var param:FLARParam = new FLARParam();
			param.loadFromARFile(new CParam()as ByteArray);
			var code:FLARCode = new FLARCode(16,16);
			var codeFile:ByteArray = new CodeData() as ByteArray;
			code.loadFromARFile(codeFile.readMultiByte(codeFile.length, "shift-jis"));
			
			this._capture = new Bitmap(new BitmapData(320, 240, false, 0), PixelSnapping.AUTO, true);
			var raster:FLARBitmapData = new FLARBitmapData(this._capture.bitmapData);
			var webcam:Camera = Camera.getCamera();
			webcam.setMode(320, 240, 30);
			
			this._video = new Video();
			this._video.attachCamera(webcam);

			var model:DisplayObject3D = new DisplayObject3D();
			model.frustumTestMethod = FrustumTestMethod.NO_TESTING;
			var mqo:Metasequoia = new Metasequoia();
			/* ここに、メタセコモデルのURLを記入 */
			mqo.load("model/pipe.mqo", 2);
			model.addChild(mqo);
			
			var mt:MaterialObject3D = new BitmapMaterial((new TexBitmap() as Bitmap).bitmapData);

			mt.doubleSided = true;
			var list:MaterialsList = new MaterialsList();
			list.addMaterial(mt, "all");

			var cube:Cube = new Cube(list,3200,6400,2400, 1, 1, 4, Cube.ALL, Cube.BACK);
			cube.frustumTestMethod = FrustumTestMethod.NO_TESTING;
			model.addChild(cube);
			this._layer = new FLARAnotherWorldWindowLayer(raster, param, code, 80, model);
			this.addChild(this._layer);
			
			this._capture.scaleX = this._capture.scaleY = 0.5;
			this.addChild(this._capture);

			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);

		}

		private function onEnterFrame(e:Event):void 
		{
			this._capture.bitmapData.draw(this._video);
			this._layer.update();
		}
	}
	
}