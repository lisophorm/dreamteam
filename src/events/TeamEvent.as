package events
{
	import flash.events.Event;
	import flash.xml.XMLNode;
	
	public class TeamEvent extends Event
	{
		public static var ADD:String = "ADD";
		public static var UPDATE:String = "UPDATE";
		public static var TEAM_INFO:String = "TEAM_INFO";

		public var data:Object =null;
		public var exitFunction:Function = null;
		public function TeamEvent(type:String="",val:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			data = val;			
			super(type, bubbles, cancelable);
		}
	}
}