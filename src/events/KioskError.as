package events
{
	import flash.events.Event;
	
	public class KioskError extends Event
	{
		public static var ERROR:String = "Error";

		public var message:String="";
		public var title:String="";
		public var exitFunction:Function = null;
		public function KioskError(type:String="",message:String="", title:String="", exitFunction:Function=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.exitFunction = exitFunction;
			this.message = message;
			this.title = title;
			super(type, bubbles, cancelable);
		}
	}
}