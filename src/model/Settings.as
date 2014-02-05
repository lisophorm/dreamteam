package model
{
	import registration.UserData;

	public class Settings
	{
		public function Settings(s:SingletonEnforcer) 
		{
			if (s == null) throw new Error("Singleton, use MySingleton.instance");
		}
		
		public static function get instance():Settings 
		{
			if (_instance == null) 
				_instance = new Settings(new SingletonEnforcer());
			return _instance;
		}
		
		private static var _instance:Settings;
		
		private var _userData : UserData = new UserData();
		
		[Bindable]
		public function set userData(value:UserData):void 
		{
			_userData = value;
		}
		
		public function get userData():UserData 
		{
			return _userData;
		}
	}
}
class SingletonEnforcer {}