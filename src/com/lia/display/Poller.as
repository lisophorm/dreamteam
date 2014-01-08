package com.lia.display {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;

	/**
	 * @author FlashDynamix
	 */
	dynamic public class Poller extends Sprite {

		protected var segments : int = 12;

		public function Poller() {
			super();
			
			this.mouseEnabled = this.mouseChildren = false;

			play();
		}

		public function set color(ct : ColorTransform) : void {
			for(var i : int = 1;i <= segments;i++) {
				MovieClip(this["pill" + i]).transform.colorTransform = ct;
			}
		}

		public function play() : void {
			var pill : MovieClip;
			var frame : int;
			for(var i : int = 1;i <= segments;i++) {
				pill = this["pill" + i];
				frame = int((i - 1) / (segments - 1) * 14) + 1;
				pill.gotoAndPlay(pill.totalFrames - frame);
			}
		}

		public function stop() : void {
			var pill : MovieClip;
			for(var i : int = 1;i <= segments;i++) {
				pill = this["pill" + i];
				pill.stop();
			}
		}
	}
}
