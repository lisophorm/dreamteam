package events
{
	import flash.events.Event;
	
	public class TeamSheetEvent extends Event
	{
		public static var ENTER_VIEW:String="ENTER";
		public static var EXIT_VIEW:String="EXIT";
		
		public function TeamSheetEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}