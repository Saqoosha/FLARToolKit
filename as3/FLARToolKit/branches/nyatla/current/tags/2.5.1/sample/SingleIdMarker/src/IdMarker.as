package{
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.materials.WireframeMaterial;
	import org.papervision3d.materials.shadematerials.FlatShadeMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.primitives.Cube;
	import org.papervision3d.objects.primitives.Plane;
	

	[SWF(width=640,height=480,frameRate=30,backgroundColor=0x0)]

	public class IdMarker extends PV3DARApp{
		
		private static const PATTERN_FILE:String = "Data/patt.hiro";
		private static const CAMERA_FILE:String = "Data/camera_para.dat";
		
		private var _plane:Plane;
		private var _cube:Cube;
		
		public function IdMarker() {
			this.addEventListener(Event.INIT, this._onInit);
			this.init(CAMERA_FILE, PATTERN_FILE);
		}
		
		private function _onInit(e:Event):void {
			this.removeEventListener(Event.INIT, this._onInit);
			
			var wmat:WireframeMaterial = new WireframeMaterial(0xff0000, 1, 2);
			wmat.doubleSided = true;
			this._plane = new Plane(wmat, 80, 80);
			this._baseNode.addChild(this._plane);
			
			var light:PointLight3D = new PointLight3D();
			light.x = 1000;
			light.y = 1000;
			light.z = -1000;
			var fmat:FlatShadeMaterial = new FlatShadeMaterial(light, 0xff22aa, 0x0);
			this._cube = new Cube(new MaterialsList({all: fmat}), 40, 40, 40);
			this._cube.z =20;
			this._baseNode.addChild(this._cube);
			
			this.stage.addEventListener(MouseEvent.CLICK, this._onClick);
		}
		
		private function _onClick(e:MouseEvent):void {
			this.mirror = !this.mirror;
		}	
	}
}