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

// _______________________________________________________________________ MaterialObject3D

package org.papervision3d.core.proto
{
	import flash.geom.Matrix;
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import org.papervision3d.core.geom.Face3D;
	import flash.display.Graphics;
	import org.papervision3d.core.geom.Vertex2D;
	import org.papervision3d.core.draw.IFaceDrawer;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.materials.WireframeMaterial;


	/**
	* The MaterialObject3D class is the base class for all materials.
	* <p/>
	* Materials collects data about how objects appear when rendered.
	* <p/>
	* A material is data that you assign to objects or faces, so that they appear a certain way when rendered. Materials affect the line and fill colors.
	* <p/>
	* Materials create greater realism in a scene. A material describes how an object reflects or transmits light.
	* <p/>
	* You assign materials to individual objects or a selection of faces; a single object can contain different materials.
	* <p/>
	* MaterialObject3D is an abstract base class; therefore, you cannot call MaterialObject3D directly.
	*/
	public class MaterialObject3D extends EventDispatcher implements IFaceDrawer
	{
		/**
		* A transparent or opaque BitmapData texture.
		*/
		public var bitmap :BitmapData;

		/**
		* A Boolean value that determines whether the BitmapData texture is smoothed when rendered.
		*/
		public var smooth :Boolean = false;

		/**
		* A Boolean value that determines whether the texture is tiled when rendered. Defaults to false.
		*/
		public var tiled :Boolean = false;

		/**
		* A RGB color value to draw the faces outline.
		*/
		public var lineColor :Number = DEFAULT_COLOR;

		/**
		* An 8-bit alpha value for the faces outline. If zero, no outline is drawn.
		*/
		public var lineAlpha :Number = 0;
		
		/**
		* An value for the thickness of the faces line.
		*/
		public var lineThickness:Number = 1;

		/**
		* A RGB color value to fill the faces with. Only used if no texture is provided.
		*/
		public var fillColor :Number = DEFAULT_COLOR;

		/**
		* An 8-bit alpha value fill the faces with. If this value is zero and no texture is provided or is undefined, a fill is not created.
		*/
		public var fillAlpha :Number = 0;

		/**
		* A Boolean value that indicates whether the faces are double sided.
		*/
		public function get doubleSided():Boolean
		{
			return ! this.oneSide;
		}

		public function set doubleSided( double:Boolean ):void
		{
			this.oneSide = ! double;
		}

		/**
		* A Boolean value that indicates whether the faces are single sided. It has preference over doubleSided.
		*/
		public var oneSide :Boolean = true;


		/**
		* A Boolean value that indicates whether the faces are invisible (not drawn).
		*/
		public var invisible :Boolean = false;

		/**
		* A Boolean value that indicates whether the face is flipped. Only used if doubleSided or not singeSided.
		*/
		public var opposite :Boolean = false;

		/**
		* The scene where the object belongs.
		*/
		public var scene :SceneObject3D;

		/**
		* Color used for DEFAULT material.
		*/
		static public var DEFAULT_COLOR :int = 0x000000;

		/**
		* Color used for DEBUG material.
		*/
		static public var DEBUG_COLOR :int = 0xFF00FF;

		/**
		* The name of the material.
		*/
		public var name :String;

		/**
		* [internal-use] [read-only] Unique id of this instance.
		*/
		public var id :Number;


		/**
		 * Internal use
		 */
		public var maxU :Number;

		/**
		 * Internal use
		 */
		public var maxV :Number;
		
		/**
		 * Defines if face normals need to be rotated for this material.
		 */
		 public var needsFaceNormals:Boolean = false;
		 
		 //To be docced
		 public var needsVertexNormals:Boolean = false;
		 
		 /**
		* Holds the original size of the bitmap before it was resized by Automip mapping
		*/
		 public var widthOffset:Number = 0;
		/**
		* Holds the original size of the bitmap before it was resized by Automip mapping
		*/
		 public var heightOffset:Number = 0;

	//	public var extra :Object;

		/**
		* Creates a new MaterialObject3D object.
		*
		* @param	initObject	[optional] - An object that contains properties for the newly created material.
		*/
		public function MaterialObject3D()
		{
			this.id = _totalMaterialObjects++;
		}

		/**
		* Returns a MaterialObject3D object with the default magenta wireframe values.
		*
		* @return A MaterialObject3D object.
		*/
		static public function get DEFAULT():MaterialObject3D
		{
			var defMaterial :MaterialObject3D = new WireframeMaterial(); //RH, it now returns a wireframe material.
			defMaterial.lineColor   = 0xFFFFFF * Math.random();
			defMaterial.lineAlpha   = 1;
			defMaterial.fillColor   = DEFAULT_COLOR;
			defMaterial.fillAlpha   = 1;
			defMaterial.doubleSided = false;

			return defMaterial;
		}

		static public function get DEBUG():MaterialObject3D
		{
			var defMaterial :MaterialObject3D = new MaterialObject3D();

			defMaterial.lineColor   = 0xFFFFFF * Math.random();
			defMaterial.lineAlpha   = 1;
			defMaterial.fillColor   = DEBUG_COLOR;
			defMaterial.fillAlpha   = 0.37;
			defMaterial.doubleSided = true;

			return defMaterial;
		}
		
		
		/**
		 *	drawFace3D();
		 *
		 * Draws the triangle to screen.
		 *
		 */
		public function drawFace3D(instance:DisplayObject3D, face3D:Face3D, graphics:Graphics, v0:Vertex2D, v1:Vertex2D, v2:Vertex2D):int
		{
			return 0;
		}
		
		/**
		* Updates the BitmapData bitmap from the given texture.
		*
		* Draws the current MovieClip image onto bitmap.
		*/
		public function updateBitmap():void {}


		/**
		* Copies the properties of a material.
		*
		* @param	material	Material to copy from.
		*/
		public function copy( material :MaterialObject3D ):void
		{
			this.bitmap    = material.bitmap;
	//		this.animated  = material.animated;
			this.smooth    = material.smooth;

			this.lineColor = material.lineColor;
			this.lineAlpha = material.lineAlpha;
			this.fillColor = material.fillColor;
			this.fillAlpha = material.fillAlpha;
			
			this.needsFaceNormals = material.needsFaceNormals;
			this.needsVertexNormals = material.needsVertexNormals;
			
			this.oneSide   = material.oneSide;
			this.opposite  = material.opposite;

			this.invisible = material.invisible;
			this.scene     = material.scene;
			this.name      = material.name;
			
			this.maxU      = material.maxU;
			this.maxV      = material.maxV;
		}

		/**
		* Creates a copy of the material.
		*
		* @return	A newly created material that contains the same properties.
		*/
		public function clone():MaterialObject3D
		{
			var cloned:MaterialObject3D = new MaterialObject3D();
			cloned.copy(this);
			return cloned;
		}

		/**
		* Returns a string value representing the material properties.
		*
		* @return	A string.
		*/
		override public function toString():String
		{
			return '[MaterialObject3D] bitmap:' + this.bitmap + ' lineColor:' + this.lineColor + ' fillColor:' + fillColor;
		}

		static private var _totalMaterialObjects :Number = 0;
	}
}