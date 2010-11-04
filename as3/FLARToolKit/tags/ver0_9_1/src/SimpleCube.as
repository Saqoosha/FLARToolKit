package {
	
	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.materials.WireframeMaterial;
	import org.papervision3d.materials.shadematerials.FlatShadeMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.primitives.Cube;
	import org.papervision3d.objects.primitives.Plane;
	
	[SWF(width=640, height=480, backgroundColor=0x808080, frameRate=30)]
	
	public class SimpleCube extends PV3DARApp {
		
		private var _plane:Plane;
		private var _cube:Cube;
		
		public function SimpleCube() {
			// Initalize application with the path of camera calibration file and patter definition file.
			// カメラ補正ファイルとパターン定義ファイルのファイル名を渡して初期化。
			this.init('../resources/Data/camera_para.dat', '../resources/Data/flarlogo.pat');
		}
		
		protected override function onInit():void {
			super.onInit(); // You must call this. / 必ず呼ぶアル。
			
			// Create Plane with same size of the marker.
			// マーカーと同じサイズを Plane を作ってみる。
			var wmat:WireframeMaterial = new WireframeMaterial(0xff0000, 1, 2); // with wireframe. / ワイヤーフレームで。
			this._plane = new Plane(wmat, 80, 80); // 80mm x 80mm。
			this._baseNode.addChild(this._plane); // attach to _baseNode to follow the marker. / _baseNode に addChild するとマーカーに追従する。

			// Place the light at upper front.
			// ライトの設定。手前、上のほう。
			var light:PointLight3D = new PointLight3D();
			light.x = 0;
			light.y = 1000;
			light.z = -1000;
			
			// Create Cube.
			// Cube を作る。
			var fmat:FlatShadeMaterial = new FlatShadeMaterial(light, 0xff22aa, 0x75104e); // Color is ping. / ピンク色。
			this._cube = new Cube(new MaterialsList({all: fmat}), 40, 40, 40); // 40mm x 40mm x 40mm
			this._cube.z = -20; // Move the cube to upper (minus Z) direction Half height of the Cube. / 立方体の高さの半分、上方向(-Z方向)に移動させるとちょうどマーカーにのっかる形になる。
			this._baseNode.addChild(this._cube);
		}
	}
}