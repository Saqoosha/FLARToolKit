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
//                                                GeometryObject3D: Sphere
package org.papervision3d.objects
{
import org.papervision3d.core.*;
import org.papervision3d.core.proto.*;
import org.papervision3d.core.geom.*;

import flash.display.BitmapData;

/**
* The Sphere class lets you create and display spheres.
* <p/>
* The sphere is divided in vertical and horizontal segment, the smallest combination is two vertical and three horizontal segments.
*/
public class Sphere extends Mesh3D
{
	/**
	* Number of segments horizontally. Defaults to 8.
	*/
	public var segmentsW :Number;

	/**
	* Number of segments vertically. Defaults to 6.
	*/
	public var segmentsH :Number;

	/**
	* Default radius of Sphere if not defined.
	*/
	static public var DEFAULT_RADIUS :Number = 100;

	/**
	* Default scale of Sphere texture if not defined.
	*/
	static public var DEFAULT_SCALE :Number = 1;

	/**
	* Default value of gridX if not defined.
	*/
	static public var DEFAULT_SEGMENTSW :Number = 8;

	/**
	* Default value of gridY if not defined.
	*/
	static public var DEFAULT_SEGMENTSH :Number = 6;

	/**
	* Minimum value of gridX.
	*/
	static public var MIN_SEGMENTSW :Number = 3;

	/**
	* Minimum value of gridY.
	*/
	static public var MIN_SEGMENTSH :Number = 2;


	// ___________________________________________________________________________________________________
	//                                                                                               N E W
	// NN  NN EEEEEE WW    WW
	// NNN NN EE     WW WW WW
	// NNNNNN EEEE   WWWWWWWW
	// NN NNN EE     WWW  WWW
	// NN  NN EEEEEE WW    WW

	/**
	* Create a new Sphere object.
	* <p/>
	* @param	material	A MaterialObject3D object that contains the material properties of the object.
	* <p/>
	* @param	radius		[optional] - Desired radius.
	* <p/>
	* @param	segmentsW	[optional] - Number of segments horizontally. Defaults to 8.
	* <p/>
	* @param	segmentsH	[optional] - Number of segments vertically. Defaults to 6.
	* <p/>
	* @param	initObject	[optional] - An object that contains user defined properties with which to populate the newly created GeometryObject3D.
	* <p/>
	* It includes x, y, z, rotationX, rotationY, rotationZ, scaleX, scaleY scaleZ and a user defined extra object.
	* <p/>
	* If extra is not an object, it is ignored. All properties of the extra field are copied into the new instance. The properties specified with extra are publicly available.
	*/
	public function Sphere( material:MaterialObject3D=null, radius:Number=100, segmentsW:int=8, segmentsH:int=6, initObject:Object=null )
	{
		super( material, new Array(), new Array(), null, initObject );

		this.segmentsW = Math.max( MIN_SEGMENTSW, segmentsW || DEFAULT_SEGMENTSW); // Defaults to 8
		this.segmentsH = Math.max( MIN_SEGMENTSH, segmentsH || DEFAULT_SEGMENTSH); // Defaults to 6
		if (radius==0) radius = DEFAULT_RADIUS; // Defaults to 100

		var scale :Number = DEFAULT_SCALE;

		buildSphere( radius );
	}

	private function buildSphere( fRadius:Number ):void
	{
		var i:Number, j:Number, k:Number;
		var iHor:Number = Math.max(3,this.segmentsW);
		var iVer:Number = Math.max(2,this.segmentsH);
		var aVertice:Array = this.geometry.vertices;
		var aFace:Array = this.geometry.faces;
		var aVtc:Array = new Array();
		for (j=0;j<(iVer+1);j++) { // vertical
			var fRad1:Number = Number(j/iVer);
			var fZ:Number = -fRadius*Math.cos(fRad1*Math.PI);
			var fRds:Number = fRadius*Math.sin(fRad1*Math.PI);
			var aRow:Array = new Array();
			var oVtx:Vertex3D;
			for (i=0;i<iHor;i++) { // horizontal
				var fRad2:Number = Number(2*i/iHor);
				var fX:Number = fRds*Math.sin(fRad2*Math.PI);
				var fY:Number = fRds*Math.cos(fRad2*Math.PI);
				if (!((j==0||j==iVer)&&i>0)) { // top||bottom = 1 vertex
					oVtx = new Vertex3D(fY,fZ,fX);
					aVertice.push(oVtx);
				}
				aRow.push(oVtx);
			}
			aVtc.push(aRow);
		}
		var iVerNum:int = aVtc.length;
		for (j=0;j<iVerNum;j++) {
			var iHorNum:int = aVtc[j].length;
			if (j>0) { // &&i>=0
				for (i=0;i<iHorNum;i++) {
					// select vertices
					var bEnd:Boolean = i==(iHorNum-0);
					var aP1:Vertex3D = aVtc[j][bEnd?0:i];
					var aP2:Vertex3D = aVtc[j][(i==0?iHorNum:i)-1];
					var aP3:Vertex3D = aVtc[j-1][(i==0?iHorNum:i)-1];
					var aP4:Vertex3D = aVtc[j-1][bEnd?0:i];
					// uv
					var fJ0:Number = j		/ iVerNum;
					var fJ1:Number = (j-1)	/ iVerNum;
					var fI0:Number = (i+1)	/ iHorNum;
					var fI1:Number = i		/ iHorNum;
					var aP4uv:NumberUV = new NumberUV(fI0,fJ1);
					var aP1uv:NumberUV = new NumberUV(fI0,fJ0);
					var aP2uv:NumberUV = new NumberUV(fI1,fJ0);
					var aP3uv:NumberUV = new NumberUV(fI1,fJ1);
					// 2 faces
					if (j<(aVtc.length-1))	aFace.push( new Face3D(new Array(aP1,aP2,aP3), null, new Array(aP1uv,aP2uv,aP3uv)) );
					if (j>1)				aFace.push( new Face3D(new Array(aP1,aP3,aP4), null, new Array(aP1uv,aP3uv,aP4uv)) );

				}
			}
		}
		this.geometry.ready = true;
	}
}
}