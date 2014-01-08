package com.alfo.utils
{
	import com.adobe.air.filesystem.FileMonitor;
	import com.adobe.air.filesystem.events.FileMonitorEvent;
	import com.alfo.utils.WatchEvent;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.utils.Timer;
	
	import mx.core.UIComponent;
	
	public class PictureWatcher extends UIComponent
	{
		public var wEvt:WatchEvent;
		
		public var monitor:FileMonitor;
		
		private var _watchFolder:String;
		
		public function PictureWatcher()
		{
			trace("picturewatcher init");
			super();

		}
		public function setWatchFolder(folder:String):void {
			_watchFolder=folder;

		}
		public function startWatch():void {
			monitor = new FileMonitor();
			monitor.addEventListener(FileMonitorEvent.CHANGE, onFileChange);
			monitor.addEventListener(FileMonitorEvent.MOVE, onFileMove);
			monitor.addEventListener(FileMonitorEvent.CREATE, onFileCreate);
			monitor.file = new File(_watchFolder);
			monitor.watch();
		}
		public function stopWatch():void 
		{
			if(monitor!=null) {
				monitor.removeEventListener(FileMonitorEvent.CHANGE, onFileChange);
				monitor.removeEventListener(FileMonitorEvent.MOVE, onFileMove);
				monitor.removeEventListener(FileMonitorEvent.CREATE, onFileCreate);
			}
			monitor=null;
		}
		private function checkFolder(event:TimerEvent):void {
			wEvt=new WatchEvent(WatchEvent.ON_ADD_PHOTO);
			wEvt.customMessage="gino";
			dispatchEvent(wEvt);
		}
		
		private function onFileChange(e:FileMonitorEvent):void
		{
			trace("file was changed");
			wEvt=new WatchEvent(WatchEvent.ON_ADD_PHOTO);
			wEvt.customMessage="gino";
			dispatchEvent(wEvt);
		}
		
		private function onFileMove(e:FileMonitorEvent):void
		{
			trace("file was moved");
			wEvt=new WatchEvent(WatchEvent.ON_ADD_PHOTO);
			wEvt.customMessage="gino";
			dispatchEvent(wEvt);
		}
		
		private function onFileCreate(e:FileMonitorEvent):void
		{
			trace("file was created");
			wEvt=new WatchEvent(WatchEvent.ON_ADD_PHOTO);
			wEvt.customMessage="gino";
			dispatchEvent(wEvt);
		}
	}
}