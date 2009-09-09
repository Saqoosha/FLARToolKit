package org.papervision3d.materials
{
	import flash.display.Graphics;
	import flash.geom.Matrix;
	
	import org.papervision3d.core.draw.IFaceDrawer;
	import org.papervision3d.core.geom.Face3D;
	import org.papervision3d.core.geom.Vertex2D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.objects.DisplayObject3D;

	public class CompositeMaterial extends MaterialObject3D implements IFaceDrawer
	{
		
		private var materials:Array;
		
		public function CompositeMaterial()
		{
			init();
		}
		
		private function init():void
		{
			materials = new Array();
		}
		
		public function addMaterial(material:MaterialObject3D):void
		{
			materials.push(material);
		}
		
		public function removeMaterial(material:MaterialObject3D):void
		{
			materials.splice(materials.indexOf(material),1);
		}
		
		public function removeAllMaterials(material:MaterialObject3D):void
		{
			materials = new Array();
		}
		
		override public function drawFace3D(instance:DisplayObject3D, face3D:Face3D, graphics:Graphics, v0:Vertex2D, v1:Vertex2D, v2:Vertex2D):int
		{
			var num:int = 0;
			for each(var n:MaterialObject3D in materials){
				num += n.drawFace3D(instance, face3D, graphics, v0, v1, v2);
			}
			return num;
		}
		
	}
}