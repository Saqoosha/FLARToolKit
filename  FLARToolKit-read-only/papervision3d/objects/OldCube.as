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
public class OldCube extends Mesh3D
{
	/**
	* Number of segments sagitally. Defaults to 1.
	*/
	public var segmentsS :Number;

	/**
	* Number of segments transversally. Defaults to 1.
	*/
	public var segmentsT :Number;

	/**
	* Number of segments horizontally. Defaults to 1.
	*/
	public var segmentsH :Number;

	/**
	* Default size of Cube if not texture is defined.
	*/
	static public var DEFAULT_SIZE :Number = 500;

	/**
	* Default size of Cube if not texture is defined.
	*/
	static public var DEFAULT_SCALE :Number = 1;

	/**
	* Default value of gridX if not defined. The default value of gridY is gridX.
	*/
	static public var DEFAULT_SEGMENTS :Number = 1;


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
	* @param	material	A MaterialObject3D object that contains the material properties of the object.
	* <p/>
	* @param	width		[optional] - Desired width or scaling factor if there's bitmap texture in material and no height is supplied.
	* <p/>
	* @param	depth		[optional] - Desired depth.
	* <p/>
	* @param	height		[optional] - Desired height.
	* <p/>
	* @param	segmentsS	[optional] - Number of segments sagitally (plane perpendicular to width). Defaults to 1.
	* <p/>
	* @param	segmentsT	[optional] - Number of segments transversally (plane perpendicular to depth). Defaults to segmentsS.
	* <p/>
	* @param	segmentsH	[optional] - Number of segments horizontally (plane perpendicular to height). Defaults to segmentsS.
	* <p/>
	* @param	initObject	[optional] - An object that contains user defined properties with which to populate the newly created GeometryObject3D.
	* <p/>
	* It includes x, y, z, rotationX, rotationY, rotationZ, scaleX, scaleY scaleZ and a user defined extra object.
	* <p/>
	* If extra is not an object, it is ignored. All properties of the extra field are copied into the new instance. The properties specified with extra are publicly available.
	* 
	* This object has been deprecated in favour of the new Cube.
	*/
	public function OldCube( material:MaterialObject3D=null, width:Number=500, depth:Number=500, height:Number=500, segmentsS:Number=1, segmentsT:Number=1, segmentsH:Number=1, initObject:Object=null )
	{
		super( material, new Array(), new Array(), null, initObject );

		this.segmentsS = segmentsS;//!=null?segmentsW:DEFAULT_SEGMENTS; // Defaults to 1
		this.segmentsT = segmentsT;//!=null?segmentsH:this.segmentsW;   // Defaults to segmentsW
		this.segmentsH = segmentsH;//!=null?segmentsT:this.segmentsW;   // Defaults to segmentsW

		var scale :Number = DEFAULT_SCALE;

		if( ! height ) {
			if( width ) scale = width;
			if( material && material.bitmap ) {
				width  = material.bitmap.width  * scale;
				height = material.bitmap.height * scale;
			} else {
				width  = DEFAULT_SIZE * scale;
				height = DEFAULT_SIZE * scale;
			}
		}
		if( ! depth ) {
			if( width ) scale = width;
			//if( material && material.bitmap ) {
			//	width  = material.bitmap.width  * scale;
			//	depth =  material.bitmap.depth * scale;
			//} else {
				width  = DEFAULT_SIZE * scale;
				depth = DEFAULT_SIZE * scale;
			//}
		}

		buildCube( width, height, depth );
	}

