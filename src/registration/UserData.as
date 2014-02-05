package registration
{
	public class UserData
	{
		public function UserData()
		{
		}
		
		public var firstName : String;
		public var lastName : String;
		public var emailAddress : String;
		private var _urn : String  = "00000000";
		
		public function set urn(value:String):void 
		{
			_urn = value;
		}
		
		public function get urn():String 
		{
			return _urn;
		}
		
		public var teamID : int;
		public var greenscreenImageName : String;
		
		public var premierLeagueOptin : Boolean = false;
		public var clubOptin : Boolean = false;
		public var barclaysOptin : Boolean = false;
		public var imageID : String;
	}
}