package {

	import flash.events.Event;
	import org.papervision3d.objects.parsers.DAE;
	
	public class Earth extends PV3DARApp {
		
		private var _earth:DAE;
		
		public function Earth() {
			this.init('Data/camera_para.dat', 'Data/flarlogo.pat');
		}
		
		protected override function onInit():void {
			super.onInit();
			
			this._earth = new DAE();
			this._earth.load('model/earth.dae');
			this._earth.scale = 10;
			this._earth.rotationX = -90;
			this._baseNode.addChild(this._earth);
			
			this.addEventListener(Event.ENTER_FRAME, this._update);
		}
		
		private function _update(e:Event):void {
			this._earth.rotationZ += 0.5
		}
	}
}