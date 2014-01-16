package views.controls.supportClasses.swipemanager
{
	import flash.events.Event;
	
	public class SwipeEvent extends Event
	{
		public static const SWIPE_RIGHT : String = "SWIPE_RIGHT";
		public static const SWIPE_LEFT : String = "SWIPE_LEFT";
		
		public function SwipeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}