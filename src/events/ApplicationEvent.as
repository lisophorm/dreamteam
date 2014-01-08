package events
{
	import flash.events.Event;
	
	public class ApplicationEvent extends Event
	{
		public static var SAVE_TYPE:String = "SAVE_TYPE";
		public static var LOGOUT:String = "LOGOUT";
		public static var POPUP_OPEN:String = "POPUP_OPEN";
		public static var POPUP_CLOSE:String = "POPUP_OPEN";



		public var value:Object=null;
		public function ApplicationEvent(type:String="",value:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.value = value;
			super(type, bubbles, cancelable);
		}
	}
}