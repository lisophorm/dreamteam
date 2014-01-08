package events
{
	import flash.events.Event;
	
	public class UserEvent extends Event
	{
		public static var URN:String = "URN";
		public static var SCORE:String = "SCORE";
		public static var REGISTERED:String = "REGISTERED";
		public static var OPTIN_TERMS:String = "OPTIN_TERMS";
		public static var OPTIN_MARKETING:String = "OPTIN_MARKETING";


		public var urn:String="";
		public var score:Number=0;
		public var userType:String="";
		public var optin_marketing:Boolean=false;
		public var optin_terms:Boolean=false;
		public var id:int=-1;
		public var name:String ="";
		
		public var exitFunction:Function = null;
		public function UserEvent(type:String="",val:String="", id:int=-1, name:String="", bubbles:Boolean=false, cancelable:Boolean=false)
		{
			if (type == UserEvent.URN)
			{
				this.urn = val;
			}
			if (type == UserEvent.SCORE)
			{
				this.score = Number(val);
			}
			if (type == UserEvent.REGISTERED)
			{
				this.userType = val.toLowerCase();
				this.id = id;
				this.name = name;
			}
			if (type == UserEvent.OPTIN_TERMS)
			{
				this.optin_terms = val.toLowerCase() == "true" ? true : false;
			}
			if (type == UserEvent.OPTIN_MARKETING)
			{
				this.optin_marketing = val.toLowerCase()== "true" ? true : false;
			}
			
			super(type, bubbles, cancelable);
		}
	}
}