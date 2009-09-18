package org.papervision3d.core.culling
{
	import org.papervision3d.core.geom.Vertex2D;
	import org.papervision3d.core.geom.Face3D;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.core.geom.Face3DInstance;

	public class CompositeTriangleCuller implements ITriangleCuller
	{
		
		private var cullers:Array;
		
		public function CompositeTriangleCuller()
		{
			init();
		}
		
		private function init():void
		{
			cullers = new Array();
		}
		
		public function addCuller(culler:ITriangleCuller):void
		{
			cullers.push(culler);
		}
		
		public function removeCuller(culler:ITriangleCuller):void
		{
			cullers.splice(cullers.indexOf(culler),1);
		}
		
		public function clearCullers():void
		{
			cullers = new Array();
		}
		
		public function testFace(displayObject:DisplayObject3D, faceInstance:Face3DInstance, vertex0:Vertex2D, vertex1:Vertex2D, vertex2:Vertex2D):Boolean
		{
			for each(var culler:ITriangleCuller in cullers)
			{
				//Add "modes here". Like inclusive or exclusive	
			}
			return true;
		}
		
	}
}