	private function buildCube( fWidth:Number, fHeight:Number, fDepth:Number ):void {
		var i:Number;
		var j:Number;
		var k:Number;
		var iSag:Number = Math.max(1,this.segmentsS); // sagittal
		var iTrv:Number = Math.max(1,this.segmentsT); // transversal
		var iHor:Number = Math.max(1,this.segmentsH); // horizontal
		var aVertice :Array  = this.geometry.vertices;
		var aFace    :Array  = this.geometry.faces;
		// vertices
		var aTopBottom:Array = new Array(new Array(),new Array());
		var aVtc:Array = new Array();

		var fZ:Number, fX:Number, fY:Number, oVtx:Vertex3D, iJsbs:int, aPlane:Array;

		for (i=0;i<(iHor+1);i++) {
			fZ = -fHeight/2 + fHeight*(i/iHor);
			var aLyr:Array = new Array();
			var iJ:int, iJrel:int;
			for (j=0;j<2*(iTrv+iSag);j++) {
				if (j<iSag) {					// side 1
					fX = -fWidth/2 + j*(fWidth/iSag);
					fY = -fDepth/2;
				} else if (j<(iTrv+iSag)) {		// side 2
					iJ = j-iSag;		//
					fX = fWidth/2;
					fY = -fDepth/2 + iJ*(fDepth/iTrv);
				} else if (j<(iTrv+2*iSag)) {	// side 3
					iJ = j-iTrv-iSag;
					fX = fWidth/2 - iJ*(fWidth/iSag);
					fY = fDepth/2;
				} else {						// side 4
					iJ = j-iTrv-2*iSag;	//
					fX = -fWidth/2;
					fY = fDepth/2 - iJ*(fDepth/iTrv);
				}
				oVtx = new Vertex3D( fY, fZ, fX );
				aLyr.push(oVtx);
				aVertice.push(oVtx);
				// if top or bottom
				if (i==0||i==iHor) {
					var iTopBot:int = i==0?0:1;
					if (j<iSag) {										// side 1
						aTopBottom[iTopBot][j] = oVtx; // "top"+j; //
					} else if (j<(iTrv+iSag)) {							// side 2
						iJ = j-iSag;
						iJrel = iSag + (iSag+1)*iJ;
						aTopBottom[iTopBot][iJrel] = oVtx; // "right"+iJ; //
					} else if (j<(iTrv+2*iSag)) {						// side 3
						iJ = j-iTrv-iSag;
						iJrel = (iSag+1)*(iTrv) + 1 + (iSag-1) - iJ;
						aTopBottom[iTopBot][iJrel] = oVtx; // "bot"+iJ; //
					} else {											// side 4
						iJ = j-iTrv-2*iSag;
						iJrel = (iSag+1)*(iTrv-iJ);
						aTopBottom[iTopBot][iJrel] = oVtx; // "left"+iJ; //
					}
				}
			}
			aVtc.push(aLyr);
		}
		// top and bottom
		var iTBnum:int = (iTrv+1)*(iSag+1) - 2*iTrv - 2*iSag;
		for (i=0;i<2;i++) {
			aPlane = new Array();
			fZ = (i==0?1:-1)*fHeight/2;
			for (j=0;j<iTBnum;j++) {
				var iXps:int = j%(iSag-1);
				var iYps:int = Math.floor(j/(iSag-1));
				fX = -fWidth/2 + (iXps+1)*(fWidth/iSag);
				fY = -fDepth/2 + (iYps+1)*(fDepth/iTrv);
				oVtx = new Vertex3D( fY, fZ, fX );
				aVertice.push(oVtx);
				aTopBottom[1-i][(iSag+1)*(iYps+1)+(iXps+1)] = oVtx;
			}
		}
		//
		// faces
		var aP1:Vertex3D, aP2:Vertex3D, aP3:Vertex3D, aP4:Vertex3D;
		var aP4uv:NumberUV, aP1uv:NumberUV, aP2uv:NumberUV, aP3uv:NumberUV;

		var iVerNum:int = aVtc.length;
		for (i=0;i<iVerNum;i++) {
			var iHorNum:int = aVtc[i].length;
			if (i>0) {
				for (j=0;j<iHorNum;j++) {
					// select vertices
					aP1 = aVtc[i][j];
					aP2 = aVtc[i][(j==0?iHorNum:j)-1];
					aP3 = aVtc[i-1][(j==0?iHorNum:j)-1];
					aP4 = aVtc[i-1][j];
					// uv
					var iTrSg:int; // transversal or sagital
					var jj:Number = (j-1+iHorNum)%iHorNum;
					if (jj<iSag) {						// side 1
						iJsbs = jj;
						iTrSg = iSag;
					} else if (jj<(iTrv+iSag)) {		// side 2
						iJsbs = jj-iSag;
						iTrSg = iTrv;
					} else if (jj<(iTrv+2*iSag))	{	// side 3
						iJsbs = jj-iTrv-iSag;
						iTrSg = iSag;
					} else {							// side 4
						iJsbs = jj-iTrv-2*iSag;
						iTrSg = iTrv;
					}
					var fI0:Number = (i-1)/(iVerNum-1);
					var fI1:Number = (i+0)/(iVerNum-1);
					var fJ0:Number = (1-(iJsbs+1)*(1/iTrSg));
					var fJ1:Number = (1-(iJsbs+0)*(1/iTrSg));
					aP4uv = new NumberUV(fJ0,fI0);
					aP1uv = new NumberUV(fJ0,fI1);
					aP2uv = new NumberUV(fJ1,fI1);
					aP3uv = new NumberUV(fJ1,fI0);
					// 2 faces
					aFace.push( new Face3D(new Array(aP1,aP3,aP2), null, new Array(aP1uv,aP3uv,aP2uv)) );
					aFace.push( new Face3D(new Array(aP1,aP4,aP3), null, new Array(aP1uv,aP4uv,aP3uv)) );
				}
			}
		}
		// top and bottom
		for (i=0;i<aTopBottom.length;i++) {
			aPlane = new Array();
			var aLine:Array = new Array();
			// poor into double array for easier use
			for (j=0;j<aTopBottom[i].length;j++) {
				aLine.push(aTopBottom[i][j]);
				if (j%(iSag+1)==iSag) {
					aPlane.push(aLine.slice(0));
					aLine = new Array();
				}
			}
			for (j=1;j<aPlane.length;j++) {
				for (k=1;k<aPlane[j].length;k++) {
					// select vertices
					aP1 = aPlane[j][k];
					aP2 = aPlane[j][k-1];
					aP3 = aPlane[j-1][k-1];
					aP4 = aPlane[j-1][k];
					// 2 faces
					var bTop:Boolean = i==0;
					// uv
					aP1uv = new NumberUV( (bTop?1:0)+(bTop?-1:1)*((j+0)/iTrv) ,(k+0)/iSag );
					aP2uv = new NumberUV( (bTop?1:0)+(bTop?-1:1)*((j+0)/iTrv) ,(k-1)/iSag );
					aP3uv = new NumberUV( (bTop?1:0)+(bTop?-1:1)*((j-1)/iTrv) ,(k-1)/iSag );
					aP4uv = new NumberUV( (bTop?1:0)+(bTop?-1:1)*((j-1)/iTrv) ,(k+0)/iSag );
					if (i==0) {
						aFace.push( new Face3D(new Array(aP1,aP2,aP3), null, new Array(aP1uv,aP2uv,aP3uv)) );
						aFace.push( new Face3D(new Array(aP1,aP3,aP4), null, new Array(aP1uv,aP3uv,aP4uv)) );
					} else {
						aFace.push( new Face3D(new Array(aP1,aP3,aP2), null, new Array(aP1uv,aP3uv,aP2uv)) );
						aFace.push( new Face3D(new Array(aP1,aP4,aP3), null, new Array(aP1uv,aP4uv,aP3uv)) );
					}
				}
			}
		}
		this.geometry.ready = true;
	}
}
}