package sketch 
{
	import flash.media.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.text.*;
    import flash.display.*; 
    import flash.events.*;
    import flash.utils.*;
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.materials.WireframeMaterial;
	import away3d.primitives.Cube;
	import away3d.primitives.Plane;
	/**
	 * サンプルで使う関数をまとめたものです。
	 */
	public class Away3DHelper
	{
		/**
		 * Create a 3dModel together with wireframe and cube.
		 * @return
		 */
		public static function createFLARCube(i_size:int):ObjectContainer3D
		{
			var node:ObjectContainer3D = new ObjectContainer3D();
			// ワイヤーフレームで,マーカーと同じサイズを Plane を作ってみる。
			var wmat:WireframeMaterial = new WireframeMaterial(0x0000ff);
			// 幅と透過度を設定
			wmat.width = 2;
			wmat.alpha = 1;
			
			var _plane:Plane = new Plane(); // 80mm x 80mm。
			_plane.width = i_size;
			_plane.height = i_size;
			_plane.material = wmat;			
			var _cube:Cube = new Cube();
			_cube.width = i_size/2;
			_cube.height = i_size/2;
			_cube.depth = i_size/2;
			_cube.y = i_size/4
 			// _container に 追加
			node.addChild(_plane);
			node.addChild(_cube);
			return node;
		}
		/*
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
		}		*/
	}
}