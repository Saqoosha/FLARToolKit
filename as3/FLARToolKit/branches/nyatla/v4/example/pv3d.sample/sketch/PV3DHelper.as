package sketch 
{
	import flash.media.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.text.*;
    import flash.display.*; 
    import flash.events.*;
    import flash.utils.*;
	import org.papervision3d.render.*;
	import org.papervision3d.view.*;
	import org.papervision3d.objects.*;
	import org.papervision3d.lights.*;
	import org.papervision3d.materials.*;
	import org.papervision3d.materials.shadematerials.*;
	import org.papervision3d.objects.primitives.*;
	import org.papervision3d.materials.utils.*;
	import org.papervision3d.scenes.*;
	import org.papervision3d.typography.*;
	import org.papervision3d.typography.fonts.*;
	import org.papervision3d.materials.special.*;	
	/**
	 * サンプルで使う関数をまとめたものです。
	 */
	public class PV3DHelper
	{
		/**
		 * Create a 3dModel together with wireframe and cube.
		 * @return
		 */
		public static function createFLARCube(i_light:PointLight3D,i_size:int,i_lcolor:uint=0xffffff,i_acolor:uint=0,i_scolor:uint=0):DisplayObject3D
		{
			var node:DisplayObject3D = new DisplayObject3D();
			//Red wireFrame
			var wmat:WireframeMaterial = new WireframeMaterial(0xff0000, 1, 2); // with wireframe. / ワイヤーフレームで。
			var plane:Plane = new Plane(wmat, i_size, i_size); // 80mm x 80mm。
			plane.rotationX = 180;
			node.addChild(plane);
			//
			var fmat:FlatShadeMaterial = new FlatShadeMaterial(i_light, i_lcolor, i_acolor,i_scolor); // Color is ping. / ピンク色。
			var cube:Cube = new Cube(new MaterialsList({all: fmat}), i_size/2,i_size/2,i_size/2);
 	        cube.z = 20; // Move the cube to upper (minus Z) direction Half height of the Cube. / 立方体の高さの半分、上方向(-Z方向)に移動させるとちょうどマーカーにのっかる形になる。
			node.addChild(cube);			
			return node;
		}
		public static function createFLText(i_text:String,i_size:int,i_scale:Number,i_lcolor:uint=0x0):DisplayObject3D
		{
			var node:DisplayObject3D = new DisplayObject3D();
			// ワイヤーフレームで,マーカーと同じサイズを Plane を作ってみる。
			var wmat:WireframeMaterial = new WireframeMaterial(0x0000ff, 1, 2);
			var plane:Plane = new Plane(wmat,i_size,i_size); // 80mm x 80mm。
			plane.rotationX = 180;
			
			// ID表示用のデータを作成する。
			var textdata:Text3D = new Text3D(i_text, new HelveticaBold(), new Letter3DMaterial(i_lcolor, 0.9), "textdata")
			textdata.rotationX = 180;
			textdata.rotationZ = 90;
			textdata.scale = i_scale;

			// _container に 追加
			node.addChild(plane);
			node.addChild(textdata);
			return node;
		}		
	}
}