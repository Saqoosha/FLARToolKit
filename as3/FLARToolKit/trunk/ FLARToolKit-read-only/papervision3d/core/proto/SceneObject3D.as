/*
 *  PAPER    ON   ERVIS  NPAPER ISION  PE  IS ON  PERVI IO  APER  SI  PA
 *  AP  VI  ONPA  RV  IO PA     SI  PA ER  SI NP PE     ON AP  VI ION AP
 *  PERVI  ON  PE VISIO  APER   IONPA  RV  IO PA  RVIS  NP PE  IS ONPAPE
 *  ER     NPAPER IS     PE     ON  PE  ISIO  AP     IO PA ER  SI NP PER
 *  RV     PA  RV SI     ERVISI NP  ER   IO   PE VISIO  AP  VISI  PA  RV3D
 *  ______________________________________________________________________
 *  papervision3d.org • blog.papervision3d.org • osflash.org/papervision3d
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
//                                                          SceneObject3D

package org.papervision3d.core.proto
{
	import flash.display.Sprite;
	import flash.utils.getTimer;
	import flash.utils.Dictionary;
	
	import org.papervision3d.Papervision3D;
	import org.papervision3d.core.proto.*;
	import org.papervision3d.materials.MaterialsList;
	import org.papervision3d.materials.MovieMaterial;
	
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.core.culling.ITriangleCuller;
	import org.papervision3d.core.culling.DefaultTriangleCuller;
	import org.papervision3d.core.stat.RenderStatistics;
	
	/**
	* The SceneObject3D class is the base class for all scenes.
	* <p/>
	* A scene is the place where objects are placed, it contains the 3D environment.
	* <p/>
	* The scene manages all objects rendered in Papervision3D. It extends the DisplayObjectContainer3D class to arrange the display objects.
	* <p/>
	* SceneObject3D is an abstract base class; therefore, you cannot call SceneObject3D directly.
	*/
	public class SceneObject3D extends DisplayObjectContainer3D
	{
		// __________________________________________________________________________
		//                                                                     STATIC
	
		/**
		* The Sprite that you draw into when rendering.
		*/
		public var container :Sprite;
	
		/**
		* A list of the geometries in the scene.
		*/
		private var geometries :Dictionary;
	
		/**
		* An object that contains total and current statistics.
		* <ul>
		* <li>points</li>
		* <li>polys</li>
		* <li>triangles</li>
		* <li>performance<li>
		* <li>rendered<li>
		* </ul>
		*/
		public var stats :RenderStatistics;
	
		/**
		* It contains a list of DisplayObject3D objects in the scene.
		*/
		public var objects :Array;
	
		/**
		* It contains a list of materials in the scene.
		*/
		public var materials :MaterialsList;
	
		// ___________________________________________________________________ N E W
		//
		// NN  NN EEEEEE WW    WW
		// NNN NN EE     WW WW WW
		// NNNNNN EEEE   WWWWWWWW
		// NN NNN EE     WWW  WWW
		// NN  NN EEEEEE WW    WW
	
		/**
		* The SceneObject3D class lets you create scene classes.
		*
		* @param	container	The Sprite that you draw into when rendering. If not defined, each object must have it's own private container.
		*/
		public function SceneObject3D( container:Sprite )
		{
			if( container )
				this.container = container;
			else
				Papervision3D.log( "Scene3D: container argument required." );
	
			this.objects = new Array();
			this.materials = new MaterialsList();
	
			Papervision3D.log( Papervision3D.NAME + " " + Papervision3D.VERSION + " (" + Papervision3D.DATE + ")\n" );
	
			this.stats = new RenderStatistics();
			this.stats.points = 0;
			this.stats.polys = 0;
			this.stats.triangles = 0;
			this.stats.performance = 0;
			this.stats.rendered = 0;
			
			this.root = this;
		}
	
		// ___________________________________________________________________ A D D C H I L D
		//
		//   AA   DDDDD  DDDDD   CCCC  HH  HH II LL     DDDDD
		//  AAAA  DD  DD DD  DD CC  CC HH  HH II LL     DD  DD
		// AA  AA DD  DD DD  DD CC     HHHHHH II LL     DD  DD
		// AAAAAA DD  DD DD  DD CC  CC HH  HH II LL     DD  DD
		// AA  AA DDDDD  DDDDD   CCCC  HH  HH II LLLLLL DDDDD
	
		/**
		* Adds a child DisplayObject3D instance to the scene.
		*
		* If you add a GeometryObject3D symbol, a new DisplayObject3D instance is created.
		*
		* [TODO: If you add a child object that already has a different display object container as a parent, the object is removed from the child list of the other display object container.]
		*
		* @param	child	The GeometryObject3D symbol or DisplayObject3D instance to add as a child of the scene.
		* @param	name	An optional name of the child to add or create. If no name is provided, the child name will be used.
		* @return	The DisplayObject3D instance that you have added or created.
		*/
		public override function addChild( child:DisplayObject3D, name:String=null ):DisplayObject3D
		{
			var newChild:DisplayObject3D =	super.addChild( child, name );
			
			// Added by John Grden for New culling code 7.18.2007
			// setting the scene will spread to the child displayobject3d's
			child.scene = this;
	
			this.objects.push( newChild );
	
			return newChild;
		}
	
		/**
		* Removes the specified child DisplayObject3D instance from the child and object list of the scene.
		* </p>
		* [TODO: The parent property of the removed child is set to null, and the object is garbage collected if no other references to the child exist.]
		* </p>
		* The garbage collector is the process by which Flash Player reallocates unused memory space. When a variable or object is no longer actively referenced or stored somewhere, the garbage collector sweeps through and wipes out the memory space it used to occupy if no other references to it exist.
		* </p>
		* @param	child	The DisplayObject3D instance to remove.
		* @return	The DisplayObject3D instance that you pass in the child parameter.
		*/
		public override function removeChild( child:DisplayObject3D ):DisplayObject3D
		{
			super.removeChild( child );
	
			for (var i:int = 0; i < this.objects.length; i++ )
			{
				if (this.objects[i] === child )
				{
					this.objects.splice(i, 1);
					return child;
				}
			}
	
			return child;
		}
	
	
		// ___________________________________________________________________ R E N D E R   C A M E R A
		//
		// RRRRR  EEEEEE NN  NN DDDDD  EEEEEE RRRRR
		// RR  RR EE     NNN NN DD  DD EE     RR  RR
		// RRRRR  EEEE   NNNNNN DD  DD EEEE   RRRRR
		// RR  RR EE     NN NNN DD  DD EE     RR  RR
		// RR  RR EEEEEE NN  NN DDDDD  EEEEEE RR  RR CAMERA
	
		/**
		* Generates an image from the camera's point of view and the visible models of the scene.
		*
		* @param	camera		camera to render from.
		*/
		public function renderCamera( camera :CameraObject3D ):void
		{
			stats.clear();
			// Render performance stats
			stats.performance = getTimer();
	
			// Materials
			MovieMaterial.updateAnimatedBitmaps();
	
			// 3D projection
			if( camera )
			{
				// Transform camera
				camera.transformView();
	
				// Project objects
				var objects :Array = this.objects;
				var p       :DisplayObject3D;
				var i       :Number = objects.length;
	
				while( p = objects[--i] )
					if( p.visible )
						p.project( camera, camera );
			}
	
			// Z sort
			if( camera.sort )
				this.objects.sortOn( 'screenZ', Array.NUMERIC );
					
			renderObjects( camera.sort );
		}
	
		public var triangleCuller:ITriangleCuller = new DefaultTriangleCuller();
		
		
		/**
		* [internal-use]
		*
		* @param	sort
		*/
		protected function renderObjects( sort:Boolean ):void {}
	}
}