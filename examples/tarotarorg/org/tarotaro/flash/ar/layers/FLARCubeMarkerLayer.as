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
package org.tarotaro.flash.ar.layers 
{
	import flash.display.Graphics;
	import org.libspark.flartoolkit.core.param.FLARParam;
	import org.libspark.flartoolkit.core.raster.rgb.IFLARRgbRaster;
	import org.libspark.flartoolkit.core.transmat.FLARTransMatResult;
	import org.libspark.flartoolkit.detector.FLARMultiMarkerDetector;
	import org.libspark.flartoolkit.detector.FLARMultiMarkerDetectorResult;
	import org.libspark.flartoolkit.support.pv3d.FLARBaseNode;
	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.materials.shadematerials.FlatShadeMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.materials.WireframeMaterial;
	import org.papervision3d.objects.primitives.Cube;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.view.BasicView;
	import org.tarotaro.flash.ar.detector.CubeMarker;
	import org.tarotaro.flash.ar.detector.CubeMarkerDetectedResult;
	import org.tarotaro.flash.ar.detector.CubeFace;
	import org.tarotaro.flash.ar.detector.FLARCubeMarkerDetector;
	
	/**
	 * ...
	 * @author 太郎(tarotaro.org)
	 */
	public class FLARCubeMarkerLayer extends FLARLayer
	{
		protected var _detector:FLARCubeMarkerDetector;
		protected var _resultMat:FLARTransMatResult;
		protected var _confidence:Number;
		protected var _baseNode:FLARBaseNode;
		private var _plane:Plane;
		private var _cube:Cube;
		private var _view:BasicView;
		
		private var colors:Object = {
			top:0xFF0000,
			front:0x00FF00,
			left:0x0000FF,
			right:0xFFFF00,
			back:0xFF00FF
		};
		public function FLARCubeMarkerLayer(src:IFLARRgbRaster, 
												param:FLARParam, 
												cube:CubeMarker, 
												confidence:Number = 0.65,
												thresh:int = 100) 
		{
			super(src, thresh);
			this._detector = new FLARCubeMarkerDetector(param, cube,1.0);
			//this._detector.sizeCheckEnabled = false;
			this._resultMat = new FLARTransMatResult();
			this._confidence = confidence;
			
			this._baseNode = new FLARBaseNode();
			var wmat:WireframeMaterial = new WireframeMaterial(0xff0000, 1, 2);
			wmat.doubleSided = true;
			this._plane = new Plane(wmat, 100, 100);
			this._baseNode.addChild(this._plane);
			
			var light:PointLight3D = new PointLight3D();
			light.x = 1000;
			light.y = 1000;
			light.z = -1000;
			var fmat:FlatShadeMaterial = new FlatShadeMaterial(light, 0xff22aa, 0x0);
			this._cube = new Cube(new MaterialsList({all: fmat}), 60,60,60);
			this._cube.z += 20;
			this._baseNode.addChild(this._cube);
			
			this._view = new BasicView(320, 240);
			this._view.scene.addChild(this._baseNode);
			this.addChild(this._view);
		}
		
		override public function update():void 
		{
			var g:Graphics = this.graphics;
			g.clear();

			var r:CubeMarkerDetectedResult = this._detector.detectMarkerLite(this._source, this._thresh);
			if (r != null && r.confidence > this._confidence) {
					trace(r.markerDirection, r.confidence);
					if (r.markerDirection == CubeFace.FRONT) {
						this._detector.getTransmationMatrix(r, this._resultMat);
						this._baseNode.setTransformMatrix(this._resultMat);
						this._view.startRendering();
					}
					var v:Array = r.square.sqvertex;
					g.lineStyle(2, colors[r.markerDirection]);
					g.moveTo(v[3].x, v[3].y);
					for (var vi:int = 0; vi < v.length; vi++) {
						g.lineTo(v[vi].x, v[vi].y);
					}
			} else {
				this._view.stopRendering();
			}
		}
		
	}
	
}