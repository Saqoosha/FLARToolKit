package org.papervision3d.core.geom
{
	import flash.display.Sprite;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.core.Number3D;
	
	public class Face3DInstance
	{
		public var face:Face3D;
		public var instance:DisplayObject3D;
		
		/**
		* container is initialized via DisplayObject3D's render method IF DisplayObject3D.faceLevelMode is set to true
		*/
		public var container:Sprite;
		public var visible:Boolean = false;
		public var screenZ:Number;
		public var faceNormal:Number3D;
		
		public function Face3DInstance(face:Face3D, instance:DisplayObject3D = null)
		{
			this.face = face;
			this.instance = instance;
			faceNormal = new Number3D();
		}
	}
}