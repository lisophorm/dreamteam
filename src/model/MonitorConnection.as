package model
{
	import air.net.URLMonitor;
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.net.URLRequest;


	public class MonitorConnection extends EventDispatcher
	{
		
		public static var EVENT_USER_IDLE_TIMEOUT:String = "EVENT_USER_IDLE_TIMEOUT";
		public static var EVENT_INTERNET_NOT_AVAILABLE:String = "EVENT_INTERNET_NOT_AVAILABLE";
		public static var EVENT_INTERNET_AVAILABLE:String = "EVENT_INTERNET_AVAILABLE";

		protected var monitor:URLMonitor;
		public function MonitorConnection(url:String)
		{
			
			
			// Detecting online/offline network connectivity with a URLMonitor
			trace("monitoring: "+url);
			
			monitor = new URLMonitor(new URLRequest(url)); // change URL to URL desired
			monitor.addEventListener(StatusEvent.STATUS, onStatusChange);
			monitor.pollInterval = 20000;// Milliseconds
			monitor.start();
			
			NativeApplication.nativeApplication.idleThreshold = 60;
			NativeApplication.nativeApplication.addEventListener(Event.USER_IDLE, onUserIdle);
			
		}
		public function isConnected():Boolean
		{
			return monitor.available;
		}
		protected function onUserIdle(event:Event):void 
		{
			trace("User idle notification");
			this.dispatchEvent(new Event(MonitorConnection.EVENT_USER_IDLE_TIMEOUT));
		}
		protected function onStatusChange(e:StatusEvent):void
		{
			trace(e)
			trace(monitor.available);
			if (monitor.available) 
			{
				this.dispatchEvent(new Event(MonitorConnection.EVENT_INTERNET_AVAILABLE));

			} else {
				this.dispatchEvent(new Event(MonitorConnection.EVENT_INTERNET_NOT_AVAILABLE));
			}
		}

	}
}