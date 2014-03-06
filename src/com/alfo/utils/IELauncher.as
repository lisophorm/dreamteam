package com.alfo.utils
{
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.system.Capabilities;
	
	
	public class IELauncher
	{
		
		
		private var process:NativeProcess;
		private var nativeProcessStartupInfo:NativeProcessStartupInfo;
		
		private var openCmd:File;
		private var closeCmd:File;
		
		private var args:Vector.<String>;
		
		public var bioPluginURL:String="192.168.0.150";
		
		private var isWindows:Boolean=false;
		
		public function IELauncher(url:String="") {
			if((Capabilities.os.indexOf("Windows") >= 0))
			{
				isWindows=true;
			}
			if(isWindows) {
				trace("birth of ielauncher");
				nativeProcessStartupInfo = new NativeProcessStartupInfo();  
				process = new NativeProcess();
				process.addEventListener(NativeProcessExitEvent.EXIT, onExit);
				process.addEventListener(Event.STANDARD_ERROR_CLOSE, standardErrorClose);
				process.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, onErrorData);
				process.addEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR, onIOError);
				process.addEventListener(Event.STANDARD_INPUT_CLOSE, standardInputClose);
				process.addEventListener(IOErrorEvent.STANDARD_INPUT_IO_ERROR, onIOError);
				process.addEventListener(ProgressEvent.STANDARD_INPUT_PROGRESS, standardInputProgress);
				process.addEventListener(Event.STANDARD_OUTPUT_CLOSE, standardOutpoutClose);
				process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onOutputData);
				process.addEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, onIOError);
			}
		}
		// incomplete
		public function setURL(theUrl:String):void {
			var pieces:Array
			if(theUrl.indexOf("/")!=-1) {
				pieces=theUrl.split("/");
			} else {
				pieces=theUrl.split("\\");
			}
			bioPluginURL=pieces[0];
			trace("url="+bioPluginURL);
		}
		
		
		public function launch():void {
			if(isWindows) {
				var cmd:File = new File("C:\\WINDOWS\\system32\\cmd.exe");
				//var svn:File = new File(File.applicationDirectory.nativePath + File.separator + svn.bat);
				openCmd=new File(File.applicationDirectory.nativePath+File.separator+"assets"+File.separator+"batchcommands"+File.separator+"launch.cmd");
				trace("path:"+openCmd.nativePath);
				if(openCmd.exists) {
					trace("file trovato!!!");
				} else {
					trace("file non trovato:"+openCmd.nativePath);
				}
				
				args = new Vector.<String>();                   
				args.push("/c", openCmd.nativePath);               
				
				
				nativeProcessStartupInfo.executable = cmd;
				nativeProcessStartupInfo.arguments = args;
				
				
				
				process.start(nativeProcessStartupInfo);
			}
		}
		
		public function kill():void
		{
			if(isWindows) {
				var cmd:File = new File("C:\\WINDOWS\\system32\\cmd.exe");
				openCmd=new File(File.applicationDirectory.nativePath+File.separator+"assets"+File.separator+"batchcommands"+File.separator+"kill.cmd");
				trace("path:"+openCmd.nativePath);
				if(openCmd.exists) {
					trace("file trovato!!!");
				} else {
					trace("file non trovato:"+openCmd.nativePath);
				}
				
				args = new Vector.<String>();                   
				args.push("/c", openCmd.nativePath);               
				
				
				nativeProcessStartupInfo.executable = cmd;
				nativeProcessStartupInfo.arguments = args;
				
				
				
				process.start(nativeProcessStartupInfo);
			}
		}
		
		public function standardOutpoutClose(evt:Event):void
		{
			trace(standardOutpoutClose);
		}
		
		public function standardInputProgress(evt:ProgressEvent):void
		{
			trace(standardInputProgress);
		}
		
		public function standardInputClose(event:Event):void
		{
			trace(standardInputClose);
		}
		
		public function standardErrorClose(event:Event):void
		{
			trace(standardErrorClose);
		}
		
		public function onOutputData(event:ProgressEvent):void
		{
			trace("Got: "+ process.standardOutput.readUTFBytes(process.standardOutput.bytesAvailable)); 
		}
		
		public function onErrorData(event:ProgressEvent):void
		{
			trace("ERROR -"+ process.standardError.readUTFBytes(process.standardError.bytesAvailable)); 
		}
		
		public function onExit(event:NativeProcessExitEvent):void
		{
			trace("Process exited with "+ event.exitCode);
		}
		
		public function onIOError(event:IOErrorEvent):void
		{
			trace("IO ERROR"+event.toString());
		}
		
	}
}

