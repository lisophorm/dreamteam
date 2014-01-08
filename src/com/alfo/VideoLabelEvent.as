package com.alfo
{
	import flash.events.Event;
	
	
	
	public class VideoLabelEvent extends Event
	{
		
		public static const CLICK:String="Clicked";
		public function VideoLabelEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type);
		}
	}
} 