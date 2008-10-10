package org.tarotaro.flash.ar 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.net.URLRequest;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.view.BasicView;
	
	/**
	 * ...
	 * @author 太郎(tarotaro.org)
	 */
	public class DummyMarkerController extends BasicView
	{
		private var _marker:BitmapData;
		private var _markerPlane:Plane;

		public function DummyMarkerController(src:BitmapData) 
		{
			var material:BitmapMaterial(src, true);
			material.doubleSided = false;
			this._markerPlane = new Plane(material, src.width, src.height, 4, 4);
		}
		
	}
	
}