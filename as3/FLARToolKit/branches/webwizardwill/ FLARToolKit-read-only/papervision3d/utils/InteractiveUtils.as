/*
 *  PAPER    ON   ERVIS  NPAPER ISION  PE  IS ON  PERVI IO  APER  SI  PA
 *  AP  VI  ONPA  RV  IO PA     SI  PA ER  SI NP PE     ON AP  VI ION AP
 *  PERVI  ON  PE VISIO  APER   IONPA  RV  IO PA  RVIS  NP PE  IS ONPAPE
 *  ER     NPAPER IS     PE     ON  PE  ISIO  AP     IO PA ER  SI NP PER
 *  RV     PA  RV SI     ERVISI NP  ER   IO   PE VISIO  AP  VISI  PA  RV3D
 *  ______________________________________________________________________
 *  papervision3d.org ? blog.papervision3d.org ? osflash.org/papervision3d
 */

/*
 * Copyright 2006 (c) Carlos Ulloa Matesanz, noventaynueve.com.
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */

/**
* @author Pierre Lepers
* @author De'Angelo Richardson
* @author John Grden
* 
* NOTES:
* 	Special thanks to Blackpawn for this post:
*   http://www.blackpawn.com/texts/pointinpoly/default.html
* 
* 	And Pierre Lepers / Away3D for providing the foundational UVatPoint and getCoordAtPoint methods.  We're not sure who came out with them first, but wanted
* 	to thank them both just the same.
* 
* 	These rock!!
* @version 1.0
*/
package org.papervision3d.utils 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import org.papervision3d.core.geom.Face3D;
	import org.papervision3d.core.geom.Vertex3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	
	/**
	 * InteractiveUtils are used in conjunction with the ISM to resolve a face's mouse interaction and coordinates back to 2D screen space
	 * 
	 * 
	 */	
	public class InteractiveUtils 
	{
		public static function UVatPoint( face3d:Face3D, x : Number, y : Number ) : Object 
		{	
			
			var v0:Vertex3D = face3d.v0;
			var v1:Vertex3D = face3d.v1;
			var v2:Vertex3D = face3d.v2;
			
			var v0Dx : Number = v0.vertex2DInstance.x;
			var v0Dy : Number = v0.vertex2DInstance.y;
			var v1Dx : Number = v1.vertex2DInstance.x;
			var v1Dy : Number = v1.vertex2DInstance.y;
			var v2Dx : Number = v2.vertex2DInstance.x;
			var v2Dy : Number = v2.vertex2DInstance.y;
			
			var v0_x : Number = v2Dx - v0Dx;
			var v0_y : Number = v2Dy - v0Dy;
			var v1_x : Number = v1Dx - v0Dx;
			var v1_y : Number = v1Dy - v0Dy;
			var v2_x : Number = x - v0Dx;
			var v2_y : Number = y - v0Dy;
				
			var dot00 : Number = v0_x * v0_x + v0_y * v0_y;
			var dot01 : Number = v0_x * v1_x + v0_y * v1_y;
			var dot02 : Number = v0_x * v2_x + v0_y * v2_y;
			var dot11 : Number = v1_x * v1_x + v1_y * v1_y;
			var dot12 : Number = v1_x * v2_x + v1_y * v2_y;
				
			var invDenom : Number = 1 / (dot00 * dot11 - dot01 * dot01);
			var u : Number = (dot11 * dot02 - dot01 * dot12) * invDenom;
			var v : Number = (dot00 * dot12 - dot01 * dot02) * invDenom;
		   
			return { u : u, v : v };
		}
		
		public static function getCoordAtPoint( face3d:Face3D, x : Number, y : Number ) : Vertex3D 
		{	
			var rUV : Object = UVatPoint(face3d, x, y);
			
			var v0x : Number = face3d.v0.x;
			var v0y : Number = face3d.v0.y;
			var v0z : Number = face3d.v0.z;
			var v1x : Number = face3d.v1.x;
			var v1y : Number = face3d.v1.y;
			var v1z : Number = face3d.v1.z;
			var v2x : Number = face3d.v2.x;
			var v2y : Number = face3d.v2.y;
			var v2z : Number = face3d.v2.z;
			
			var u : Number = rUV.u;
			var v : Number = rUV.v;
				
			var rX : Number = v0x + ( v1x - v0x ) * v + ( v2x - v0x ) * u;
			var rY : Number = v0y + ( v1y - v0y ) * v + ( v2y - v0y ) * u;
			var rZ : Number = v0z + ( v1z - v0z ) * v + ( v2z - v0z ) * u;
				
			return new Vertex3D( rX, rY, rZ );
		}
		
		public static function getMapCoordAtPointDO3D( displayObject:DisplayObject3D, x : Number, y : Number ):Object
		{
			var face:Face3D = displayObject.geometry.faces[0];
			return getMapCoordAtPoint(face, x, y);
		}
		
		public static function getMapCoordAtPoint( face3d:Face3D, x : Number, y : Number ) : Object 
		{
			var uv:Array = face3d.uv;
			
			var rUV : Object = UVatPoint(face3d, x, y);
			var u : Number = rUV.u;
			var v : Number = rUV.v;
			
			var u0 : Number = uv[0].u;
			var u1 : Number = uv[1].u;
			var u2 : Number = uv[2].u;
			var v0 : Number = uv[0].v;
			var v1 : Number = uv[1].v;
			var v2 : Number = uv[2].v;
				
			var v_x : Number = ( u1 - u0 ) * v +  ( u2 - u0 ) * u + u0;
			var v_y : Number = ( v1 - v0 ) * v +  ( v2 - v0 ) * u + v0;

			var material:MaterialObject3D = face3d.face3DInstance.instance.material;
			var bitmap:BitmapData = material.bitmap;
			var width:Number = 1;
			var height:Number = 1;
			if(bitmap)
			{
				width = BitmapMaterial.AUTO_MIP_MAPPING ? material.widthOffset : bitmap.width;
				height = BitmapMaterial.AUTO_MIP_MAPPING ? material.heightOffset : bitmap.height;
			}
				
			return { x:v_x * width, y:height - v_y * height };
		}
	}	
}