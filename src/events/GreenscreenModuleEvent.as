package events
{
	import flash.events.Event;
	
	public class GreenscreenModuleEvent extends Event
	{
		public static var NOTIFY:String = "GREENSCREEN_NOTIFY";
		
		public var exitFunctionYes:Function = null;
		public var exitFunctionNo:Function = null;
		public var photopath:String ="";
		public function GreenscreenModuleEvent(exitFunctionYes:Function=null, exitFunctionNo:Function=null, photopath:String="", bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.exitFunctionYes = exitFunctionYes;
			this.exitFunctionNo = exitFunctionNo;
			this.photopath = photopath;
			super(NOTIFY, bubbles, cancelable);
		}
	}
}