package org.papervision3d.scenes
{
	import flash.display.Sprite;
	import org.papervision3d.objects.DisplayObject3D;
	import com.blitzagency.xray.logger.XrayLog;
	import org.papervision3d.utils.InteractiveSceneManager;
	import org.papervision3d.core.proto.CameraObject3D;

	public class InteractiveScene3D extends MovieScene3D
	{
		//new
		public var interactiveSceneManager:InteractiveSceneManager;
		
		public function InteractiveScene3D(container:Sprite)
		{
			super(container);
			
			interactiveSceneManager = new InteractiveSceneManager(this);
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
		public override function renderCamera( camera :CameraObject3D ):void
		{
			interactiveSceneManager.resetFaces();
			super.renderCamera( camera );
			interactiveSceneManager.sortObjects();
		}		
	}
}