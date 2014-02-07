package events
{
	import flash.events.Event;
	
	public class ViewEvent extends Event
	{
		public static var NAVIGATE:String = "NAVIGATE";
		
		public static var LOCATION_RESTART:String = "restart";
		public static var LOCATION_CONFIG:String = "Config";
		public static var LOCATION_FACEBOOK_FORCELOGOUT:String = "Force logout";

		public static var LOCATION_REGISTRATION : String = "LocationRegistration";
		public static var LOCATION_STANDARD_REGISTRATION:String = "Standard registration";
		public static var LOCATION_SELECT_USER_TYPE:String = "Select user type";
		public static var LOCATION_SELECT_REGISTRATION_TEAM : String = "SelectRegistrationTeam";
		public static var LOCATION_FACEBOOK:String = "Facebook";
		public static var LOCATION_FACEBOOK_REGISTERED:String = "Facebook registered";
		public static var LOCATION_SELECT_TEAM:String = "SelectTeam";
		public static var LOCATION_SELECT_GAME_TEAM : String = "SelectGameTeam";
		public static var LOCATION_TEAM_SELECTED:String = "Team selected";
		public static var LOCATION_REGISTRATION_COMPLETE:String = "Registration complete";
		public static var LOCATION_PHOTO_SELECTED_USER:String = "location photo selected user";
		public static var LOCATION_GAME:String = "Game";
		public static var LOCATION_GAME_COMPLETE:String = "Game Complete";
		public static var LOCATION_RESULT:String = "Result";
		public static var LOCATION_SELECT_GAME_OR_RESULT:String = "Select Game or Result";
		public static var LOCATION_TEAMSHEETS:String = "Teamsheets"
		public static var LOCATION_WELCOME_BACK : String = "WelcomeBack";
		
		

		public var object:Object = null;
		public var location:String = "";

		public function ViewEvent(location:String = "HOME", val:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			trace("**** View '"+location+"'");
			object = val;
			this.location = location
			super(ViewEvent.NAVIGATE, bubbles, cancelable);
		}
	}
}