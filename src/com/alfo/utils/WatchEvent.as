package com.alfo.utils
{
	import flash.events.Event;
	
	public class WatchEvent extends Event
	{
		
		public static const ON_ADD_PHOTO:String = "onAddPhoto";
		
		public var customMessage:String = "";

		public function WatchEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}