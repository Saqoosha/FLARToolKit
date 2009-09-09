package org.papervision3d.core.culling
{
	import org.papervision3d.core.geom.Vertex2D;
	import org.papervision3d.core.geom.Face3D;
	import flash.geom.Rectangle;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.core.geom.Face3DInstance;

	public class RectangleTriangleCuller extends DefaultTriangleCuller implements ITriangleCuller
	{
		
		private static const DEFAULT_RECT_W:Number = 640;
		private static const DEFAULT_RECT_H:Number = 480;
		private static const DEFAULT_RECT_X:Number = -(DEFAULT_RECT_W/2);
		private static const DEFAULT_RECT_Y:Number = -(DEFAULT_RECT_H/2);
		
		
		private static var hitRect:Rectangle = new Rectangle();
		
		public var cullingRectangle:Rectangle = new Rectangle(DEFAULT_RECT_X, DEFAULT_RECT_Y, DEFAULT_RECT_W, DEFAULT_RECT_H);
	
		/**
		 * @Author Ralph Hauwert
		 *
		 * RectangleTriangleCuller
		 * 
		 * This Triangle Culler culls faces based upon the visibility of it vertices and their visibility in a defined rectangle.
		 */
		public function RectangleTriangleCuller(cullingRectangle:Rectangle = null):void
		{
			if(cullingRectangle){
				this.cullingRectangle = cullingRectangle;	
			}
		}
		
		override public function testFace(displayObject3D:DisplayObject3D, faceInstance:Face3DInstance, vertex0:Vertex2D, vertex1:Vertex2D, vertex2:Vertex2D):Boolean
		{
			if(super.testFace(displayObject3D, faceInstance, vertex0, vertex1, vertex2)){
				hitRect.x = Math.min(vertex2.x, Math.min(vertex1.x, vertex0.x));
				hitRect.width = Math.max(vertex2.x, Math.max(vertex1.x, vertex0.x)) + Math.abs(hitRect.x);
				hitRect.y = Math.min(vertex2.y, Math.min(vertex1.y, vertex0.y));
				hitRect.height = Math.max(vertex2.y, Math.max(vertex1.y, vertex0.y)) + Math.abs(hitRect.y);
				return cullingRectangle.intersects(hitRect);	
			}
			return false;
		}
		
	}
}