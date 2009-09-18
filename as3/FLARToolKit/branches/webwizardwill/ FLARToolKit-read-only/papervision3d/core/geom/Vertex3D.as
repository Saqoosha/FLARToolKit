/*
 *  PAPER    ON   ERVIS  NPAPER ISION  PE  IS ON  PERVI IO  APER  SI  PA
 *  AP  VI  ONPA  RV  IO PA     SI  PA ER  SI NP PE     ON AP  VI ION AP
 *  PERVI  ON  PE VISIO  APER   IONPA  RV  IO PA  RVIS  NP PE  IS ONPAPE
 *  ER     NPAPER IS     PE     ON  PE  ISIO  AP     IO PA ER  SI NP PER
 *  RV     PA  RV SI     ERVISI NP  ER   IO   PE VISIO  AP  VISI  PA  RV3D
 *  ______________________________________________________________________
 *  papervision3d.org + blog.papervision3d.org + osflash.org/papervision3d
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

// ______________________________________________________________________
//                                                               Vertex3D
package org.papervision3d.core.geom
{
	import org.papervision3d.core.Number3D;
	import com.blitzagency.xray.logger.util.ObjectTools;
	import flash.utils.Dictionary;
	

	/**
	* The Vertex3D constructor lets you create 3D vertices.
	*/
	public class Vertex3D
	{
		/**
		* An Number that sets the X coordinate of a object relative to the scene coordinate system.
		*/
		public var x :Number;
	
		/**
		* An Number that sets the Y coordinate of a object relative to the scene coordinates.
		*/
		public var y :Number;
	
		/**
		* An Number that sets the Z coordinate of a object relative to the scene coordinates.
		*/
		public var z :Number;
	
		/**
		* An object that contains user defined properties.
		*/
		public var extra :Object;
		
		/**
		 * Vertex2D instance 
		 */
		 public var vertex2DInstance:Vertex2D;
		
		//To be docced
		public var normal:Number3D;
		public var connectedFaces:Dictionary;
	
		/**
		* Creates a new Vertex3D object whose three-dimensional values are specified by the x, y and z parameters.
		*
		* @param	x	The horizontal coordinate value. The default value is zero.
		* @param	y	The vertical coordinate value. The default value is zero.
		* @param	z	The depth coordinate value. The default value is zero.
		*
		* */
		public function Vertex3D( x:Number=0, y:Number=0, z:Number=0 )
		{
			this.x = x;
			this.y = y;
			this.z = z;
			
			this.vertex2DInstance = new Vertex2D();
			this.normal = new Number3D();
			this.connectedFaces = new Dictionary();
		}
		
		public function toNumber3D():Number3D
		{
			return new Number3D(x,y,z);
		}
		
		public function clone():Vertex3D
		{
			var clone:Vertex3D = new Vertex3D(x,y,z);
			clone.extra = extra;
			clone.vertex2DInstance = vertex2DInstance.clone();
			clone.normal = normal.clone();
			
			return clone;
		}
		
		public function calculateNormal():void
		{
			var face:Face3D;
			normal = new Number3D();
			for each(face in connectedFaces)
			{	
				normal = Number3D.add(face.faceNormal, normal);
			}
			normal.normalize();
		}
		
	}
}