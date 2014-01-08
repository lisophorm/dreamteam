package com.alfo
{
	import flash.events.Event;
	
	internal class ShowSyncError extends Event
	{
		
		public var errorMessage:String;
		
		public static const IOERROR:String="ioerror";
		
		public function ShowSyncError(type:String,message:String)
		{
			super(type);
			errorMessage=message;
		}
	}
}