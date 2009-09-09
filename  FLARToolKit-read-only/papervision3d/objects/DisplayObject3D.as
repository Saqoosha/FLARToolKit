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

// _______________________________________________________________________ DisplayObject3D

package org.papervision3d.objects
{
import com.blitzagency.xray.logger.XrayLog;

import flash.display.Sprite;
import flash.geom.Matrix;
import flash.utils.Dictionary;

import org.papervision3d.Papervision3D;
import org.papervision3d.core.Matrix3D;
import org.papervision3d.core.Number3D;
import org.papervision3d.core.geom.Face3DInstance;
import org.papervision3d.core.proto.CameraObject3D;
import org.papervision3d.core.proto.DisplayObjectContainer3D;
import org.papervision3d.core.proto.GeometryObject3D;
import org.papervision3d.core.proto.MaterialObject3D;
import org.papervision3d.core.proto.SceneObject3D;
import org.papervision3d.materials.MaterialsList;
import org.papervision3d.scenes.InteractiveScene3D;
import org.papervision3d.utils.InteractiveSceneManager;
import org.papervision3d.utils.InteractiveSprite;

/**
* The DisplayObject class represents instances of 3D objects that are contained in the scene.
* <p/>
* That includes all objects in the scene, not only those that can be rendered, but also the camera and its target.
* <p/>
* The DisplayObject3D class supports basic functionality like the x, y and z position of an object, as well as rotationX, rotationY, rotationZ, scaleX, scaleY and scaleZ and visible. It also supports more advanced properties of the object such as its transform Matrix3D.
* <p/>
* <p/>
* DisplayObject3D is not an abstract base class; therefore, you can call DisplayObject3D directly. Invoking new DisplayObject() creates a new empty object in 3D space, like when you used createEmptyMovieClip().
*
*/
public class DisplayObject3D extends DisplayObjectContainer3D
{
	// ___________________________________________________________________ P O S I T I O N

	/**
	* An Number that sets the X coordinate of a object relative to the origin of its parent.
	*/
	public function get x():Number
	{
		return this.transform.n14;
	}

	public function set x( value:Number ):void
	{
		this.transform.n14 = value;
	}


	/**
	* An Number that sets the Y coordinate of a object relative to the origin of its parent.
	*/
	public function get y():Number
	{
		return this.transform.n24;
	}

	public function set y( value:Number ):void
	{
		this.transform.n24 = value;
	}


	/**
	* An Number that sets the Z coordinate of a object relative to the origin of its parent.
	*/
	public function get z():Number
	{
		return this.transform.n34;
	}

	public function set z( value:Number ):void
	{
		this.transform.n34 = value;
	}


	// ___________________________________________________________________ R O T A T I O N

	/**
	* Specifies the rotation around the X axis from its original orientation.
	*/
	public function get rotationX():Number
	{
		if( this._rotationDirty ) updateRotation();

		return Papervision3D.useDEGREES? -this._rotationX * toDEGREES : -this._rotationX;
	}

	public function set rotationX( rot:Number ):void
	{
		this._rotationX = Papervision3D.useDEGREES? -rot * toRADIANS : -rot;
		this._transformDirty = true;
	}


	/**
	* Specifies the rotation around the Y axis from its original orientation.
	*/
	public function get rotationY():Number
	{
		if( this._rotationDirty ) updateRotation();

		return Papervision3D.useDEGREES? -this._rotationY * toDEGREES : -this._rotationY;
	}

	public function set rotationY( rot:Number ):void
	{
		this._rotationY = Papervision3D.useDEGREES? -rot * toRADIANS : -rot;
		this._transformDirty = true;
	}


	/**
	* Specifies the rotation around the Z axis from its original orientation.
	*/
	public function get rotationZ():Number
	{
		if( this._rotationDirty ) updateRotation();

		return Papervision3D.useDEGREES? -this._rotationZ * toDEGREES : -this._rotationZ;
	}

	public function set rotationZ( rot:Number ):void
	{
		this._rotationZ = Papervision3D.useDEGREES? -rot * toRADIANS : -rot;
		this._transformDirty = true;
	}


	// Update rotation values
	private function updateRotation():void
	{
		var rot:Number3D = Matrix3D.matrix2euler( this.transform );
		this._rotationX = rot.x * toRADIANS;
		this._rotationY = rot.y * toRADIANS;
		this._rotationZ = rot.z * toRADIANS;

		this._rotationDirty = false;
	}

	// ___________________________________________________________________ S C A L E

	/**
	* Sets the 3D scale as applied from the registration point of the object.
	*/
	public function get scale():Number
	{
		if( this._scaleX == this._scaleY && this._scaleX == this._scaleZ )
			if( Papervision3D.usePERCENT ) return this._scaleX * 100;
			else return this._scaleX;
		else return NaN;
	}

	public function set scale( scale:Number ):void
	{
		if( Papervision3D.usePERCENT ) scale /= 100;

		this._scaleX = this._scaleY = this._scaleZ = scale;

		this._transformDirty = true;
	}


	/**
	* Sets the scale along the local X axis as applied from the registration point of the object.
	*/
	public function get scaleX():Number
	{
		if( Papervision3D.usePERCENT ) return this._scaleX * 100;
		else return this._scaleX;
	}

	public function set scaleX( scale:Number ):void
	{
		if( Papervision3D.usePERCENT ) this._scaleX = scale / 100;
		else this._scaleX = scale;

		this._transformDirty = true;
	}

	/**
	* Sets the scale along the local Y axis as applied from the registration point of the object.
	*/
	public function get scaleY():Number
	{
		if( Papervision3D.usePERCENT ) return this._scaleY * 100;
		else return this._scaleY;
	}

	public function set scaleY( scale:Number ):void
	{
		if( Papervision3D.usePERCENT ) this._scaleY = scale / 100;
		else this._scaleY = scale;

		this._transformDirty = true;
	}

	/**
	* Sets the scale along the local Z axis as applied from the registration point of the object.
	*/
	public function get scaleZ():Number
	{
		if( Papervision3D.usePERCENT ) return this._scaleZ * 100;
		else return this._scaleZ;
	}

	public function set scaleZ( scale:Number ):void
	{
		if( Papervision3D.usePERCENT ) this._scaleZ = scale / 100;
		else this._scaleZ = scale;

		this._transformDirty = true;
	}

	
	// ___________________________________________________________________ W O R L D

	/**
	* The X coordinate of a object relative to the scene coordinate system.
	*/
	public function get sceneX():Number
	{
		return this.world.n14;
	}

	/**
	* The Y coordinate of a object relative to the scene coordinate system.
	*/
	public function get sceneY():Number
	{
		return this.world.n24;
	}

	/**
	* The Z coordinate of a object relative to the scene coordinate system.
	*/
	public function get sceneZ():Number
	{
		return this.world.n34;
	}

	// ___________________________________________________________________ S C R E E N

	/**
	* [read-only] The coordinate of the object on screen.
	*/
	public var screen :Number3D = new Number3D();

	// ___________________________________________________________________ P R O P E R T I E S

	/**
	* Whether or not the display object is visible.
	* <p/>
	* A Boolean value that indicates whether the object is projected, transformed and rendered. A value of false will effectively ignore the object. The default value is true.
	*/
	public var visible :Boolean;


	/**
	* An optional object name.
	*/
	public var name :String;

	/**
	* [read-only] Unique id of this instance.
	*/
	public var id :int;


	/**
	* An object that contains user defined properties.
	* <p/>
	* All properties of the extra field are copied into the new instance. The properties specified with extra are publicly available.
	*/
	public var extra :Object // = {}; TBD

	/**
	* The Sprite that you draw into when rendering in a MovieScene3D.
	*
	* While Scene3D uses a single Sprite container for all the objects, MovieScene3D renders each object in its own unique Sprite.
	*
	* You can use the container like any other Sprite. For example, you can add events to it, apply filters or change the blend mode.
	*/
	public var container   :Sprite;


	/**
	* The default material for the object instance. Materials collect data about how objects appear when rendered.
	*/
	public var material    :MaterialObject3D;

	/**
	* The list of materials for this instance.
	*/
	public var materials   :MaterialsList;


	/**
	* If an InteractiveScene3D is used, this will DisplayObject3D will be registered with the InteractiveSceneManager
	*/	
	public var interactiveSceneManager:InteractiveSceneManager;

	/**
	* The scene where the object belongs.
	*/
	protected var _scene :SceneObject3D = null;
	
	public function set scene(p_scene:SceneObject3D):void
	{
		// set scene property
		_scene = p_scene;
		
		for each( var child:DisplayObject3D in this._childrenByName )
		{
			if(child.scene == null) child.scene = _scene;
		}
		
		// if this is NOT an interactiveScene3D, just return
		if(_scene is InteractiveScene3D == false) return;
		
		// if we have an InteractiveScene3D, register this and the children to add them to the InteractiveSceneManager
		interactiveSceneManager = InteractiveScene3D(_scene).interactiveSceneManager;
	}
	
	public function get scene():SceneObject3D { return _scene; }

	/**
	* [read-only] Indicates the DisplayObjectContainer3D object that contains this display object.
	*/
	public var parent :DisplayObjectContainer3D;
	
	/**
	* tells Mesh3D's render() method to sort by measuring from the center of a triangle
	*/	
	public static const MESH_SORT_CENTER:uint = 1;
	
	/**
	* tells Mesh3D's render() method to sort by measuring from the farthest point of a triangle
	*/	
	public static const MESH_SORT_FAR:uint = 2;
	
	/**
	* tells Mesh3D's render() method to sort by measuring from the closest point of a triangle
	*/	
	public static const MESH_SORT_CLOSE:uint = 3;
	
	/**
	* tells Mesh3D's render() method to compare the measurement choice of the user for a triangle's sorting
	*/	
	public var meshSort:uint = MESH_SORT_CENTER;
	
	/**
	* Returns an empty DiplayObject3D object positioned in the center of the 3D coordinate system (0, 0 ,0).
	*/
	static public function get ZERO():DisplayObject3D
	{
		return new DisplayObject3D();
	}


	/**
	* Relative directions.
	*/
	static private var FORWARD  :Number3D = new Number3D(  0,  0,  1 );
	static private var BACKWARD :Number3D = new Number3D(  0,  0, -1 );
	static private var LEFT     :Number3D = new Number3D( -1,  0,  0 );
	static private var RIGHT    :Number3D = new Number3D(  1,  0,  0 );
	static private var UP       :Number3D = new Number3D(  0,  1,  0 );
	static private var DOWN     :Number3D = new Number3D(  0, -1,  0 );

	/**
	* A Matrix3D object containing values that affect the scaling, rotation, and translation of the display object.
	*/
	public var transform :Matrix3D;

	/**
	* [internal-use] A camera transformed Matrix3D object.
	*/
	public var view      :Matrix3D;

	/**
	* World transformation.
	*/
	public var world     :Matrix3D;

	/**
	* [internal-use]
	*/
	public var faces     :Array = new Array();

	/**
	 * This allows objects faces to have their own containers.
	 */
	public static var faceLevelMode  :Boolean;
	
	/**
	* The GeometryObject3D object that contains the 3D definition of this instance.
	* <p/>
	* When different objects share the same geometry, they become instances. They are the same object, displayed multiple times. Changing the shape of this object changes the shape of all of its instances.
	* <p/>
	* Instancing an object saves system memory, and is useful to display an object multiple times while maintaining its shape.
	* <p/>
	* For example, you could create armies and forests full of duplicate objects without needing the memory to handle that much actual geometry. Each instance has its own transform node so it can have its own position, rotation, and scaling.
	*/
	public var geometry :GeometryObject3D;

	/**
	* [internal-use] The average depth of the object faces center. Used internally for z-sorting.
	*/
	public var screenZ :Number;

	// ___________________________________________________________________________________________________
	//                                                                                               N E W
	// NN  NN EEEEEE WW    WW
	// NNN NN EE     WW WW WW
	// NNNNNN EEEE   WWWWWWWW
	// NN NNN EE     WWW  WWW
	// NN  NN EEEEEE WW    WW

	/**
	* Creates a new DisplayObject3D instance. After creating the instance, call the addChild() method of a DisplayObjectContainer3D.
	*
	* @param	name		[optional] - The name of the newly created object.
	* @param	geometry	[optional] - The geometry of the newly created object.
	* @param	initObject	[optional] - An object that contains user defined properties with which to populate the newly created DisplayObject3D.
	*
	* <ul>
	* <li><b>x</b></b>: An Number that sets the X coordinate of a object relative to the scene coordinate system.</li>
	* <p/>
	* <li><b>y</b>: An Number that sets the Y coordinate of a object relative to the scene coordinate system.</li>
	* <p/>
	* <li><b>z</b>: An Number that sets the Z coordinate of a object relative to the scene coordinate system.</li>
	* <p/>
	* <li><b>rotationX</b>: Specifies the rotation around the X axis from its original orientation.</li>
	* <p/>
	* <li><b>rotationY</b>: Specifies the rotation around the Y axis from its original orientation.</li>
	* <p/>
	* <li><b>rotationZ</b>: Specifies the rotation around the Z axis from its original orientation.</li>
	* <p/>
	* <li><b>scaleX</b>: Sets the scale along the local X axis as applied from the registration point of the object.</li>
	* <p/>
	* <li><b>scaleY</b>: Sets the scale along the local Y axis as applied from the registration point of the object.</li>
	* <p/>
	* <li><b>scaleZ</b>: Sets the scale along the local Z axis as applied from the registration point of the object.</li>
	* <p/>
	* <li><b>visible</b>: Whether or not the display object is visible.
	* <p/>
	* A Boolean value that indicates whether the object is projected, transformed and rendered. A value of false will effectively ignore the object. The default value is true.</li>
	* <p/>
	* <li><b>container</b>: The MovieClip that you draw into when rendering. Use only when the object is rendered in its own unique MovieClip.
	* <p/>
	* It's Boolean value determines whether the container MovieClip should be cleared before rendering.</li>
	* <p/>
	* <li><b>extra</b>: An object that contains user defined properties.
	* <p/>
	* All properties of the extra field are copied into the new instance. The properties specified with extra are publicly available.</li>
	* </ul>
	*/
	public function DisplayObject3D( name:String=null, geometry:GeometryObject3D=null, initObject:Object=null ):void
	{
		super();

		Papervision3D.log( "DisplayObject3D: " + name );

		this.transform = Matrix3D.IDENTITY;
		this.world     = Matrix3D.IDENTITY;
		this.view      = Matrix3D.IDENTITY;

		// TODO if( initObject )...
		this.x = initObject? initObject.x || 0 : 0;
		this.y = initObject? initObject.y || 0 : 0;
		this.z = initObject? initObject.z || 0 : 0;

		rotationX = initObject? initObject.rotationX || 0 : 0;
		rotationY = initObject? initObject.rotationY || 0 : 0;
		rotationZ = initObject? initObject.rotationZ || 0 : 0;

		var scaleDefault:Number = Papervision3D.usePERCENT? 100 : 1;
		scaleX = initObject? initObject.scaleX || scaleDefault : scaleDefault;
		scaleY = initObject? initObject.scaleY || scaleDefault : scaleDefault;
		scaleZ = initObject? initObject.scaleZ || scaleDefault : scaleDefault;

		if( initObject && initObject.extra ) this.extra = initObject.extra;
		if( initObject && initObject.container ) this.container = initObject.container;

		this.visible = true;

		this.id = _totalDisplayObjects++;
		this.name = name || String( this.id );

		if( geometry ) addGeometry( geometry );
	}

	// ___________________________________________________________________________________________________
	//                                                                                           U T I L S
	
	/**
	* Adds a child DisplayObject3D instance to this DisplayObjectContainer instance.
	*
	* [TODO: If you add a child object that already has a different display object container as a parent, the object is removed from the child list of the other display object container.]
	*
	* @param	child	The DisplayObject3D instance to add as a child of this DisplayObjectContainer3D instance.
	* @param	name	An optional name of the child to add or create. If no name is provided, the child name will be used.
	* @return	The DisplayObject3D instance that you have added or created.
	*/
	public override function addChild( child :DisplayObject3D, name:String=null ):DisplayObject3D
	{
		child = super.addChild( child, name );
		
		if( child.scene == null ) child.scene = scene;

		return child;
	}
	
	/**
	* Adds a geometry definition to the instance.
	*
	* A geometry describes the visual shape and appearance of an object in a scene.
	*
	* @param	geometry	A geometry definition.
	*/
	public function addGeometry( geometry:GeometryObject3D=null ):void
	{

		if( geometry )
			this.geometry = geometry;
/*
		if( geometry.material )
			this.material = geometry.material.clone();

		if( geometry.materials )
			this.materials = geometry.materials.clone();
*/

	}

	// ___________________________________________________________________________________________________
	//                                                                                   C O L L I S I O N

	/**
	* Gets the distance to the position of the given object.
	*
	* @param	obj		The display object to measure the distance to.
	* @return	The distance to the registration point of the given object.
	*/
	public function distanceTo( obj:DisplayObject3D ):Number
	{
		var x :Number = this.x - obj.x;
		var y :Number = this.y - obj.y;
		var z :Number = this.z - obj.z;

		return Math.sqrt( x*x + y*y + z*z );
	}


	/**
	* Evaluates the display object to see if it overlaps or intersects with the point specified by the x, y and z parameters.
	* <p/>
	* The x, y and z parameters specify a point in the coordinate space of the instance parent object, not the scene (unless that parent object is the scene).
	*
	* @param	x	The x coordinate to test against this object.
	* @param	y	The y coordinate to test against this object.
	* @param	z	The z coordinate to test against this object.
	* @return	true if the display object overlaps or intersects with the specified point; false otherwise.
	*/
	public function hitTestPoint( x:Number, y:Number, z:Number ):Boolean
	{
		var dx :Number = this.x - x;
		var dy :Number = this.y - y;
		var dz :Number = this.z - z;

		var d2 :Number = x*x + y*y + z*z;

		var sA :Number = this.geometry? this.geometry.boundingSphere2 : 0;

		return sA > d2;
	}


	/**
	* Evaluates the display object to see if it overlaps or intersects with the obj display object.
	*
	* @param	obj	 The display object to test against.
	* @return	true if the display objects intersect; false if not.
	*/
	// TODO: Use group boundingSphere
	public function hitTestObject( obj:DisplayObject3D, multiplier:Number=1 ):Boolean
	{
		var dx :Number = this.x - obj.x;
		var dy :Number = this.y - obj.y;
		var dz :Number = this.z - obj.z;

		var d2 :Number = dx*dx + dy*dy + dz*dz;

		var sA :Number = this.geometry? this.geometry.boundingSphere2 : 0;
		var sB :Number = obj.geometry?  obj.geometry.boundingSphere2  : 0;
		
		sA = sA * multiplier;

		return sA + sB > d2;
	}

	// ___________________________________________________________________________________________________
	//                                                                                   M A T E R I A L S

	/**
	* Returns the material that exists with the specified name in the materials list.
	* </p>
	* If more that one material object has the specified name, the method returns the first material object in the materials list.
	* </p>
	* @param	name	The name of the material to return.
	* @return	The material object with the specified name.
	*/
	// TODO: Recursive
	public function getMaterialByName( name:String ):MaterialObject3D
	{
		var material:MaterialObject3D = this.materials.getMaterialByName( name );
		
		if( material )
			return material;
		else
			for each( var child :DisplayObject3D in this._childrenByName )
			{
				material = child.getMaterialByName( name );

				if( material ) return material;
			}

		return null;
	}

	/**
	* Returns a string value with the list of material names of the materials list.
	*
	* @return	A string.
	*/
	// TODO: Recursive
	public function materialsList():String
	{
		var list:String = "";

		for( var name:String in this.materials )
			list += name + "\n";

		for each( var child :DisplayObject3D in this._childrenByName )
		{
			for( name in child.materials.materialsByName )
				list += "+ " + name + "\n";
		}

		return list;
	}


	// ___________________________________________________________________________________________________
	//                                                                                       P R O J E C T
	// PPPPP  RRRRR   OOOO      JJ EEEEEE  CCCC  TTTTTT
	// PP  PP RR  RR OO  OO     JJ EE     CC  CC   TT
	// PPPPP  RRRRR  OO  OO     JJ EEEE   CC       TT
	// PP     RR  RR OO  OO JJ  JJ EE     CC  CC   TT
	// PP     RR  RR  OOOO   JJJJ  EEEEEE  CCCC    TT

	/**
	* [internal-use] Projects three dimensional coordinates onto a two dimensional plane to simulate the relationship of the camera to subject.
	* <p/>
	* This is the first step in the process of representing three dimensional shapes two dimensionally.
	*
 	* @param	parent	The DisplayObject3D object that contains this display object.
	* @param	camera	Camera3D object to render from.
	* @param	sorted  The list of faces of the current sort branch.
	*/
	public function project( parent :DisplayObject3D, camera :CameraObject3D, sorted :Array=null ):Number
	{
		if( this._transformDirty ) updateTransform();

		this.view.calculateMultiply( parent.view, this.transform );
		this.world.calculateMultiply( parent.world, this.transform );

		calculateScreenCoords( camera );

		var screenZs :Number = 0;
		var children :Number = 0;

		if( ! sorted ) this._sorted = sorted = new Array();

		for each( var child:DisplayObject3D in this._childrenByName )
		{
			if( child.visible )
			{
				screenZs += child.project( this, camera, sorted );
				children++;
			}
		}

		return this.screenZ = screenZs / children;
	}

	private function calculateScreenCoords( camera :CameraObject3D ):void
	{
		var persp:Number = (camera.focus * camera.zoom) / (camera.focus + view.n34);
		screen.x = view.n14 * persp;
		screen.y = view.n24 * persp;
		screen.z = view.n34;
	}	
	
	// ___________________________________________________________________________________________________
	//                                                                                         R E N D E R
	// RRRRR  EEEEEE NN  NN DDDDD  EEEEEE RRRRR
	// RR  RR EE     NNN NN DD  DD EE     RR  RR
	// RRRRR  EEEE   NNNNNN DD  DD EEEE   RRRRR
	// RR  RR EE     NN NNN DD  DD EE     RR  RR
	// RR  RR EEEEEE NN  NN DDDDD  EEEEEE RR  RR

	/**
	* [internal-use] Render the projected object.
	*
	* @param	scene	The scene where the object belongs.
	*/
	public function render( scene :SceneObject3D ):void
	{
		var iFaces :Array = this._sorted;

		iFaces.sortOn( 'screenZ', Array.DESCENDING | Array.NUMERIC );

		// Render
		
		var container 	:Sprite = this.container || scene.container,
		rendered  		:Number = 0,
		iFace     		:Face3DInstance, 
		length			:Number = iFaces.length,
		i				:int = 0;	
		//for( var i:int = 0; iFace = iFaces[i]; i++ )
		//for( var i:int = 0; i < length ; i++ )
		while(i < length)
		{
			iFace = iFaces[i];
			if( faceLevelMode )
			{
				if( !iFace.container )
				{
					iFace.container = new InteractiveSprite(this);
					scene.container.addChild(iFace.container);
				}
				else
				{
					iFace.container.graphics.clear();
				}
				
				if( iFace.visible )
					rendered += iFace.face.render( iFace.instance,  iFace.container)
			}else
			{
				// if we're not in faceLevelMode, then it's render as usual - no extra checks in the render loop
				if( iFace.visible )
					rendered += iFace.face.render( iFace.instance, container );
			}	
			
			i++;		
		}

		// Update stats
		scene.stats.rendered += rendered;
	}

	// ___________________________________________________________________________________________________
	//                                                                     L O C A L   T R A N S F O R M S
	// LL      OOOO   CCCC    AA   LL
	// LL     OO  OO CC  CC  AAAA  LL
	// LL     OO  OO CC     AA  AA LL
	// LL     OO  OO CC  CC AAAAAA LL
	// LLLLLL  OOOO   CCCC  AA  AA LLLLLL

	/**
	* Translate the display object in the direction it is facing, i.e. it's positive Z axis.
	*
	* @param	distance	The distance that the object should move forward.
	*/
	public function moveForward  ( distance:Number ):void { translate( distance, FORWARD  ); }

	/**
	* Translate the display object in the opposite direction it is facing, i.e. it's negative Z axis.
	*
	* @param	distance	The distance that the object should move backward.
	*/
	public function moveBackward ( distance:Number ):void { translate( distance, BACKWARD ); }

	/**
	* Translate the display object lateraly, to the left of the direction it is facing, i.e. it's negative X axis.
	*
	* @param	distance	The distance that the object should move left.
	*/
	public function moveLeft     ( distance:Number ):void { translate( distance, LEFT     ); }

	/**
	* Translate the display object lateraly, to the right of the direction it is facing, i.e. it's positive X axis.
	*
	* @param	distance	The distance that the object should move right.
	*/
	public function moveRight    ( distance:Number ):void { translate( distance, RIGHT    ); }

	/**
	* Translate the display object upwards, with respect to the direction it is facing, i.e. it's positive Y axis.
	*
	* @param	distance	The distance that the object should move up.
	*/
	public function moveUp       ( distance:Number ):void { translate( distance, UP       ); }

	/**
	* Translate the display object downwards, with respect to the direction it is facing, i.e. it's negative Y axis.
	*
	* @param	distance	The distance that the object should move down.
	*/
	public function moveDown     ( distance:Number ):void { translate( distance, DOWN     ); }

	// ___________________________________________________________________________________________________
	//                                                                   L O C A L   T R A N S L A T I O N

	/**
	* Move the object along a given direction.
	*
	* @param	distance	The distance that the object should travel.
	* @param	axis		The direction that the object should move towards.
	*/
	public function translate( distance:Number, axis:Number3D ):void
	{
		var vector:Number3D = axis.clone();

		if( this._transformDirty ) updateTransform();

		Matrix3D.rotateAxis( transform, vector )

		this.x += distance * vector.x;
		this.y += distance * vector.y;
		this.z += distance * vector.z;
	}

	// ___________________________________________________________________________________________________
	//                                                                         L O C A L   R O T A T I O N

	/**
	* Rotate the display object around its lateral or transverse axis —an axis running from the pilot's left to right in piloted aircraft, and parallel to the wings of a winged aircraft; thus the nose pitches up and the tail down, or vice-versa.
	*
	* @param	angle	The angle to rotate.
	*/
	public function pitch( angle:Number ):void
	{
		angle = Papervision3D.useDEGREES? angle * toRADIANS : angle;

		var vector:Number3D = RIGHT.clone();

		if( this._transformDirty ) updateTransform();

		Matrix3D.rotateAxis( transform, vector );
		var m:Matrix3D = Matrix3D.rotationMatrix( vector.x, vector.y, vector.z, angle );

//		this.transform.copy3x3( Matrix3D.multiply3x3( m ,transform ) );
		this.transform.calculateMultiply3x3( m ,transform );

		this._rotationDirty = true;
	}


	/**
	* Rotate the display object around about the vertical axis —an axis drawn from top to bottom.
	*
	* @param	angle	The angle to rotate.
	*/
	public function yaw( angle:Number ):void
	{
		angle = Papervision3D.useDEGREES? angle * toRADIANS : angle;

		var vector:Number3D = UP.clone();

		if( this._transformDirty ) updateTransform();

		Matrix3D.rotateAxis( transform, vector );
		var m:Matrix3D = Matrix3D.rotationMatrix( vector.x, vector.y, vector.z, angle );

		this.transform.calculateMultiply3x3( m ,transform );

		this._rotationDirty = true;
	}


	/**
	* Rotate the display object around the longitudinal axis —an axis drawn through the body of the vehicle from tail to nose in the normal direction of flight, or the direction the object is facing.
	*
	* @param	angle
	*/
	public function roll( angle:Number ):void
	{
		angle = Papervision3D.useDEGREES? angle * toRADIANS : angle;

		var vector:Number3D = FORWARD.clone();

		if( this._transformDirty ) updateTransform();

		Matrix3D.rotateAxis( transform, vector );
		var m:Matrix3D = Matrix3D.rotationMatrix( vector.x, vector.y, vector.z, angle );

		this.transform.calculateMultiply3x3( m ,transform );

		this._rotationDirty = true;
	}


	/**
	* Make the object look at a specific position.
	*
	* @param	targetObject	Object to look at.
	* @param	upAxis			The vertical axis of the universe. Normally the positive Y axis.
	*/
	public function lookAt( targetObject:DisplayObject3D, upAxis:Number3D=null ):void
	{
		var position :Number3D = new Number3D( this.x, this.y, this.z );
		var target   :Number3D = new Number3D( targetObject.x, targetObject.y, targetObject.z );

		var zAxis    :Number3D = Number3D.sub( target, position );
		zAxis.normalize();

		if( zAxis.modulo > 0.1 )
		{
			var xAxis :Number3D = Number3D.cross( zAxis, upAxis || UP );
			xAxis.normalize();

			var yAxis :Number3D = Number3D.cross( zAxis, xAxis );
			yAxis.normalize();

			var look  :Matrix3D = this.transform;

			/*
			look.n11 = xAxis.x;
			look.n21 = xAxis.y;
			look.n31 = xAxis.z;

			look.n12 = -yAxis.x;
			look.n22 = -yAxis.y;
			look.n32 = -yAxis.z;

			look.n13 = zAxis.x;
			look.n23 = zAxis.y;
			look.n33 = zAxis.z;
			*/
			
			// scale fix for lookAt()
			look.n11 =  xAxis.x * _scaleX;
			look.n21 =  xAxis.y * _scaleX;
			look.n31 =  xAxis.z * _scaleX;
			
			look.n12 = -yAxis.x * _scaleY;
			look.n22 = -yAxis.y * _scaleY;
			look.n32 = -yAxis.z * _scaleY;
			
			look.n13 =  zAxis.x * _scaleZ;
			look.n23 =  zAxis.y * _scaleZ;
			look.n33 =  zAxis.z * _scaleZ;

			this._transformDirty = false;
			this._rotationDirty = true;
			// TODO: Implement scale
		}
		else
		{
			var log:XrayLog = new XrayLog();
			log.debug( "lookAt Error" );
		}
	}

	// ___________________________________________________________________________________________________
	//                                                                                   T R A N S F O R M
	// TTTTTT RRRRR    AA   NN  NN  SSSSS FFFFFF OOOO  RRRRR  MM   MM
	//   TT   RR  RR  AAAA  NNN NN SS     FF    OO  OO RR  RR MMM MMM
	//   TT   RRRRR  AA  AA NNNNNN  SSSS  FFFF  OO  OO RRRRR  MMMMMMM
	//   TT   RR  RR AAAAAA NN NNN     SS FF    OO  OO RR  RR MM M MM
	//   TT   RR  RR AA  AA NN  NN SSSSS  FF     OOOO  RR  RR MM   MM

	/**
	* Copies the position information (x, y and z coordinates) from another object or Matrix3D.
	*
	* @param	reference	A DisplayObject3D or Matrix3D object to copy the position from.
	*/
	public function copyPosition( reference:* ):void
	{
		var trans  :Matrix3D = this.transform;
		var matrix :Matrix3D = (reference is DisplayObject3D)? reference.transform : reference;

		trans.n14 = matrix.n14;
		trans.n24 = matrix.n24;
		trans.n34 = matrix.n34;
	}

	/**
	* Copies the transformation information (position, rotation and scale) from another object or Matrix3D.
	*
	* @param	reference	A DisplayObject3D or Matrix3D object to copy the position from.
	*/
	public function copyTransform( reference:* ):void
	{
		var trans  :Matrix3D = this.transform;
		var matrix :Matrix3D = (reference is DisplayObject3D)? reference.transform : reference;

		trans.n11 = matrix.n11;		trans.n12 = matrix.n12;
		trans.n13 = matrix.n13;		trans.n14 = matrix.n14;

		trans.n21 = matrix.n21;		trans.n22 = matrix.n22;
		trans.n23 = matrix.n23;		trans.n24 = matrix.n24;

		trans.n31 = matrix.n31;		trans.n32 = matrix.n32;
		trans.n33 = matrix.n33;		trans.n34 = matrix.n34;

		this._transformDirty = false;
		this._rotationDirty  = true;
	}


	/**
	* [internal-use] Updates the transform Matrix3D with the current rotation and scale values.
	*/
	// TODO OPTIMIZE (HIGH)
	protected function updateTransform():void
	{
		var q:Object = Matrix3D.euler2quaternion( -this._rotationY, -this._rotationZ, this._rotationX ); // Swapped

		var m:Matrix3D = Matrix3D.quaternion2matrix( q.x, q.y, q.z, q.w );

		var transform:Matrix3D = this.transform;

		m.n14 = transform.n14;
		m.n24 = transform.n24;
		m.n34 = transform.n34;

		transform.copy( m );

		// Scale
		var scaleM:Matrix3D = Matrix3D.IDENTITY;
		scaleM.n11 = this._scaleX;
		scaleM.n22 = this._scaleY;
		scaleM.n33 = this._scaleZ;

		this.transform.calculateMultiply( transform, scaleM );

		this._transformDirty = false;
	}


	// ___________________________________________________________________________________________________

	/**
	* Returns a string value representing the three-dimensional position values of the display object instance.
	*
	* @return	A string.
	*/
	public override function toString(): String
	{
		return this.name + ': x:' + Math.round(this.x) + ' y:' + Math.round(this.y) + ' z:' + Math.round(this.z);
	}

	// ___________________________________________________________________________________________________
	//                                                                                       P R I V A T E

	/**
	* [internal-use]
	*/
	protected var _transformDirty :Boolean = false;

	private var _rotationX      :Number;
	private var _rotationY      :Number;
	private var _rotationZ      :Number;
	private var _rotationDirty  :Boolean = false;

	private var _scaleX         :Number;
	private var _scaleY         :Number;
	private var _scaleZ         :Number;
	private var _scaleDirty     :Boolean = false;

	protected var _sorted       :Array;

	static private var _totalDisplayObjects :int = 0;

	static private var toDEGREES :Number = 180/Math.PI;
	static private var toRADIANS :Number = Math.PI/180;
}
}