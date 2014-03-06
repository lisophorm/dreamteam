package registration
{
	import flash.events.Event;
	
	public class RegistrationEvent extends Event
	{
		
		public static var SCAN_READY:String 		= "SCAN_READY";
		public static var SCAN_STEP_1:String	 	= "SCAN_STEP_1";
		public static var SCAN_STEP_2:String	 	= "SCAN_STEP_2";
		public static var SCAN_STEP_3:String 		= "SCAN_STEP_3";
		public static var SCAN_COMPLETED:String 	= "SCAN_COMPLETED";
		public static var SCAN_AGAIN:String			= "SCAN_AGAIN";
		public static var SCAN_RESTART:String 		= "SCAN_RESTART";
		public static var SCAN_CANCELLED:String 	= "SCAN_CANCELLED";
		public static var SCAN_REINITIALISE:String 	= "SCAN_REINITIALISE";
		
		public static var IO_ERROR:String 	= "NETWORK_ERROR";
		
		
		public static var USER_FOUND:String 			= "USER_FOUND";
		public static var USER_REGISTERED:String 			= "USER_REGISTERED";
		public static var USER_ALREADY_REGISTERED:String 	= "USER_ALREADY_REGISTERED";
		public static var USER_NOT_FOUND:String 			= "USER_NOT_FOUND";
		
		public static var ERROR:String = "ERROR";
		
		public var URN:String;
		public var message:String="";
		public function RegistrationEvent(type:String, URN:String, msg:String="", bubbles:Boolean=false, cancelable:Boolean=false)
		{
			trace(msg);
			this.URN = URN;
			this.message = msg;
			super(type, bubbles, cancelable);
		}
	}
}