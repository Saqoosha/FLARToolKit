/*
 *  PAPER    ON   ERVIS  NPAPER ISION  PE  IS ON  PERVI IO  APER  SI  PA
 *  AP  VI  ONPA  RV  IO PA     SI  PA ER  SI NP PE     ON AP  VI ION AP
 *  PERVI  ON  PE VISIO  APER   IONPA  RV  IO PA  RVIS  NP PE  IS ONPAPE
 *  ER     NPAPER IS     PE     ON  PE  ISIO  AP     IO PA ER  SI NP PER
 *  RV     PA  RV SI     ERVISI NP  ER   IO   PE VISIO  AP  VISI  PA  RV3D
 *  ______________________________________________________________________
 *  papervision3d.org � blog.papervision3d.org � osflash.org/papervision3d
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
//                                              DisplayObject3D: Camera3D

package org.papervision3d.core.proto
{
import org.papervision3d.Papervision3D;
import org.papervision3d.core.Number3D;
import org.papervision3d.core.Matrix3D;
import org.papervision3d.objects.DisplayObject3D;

/**
* The CameraObject3D class is the base class for all the cameras that can be placed in a scene.
* <p/>
* A camera defines the view from which a scene will be rendered. Different camera settings would present a scene from different points of view.
* <p/>
* 3D cameras simulate still-image, motion picture, or video cameras of the real world. When rendering, the scene is drawn as if you were looking through the camera lens.
*/
public class CameraObject3D extends DisplayObject3D
{
	// __________________________________________________________________________
	//                                                                     PUBLIC

	/**
	* This value specifies the scale at which the 3D objects are rendered. Higher values magnify the scene, compressing distance. Use it in conjunction with focus.
	*/
	public var zoom :Number;


	/**
	* This value is a positive number representing the distance of the observer from the front clipping plane, which is the closest any object can be to the camera. Use it in conjunction with zoom.
	* <p/>
	* Higher focus values tend to magnify distance between objects while allowing greater depth of field, as if the camera had a wider lenses. One result of using a wide angle lens in proximity to the subject is an apparent perspective distortion: parallel lines may appear to converge and with a fisheye lens, straight edges will appear to bend.
	* <p/>
	* Different lenses generally require a different camera to subject distance to preserve the size of a subject. Changing the angle of view can indirectly distort perspective, modifying the apparent relative size of the subject and foreground.
	*/
	public var focus :Number;


	/**
	* A Boolean value that determines whether the 3D objects are z-depth sorted between themselves when rendering.
	*/
	public var sort :Boolean;


	/**
	* The default position for new cameras.
	*/
	public static var DEFAULT_POS :Number3D = new Number3D( 0, 0, -1000 );


	// __________________________________________________________________________
	//                                                                      N E W
	// NN  NN EEEEEE WW    WW
	// NNN NN EE     WW WW WW
	// NNNNNN EEEE   WWWWWWWW
	// NN NNN EE     WWW  WWW
	// NN  NN EEEEEE WW    WW

	/**
	* The CameraObject3D constructor lets you create cameras for setting up the view from which a scene will be rendered.
	*
	* Its initial position can be specified in the initObject.
	*
	* @param	zoom		This value specifies the scale at which the 3D objects are rendered. Higher values magnify the scene, compressing distance. Use it in conjunction with focus.
	* <p/>
	* @param	focus		This value is a positive number representing the distance of the observer from the front clipping plane, which is the closest any object can be to the camera. Use it in conjunction with zoom.
	* <p/>
	* @param	initObject	An optional object that contains user defined properties with which to populate the newly created DisplayObject3D.
	* <p/>
	* It includes x, y, z, rotationX, rotationY, rotationZ, scaleX, scaleY scaleZ and a user defined extra object.
	* <p/>
	* If extra is not an object, it is ignored. All properties of the extra field are copied into the new instance. The properties specified with extra are publicly available.
	* <p/>
	* The following initObject property is also recognized by the constructor:
	* <ul>
	* <li><b>sort</b>: A Boolean value that determines whether the 3D objects are z-depth sorted between themselves when rendering. The default value is true.</li>
	* </ul>
	*/
	public function CameraObject3D( zoom:Number=3, focus:Number=500, initObject:Object=null )
	{
		super();

		this.x = initObject? initObject.x || DEFAULT_POS.x : DEFAULT_POS.x;
		this.y = initObject? initObject.y || DEFAULT_POS.y : DEFAULT_POS.y;
		this.z = initObject? initObject.z || DEFAULT_POS.z : DEFAULT_POS.z;

		this.zoom  = zoom;
		this.focus = focus;

		this.sort = initObject? (initObject.sort != false) : true;
	}


	// ___________________________________________________________________________________________________
	//                                                                                   T R A N S F O R M
	// TTTTTT RRRRR    AA   NN  NN  SSSSS FFFFFF OOOO  RRRRR  MM   MM
	//   TT   RR  RR  AAAA  NNN NN SS     FF    OO  OO RR  RR MMM MMM
	//   TT   RRRRR  AA  AA NNNNNN  SSSS  FFFF  OO  OO RRRRR  MMMMMMM
	//   TT   RR  RR AAAAAA NN NNN     SS FF    OO  OO RR  RR MM M MM
	//   TT   RR  RR AA  AA NN  NN SSSSS  FF     OOOO  RR  RR MM   MM

	/**
	* [internal-use] Transforms world coordinates into camera space.
	*/
	// TODO: OPTIMIZE (LOW) Resolve + inline
	public function transformView( transform:Matrix3D=null ):void
	{
		this.view = Matrix3D.inverse( Matrix3D.multiply( transform || this.transform, _flipY ) );
	}

	static private var _flipY :Matrix3D = Matrix3D.scaleMatrix( 1, -1, 1 );


	/**
	* Rotate the camera in its vertical plane.
	* <p/>
	* Tilting the camera results in a motion similar to someone nodding their head "yes".
	*
	* @param	angle	Angle to tilt the camera.
	*/
	public function tilt( angle:Number ):void
	{
		super.pitch( angle );
	}

	/**
	* Rotate the camera in its horizontal plane.
	* <p/>
	* Panning the camera results in a motion similar to someone shaking their head "no".
	*
	* @param	angle	Angle to pan the camera.
	*/
	public function pan( angle:Number ):void
	{
		super.yaw( angle );
	}
}
}