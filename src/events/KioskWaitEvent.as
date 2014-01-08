package events
{
	import flash.events.Event;
	
	public class KioskWaitEvent extends Event
	{
		public static var NOTIFY:String = "WAIT_NOTIFY";
		public var message:String="";
		public function KioskWaitEvent(message:String="", bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.message = message;
			super(NOTIFY, bubbles, cancelable);
		}
	}
}