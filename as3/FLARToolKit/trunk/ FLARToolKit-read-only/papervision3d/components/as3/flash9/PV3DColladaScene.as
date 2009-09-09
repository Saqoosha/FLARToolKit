/**
* @author John Grden
*/
package org.papervision3d.components.as3.flash9
{
	import com.blitzagency.xray.logger.util.PropertyTools;
	
	import fl.data.SimpleDataProvider;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import org.papervision3d.components.as3.collections.MaterialsListItem;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.events.FileLoadEvent;
	import org.papervision3d.materials.BitmapAssetMaterial;
	import org.papervision3d.materials.BitmapFileMaterial;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.materials.ColorMaterial;
	import org.papervision3d.materials.MaterialsList;
	import org.papervision3d.materials.MovieAssetMaterial;
	import org.papervision3d.objects.Collada;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.materials.InteractiveBitmapFileMaterial;
	import org.papervision3d.materials.InteractiveMovieAssetMaterial;
	import org.papervision3d.materials.InteractiveBitmapAssetMaterial;
	import org.papervision3d.components.as3.utils.ObjectController;
	
	/**
	* Dispatched when the collada file and materials have been completely parsed and loaded.
	* 
	* @eventType org.papervision3d.components.as3.flash9.PV3DColladaScene.SCENE_COMPLETE
	*/
	[Event(name="sceneComplete", type="flash.events.Event")]
	
	/**
	* Dispatched while the collada file is loading.  
	 * <p>Event carries 2 properties:
	 * <ul>
	 * <li>1.  bytesLoaded
	 * <li>2.  bytesTotal
	* </ul>
	 * </p>
	* @eventType org.papervision3d.components.as3.flash9.PV3DColladaScene.SCENE_LOAD_PROGRESS
	*/
	[Event(name="sceneLoadProgress", type="flash.events.Event")]
	
	/**
	* Dispatched when the collada object cannot load the file specified either because of security or non-existance
	* <p>
	 * provides a property called "message" which is the actual load error initially received.
	 * </p>
	* @eventType org.papervision3d.components.as3.flash9.PV3DColladaScene.SCENE_LOAD_ERROR
	*/
	[Event(name="sceneLoadError", type="flash.events.Event")]
	
	/**
	 * PV3DColladaScene is the main class for the Flash CS3 COLLADA component.
	 * </p>
	 * <p>It's main purpose is to provide the developer/designer with drag and drop functionality to render a COLLADA scene with a camera and Scene3D.  Full access to a materials list and objects
	 * is given through the api:
	 * <ul>
	 * <li>scene</li>
	 * <li>camera</li>
	 * <li>collada</li>
	 * </ul>
	 * </p>
	 * <p>The component includes a Custom Panel via Windows>other panels>PV3DPanel</P>
	 * <p>To use the component, drag it from the components list on to the stage in the Flash IDE.  First, set the local directory by clicking on the folder icon in the Panel.
	 * Then, select the DAE (COLLADA) file to use.  At this point, you *should* see your 3D scene being rendered.
	 * </p>
	 * <p>You might have to play with the scale if you're not seeing the scene or camera Z (move it out more).
	 * </p>
	 * <p>If you textured your models with bitmaps in your 3D application, COLLADA retains those file paths and Papervision3D will attempt to dynamically load them for you IF you don't 
	 * provide a materials list.  So, there is a good chance you'll see your scene fully textured once you've provided the local directory and file paths.
	 * </p>
	 * <p>If you provide a MaterialsList via the property inspector, there are 3 types supported:
	 * <ul>
	 * <li>Bitmap: BitmapAssetMaterial - a bitmap defined in the library</li>
	 * <li>MovieClip: MovieAssetMaterial - a MovieClip defined in the library</li>
	 * <li>File: BitmapFileMaterial - an external bitmap file</li>
	 * </ul>
	 * 
	 * </p>
	 * @see org.papervision3d.components.as3.collections.MaterialsListItem
	 */	
	public class PV3DColladaScene extends PV3DScene3D
	{
		
		/**
		* @eventType sceneComplete
		*/		
		public static const SCENE_COMPLETE	:String = "sceneComplete";
		
		/**
		* @eventType sceneLoadProgress
		*/		
		public static const SCENE_LOAD_PROGRESS	:String = "sceneLoadProgress";
		
		/**
		* @eventType sceneLoadError
		*/		
		public static const SCENE_LOAD_ERROR	:String = "sceneLoadError";
		
		/**
		* A boolean flag letting the component know whether or not to show trace output
		*/		
		public var debug						:Boolean = false;
		
				
		private var _materialsList						:MaterialsList = new MaterialsList();
		/**
		* The MaterialsList object that is used by the component if one is provided.  This is set at design-time and is read-only at runtime
		*/
		public function get materialsList():MaterialsList { return _materialsList; }
		
		private var _col						:Collada;		
		private var _colladaFile				:String = "";
		private var _localPath					:String = "";
		private var _sceneScale					:Number = 0;
		private var rebuildCollada				:Boolean = false;
		private var _rotationList				:Object = {pitch:0, yaw:0, roll:0};
		private var _extMaterials				:SimpleDataProvider = new SimpleDataProvider();
		
		private var materialsQue				:Dictionary = new Dictionary();
		
		private var previewTimer				:Timer = new Timer(25,0);
		
		/**
		 * @private
		 * @note Called when the component is actually running in a compiled SWF at runtime, rather than LivePreview
		 * @param p_piSetting
		 * 
		 */	
		override public function set componentInspectorSetting(p_piSetting:Boolean):void
		{
			_componentInspectorSetting = p_piSetting;
			if(debug) log.debug("componentInspectorSetting", p_piSetting);
			if(!_componentInspectorSetting) 
			{
				initApp();
				if(debug) log.debug("colladaFile?", colladaFile);
				if(debug) log.debug("isLivePreview?", isLivePreview);
				
				// just start by building materials and it'll light up from there.
				createMaterials();
			}
		}
		
		/**
		 * @private
		 */	
		override public function get componentInspectorSetting():Boolean
		{
			return _componentInspectorSetting;
		}
		
		/**
		 * The Papervision3D Collada object created for the component's use.
		 * @return Collada object
		 * 
		 */		
		public function get collada():Collada
		{
			return _col;
		}
		
		public function set collada(col:Collada):void
		{
			_col = col;
		}
		
		/**
		 * this fires after all of the properties have been updated.  The Property Inspector (pi) sets all properties for a component even if only 1 is updated.
		 * So, the modified LivePreviewParent I created makes this call to propertyInspectorSetting and passes a flag to let the component know that's its
		 * ok to proceed with dealing with the changes.
		 * 
		 * Changes have to be dealt with in a specific order.  Materials, then collada WITH scale passed in the constructor, then rotation after collada is completely loaded.
		 * @private
		 */	
		override public function set propertyInspectorSetting(p_piSetting:Boolean):void
		{
			_propertyInspectorSetting = p_piSetting;
			if(!p_piSetting)
			{
				// if we haven't initialized yet, do so
				if(!isAppInitialized) initApp();
				
				if(debug) log.debug("********** isLivePreview?", isLivePreview);
				
				if(rebuildCollada || collada == null) 
				{
					if(debug) log.debug("GO CREATE MATERIALS");
					createMaterials();
				}else
				{
					if(debug) log.debug("GO update collada");
					finalizeColladaLoad();
				}
			}
			if(debug) log.debug("propertyInspectorSetting", p_piSetting);
		}
		
		/**
		 * @private
		 */	
		override public function get propertyInspectorSetting():Boolean
		{
			return _propertyInspectorSetting;
		}
		
		[Inspectable (name="Scene Rotation", defaultValue=false, type="Boolean")]
		/**
		* Boolean flag indicating whether or not to add mouse drag/rotation abilities to the collada container.  Clicking 
		 * yes will allow you to use simple dragging to rotate the scene.
		*/		
		public var sceneRotation					:Boolean = true;
			
		[Inspectable (type="String", defaultValue="", name="Local Directory") ]
		/**
		 * @private
		 */	
		public function set localPath(p_localPath:String):void
		{
			if(p_localPath != _localPath && p_localPath.length > 0) 
			{
				p_localPath = p_localPath.split("\\").join("/");
				_localPath = p_localPath.substring(p_localPath.length-1) == "/" ?  p_localPath : p_localPath + "/";
			}
		}
		/**
		 * @private
		 */	
		public function get localPath():String
		{
			return _localPath;
		}
				
		[Inspectable (type="String", defaultValue="", name="Collada File") ]
		/**
		 * A relative reference to the external collada file to be used
		 * @return String 
		 * 
		 */	
		public function set colladaFile(p_colladaFile:String):void
		{
			if(_colladaFile != p_colladaFile && p_colladaFile.length > 0) 
			{
				if(debug) log.debug("set colladaFile", p_colladaFile);
				rebuildCollada = true;
				_colladaFile = p_colladaFile;
			}
		}
	
		public function get colladaFile():String
		{
			return _colladaFile;
		}
		
		[Collection(name="Materials List", collectionClass="fl.data.SimpleDataProvider", collectionItem="org.papervision3d.components.as3.collections.MaterialsListItem", identifier="item")]
		/**
		 * @private
		 */	
		public function set extMaterials(p_extMaterials:SimpleDataProvider):void
		{
			if(p_extMaterials.dataProvider.length > 0 && !checkMaterialListsMatch(extMaterials, p_extMaterials)) 
			{
				if(debug) log.debug("****** COMPARE", checkMaterialListsMatch(extMaterials, p_extMaterials));
				_extMaterials = p_extMaterials;
				rebuildCollada = true;
			}
		}
		/**
		 * @private
		 */	
		public function get extMaterials():SimpleDataProvider { return _extMaterials; }
		
		[Inspectable (type="Number", defaultValue=.01, name="Scale") ]
		/**
		 * @private
		 */	
		public function set sceneScale(p_scale:Number):void
		{
			if(p_scale == _sceneScale) return;
			_sceneScale = p_scale;
			if(isLivePreview && (collada != null && colladaFile.length > 0)) 
			{
				// force an object redraw
				rebuildCollada = true;
			}
		}
		/**
		 * @private
		 */	
		public function get sceneScale():Number
		{
			return _sceneScale;
		}
		
		[Inspectable (type="Object", defaultValue="pitch:0, yaw:0, roll:0", name="Initial Rotation") ]
		/**
		 * @private
		 */	
		public function set rotationList(p_rotation:Object):void
		{
			_rotationList = p_rotation;
		}
		/**
		 * @private
		 */	
		public function get rotationList():Object
		{
			return _rotationList;
		}
		
		public function PV3DColladaScene()
		{
			//BitmapMaterial.AUTO_MIP_MAPPING = true;
			super();
		}
		
		/**
		 * @private
		 */	
		override protected function init3D():void
		{
			super.init3D();
			
			initScene();
		}
		
		/**
		 * @private
		 */	
		protected function initScene():void
		{

		}
		
		/**
		 * @private
		 * Creates the 3 main types of materials and loads external materials.
		 * 
		 * Note that smooth has been pulled. It was causing rte's about smooth not being a property of the materials.  Will have to fix later.
		 */	
		protected function createMaterials():void
		{
			if(debug) log.debug("extMaterials", extMaterials.dataProvider.length);
			var loadCollada:Boolean = false;
			
			if(extMaterials.dataProvider.length > 0)
			{
				// reset the materials que
				materialsQue = new Dictionary();
				
				var clrMat:ColorMaterial = new ColorMaterial(0x00ff00, .75);
				
				for(var i:Number=0;i<extMaterials.dataProvider.length;i++)
				{
					// materials are in library with linkage
					var materialsListItem:MaterialsListItem = MaterialsListItem(extMaterials.dataProvider[i]);
					
					switch(materialsListItem.materialType.toLowerCase())
					{
						case "bitmap":
							if(isLivePreview)
							{								
								clrMat.oneSide = materialsListItem.singleSided;
								materialsList.addMaterial(clrMat, materialsListItem.materialName);
							}else
							{
								var bam:BitmapAssetMaterial = materialsListItem.interactive ? new InteractiveBitmapAssetMaterial(materialsListItem.materialLinkageID) : new BitmapAssetMaterial(materialsListItem.materialLinkageID);;
								loadCollada = true;
								bam.oneSide = materialsListItem.singleSided;
								//bam.smooth = materialsListItem.smooth;
								materialsList.addMaterial(bam, materialsListItem.materialName);
							}
							if(!checkForFileLoads(extMaterials)) loadCollada = true;
						break;
						
						case "file":
							var fileLocation:String = isLivePreview ? _localPath + materialsListItem.materialFileLocation : materialsListItem.materialFileLocation;
							fileLocation = fileLocation.split("\\").join("/");
							if(debug) log.debug("File to load", fileLocation);
							var bm:BitmapFileMaterial = materialsListItem.interactive ? new InteractiveBitmapFileMaterial("") : new BitmapFileMaterial("");
							bm.addEventListener(FileLoadEvent.LOAD_COMPLETE, handleBitmapFileLoadComplete);
							materialsQue[bm] = false;
							// setting the texture property actually causes the load of the file
							bm.texture = fileLocation;
							//bm.smooth = materialsListItem.smooth;
							// because we didn't set the URL through the constructor, we have to set it manually if we want it back in the event thats disatched
							bm.url = fileLocation;
							bm.oneSide = materialsListItem.singleSided;
							materialsList.addMaterial(bm, materialsListItem.materialName);
						break;
						
						case "movieclip":
							if(isLivePreview)
							{
								clrMat.oneSide = materialsListItem.singleSided;
								materialsList.addMaterial(clrMat, materialsListItem.materialName);
							}else
							{
								var mov:MovieAssetMaterial = materialsListItem.interactive ? new InteractiveMovieAssetMaterial(materialsListItem.materialLinkageID, materialsListItem.transparent) : new MovieAssetMaterial(materialsListItem.materialLinkageID, materialsListItem.transparent);
								if(materialsListItem.animated) mov.animated = true;
								mov.oneSide = materialsListItem.singleSided;
								//mov.smooth = materialsListItem.smooth;
								materialsList.addMaterial(mov, materialsListItem.materialName);
							}
							if(!checkForFileLoads(extMaterials)) loadCollada = true;
						break;
					}
				}
			}else
			{
				if(debug) log.debug("*************************** NO MATERIALS TO LOAD***************");
				loadCollada = true;
			}
			
			if(loadCollada)	createColladaScene();
		}
		
		/**
		 * @private
		 * Checks the load que to make sure all files are loaded before loading the collada scene
		 */	
		private function checkForFileLoads(obj:SimpleDataProvider):Boolean
		{			
			for(var i:Number=0;i<obj.dataProvider.length;i++)
			{
				var materialsListItem:MaterialsListItem = MaterialsListItem(extMaterials.dataProvider[i]);
				if(debug) log.debug("@@@@@@@@@@@@@@@@ checkForFileLoads", materialsListItem.materialType.toLowerCase())
				if(materialsListItem.materialType.toLowerCase() == "file") return true;
			}
			
			return false;
		}
		
		/**
		 * @private
		 * When an external file is completely loaded, we receive this event and check to see if all the files have been loaded before loading the collada scene
		 */	
		protected function handleBitmapFileLoadComplete(e:FileLoadEvent):void
		{
			if(debug) log.debug("%%%%%% handleBitmapFileLoadComplete", e.file);
			materialsQue[e.target] = true;
			var bm:BitmapFileMaterial = BitmapFileMaterial(e.target);
			bm.removeEventListener(FileLoadEvent.LOAD_COMPLETE, handleBitmapFileLoadComplete);
			if(collada != null && materialsList.numMaterials > 0) collada.materials = materialsList;
			if(colladaFile.length > 0 && checkLoadedQue()) 
			{
				if(debug) log.debug("should load collada after getting all bitmaps");
				createColladaScene();
			}
		}
		
		/**
		 * @private
		 */	
		protected function checkLoadedQue():Boolean
		{
			for each(var items:Object in materialsQue)
			{
				if(!items) return false;
			}
			return true;
		}
		
		/**
		 * @private
		 */	
		override protected function stageResizeHandler(e:Event):void
		{			
			if(!resizeWithStage) return;
			if(debug) log.debug("stageResize");
			resizeStage();
		}
		
		/**
		 * @private
		 * Creates the Collada object and loads the file
		 */	
		protected function createColladaScene():void
		{
			if(colladaFile.length == 0) return;
			
			if(debug) log.debug("createColladaScene", colladaFile, scene == null);
			
			if(collada != null) scene.removeChild(collada);
			
			var fileLocation:String = isLivePreview ? _localPath + colladaFile : colladaFile;
			if(debug) log.debug("fileLocation for collada", fileLocation);
			
			if(collada) collada.container.graphics.clear();
			collada = new Collada(fileLocation, materialsList, sceneScale,{localPath:localPath});
			scene.addChild(collada);
			collada.addEventListener(FileLoadEvent.LOAD_COMPLETE, handleLoadComplete);
			//collada.addEventListener(FileLoadEvent.COLLADA_MATERIALS_DONE, handleLoadComplete);
			collada.addEventListener(FileLoadEvent.LOAD_PROGRESS, handleLoadProgress);
			collada.addEventListener(FileLoadEvent.LOAD_ERROR, handleLoadError);
			collada.addEventListener(FileLoadEvent.SECURITY_LOAD_ERROR, handleLoadError);
		}
		
		/**
		 * @private
		 * Called when Collada file is completely rendered
		 */	
		protected function handleLoadComplete(e:FileLoadEvent):void
		{
			if(debug) log.debug("handleLoadComplete - Collada", e.file);
			// remove listeners
			collada.removeEventListener(FileLoadEvent.LOAD_COMPLETE, handleLoadComplete);
			collada.removeEventListener(FileLoadEvent.LOAD_PROGRESS, handleLoadProgress);
			collada.removeEventListener(FileLoadEvent.LOAD_ERROR, handleLoadError);
			collada.removeEventListener(FileLoadEvent.SECURITY_LOAD_ERROR, handleLoadError);
			
			finalizeColladaLoad();
		}
		
		/**
		 * @private
		 * Called when Collada progress event is dispatched
		 */	
		protected function handleLoadProgress(e:FileLoadEvent):void
		{
			dispatchEvent(new FileLoadEvent(SCENE_LOAD_PROGRESS, e.file, e.bytesLoaded, e.bytesTotal));
		}
		
		/**
		 * @private
		 * Called when Collada has an error with loading the DAE file specified
		 */	
		protected function handleLoadError(e:FileLoadEvent):void
		{
			dispatchEvent(new FileLoadEvent(SCENE_LOAD_ERROR, e.file, 0, 0, e.message));
		}
		
		/**
		 * @private
		 * Called after Collada file is loaded completely.  sets the rotation, and updates the scene.
		 */	
		protected function finalizeColladaLoad():void
		{			
			collada.rotationX = rotationList.pitch;
			collada.rotationY = rotationList.yaw;
			collada.rotationZ = rotationList.roll;			
			
			updateScene();
			
			dispatchEvent(new FileLoadEvent(SCENE_COMPLETE));
			
			// set to false so no unnecessary redraws occur
			rebuildCollada = false;
			
			if(sceneRotation && !isLivePreview)
			{
				ObjectController.getInstance().registerStage(this.stage);
				ObjectController.getInstance().registerControlObject(collada);
			}
			
			// for debugging
			if(debug) showChildren();
		}
		
		/**
		 * @private
		 * Just for testing to see the children of the collada object
		 */	
		private function showChildren():void
		{
			for each(var item:Object in collada.children) if(debug) trace("collada children: ", item.name);
		}
		
		/**
		 * @private
		 */	
		override protected function handleTimerUpdate(e:TimerEvent):void
		{
			updateScene();
		}
		
		/**
		 * @private
		 * Used for matching the materials list that comes in when an update occurs on the component at Designtime.  A brand new version is sent with every change to the 
		 * component at design time, so we have to crawl through and verify if it's been changed to really know if we need to re-render the collada scene.
		 */	
		private function checkMaterialListsMatch(obj_0:SimpleDataProvider, obj_1:SimpleDataProvider):Boolean
		{
			if(obj_0.dataProvider.length != obj_1.dataProvider.length) return false;
			
			for(var i:Number=0;i<obj_0.dataProvider.length;i++)
			{
				// materials are in library with linkage
				var m0:MaterialsListItem = MaterialsListItem(obj_0.dataProvider[i]);
				var m1:MaterialsListItem = MaterialsListItem(obj_1.dataProvider[i]);
								
				var props:Array = PropertyTools.getProperties(m0);
				
				for (var ii:Number=0;i<props.length;i++)
				{
					if(debug) log.debug("compare", m0[props[i].name] + ", " + m1[props[i].name]);
					if(m0[props[i].name] != m1[props[i].name]) return false;
				}
				
			}
			
			return true;
		}
	}
}