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

// _______________________________________________________________________ MovieScene3D

package org.papervision3d.scenes
{
	import flash.utils.getTimer;
	import flash.display.*;
	
	import org.papervision3d.scenes.*;
	import org.papervision3d.core.proto.*;
	
	import org.papervision3d.objects.DisplayObject3D;
	import flash.utils.Dictionary;
	
	/**
	* The MovieScene3D class lets you create a scene where each object is rendered in its own container.
	* <p/>
	* A scene is the place where objects are placed, it contains the 3D environment.
	*/
	
	public class MovieScene3D extends Scene3D
	{
		// ___________________________________________________________________ N E W
		//
		// NN  NN EEEEEE WW    WW
		// NNN NN EE     WW WW WW
		// NNNNNN EEEE   WWWWWWWW
		// NN NNN EE     WWW  WWW
		// NN  NN EEEEEE WW    WW
	
		/**
		* Creates a scene where each object is rendered in its own container.
		*
		* @param	container	The Sprite where the new containers are created.
		*
		*/
		public function MovieScene3D( container:Sprite )
		{
			super( container );
	
			this.containerList = new Array();
			spriteList = new Dictionary();
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
		public override function addChild( child :DisplayObject3D, name :String=null ):DisplayObject3D
		{
			child = super.addChild( child, name );
	
			child.container = new Sprite();
			container.addChild( child.container );
			this.containerList.push( child.container );
			spriteList[child] = child.container;
			return child;
		}
		
		public function getSprite(child:DisplayObject3D):Sprite
		{
			return spriteList[child];
		}
	
		public override function removeChild( child:DisplayObject3D ):DisplayObject3D
		{
			var removed:DisplayObject3D=super.removeChild(child);
			for(var i:int=0;i<containerList.length;i++){
				if(removed.container==containerList[i]){
					this.containerList.splice(i, 1);
				}
			}
			
			container.removeChild(removed.container);
			
			delete spriteList[removed];
			
			return removed;
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
		protected override function renderObjects( sort:Boolean ):void
		{
			var objectsLength :Number = this.objects.length;
	
			// Clear object container
			var gfx          :Sprite;
			var containerList :Array = this.containerList;
			var i            :Number = 0;
	
			// Clear all known object
			while( gfx = containerList[i++] ) gfx.graphics.clear();
	
			// Render
			var p       :DisplayObject3D;
			var objects :Array  = this.objects;
			i = objects.length;
	
			if( sort )
			{
				while( p = objects[--i] )
				{
					if( p.visible )
					{
						container.addChild( p.container );
						p.render( this );
					}
				}
			}
			else
			{
				while( p = objects[--i] )
				{
					if( p.visible )
					{
						p.render( this );
					}
				}
			}
	
			// Update stats
			var stats:Object  = this.stats;
			stats.performance = getTimer() - stats.performance;
		}
	
		private var containerList : Array;
		private var spriteList : Dictionary;
	}
}