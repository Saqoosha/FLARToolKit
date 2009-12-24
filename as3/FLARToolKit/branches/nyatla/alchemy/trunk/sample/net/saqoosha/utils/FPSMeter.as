package net.saqoosha.utils {
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	public class FPSMeter extends Sprite {
		
		private var _fpsText:TextField;
		private var _lastFrameTime:int;
		private var _lastUpdateTime:int;
		private var _frameCount:Number;
		private var _fps:Number;
		private var _performance:Number;
		private var _checkTimer:Timer;
		
		public function FPSMeter() {
			this._fpsText = new TextField();
			this._fpsText.defaultTextFormat = new TextFormat('Lucida Grande', 10, 0xffffff, true);
			this._fpsText.background = true;
			this._fpsText.backgroundColor = 0x0055ff;
			this._fpsText.height = 16;
			this._fpsText.width = 200;
			this.addChild(this._fpsText);
			
			this.addEventListener(Event.ADDED_TO_STAGE, this.setup);
		}
		
		private function setup(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, this.setup);
			this.stage.addEventListener(Event.ENTER_FRAME, this.countFrame);
			this._checkTimer = new Timer(1000, 0);
			this._checkTimer.addEventListener(TimerEvent.TIMER, this.update);
			this._checkTimer.start();
			this._lastFrameTime = this._lastUpdateTime = getTimer();
			this._frameCount = 0;
		}
		
		public function countFrame(e:Event):void {
			var now:int = getTimer();
			var performance:Number = now - this._lastFrameTime;
			this._fpsText.width = 5 * performance;
			this._fpsText.text = '' + int(this._fps * 100) / 100 + 'fps ' + performance + 'ms';
			this._lastFrameTime = now;
			this._frameCount++;
		}
		
		public function update(e:Event = null):void {
			var now:int = getTimer();
			var performance:Number = now - this._lastUpdateTime;
			this._fps = this._frameCount / (performance / 1000);
			this._lastUpdateTime = now;
			this._frameCount = 0;
		}
		
	}
	
}