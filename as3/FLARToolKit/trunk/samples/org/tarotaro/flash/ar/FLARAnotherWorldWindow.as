/* 
 * PROJECT: FLARToolKit
 * --------------------------------------------------------------------------------
 * This work is based on the NyARToolKit developed by
 *   R.Iizuka (nyatla)
 * http://nyatla.jp/nyatoolkit/
 *
 * The FLARToolKit is ActionScript 3.0 version ARToolkit class library.
 * Copyright (C)2008 Saqoosha
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this framework; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 * 
 * For further information please contact.
 *	http://www.libspark.org/wiki/saqoosha/FLARToolKit
 *	<saq(at)saqoosha.net>
 * 
 * For further information of this Class please contact.
 *	http://www.libspark.org/wiki/saqoosha/FLARToolKit
 *	<taro(at)tarotaro.org>
 *
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
	import org.libspark.flartoolkit.core.param.FLARParam;
	import org.libspark.flartoolkit.core.raster.IFLARRaster;
	import org.libspark.flartoolkit.core.raster.rgb.FLARRgbRaster_BitmapData;
	import org.libspark.flartoolkit.core.raster.rgb.IFLARRgbRaster;
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
	import org.tarotaro.flash.ar.layers.FLARAnotherWorldWindowLayer;
	
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
		//箱のテクスチャはFlickrなどから調達して、Data以下に格納してください。
		[Embed(source = '../../../../Data/tex3.jpg')]private var TexBitmap:Class;

		private var _capture:Bitmap;
		private var _video:Video;
		private var _layer:FLARAnotherWorldWindowLayer;

		public function FLARAnotherWorldWindow() 
		{
			//AR部分の設定
			var param:FLARParam = new FLARParam();
			param.loadARParam(new CParam()as ByteArray);
			var code:FLARCode = new FLARCode(16,16);
			var codeFile:ByteArray = new CodeData() as ByteArray;
			code.loadARPatt(codeFile.readMultiByte(codeFile.length, "shift-jis"));
			
			this._capture = new Bitmap(new BitmapData(320, 240, false, 0), PixelSnapping.AUTO, true);
			var raster:IFLARRgbRaster = new FLARRgbRaster_BitmapData(this._capture.bitmapData);
			var webcam:Camera = Camera.getCamera();
			webcam.setMode(320, 240, 30);
			
			this._video = new Video();
			this._video.attachCamera(webcam);

			var model:DisplayObject3D = new DisplayObject3D();
			model.frustumTestMethod = FrustumTestMethod.NO_TESTING;
			var mqo:Metasequoia = new Metasequoia();
			/* ここに、メタセコモデルのURLを記入 */
			mqo.load("Data/miku_mahou.mqo", 2);
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