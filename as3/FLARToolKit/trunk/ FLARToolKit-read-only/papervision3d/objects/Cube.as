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
//                                                GeometryObject3D: Cube
package org.papervision3d.objects
{
import org.papervision3d.materials.MaterialsList;
import org.papervision3d.Papervision3D;
import org.papervision3d.core.*;
import org.papervision3d.core.proto.*;
import org.papervision3d.core.geom.*;

import flash.display.BitmapData;

/**
* The Cube class lets you create and display flat rectangle objects.
* <p/>
* The rectangle can be divided in smaller segments. This is usually done to reduce linear mapping artifacts.
* <p/>
* Dividing the Cube in the direction of the perspective or vanishing point, helps to reduce this problem. Perspective distortion dissapears when the Cube is facing straignt to the camera, i.e. it is perpendicular with the vanishing point of the scene.
*/
public class Cube extends Mesh3D
{
	/**
	* Number of segments per axis. Defaults to 1.
	*/
	public var segments :Number3D;

	/**
	* No faces selected.
	*/
	static public var NONE   :int = 0x00;

	/**
	* Front face selection
	*/
	static public var FRONT  :int = 0x01;

	/**
	* Back face selection
	*/
	static public var BACK   :int = 0x02;

	/**
	* Right face selection
	*/
	static public var RIGHT  :int = 0x04;

	/**
	* Left face selection
	*/
	static public var LEFT   :int = 0x08;

	/**
	* Top face selection
	*/
	static public var TOP    :int = 0x10;

	/**
	* Bottom face selection
	*/
	static public var BOTTOM :int = 0x20;

	/**
	* All faces selected.
	*/
	static public var ALL    :int = FRONT + BACK + RIGHT + LEFT + TOP + BOTTOM;

	// ___________________________________________________________________________________________________
	//                                                                                               N E W
	// NN  NN EEEEEE WW    WW
	// NNN NN EE     WW WW WW
	// NNNNNN EEEE   WWWWWWWW
	// NN NNN EE     WWW  WWW
	// NN  NN EEEEEE WW    WW

	/**
	* Create a new Cube object.
	* <p/>
	* @param	materials	A MaterialObject3D object that contains the material properties of the object.
	* 
	* Supported materials are: front, back, right, left, top, bottom & all, for example: 
	* 
	*	var materials:MaterialsList = new MaterialsList(
	*	{
	*		all:	new MovieAssetMaterial( "Front", true ), // This is the default material
	*		front:  new MovieAssetMaterial( "Front", true ),
	*		back:   new MovieAssetMaterial( "Back", true ),
	*		right:  new MovieAssetMaterial( "Right", true ),
	*		left:   new MovieAssetMaterial( "Left", true ),
	*		top:    new MovieAssetMaterial( "Top", true ),
	*		bottom: new MovieAssetMaterial( "Bottom", true )
	*	} );
	* 
	* <p/>
	* @param	width			[optional] - Desired width.
	* <p/>
	* @param	depth			[optional] - Desired depth.
	* <p/>
	* @param	height			[optional] - Desired height.
	* <p/>
	* @param	segmentsS		[optional] - Number of segments sagitally (plane perpendicular to width). Defaults to 1.
	* <p/>
	* @param	segmentsT		[optional] - Number of segments transversally (plane perpendicular to depth). Defaults to segmentsS.
	* <p/>
	* @param	segmentsH		[optional] - Number of segments horizontally (plane perpendicular to height). Defaults to segmentsS.
	* <p/>
	* @param	insideFaces		[optional] - Faces that are visible from the inside. Defaults to Cube.NONE.
	*
	* You can add or sustract faces to your selection. For examples: Cube.FRONT+Cube.BACK or Cube.ALL-Cube.Top.
	* 
	* <p/>
	* @param	excludeFaces	[optional] - Faces that will not be created. Defaults to Cube.NONE.
	* 
	* You can add or sustract faces to your selection. For examples: Cube.FRONT+Cube.BACK or Cube.ALL-Cube.Top.
	* 
	* <p/>
	* @param	initObject		[optional] - An object that contains user defined properties with which to populate the newly created GeometryObject3D.
	* <p/>
	* It includes x, y, z, rotationX, rotationY, rotationZ, scaleX, scaleY scaleZ and a user defined extra object.
	* <p/>
	* If extra is not an object, it is ignored. All properties of the extra field are copied into the new instance. The properties specified with extra are publicly available.
	*/
	public function Cube( materials:MaterialsList, width:Number=500, depth:Number=500, height:Number=500, segmentsS:int=1, segmentsT:int=1, segmentsH:int=1, insideFaces:int=0, excludeFaces:int=0, initObject:Object=null )
	{
		super( materials.getMaterialByName( "all" ), new Array(), new Array(), null, initObject );
		
		this.materials = materials;
		
		this.insideFaces  = insideFaces;
		this.excludeFaces = excludeFaces;

		segments = new Number3D( segmentsS, segmentsT, segmentsH );

		buildCube( width, height, depth );
	}

	private function buildCube( width:Number, height:Number, depth:Number ):void
	{
		var width2  :Number = width  /2;
		var height2 :Number = height /2;
		var depth2  :Number = depth  /2;
		
		if( ! (excludeFaces & FRONT) )
			buildPlane( "front", "x", "y", width, height, depth2, ! Boolean( insideFaces & FRONT ) );

		if( ! (excludeFaces & BACK) )
			buildPlane( "back", "x", "y", width, height, -depth2, Boolean( insideFaces & BACK ) );

		if( ! (excludeFaces & RIGHT) )
			buildPlane( "right", "z", "y", depth, height, width2, Boolean( insideFaces & RIGHT ) );

		if( ! (excludeFaces & LEFT) )
			buildPlane( "left", "z", "y", depth, height, -width2, ! Boolean( insideFaces & LEFT ) );

		if( ! (excludeFaces & TOP) )
			buildPlane( "top", "x", "z", width, depth, height2, Boolean( insideFaces & TOP ) );

		if( ! (excludeFaces & BOTTOM) )
			buildPlane( "bottom", "x", "z", width, depth, -height2, ! Boolean( insideFaces & BOTTOM ) );

		mergeVertices();

		this.geometry.ready = true;
	}

	private function buildPlane( mat:String, u:String, v:String, width:Number, height:Number, depth:Number, reverse:Boolean=false ):void
	{
		var matInstance:MaterialObject3D;
		if( ! (matInstance= materials.getMaterialByName( mat )))
		{
			if(!(matInstance=materials.getMaterialByName( "all" ))){
				Papervision3D.log( "Cube: Required material not found in given materials list. Supported materials are: front, back, right, left, top, bottom & all." );
				return;
			}
		}

		// Find w depth axis
		var w :String;
		if( (u=="x" && v=="y") || (u=="y" && v=="x") ) w = "z";
		else if( (u=="x" && v=="z") || (u=="z" && v=="x") ) w = "y";
		else if( (u=="z" && v=="y") || (u=="y" && v=="z") ) w = "x";

		// Mirror
		var rev :Number = reverse? -1 : 1;

		// Build plane
		var gridU    :Number = this.segments[ u ];
		var gridV    :Number = this.segments[ v ];
		var gridU1   :Number = gridU + 1;
		var gridV1   :Number = gridV + 1;

		var vertices   :Array = this.geometry.vertices;
		var faces      :Array = this.geometry.faces;
		var planeVerts :Array = new Array();

		var textureU :Number = width /2;
		var textureV :Number = height /2;

		var incU     :Number = width / gridU;
		var incV     :Number = height / gridV;

		// Vertices
		for( var iu:int = 0; iu < gridU1; iu++ )
		{
			for( var iv:int = 0; iv < gridV1; iv++ )
			{
				var vertex:Vertex3D = new Vertex3D();
				
				vertex[ u ] = (iu * incU - textureU) * rev;
				vertex[ v ] = iv * incV - textureV;
				vertex[ w ] = depth;

				vertices.push( vertex );
				planeVerts.push( vertex );
			}
		}

		// Faces
		var uvA :NumberUV;
		var uvC :NumberUV;
		var uvB :NumberUV;

		for(  iu = 0; iu < gridU; iu++ )
		{
			for(  iv= 0; iv < gridV; iv++ )
			{
				// Triangle A
				var a:Vertex3D = planeVerts[ iu     * gridV1 + iv     ];
				var c:Vertex3D = planeVerts[ iu     * gridV1 + (iv+1) ];
				var b:Vertex3D = planeVerts[ (iu+1) * gridV1 + iv     ];

				uvA =  new NumberUV( iu     / gridU, iv     / gridV );
				uvC =  new NumberUV( iu     / gridU, (iv+1) / gridV );
				uvB =  new NumberUV( (iu+1) / gridU, iv     / gridV );

				faces.push( new Face3D( [ a, b, c ], matInstance, [ uvA, uvB, uvC ] ) );

				// Triangle B
				a = planeVerts[ (iu+1) * gridV1 + (iv+1) ];
				c = planeVerts[ (iu+1) * gridV1 + iv     ];
				b = planeVerts[ iu     * gridV1 + (iv+1) ];

				uvA =  new NumberUV( (iu+1) / gridU, (iv+1) / gridV );
				uvC =  new NumberUV( (iu+1) / gridU, iv     / gridV );
				uvB =  new NumberUV( iu     / gridU, (iv+1) / gridV );

				faces.push( new Face3D( [ a, b, c ], matInstance, [ uvA, uvB, uvC ] ) );
			}
		}
	}
	private var insideFaces  :int;
	private var excludeFaces :int
	
}
}