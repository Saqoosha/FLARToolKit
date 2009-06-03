package org.papervision3d.objects.parsers
{
 	import flash.events.Event;
 	import flash.events.ProgressEvent;
 	import flash.system.Capabilities;
 	import flash.utils.ByteArray;
 	import flash.utils.Dictionary;
 	import flash.utils.getTimer;
 	
 	import org.ascollada.ASCollada;
 	import org.ascollada.core.*;
 	import org.ascollada.fx.*;
 	import org.ascollada.io.DaeReader;
 	import org.ascollada.namespaces.*;
 	import org.ascollada.types.*;
 	import org.papervision3d.Papervision3D;
 	import org.papervision3d.core.animation.*;
 	import org.papervision3d.core.animation.channel.*;
 	import org.papervision3d.core.controller.IObjectController;
 	import org.papervision3d.core.controller.SkinController;
 	import org.papervision3d.core.geom.*;
 	import org.papervision3d.core.geom.renderables.*;
 	import org.papervision3d.core.log.PaperLogger;
 	import org.papervision3d.core.material.AbstractLightShadeMaterial;
 	import org.papervision3d.core.math.*;
 	import org.papervision3d.core.proto.*;
 	import org.papervision3d.core.render.data.RenderSessionData;
 	import org.papervision3d.events.AnimationEvent;
 	import org.papervision3d.events.FileLoadEvent;
 	import org.papervision3d.materials.*;
 	import org.papervision3d.materials.shaders.ShadedMaterial;
 	import org.papervision3d.materials.special.*;
 	import org.papervision3d.materials.utils.*;
 	import org.papervision3d.objects.DisplayObject3D;
 	import org.papervision3d.objects.special.Skin3D;
	
	/**
	 * The DAE class represents a parsed COLLADA 1.4.1 file.
	 * 
	 * <p>Typical use case:</p>
	 * <pre>
	 * var dae :DAE = new DAE();
	 * 
	 * dae.addEventListener(FileLoadEvent.LOAD_COMPLETE, myOnLoadCompleteHandler);
	 * 
	 * dae.load( "path/to/collada" );
	 * </pre>
	 * 
	 * <p>Its possible to pass you own materials via a MaterialsList:</p>
	 * <pre>
	 * var materials :MaterialsList = new MaterialsList();
	 * 
	 * materials.addMaterial( new ColorMaterial(), "MyMaterial" );
	 * 
	 * var dae :DAE = new DAE();
	 * 
	 * dae.addEventListener(FileLoadEvent.LOAD_COMPLETE, myOnLoadCompleteHandler);
	 * 
	 * dae.load( "path/to/collada", materials );
	 * </pre>
	 * <p>Note that in above case you need the material names as specified in your 3D modelling application.
	 * The material names can also be found by looking at the COLLADA file: find the xml elements 
	 * &lt;instance_material symbol="MyMaterialName" target="SomeTarget" /&gt;. The material names are specified
	 * by the symbol attribute of this element.</p>
	 * 
	 * <p>A COLLADA file can contain animations. Animations take a long time to parse, hence 
	 * animations are parsed asynchroniously. Listen for FileLoadEvent.ANIMATIONS_COMPLETE and 
	 * FileLoadEvent.ANIMATIONS_PROGRESS:</p>
	 * <pre>
	 * var dae :DAE = new DAE();
	 * 
	 * dae.addEventListener(FileLoadEvent.LOAD_COMPLETE, myOnLoadCompleteHandler);
	 * dae.addEventListener(FileLoadEvent.ANIMATIONS_COMPLETE, myOnAnimationsCompleteHandler);
	 * dae.addEventListener(FileLoadEvent.ANIMATIONS_PROGRESS, myOnAnimationsProgressHandler);
	 * 
	 * dae.load( "path/to/collada" );
	 * </pre>
	 * 
	 * @author Tim Knip
	 */ 
	public class DAE extends DisplayObject3D implements IAnimationDataProvider, IAnimatable
	{
		use namespace collada;
		
		public static const ROOTNODE_NAME:String = "COLLADA_Scene";
		
		/** Defines wether to set materials by target id or name - Might fix C4D**/
		public var useMaterialTargetName:Boolean = false;
		
		/** Default line color for splines. */
		public static var DEFAULT_LINE_COLOR:uint = 0xffff00;
		
		/** Default line width for splines */
		public static var DEFAULT_LINE_WIDTH:Number = 0;
		
		/** Alternative file-extension for TGA images. Default is "png". */
		public static var DEFAULT_TGA_ALTERNATIVE:String = "png";
		
		
		/** change this to 0 if you're DAE is picking the wrong coordinates */
		
		public var forceCoordSet : int = 0;
		
		/** The loaded XML. */
		public var COLLADA:XML;
	
		/** The filename - if applicable. */
		public var filename:String;
		
		/** The filetitle - if applicable. */
		public var fileTitle:String;
		
		/** Base url. */
		public var baseUrl:String;
		
		/** Path where the textures should be loaded from. */
		public var texturePath:String;
		
		/** The COLLADA parser. */
		public var parser:DaeReader;
		
		/** The DaeDocument. @see org.ascollada.core.DaeDocument */
		public var document:DaeDocument;
			
		/** */
		protected var _colladaID:Dictionary;
		
		/** */
		protected var _colladaSID:Dictionary;
		
		/** */
		protected var _colladaIDToObject:Object;
		
		/** */
		protected var _colladaSIDToObject:Object;
		
		/** */
		protected var _objectToNode:Object;
		
		/** */
		protected var _channelsByTarget:Dictionary;
		
		/** */
		protected var _geometries:Object;
		
		/** */
		protected var _queuedMaterials:Array;
		
		/** */
		protected var _textureSets:Object;
		
		/** */
		protected var _channels:Array;
		
		/** */
		protected var _skins:Dictionary;
		
		/** */
		protected var _numSkins:uint;
		
		/** */
		protected var _rootNode:DisplayObject3D;
		
		/** */
		protected var _currentFrame:int = 0;
		
		/** */
		protected var _currentTime:int;
		
		/** */
		protected var _totalFrames:int = 0;
		
		/** */
		protected var _startTime:Number;
		
		/** */
		protected var _endTime:Number;
		
		/** */
		protected var _isAnimated:Boolean = false;
		
		/** */
		protected var _isPlaying:Boolean = false;
		
		/** */
		protected var _autoPlay:Boolean;
		
		/** */
		protected var _rightHanded:Boolean;
		
		/** */
		protected var _controllers:Array; 
		
		protected var _playerType:String;
		
		protected var _loop:Boolean = false;
		
		protected var _bindVertexInputs : Dictionary;
		
		
		
		/**
		 * Constructor.
		 * 
		 * @param	autoPlay	Whether to start the animation automatically.
		 * @param	name	Optional name for the DAE.
		 */ 
		public function DAE(autoPlay:Boolean=true, name:String=null, loop:Boolean=false)
		{
			super(name);
			_autoPlay = autoPlay;
			_rightHanded = Papervision3D.useRIGHTHANDED;
			_loop = loop;
			_playerType = Capabilities.playerType;
		}
		
		/**
		 * Plays the animation.
		 * 
		 * @param 	clip	Optional clip name.
		 */ 
		public function play(clip:String=null):void
		{
			_currentFrame = 0;
			_currentTime = getTimer();
			_isPlaying = (_isAnimated && _channels && _channels.length);
		}
		
		/**
		 * Stops the animation.
		 */ 
		public function stop():void
		{
			trace("STOP CALLED ON DAE");
			_isPlaying = false;	
			dispatchEvent(new AnimationEvent(AnimationEvent.ANIMATION_COMPLETE, _currentFrame, _totalFrames));
		}
		
		
		/**
		 * Gets the default FPS.
		 */ 
		public function get fps():uint
		{
			return 20;
		}
		
		/**
		 * Gets a animation channel by its name.
		 * 
		 * @param	name
		 * 
		 * @return the found channel.
		 */ 
		public function getAnimationChannelByName(name:String):AbstractChannel3D
		{
			return null;	
		}
		
		/**
		 * Gets all animation channels for a target. 
		 * <p>NOTE: when target is null, all channels for this object are returned.</p>
		 * 
		 * @param	target	The target to get the channels for.
		 * 
		 * @return	Array of AnimationChannel3D.
		 */ 
		public function getAnimationChannels(target:DisplayObject3D=null):Array
		{
			var channels:Array = new Array();
			if(target == null)
			{
				for each(var array:Array in _channelsByTarget)
					channels = channels.concat(array);
			}
			else if(_channelsByTarget[target])
			{
				channels = channels.concat(_channelsByTarget[target]);
			}
			else
				return null;
					
			return channels;
		}
		
		/**
		 * Gets animation channels by clip name.
		 * 
		 * @param	name	The clip name
		 * 
		 * @return	Array of AnimationChannel3D.
		 */ 
		public function getAnimationChannelsByClip(name:String):Array
		{
			return null;	
		}
		
		/**
		 * Loads the COLLADA.
		 * 
		 * @param	asset The url, an XML object or a ByteArray specifying the COLLADA file.
		 * @param	materials	An optional materialsList.
		 */ 
		public function load(asset:*, materials:MaterialsList = null, asynchronousParsing : Boolean = false):void
		{
			this.materials = materials || new MaterialsList();
			
			buildFileInfo(asset);
			
			_bindVertexInputs = new Dictionary(true);
			
			this.parser = new DaeReader(asynchronousParsing);
			this.parser.addEventListener(Event.COMPLETE, onParseComplete);
			this.parser.addEventListener(ProgressEvent.PROGRESS, onParseProgress);
			
			if(asset is XML)
			{
				this.COLLADA = asset as XML;
				this.parser.loadDocument(asset);
			}
			else if(asset is ByteArray)
			{
				this.COLLADA = new XML(ByteArray(asset));
				this.parser.loadDocument(asset);
			}
			else if(asset is String)
			{
				this.filename = String(asset);
				this.parser.read(this.filename);
			}
			else
			{
				throw new Error("load : unknown asset type!");
			}
		}
		
		/**
		 * Removes a child.
		 * 
		 * @param	child	The child to remove
		 * 
		 * @return	The removed child
		 */ 
		override public function removeChild(child:DisplayObject3D):DisplayObject3D
		{
			var object:DisplayObject3D = getChildByName(child.name, true);
			
			if(object)
			{
				var parent:DisplayObject3D = DisplayObject3D(object.parent);
				if(parent)
				{
					var removed:DisplayObject3D = parent.removeChild(object);
					if(removed)
						return removed;
				}
			}
			return null;	
		}
		
		
		
		/**
		 * Project.
		 * 
		 * @param	parent
		 * @param	renderSessionData
		 * 
		 * @return	Number
		 */ 
		public override function project(parent:DisplayObject3D, renderSessionData:RenderSessionData):Number
		{
			// update controllers
			for each(var controller:IObjectController in _controllers)
			{
				controller.update();
			}
			
			// update animation
			if(_isPlaying && _channels)
			{
				var secs:Number = _currentTime / 1000;
				var duration:Number = _endTime - _startTime;
				var elapsed:Number = (getTimer()/1000) - secs;
				
				if(elapsed > duration)
				{
					_currentTime = getTimer();
					secs = _currentTime / 1000;
					elapsed = 0;
				}
				var time:Number = elapsed / duration;

				if (time == 0 && !_loop)
					stop();
				else
				{
					for each(var channel:AbstractChannel3D in _channels)
						channel.updateToTime(time);
				}
			}

			return super.project(parent, renderSessionData);	
		}
		
		/**
		 * Builds a animation channel for an object.
		 * 
		 * @param	matrixStackChannel	the target object's channel
		 * @param	target	The target object
		 * @param	channel	The DaeChannel
		 */ 
		protected function buildAnimationChannel(target:DisplayObject3D, channel:DaeChannel):MatrixChannel3D
		{				
			var node:DaeNode = _objectToNode[target];
					
			if(!node)
				throw new Error("Couldn't find the targeted object!");
					
			var matrixChannel:MatrixChannel3D = new MatrixChannel3D(target, channel.syntax.targetSID);
			
			var transform:DaeTransform = node.findMatrixBySID(channel.syntax.targetSID);
					
			if(!transform)
			{
				PaperLogger.warning("Couldn't find the targeted object's transform: " + channel.syntax.targetSID);
				return null;
			}
			
			var matrix:Matrix3D;
			var matrixProp:String;
			var arrayMember:String;
			var data:Array;
			var val:Number;
			var i:int;
						
			if(channel.syntax.isArrayAccess)
			{
				arrayMember = channel.syntax.arrayMember.join("");
				
				switch(arrayMember)
				{
					case "(0)(0)":
						matrixProp = "n11";
						break;
					case "(1)(0)":
						matrixProp = "n12";
						break;
					case "(2)(0)":
						matrixProp = "n13";
						break;
					case "(3)(0)":
						matrixProp = "n14";
						break;
					case "(0)(1)":
						matrixProp = "n21";
						break;
					case "(1)(1)":
						matrixProp = "n22";
						break;
					case "(2)(1)":
						matrixProp = "n23";
						break;
					case "(3)(1)":
						matrixProp = "n24";
						break;
					case "(0)(2)":
						matrixProp = "n31";
						break;
					case "(1)(2)":
						matrixProp = "n32";
						break;
					case "(2)(2)":
						matrixProp = "n33";
						break;
					case "(3)(2)":
						matrixProp = "n34";
						break;
					case "(0)(3)":
						matrixProp = "n41";
						break;
					case "(1)(3)":
						matrixProp = "n42";
						break;
					case "(2)(3)":
						matrixProp = "n43";
						break;
					case "(3)(3)":
						matrixProp = "n44";
						break;
					default:
						throw new Error(arrayMember);
				}
			}
					
			switch(transform.type)
			{
				case "matrix":
					if(channel.syntax.isFullAccess)
					{
						for(i = 0; i < channel.input.length; i++)
						{
							data = channel.output[i];
							matrix = new Matrix3D(data);
							matrixChannel.addKeyFrame(new AnimationKeyFrame3D("keyframe_" + i, channel.input[i], [matrix]));
						}
					}
					else if(channel.syntax.isArrayAccess)
					{
						matrix = Matrix3D.clone(target.transform);
						
						for(i = 0; i < channel.input.length; i++)
						{
							matrix[matrixProp] = channel.output[i];
							matrixChannel.addKeyFrame(new AnimationKeyFrame3D("keyframe_" + i, channel.input[i], [matrix]));
						}
					}
					else
					{
						throw new Error("Don't know how to handle this channel: " + channel.syntax);
					}
					break;
				case "rotate":
					if(channel.syntax.isFullAccess)
					{
						for(i = 0; i < channel.input.length; i++)
						{
							data = channel.output[i];
							matrix = Matrix3D.rotationMatrix(data[0], data[1], data[2], data[3] * (Math.PI/180));
							matrixChannel.addKeyFrame(new AnimationKeyFrame3D("keyframe_" + i, channel.input[i], [matrix]));
						}
					}
					else if(channel.syntax.isDotAccess)
					{
						switch(channel.syntax.member)
						{
							case "ANGLE":
								for(i = 0; i < channel.input.length; i++)
								{
									var angle:Number = channel.output[i] * (Math.PI/180);
									matrix = Matrix3D.rotationMatrix(transform.values[0], transform.values[1], transform.values[2], angle);
									matrixChannel.addKeyFrame(new AnimationKeyFrame3D("keyframe_" + i, channel.input[i], [matrix]));
								}
								break;
							default:
								throw new Error("Don't know how to handle this channel: " + channel.syntax);
						}
					}
					else
					{
						throw new Error("Don't know how to handle this channel: " + channel.syntax);
					}	
					break;
				case "scale":
					if(channel.syntax.isFullAccess)
					{
						for(i = 0; i < channel.input.length; i++)
						{
							data = channel.output[i];
							matrix = Matrix3D.scaleMatrix(data[0], data[1], data[2]);
							matrixChannel.addKeyFrame(new AnimationKeyFrame3D("keyframe_" + i, channel.input[i], [matrix]));
						}
					}
					else if(channel.syntax.isDotAccess)
					{
						for(i = 0; i < channel.input.length; i++)
						{
							val = channel.output[i];
							switch(channel.syntax.member)
							{
								case "X":
									matrix = Matrix3D.scaleMatrix(val, 0, 0);
									matrixChannel.addKeyFrame(new AnimationKeyFrame3D("keyframe_" + i, channel.input[i], [matrix]));
									break;
								case "Y":
									matrix = Matrix3D.scaleMatrix(0, val, 0);
									matrixChannel.addKeyFrame(new AnimationKeyFrame3D("keyframe_" + i, channel.input[i], [matrix]));
									break;
								case "Z":
									matrix = Matrix3D.scaleMatrix(0, 0, val);
									matrixChannel.addKeyFrame(new AnimationKeyFrame3D("keyframe_" + i, channel.input[i], [matrix]));
									break;
								default:
									break;		
							}
						}
					}
					else
					{
						throw new Error("Don't know how to handle this channel: " + channel.syntax);
					}
					break;
				case "translate":
					if(channel.syntax.isFullAccess)
					{
						for(i = 0; i < channel.input.length; i++)
						{
							data = channel.output[i];
							matrix = Matrix3D.translationMatrix(data[0], data[1], data[2]);
							matrixChannel.addKeyFrame(new AnimationKeyFrame3D("keyframe_" + i, channel.input[i], [matrix]));
						}
					}	
					else if(channel.syntax.isDotAccess)
					{
						for(i = 0; i < channel.input.length; i++)
						{
							val = channel.output[i];
							switch(channel.syntax.member)
							{
								case "X":
									matrix = Matrix3D.translationMatrix(val, 0, 0);
									matrixChannel.addKeyFrame(new AnimationKeyFrame3D("keyframe_" + i, channel.input[i], [matrix]));
									break;
								case "Y":
									matrix = Matrix3D.translationMatrix(0, val, 0);
									matrixChannel.addKeyFrame(new AnimationKeyFrame3D("keyframe_" + i, channel.input[i], [matrix]));
									break;
								case "Z":
									matrix = Matrix3D.translationMatrix(0, 0, val);
									matrixChannel.addKeyFrame(new AnimationKeyFrame3D("keyframe_" + i, channel.input[i], [matrix]));
									break;
								default:
									break;		
							}
						}
					}
					else
					{
						throw new Error("Don't know how to handle this channel: " + channel.syntax);
					}		
					break;
				default:
					throw new Error("Unknown transform type!");	
			}
				
			return matrixChannel;
		}
		
		/**
		 * Build all animation channels.
		 */ 
		protected function buildAnimationChannels():void
		{
			var target:DisplayObject3D;
			var channel:DaeChannel;
			var channelsByObject:Dictionary = new Dictionary(true);
			var i:int;
			
			_channelsByTarget = new Dictionary(true);
			
			for each(var animation:DaeAnimation in this.document.animations)
			{
				for(i = 0; i < animation.channels.length; i++)
				{
					channel = animation.channels[i];
					
					target = _colladaIDToObject[channel.syntax.targetID];
					if(!target)
						throw new Error("damn");
						
					if(!channelsByObject[target])
						channelsByObject[target] = new Array();
					
					channelsByObject[target].push(channel);
				}
			}
			
			for(var object:* in channelsByObject)
			{
				target = object as DisplayObject3D;
							
				var channels:Array = channelsByObject[object];
				var node:DaeNode = _objectToNode[target];
					
				if(!node)
					throw new Error("Couldn't find the targeted object with name '" + node.name + "'");
					
				node.channels = channels;
				
				if(!channels.length)
					continue;
				
				channel = channels[0];
				
				var transform:DaeTransform = node.findMatrixBySID(channel.syntax.targetSID);
				
				if(!transform)
				{
					PaperLogger.warning("Could not find a transform with SID=" + channel.syntax.targetSID);
					continue;
				}
	
				// the object has a single <matrix> channel
				if(channels.length == 1 && transform.type == ASCollada.DAE_MATRIX_ELEMENT)
				{
					_channelsByTarget[target] = [buildAnimationChannel(target, channel)];
					continue;
				}
				
				// the object has multiple channels, lets bake 'm into a single channel
				var allTimes:Array = new Array();
				var times:Array = new Array();
				var lastTime:Number;
				
				// fetch all times for all channels
				for each(channel in channels)
					allTimes = allTimes.concat(channel.input);
				allTimes.sort(Array.NUMERIC);
				
				// make array with unique times
				for(i = 0; i < allTimes.length; i++)
				{
					var t:Number = allTimes[i];
					if(i == 0)
						times.push(t);
					else if(t - lastTime > 0.01)
						times.push(t);
					lastTime = t;	
				}
				
				// build the MatrixChannel3D's for this object
				var mcs:Object = new Object();
				for each(channel in channels)
				{
					var animationChannel:MatrixChannel3D = buildAnimationChannel(target, channel);
					if(animationChannel) 
						mcs[ channel.syntax.targetSID ] = buildAnimationChannel(target, channel);
				}
					
				var bakedChannel:MatrixChannel3D = new MatrixChannel3D(target);
				
				// build a baked channel
				for(i = 0; i < times.length; i++)
				{
					var keyframeTime:Number = times[i];
					var bakedMatrix:Matrix3D = Matrix3D.IDENTITY;
					
					// loop over the DaeNode's transform-stack
					for(var j:int = 0; j < node.transforms.length; j++)
					{
						transform = node.transforms[j];
						
						var matrixChannel:MatrixChannel3D = mcs[ transform.sid ];
						
						if(matrixChannel)
						{
							// this transform is animated, so lets determine the matrix for the current keyframeTime
							var time:Number;
							if(keyframeTime < matrixChannel.startTime)
								time = 0;
							else if(keyframeTime > matrixChannel.endTime)
								time = 1;
							else
								time = keyframeTime / (matrixChannel.endTime - matrixChannel.startTime);
								
							// update the channel by time, so the matrix for the current keyframe is setup
							matrixChannel.updateToTime(time);
							
							// bake the matrix
							bakedMatrix = Matrix3D.multiply(bakedMatrix, target.transform);
						}
						else
						{
							// this transform isn't animated, simply bake the transform into the matrix
							bakedMatrix = Matrix3D.multiply(bakedMatrix, buildMatrixFromTransform(transform));
						}
					}
					
					// now we can add the baked matrix as a new keyframe
					bakedChannel.addKeyFrame(new AnimationKeyFrame3D("frame_" + i, keyframeTime, [bakedMatrix]));
				}
				
				_channelsByTarget[target] = [bakedChannel];
			}
		}
		
		/**
		 * Build a color from RGB values.
		 * 
		 * @param	rgb
		 *  
		 * @return
		 */
		protected function buildColor( rgb:Array ):uint
		{
			var r:uint = rgb[0] * 0xff;
			var g:uint = rgb[1] * 0xff;
			var b:uint = rgb[2] * 0xff;
			return (r<<16|g<<8|b);
		}
		
		/**
		 * Creates the faces for a COLLADA primitive. @see org.ascollada.core.DaePrimitive
		 * 
		 * @param 	primitive
		 * @param	geometry
		 * @param	voffset
		 * 
		 * @return 	The created faces.
		 */ 
		protected function buildFaces(primitive:DaePrimitive, geometry:GeometryObject3D, voffset:uint):void
		{
			var faces:Array = new Array();
			var material:MaterialObject3D = this.materials.getMaterialByName(primitive.material);
			
			material = material || MaterialObject3D.DEFAULT;
			
			var instanceMaterial : DaeInstanceMaterial = _bindVertexInputs[ material ];
			
			// retreive correct texcoord-set for the material.
			var setID:int = this.forceCoordSet;
			var textureSet:String = _textureSets[primitive.material];
			var geom:DaeGeometry = primitive.mesh.geometry;
			
			if( textureSet && textureSet.length && geom )
			{
				var instGeom:DaeInstanceGeometry = this.document.getDaeInstanceGeometry( geom.id );
				if( instGeom )
				{
					var vinput:DaeBindVertexInput = instGeom.findBindVertexInput( primitive.material, textureSet );
					if( vinput )
					{
						PaperLogger.info( "using input set #" + vinput.input_set + " for material " + primitive.material );
						setID = vinput.input_set;
					}
				}
			}
			
			var texCoordSet:Array = primitive.getTexCoords(setID); 
			var texcoords:Array = new Array();
			var i:int, j:int = 0, k:int;

			// texture coords
			for( i = 0; i < texCoordSet.length; i++ ) 
				texcoords.push(new NumberUV(texCoordSet[i][0], texCoordSet[i][1]));
			
			var hasUV:Boolean = (texcoords.length == primitive.vertices.length);

			var idx:Array = new Array();
			var v:Array = new Array();
			var uv:Array = new Array();
		
			switch( primitive.type ) 
			{
				// Each line described by the mesh has two vertices. The first line is formed 
				// from first and second vertices. The second line is formed from the third and fourth 
				// vertices and so on.
				case ASCollada.DAE_LINES_ELEMENT:
					for( i = 0; i < primitive.vertices.length; i += 2 ) 
					{
						v[0] = geometry.vertices[ primitive.vertices[i] ];
						v[1] = geometry.vertices[ primitive.vertices[i+1] ];
						uv[0] = hasUV ? texcoords[  i  ] : new NumberUV();
						uv[1] = hasUV ? texcoords[ i+1 ] : new NumberUV();
						//geometry.faces.push( new Triangle3D(instance, [v[0], v[1], v[1]], material, [uv[0], uv[1], uv[1]]) );
					}
					break;
					
				// simple triangles
				case ASCollada.DAE_TRIANGLES_ELEMENT:
					for(i = 0, j = 0; i < primitive.vertices.length; i += 3, j++) 
					{
						idx[0] = voffset + primitive.vertices[i];
						idx[1] = voffset + primitive.vertices[i+1];
						idx[2] = voffset + primitive.vertices[i+2];
						
						v[0] = geometry.vertices[ idx[0] ];
						v[1] = geometry.vertices[ idx[1] ];
						v[2] = geometry.vertices[ idx[2] ];
						
						uv[0] = hasUV ? texcoords[ i+0 ] : new NumberUV();
						uv[1] = hasUV ? texcoords[ i+1 ] : new NumberUV();
						uv[2] = hasUV ? texcoords[ i+2 ] : new NumberUV();
				
						geometry.faces.push(new Triangle3D(null, [v[0], v[1], v[2]], material, [uv[0], uv[1], uv[2]]));
					}
					break;
				// polygon with *no* holes
				case ASCollada.DAE_POLYLIST_ELEMENT:
					for( i = 0, k = 0; i < primitive.vcount.length; i++ ) 
					{
						var poly:Array = new Array();
						var uvs:Array = new Array();
						
						for( j = 0; j < primitive.vcount[i]; j++ ) 
						{
							uvs.push( (hasUV ? texcoords[ k ] : new NumberUV()) );
							poly.push( geometry.vertices[primitive.vertices[k++]] );
						}
						
						if( !geometry || !geometry.faces || !geometry.vertices )
							throw new Error( "no geometry" );
							
						v[0] = poly[0];
						uv[0] = uvs[0];

						for( j = 1; j < poly.length - 1; j++ )
						{
							v[1] = poly[j];
							v[2] = poly[j+1];
							uv[1] = uvs[j];
							uv[2] = uvs[j+1];
							
							if( v[0] is Vertex3D && v[1] is Vertex3D && v[2] is Vertex3D)
							{
								geometry.faces.push(new Triangle3D(null, [v[0], v[1], v[2]], material, [uv[0], uv[1], uv[2]]));
							}
							else
							{
							//	PaperLogger.error("" +primitive.name+ " "+ poly.length +" "+primitive.vertices.length+" "+geometry.vertices.length);
							}
						}
					}
					break;
				
				// polygons *with* holes (but holes not yet processed...)
				case ASCollada.DAE_POLYGONS_ELEMENT:
					for(i = 0, k = 0; i < primitive.polygons.length; i++)
					{
						var p:Array = primitive.polygons[i];
						var np:Array = new Array();
						var nuv:Array = new Array();
						
						for(j = 0; j < p.length; j++)
						{
							nuv.push( (hasUV ? texcoords[ k ] : new NumberUV()) );
							np.push( geometry.vertices[primitive.vertices[k++]] );
						}
						
						v[0] = np[0];
						uv[0] = nuv[0];
						
						for(j = 1; j < np.length - 1; j++)
						{
							v[1] = np[j];
							v[2] = np[j+1];
							uv[1] = nuv[j];
							uv[2] = nuv[j+1];
				
							geometry.faces.push(new Triangle3D(null, [v[0], v[1], v[2]], material, [uv[0], uv[1], uv[2]]));
						}
					}
					break;
						
				default:
					throw new Error("Don't know how to create face for a DaePrimitive with type = " + primitive.type);
			}
		}
		
		/**
		 * 
		 * @param	asset
		 * @return
		 */
		protected function buildFileInfo( asset:* ):void
		{
			this.filename = asset is String ? String(asset) : "./meshes/rawdata_dae";
			
			// make sure we've got forward slashes!
			this.filename = this.filename.split("\\").join("/");
				
			if( this.filename.indexOf("/") != -1 )
			{
				// dae is located in a sub-directory of the swf.
				var parts:Array = this.filename.split("/");
				this.fileTitle = String( parts.pop() );
				this.baseUrl = parts.join("/");
			}
			else
			{
				// dae is located in root directory of swf.
				this.fileTitle = this.filename;
				this.baseUrl = "";
			}
		}
		
		/**
		 * Builds all COLLADA geometries.
		 */ 
		protected function buildGeometries():void
		{
			var i:int, j:int, k:int;
			
			_geometries = new Object();
			
			for each(var geometry:DaeGeometry in this.document.geometries)
			{
				if(geometry.mesh)
				{
					var g:GeometryObject3D = new GeometryObject3D();
					
					g.vertices = buildVertices(geometry.mesh);
					g.faces = new Array();

					if(!g.vertices.length)
						continue;
						
					for(i = 0; i < geometry.mesh.primitives.length; i++)
					{
						buildFaces(geometry.mesh.primitives[i], g, 0);
					}
					
					_geometries[geometry.id] = g;
				}
				else if(geometry.spline && geometry.splines)
				{
					var lines:Lines3D = new Lines3D(new LineMaterial(DEFAULT_LINE_COLOR), geometry.id);
					
					for(i = 0; i < geometry.splines.length; i++)
					{
						var spline:DaeSpline = geometry.splines[i];
						
						for(j = 0; j < spline.vertices.length; j++)
						{
							k = (j+1) % spline.vertices.length;
							
							var v0:Vertex3D = new Vertex3D(spline.vertices[j][0], spline.vertices[j][1], spline.vertices[j][2]);
							var v1:Vertex3D = new Vertex3D(spline.vertices[k][0], spline.vertices[k][1], spline.vertices[k][2]);
						
							var line:Line3D = new Line3D(lines, lines.material as LineMaterial, DEFAULT_LINE_WIDTH, v0, v1);
							
							lines.addLine(line);
						}
					}
					
					_geometries[geometry.id] = lines;
				}
			}	
		}
		
	
		
		/**
		 *
		 * @return
		 */
		protected function buildImagePath( meshFolderPath:String, imgPath:String ):String
		{
			if (texturePath != null)
				imgPath = texturePath + imgPath.slice( imgPath.lastIndexOf("/") + 1 );
			
			var baseParts:Array = meshFolderPath.split("/");
			var imgParts:Array = imgPath.split("/");
			
			while( baseParts[0] == "." )
				baseParts.shift();
				
			while( imgParts[0] == "." )
				imgParts.shift();
				
			while( imgParts[0] == ".." )
			{
				imgParts.shift();
				baseParts.pop();
			}
						
			var imgUrl:String = baseParts.length > 1 ? baseParts.join("/") : (baseParts.length?baseParts[0]:"");
						
			imgUrl = imgUrl != "" ? imgUrl + "/" + imgParts.join("/") : imgParts.join("/");
			
			return imgUrl;
		}
		
		protected function getSymbolName(effectID:String):String
		{
		    var ef:DaeEffect;
		    for each ( var effect:DaeEffect in this.document.effects )
		    {
		       // trace("locating effect", effect.id, effectID);
		        if( effect.id == effectID ) 
		        {
		            return effect.texture_url;
		        }
		    }

		    return null;
		}
		
		/**
		 * Builds the materials.
		 */ 
		protected function buildMaterials():void
		{
			_queuedMaterials = new Array();
			
			for( var materialId:String in this.document.materials )
			{
				var material:MaterialObject3D = null;
				var daeMaterial:DaeMaterial = this.document.materials[ materialId ];
				
				var symbol:String = this.document.materialTargetToSymbol[ daeMaterial.id ];
				
				var mat:MaterialObject3D;
				if(useMaterialTargetName){
					mat = this.materials.getMaterialByName(materialId);
					
				}else{
					mat = this.materials.getMaterialByName(symbol);
				}
				
				/*
				 This next if block is a hack based on materials having their names as the bitmaps URL. 
				 If the material WAS passed in but given the same name as the bitmap's URL, then we 
				 add another material to the materials list using the symbol name.				 
				 */
				if( mat == null) 
				{
				    var matID:String = getSymbolName( daeMaterial.effect );
				    mat = this.materials.getMaterialByName(matID);
				    // remove bad reference BEFORE adding the next - otherwise, they'll both be removed
				    this.materials.removeMaterial(mat);
				    if( mat ) 
				    {
				        if(useMaterialTargetName)
				        {
				             this.materials.addMaterial(mat, materialId);
				        }
				        else
				        {
				             this.materials.addMaterial(mat, symbol);
				        }
				    }

				}
					
				var effect:DaeEffect = document.effects[ daeMaterial.effect ];
				
				var lambert:DaeLambert = effect.color as DaeLambert;
				
				// save the texture-set if necessary
				if(lambert && lambert.diffuse.texture)
				{
					_textureSets[symbol] = lambert.diffuse.texture.texcoord;
				}
				
				// material already exists in our materialsList, no need to process
				if(mat){
					continue;
				}
					
				// if the material has a texture, qeueu the bitmap
				if(effect && effect.texture_url)
				{				
					var image:DaeImage = document.images[effect.texture_url];
					if(image)
					{
						var imageUrl:String = buildImagePath(this.baseUrl, image.init_from);
					
						material = new BitmapFileMaterial();
						material.doubleSided = effect.double_sided;
						_queuedMaterials.push({symbol:symbol, url:imageUrl, material:material, target:materialId});
						continue;
					}
				}

				if(lambert && lambert.diffuse.color)
				{
					if(effect.wireframe)
						material = new WireframeMaterial(buildColor(lambert.diffuse.color));
					else
						material = new ColorMaterial(buildColor(lambert.diffuse.color));
				}
				else
					material = MaterialObject3D.DEFAULT;
					
				material.doubleSided = effect.double_sided;
				
				if(useMaterialTargetName){
					this.materials.addMaterial(material, materialId);
					
				}else{
					this.materials.addMaterial(material, symbol);
				}
				
				
			}
		
			
		
		}
		
		/**
		 * Builds a Matrix3D from a node's transform array. @see org.ascollada.core.DaeNode#transforms
		 * 
		 * @param	node
		 * 
		 * @return
		 */
		protected function buildMatrix(node:DaeNode):Matrix3D 
		{
			var stack:Array = buildMatrixStack(node);
			var matrix:Matrix3D = Matrix3D.IDENTITY;
			for( var i:int = 0; i < stack.length; i++ ) 
				matrix.calculateMultiply4x4(matrix, stack[i]);
			return matrix;
		}
		
		/**
		 * 
		 * @param	node
		 * @return
		 */
		protected function buildMatrixFromTransform(transform:DaeTransform):Matrix3D
		{
			var matrix:Matrix3D;
			var toRadians:Number = Math.PI/180;
			var v:Array = transform.values;
			
			switch(transform.type)
			{
				case ASCollada.DAE_ROTATE_ELEMENT:
					matrix = Matrix3D.rotationMatrix(v[0], v[1], v[2], v[3] * toRadians);
					break;
				case ASCollada.DAE_SCALE_ELEMENT:
					matrix = Matrix3D.scaleMatrix(v[0], v[1], v[2]);
					break;
				case ASCollada.DAE_TRANSLATE_ELEMENT:
					matrix = Matrix3D.translationMatrix(v[0], v[1], v[2]);
					break;
				case ASCollada.DAE_MATRIX_ELEMENT:
					matrix = new Matrix3D(v);
					break;
				default:
					throw new Error("Unknown transform type: " + transform.type);
			}
			return matrix;
		}
		
		/**
		 * 
		 * @param	node
		 * @return
		 */
		protected function buildMatrixStack(node:DaeNode):Array
		{
			var stack:Array = new Array();	
			for( var i:int = 0; i < node.transforms.length; i++ ) 
				stack.push(buildMatrixFromTransform(node.transforms[i]));
			return stack;
		}
		
		/**
		 * Builds a DisplayObject3D from a node. @see org.ascollada.core.DaeNode
		 * 
		 * @param	node	
		 * 
		 * @return	The created DisplayObject3D. @see org.papervision3d.objects.DisplayObject3D
		 */ 
		protected function buildNode(node:DaeNode, parent:DisplayObject3D):void
		{
			var instance:DisplayObject3D;
			var material:MaterialObject3D;
			var i:int;
			
			if(node.controllers.length)
			{
				// controllers, can be of type 'skin' or 'morph'
				for(i = 0; i < node.controllers.length; i++)
				{
					var instanceController:DaeInstanceController = node.controllers[i];
					var colladaController:DaeController = document.controllers[instanceController.url];

					if(colladaController.skin)
					{
						instance = new Skin3D(null, [], [], node.name);
						
						buildSkin(instance as Skin3D, colladaController.skin, instanceController.skeletons, node);
					}
					else if(colladaController.morph)
					{
						throw new Error("morph!");
					}
					else
						throw new Error("A COLLADA controller should be of type <skin> or <morph>!");
				
					// dunnu yet how to handle multiple controllers.
					break;
				}
			}
			else if(node.geometries.length)
			{
				// got geometry, so create a TriangleMesh3D
				instance = new TriangleMesh3D(null, [], [], node.name);
				
				// add all COLLADA geometries to the TriangleMesh3D
				for each(var geom:DaeInstanceGeometry in node.geometries)
				{
					var geometry:GeometryObject3D = _geometries[ geom.url ];		
					if(!geometry)
						continue;
					
					if(_geometries[ geom.url ] is Lines3D)
					{
						instance.addChild(_geometries[ geom.url ]);
						continue;
					}
						
					var materialInstances:Array = new Array();
					if(geom.materials)
					{
						for each(var instanceMaterial:DaeInstanceMaterial in geom.materials)
						{
							if(useMaterialTargetName){
								material = this.materials.getMaterialByName(instanceMaterial.target);
							}else{
								material = this.materials.getMaterialByName(instanceMaterial.symbol);
							}
							
							if(material)
							{
								_bindVertexInputs[ material ] = instanceMaterial;
								
								// register shaded materials with its object
								if(material is AbstractLightShadeMaterial || material is ShadedMaterial)
									material.registerObject(instance);
								
								materialInstances.push(material);
							}
						}
					}
					
					mergeGeometries(instance.geometry, geometry.clone(instance), materialInstances);
				}
			}
			else
			{
				// no geometry, simply create a Joint3D
				instance = new DisplayObject3D(node.name);
			}
			
			// recurse node instances
			for(i = 0; i < node.instance_nodes.length; i++)
			{
				var dae_node:DaeNode = document.getDaeNodeById(node.instance_nodes[i].url);
				buildNode(dae_node, instance);
			}

			// setup the initial transform
			instance.copyTransform(buildMatrix(node));	
			
			// recurse node children
			for(i = 0; i < node.nodes.length; i++)
				buildNode(node.nodes[i], instance);
					
			// save COLLADA id, sid
			_colladaID[instance] = node.id;
			_colladaSID[instance] = node.sid;
			_colladaIDToObject[node.id] = instance;
			_colladaSIDToObject[node.sid] = instance;
			_objectToNode[instance] = node;
			
			instance.flipLightDirection = true;
				
			parent.addChild(instance);
		}
		
		/**
		 * Builds the scene.
		 */ 
		protected function buildScene():void
		{
			
			
			_controllers = new Array();
	
			buildGeometries();
			
			_rootNode = new DisplayObject3D(ROOTNODE_NAME);
			
			for(var i:int = 0; i < this.document.vscene.nodes.length; i++)
			{
				buildNode(this.document.vscene.nodes[i], _rootNode);
			}
			
			// link the skins
			linkSkins();
			
			this.addChild(_rootNode);
			
			if(this.yUp)
			{
				
			}
			else
			{
				_rootNode.rotationX = -90;
				_rootNode.rotationY = 180;
			}
			
			if(!_rightHanded)
				_rootNode.scaleX = -_rootNode.scaleX;
			
			// animation stuff
			_currentFrame = 0;
			_totalFrames = 0;
			_startTime = _endTime = 0;
			_channels = new Array();
			_isAnimated = false;
			_isPlaying = false;
			

			
			// may have animations to be parsed.
			if(document.numQueuedAnimations)
			{
				_isAnimated = true;
				
				this.parser.addEventListener(Event.COMPLETE, onParseAnimationsComplete);
				this.parser.addEventListener(ProgressEvent.PROGRESS, onParseAnimationsProgress);
				this.parser.readAnimations();
			}
			
			dispatchEvent(new FileLoadEvent(FileLoadEvent.LOAD_COMPLETE, this.filename));
		}
		
		/**
		 * Builds a skin.
		 * 
		 * @param	instance
		 * @param	colladaSkin
		 * @param	skeletons
		 */ 
		protected function buildSkin(instance:Skin3D, colladaSkin:DaeSkin, skeletons:Array, node:DaeNode):void
		{
			var skin:GeometryObject3D = _geometries[ colladaSkin.source ];
			if(!skin)
			{
				// geometry can be inside a morph controller
				var morphController:DaeController = this.document.controllers[colladaSkin.source];
				if(morphController && morphController.morph)
				{
					var morph:DaeMorph = morphController.morph;
					
					// fetch geometry
					skin = _geometries[morph.source];

					// fetch target geometries
					for(var j:int = 0; j < morph.targets.length; j++)
					{
						var targetGeometry:GeometryObject3D = _geometries[morph.targets[j]];
					}
				}
				if(!skin)
					throw new Error("no geometry for source: " + colladaSkin.source);
			}
			
			mergeGeometries(instance.geometry, skin.clone(instance));
			
			_skins[ instance ] = colladaSkin;
		}
		
		/**
		 * Builds vertices from a COLLADA mesh.
		 * 
		 * @param	mesh	The COLLADA mesh. @see org.ascollada.core.DaeMesh
		 * 
		 * @return	Array of Vertex3D
		 */
		protected function buildVertices(mesh:DaeMesh):Array
		{
			var vertices:Array = new Array();
			for( var i:int = 0; i < mesh.vertices.length; i++ )
				vertices.push(new Vertex3D(mesh.vertices[i][0], mesh.vertices[i][1], mesh.vertices[i][2]));
			return vertices;
		}
		
		/**
		 * Recursively finds a child by its COLLADA is.
		 * 
		 * @param	id
		 * @param	parent
		 * 
		 * @return 	The found child.
		 */ 
		protected function findChildByID(id:String, parent:DisplayObject3D = null):DisplayObject3D
		{
			parent = parent || this;
			if(_colladaID[parent] == id)
				return parent;
			for each(var child:DisplayObject3D in parent.children)	
			{
				var obj:DisplayObject3D = findChildByID(id, child);
				if(obj) 
					return obj;
			}
			return null;
		}
		
		/**
		 * Recursively finds a child by its SID.
		 * 
		 * @param	name
		 * @param	parent
		 * 
		 * @return 	The found child.
		 */ 
		protected function findChildBySID(sid:String, parent:DisplayObject3D = null):DisplayObject3D
		{
			parent = parent || this;
			if(_colladaSID[parent] == sid)
				return parent;
			for each(var child:DisplayObject3D in parent.children)	
			{
				var obj:DisplayObject3D = findChildBySID(sid, child);
				if(obj) 
					return obj;
			}
			return null;
		}
		
		/**
		 * Tests whether a node has a baked transform
		 * 
		 * @param	node
		 */ 
		protected function isBakedMatrix(node:DaeNode):Boolean
		{
			if(!node.transforms.length || node.transforms.length > 1)
				return false;
			var transform:DaeTransform = node.transforms[0];
			return (transform.type == ASCollada.DAE_MATERIAL_ELEMENT);
		}
		
		/**
		 * Setup the skin controllers.
		 */ 
		protected function linkSkin(instance:DisplayObject3D, skin:DaeSkin):void
		{			
			var i:int;
			var found:Object = new Object();
			
			var controller:SkinController = new SkinController(instance as Skin3D);

			controller.bindShapeMatrix = new Matrix3D(skin.bind_shape_matrix);
			controller.joints = new Array();
			controller.vertexWeights = new Array();
			controller.invBindMatrices = new Array();
			
			for(i = 0; i < skin.joints.length; i++)
			{
				var jointId:String = skin.joints[i];
				
				if(found[jointId])
					continue;
					
				var joint:DisplayObject3D = _colladaIDToObject[jointId];
				if(!joint)
					joint = _colladaSIDToObject[jointId];
				if(!joint)
					throw new Error("Couldn't find the joint id = " + jointId);

				var vertexWeights:Array = skin.findJointVertexWeightsByIDOrSID(jointId);
				if(!vertexWeights)
					throw new Error("Could not find vertex weights for joint with id = " + jointId);
					
				var bindMatrix:Array = skin.findJointBindMatrix2(jointId);
				if(!bindMatrix || bindMatrix.length != 16)
					throw new Error("Could not find inverse bind matrix for joint with id = " + jointId);
				
				controller.joints.push(joint);
				controller.invBindMatrices.push(new Matrix3D(bindMatrix));
				controller.vertexWeights.push(vertexWeights);
				
				found[jointId] = true;
			}
			
			_controllers.push(controller);
		}
		
		/**
		 * Setup the skin controllers.
		 */ 
		protected function linkSkins():void
		{
			_numSkins = 0;
			
			for(var object:* in _skins)
			{
				var instance:TriangleMesh3D = object as TriangleMesh3D;
				if(!instance)
					throw new Error("Not a Skin3D?");
				linkSkin(instance, _skins[object]);
				_numSkins++;
			}
		}
		
		/**
		 * Loads the next material.
		 * 
		 * @param	event
		 */ 
		protected function loadNextMaterial(event:FileLoadEvent=null):void
		{
			if(event)
			{
				var previous:BitmapFileMaterial = event.target as BitmapFileMaterial;
				if(_rightHanded && previous)
					BitmapMaterialTools.mirrorBitmapX(previous.bitmap);
			}
			
			if(_queuedMaterials.length)
			{
				var data:Object = _queuedMaterials.shift();
				var url:String = data.url;
				var symbol:String = data.symbol;
				var target:String = data.target;
				
				url = url.replace(/\.tga/i, "."+DEFAULT_TGA_ALTERNATIVE);
				
				var material:BitmapFileMaterial = data.material;
				material.addEventListener(FileLoadEvent.LOAD_COMPLETE, loadNextMaterial);
				material.addEventListener(FileLoadEvent.LOAD_ERROR, onMaterialError);
				
				// shouldn't need the ?nc no cache filename now that BitmapFileMaterial has been fixed. 
                material.texture = url;

				if(useMaterialTargetName){
					material.name = target;
					this.materials.addMaterial(material, target);
				}else{
					material.name = symbol;
					this.materials.addMaterial(material, symbol);
				}
			}
			else
			{
				dispatchEvent(new FileLoadEvent(FileLoadEvent.COLLADA_MATERIALS_DONE, this.filename));

				onMaterialsLoaded();
				//buildScene();
			}
		}
		
		
		protected function onMaterialsLoaded() : void
		{
			
			if(this.parser.hasEventListener(Event.COMPLETE))
				this.parser.removeEventListener(Event.COMPLETE, onParseComplete);
			if(this.parser.hasEventListener(ProgressEvent.PROGRESS))
				this.parser.removeEventListener(ProgressEvent.PROGRESS, onParseProgress);
			
			//may have geometries to be parsed
			if(document.numQueuedGeometries)
			{
				this.parser.addEventListener(Event.COMPLETE, onParseGeometriesComplete);
				//this.parser.addEventListener(ProgressEvent.PROGRESS, onParseGeometriesProgress);
				this.parser.readGeometries();
			}
			else
			{
				buildScene(); 
			}
			
			
			
			
		}
		
		protected function onParseGeometriesComplete(e:Event) : void
		{
			if(this.parser.hasEventListener(Event.COMPLETE))
				this.parser.removeEventListener(Event.COMPLETE, onParseGeometriesComplete);
			buildScene(); 
		}
		
		/**
		 * Merge geometries.
		 * 
		 * @param target The target geometry to merge to.
		 * @param source The source geometry
		 * @param material Optional material for triangles, only used when a triangle has no material.
		 */ 
		protected function mergeGeometries(target:GeometryObject3D, source:GeometryObject3D, materialInstances:Array=null):void
		{
			if(materialInstances && materialInstances.length)
			{
				var firstMaterial:MaterialObject3D = materialInstances[0];
				
				for each(var triangle:Triangle3D in source.faces)
				{
					var correctMaterial:Boolean = false;
					for each(var material:MaterialObject3D in materialInstances)
					{
						if(material === triangle.material)
						{
							correctMaterial = true;
							break;
						}
					}
					triangle.material = correctMaterial ? triangle.material : firstMaterial;
				}
			}
			target.vertices = target.vertices.concat(source.vertices);
			target.faces = target.faces.concat(source.faces);
			target.ready = true;
		}

		/**
		 * Called when a BitmapMaterial failed to load.
		 * 
		 * @param	event
		 */ 
		protected function onMaterialError(event:Event):void
		{
			loadNextMaterial();	
		}
		
		/**
		 * Called when the parser completed parsing animations.
		 * 
		 * @param	event
		 */ 
		protected function onParseAnimationsComplete(event:Event):void
		{	
			buildAnimationChannels();
					
			_channels = this.getAnimationChannels() || new Array();	
			_currentFrame = _totalFrames = 0;
			_startTime = _endTime = 0;
			
			for each(var channel:AbstractChannel3D in _channels)
			{
				_totalFrames = Math.max(_totalFrames, channel.keyFrames.length);	
				_startTime = Math.min(_startTime, channel.startTime);
				_endTime = Math.max(_endTime, channel.endTime);
				channel.updateToTime(0);
			}
			
			PaperLogger.info( "animations COMPLETE (#channels: " + _channels.length + " #frames: " + _totalFrames + ", startTime: " + _startTime + " endTime: " + _endTime+ ")");
			
			dispatchEvent(new FileLoadEvent(FileLoadEvent.ANIMATIONS_COMPLETE, this.filename));
			
			if(_autoPlay)
				play();
		}
		
		/**
		 * Called on parse animations progress.
		 * 
		 * @param	event
		 */ 
		protected function onParseAnimationsProgress(event:ProgressEvent):void
		{
			PaperLogger.info( "animations #" + event.bytesLoaded + " of " + event.bytesTotal);
		}
		
		/**
		 * Called when the DaeReader completed parsing.
		 * 
		 * @param	event
		 */
		protected function onParseComplete(event:Event):void
		{
			var reader:DaeReader = event.target as DaeReader;
			
			this.document = reader.document;
			
			_textureSets = new Object();
			_colladaID = new Dictionary(true);
			_colladaSID = new Dictionary(true);
			_colladaIDToObject = new Object();
			_colladaSIDToObject = new Object();
			_objectToNode = new Object();
			_skins = new Dictionary(true);
			
			buildMaterials();
			loadNextMaterial();
		}
		
		/**
		 * Called on parsing progress.
		 * 
		 * @param	event
		 */ 
		protected function onParseProgress(event:ProgressEvent):void
		{
			dispatchEvent(new FileLoadEvent(FileLoadEvent.LOAD_PROGRESS, this.filename, event.bytesLoaded, event.bytesTotal, null, null, true, false));
		}
		
		/** Whether the COLLADA uses Y-up, Z-up otherwise. */
		public function get yUp():Boolean
		{
			if(this.document){
				return (this.document.asset.yUp == ASCollada.DAE_Y_UP);
			}else{
				return false;
			}
		}
		
	}
}

