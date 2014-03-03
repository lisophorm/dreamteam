package events
{
	import flash.events.Event;
	
	public class LifecycleEvent extends Event
	{
		public static const FINALISE : String = "finalise";
		
		public function LifecycleEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event
		{
			return new LifecycleEvent(type, bubbles, cancelable);
		}
	}
}