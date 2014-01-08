package events
{
	import flash.events.Event;
	
	public class ScrollSupportEvent extends Event
	{
		public static var UPDATE:String = "UPDATE_SCROLLSUPPORT_DEGREES";


		public var degree:Number = 0;
		
		public var exitFunction:Function = null;
		public function ScrollSupportEvent(type:String="",value:Number=0, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			if (type == ScrollSupportEvent.UPDATE)
			{
				this.degree = value;
			}
			super(type, bubbles, cancelable);
		}
	}
}