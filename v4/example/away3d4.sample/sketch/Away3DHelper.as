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
	import away3d.containers.*;
    import away3d.materials.*;
    import away3d.materials.lightpickers.*;
    import away3d.primitives.*;
	import away3d.entities.*;
	import away3d.lights.DirectionalLight;	
	/**
	 * サンプルで使う関数をまとめたものです。
	 */
	public class Away3DHelper
	{
		/**
		 * Create a 3dModel together with wireframe and cube.
		 * @return
		 */
		public static function createFLARCube(i_size:Number, i_light:DirectionalLight,c:uint=0xff0000):ObjectContainer3D
		{
			var node:ObjectContainer3D = new ObjectContainer3D();
			var material : ColorMaterial = new ColorMaterial(c);
            var _cubeGeo:CubeGeometry = new CubeGeometry(i_size/2,i_size/2,i_size/2,4,4,4);
            var _cube:Mesh = new Mesh(_cubeGeo, material);
			_cube.name = "CUBE";
			if(i_light!=null){
				_cube.material.lightPicker = new StaticLightPicker([i_light]);
				node.addChild(i_light);
			}
			_cube.z = i_size / 4;
            node.addChild(_cube);
			return node;
		}

	}
}