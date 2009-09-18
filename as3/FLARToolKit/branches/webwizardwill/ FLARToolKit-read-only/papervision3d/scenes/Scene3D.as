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
//                                                                Scene3D

package org.papervision3d.scenes
{
import flash.utils.getTimer;
import flash.display.Sprite;

import org.papervision3d.objects.DisplayObject3D;
import org.papervision3d.scenes.*;
import org.papervision3d.core.proto.*;

/**
* The Scene3D class lets you create a scene where all objects are rendered in the same container.
* <p/>
* A scene is the place where objects are placed, it contains the 3D environment.
*/
public class Scene3D extends SceneObject3D
{
	// ___________________________________________________________________ N E W
	//
	// NN  NN EEEEEE WW    WW
	// NNN NN EE     WW WW WW
	// NNNNNN EEEE   WWWWWWWW
	// NN NNN EE     WWW  WWW
	// NN  NN EEEEEE WW    WW

	/**
	* The Scene3D class lets you create a scene where all objects are rendered in the same container.
	*
	* @param	container	The Sprite that you draw into when rendering.
	*
	*/
	public function Scene3D( container:Sprite )
	{
		super( container );
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
		// Clear scene container
		this.container.graphics.clear();

		var p       :DisplayObject3D;
		var objects :Array  = this.objects;
		var i       :Number = objects.length;

		while( p = objects[--i] )
			if( p.visible )
				p.render( this );

		// Update stats
		var stats:Object  = this.stats;
		stats.performance = getTimer() - stats.performance;
	}
}
}