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

// _______________________________________________________________________ LayerScene3D

package org.papervision3d.scenes
{
import flash.utils.getTimer;
import flash.display.*;

import org.papervision3d.Papervision3D;
import org.papervision3d.scenes.*;
import org.papervision3d.core.proto.*;

import org.papervision3d.objects.DisplayObject3D;
import flash.utils.Dictionary;

/**
* The LayerScene3D class lets you create a scene where each object is rendered in its own container.
* <p/>
* A scene is the place where objects are placed, it contains the 3D environment.
*/

public class LayerScene3D extends Scene3D
{
	public var totalLayers :Number = 32;

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
	public function LayerScene3D( container:Sprite )
	{
		super( container );

		containerList = new Array();

		currentLayer = createLayer( 0 );
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

		child.container = currentLayer;

		return child;
	}
	
	
	// ___________________________________________________________________ A D D C H I L D
	//
	//   AA   DDDDD  DDDDD   CCCC  HH  HH II LL     DDDDD
	//  AAAA  DD  DD DD  DD CC  CC HH  HH II LL     DD  DD
	// AA  AA DD  DD DD  DD CC     HHHHHH II LL     DD  DD
	// AAAAAA DD  DD DD  DD CC  CC HH  HH II LL     DD  DD
	// AA  AA DDDDD  DDDDD   CCCC  HH  HH II LLLLLL DDDDD

	/**
	* Adds a child DisplayObject3D instance to a layer in the scene.
	*
	* [TODO: If you add a child object that already has a different display object container as a parent, the object is removed from the child list of the other display object container.]
	*
	* @param	child	The GeometryObject3D symbol or DisplayObject3D instance to add as a child of the scene.
	* @param	layer	The layer to add to.
	* @param	name	An optional name of the child to add or create. If no name is provided, the child name will be used.
	* @return	The DisplayObject3D instance that you have added or created.
	*/
	public function addChildAt( child :DisplayObject3D, layer :int, name :String=null ):DisplayObject3D
	{
		child = super.addChild( child, name );

		var childContainer :Sprite = layerContainer( layer );

		if( childContainer )
		{
			child.container = childContainer;
		}
		else
			child.container = currentLayer;
		
		return child;
	}


	public function selectLayer( layer:int ):void
	{
		var selectContainer :Sprite = layerContainer( layer );
		
		if( selectContainer )
			currentLayer = selectContainer;
	}

	
	
	private function layerContainer( layer:int ):Sprite
	{
		var layerSprite:Sprite = getLayerSprite( layer );

		if( ! layerSprite )
		{
			layerSprite = createLayer( layer );
		}

		return layerSprite;
	}


	private function createLayer( layer:int ):Sprite
	{
		if( layer < totalLayers )
		{
			for( var i:int = container.numChildren; i <= layer; i++ )
			{
				var layerSprite:Sprite = new Sprite();

				layerSprite.name = "Layer"+i;
				container.addChildAt( layerSprite, i );
				containerList[ i ] = layerSprite;
			}
			return layerSprite;
		}
		else
		{
			Papervision3D.log( "SceneLayer3D - ERROR: Layer " + layer + " is not allowed as it's greater than totalLayers. Use a lower layer number or change totalLayers if really needed." );

			return null;
		}
	}


	public function getLayerSprite( layer:int ):Sprite
	{
		return containerList[ layer ];
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
		var gfx           :Sprite;
		var i             :Number = 0;

		// Clear all known object
		while( gfx = containerList[i++] ) gfx.graphics.clear();

		// Render
		var p       :DisplayObject3D;
		var objects :Array  = this.objects;
		i = objects.length;

		while( p = objects[--i] )
		{
			if( p.visible )
			{
				p.render( this );
			}
		}

		// Update stats
		var stats:Object  = this.stats;
		stats.performance = getTimer() - stats.performance;
	}

	private var containerList :Array;
	private var currentLayer  :Sprite;
}
}