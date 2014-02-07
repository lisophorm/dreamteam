package com.alfo.utils
{
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.filesystem.File;
	import com.alfo.utils.StringUtils;
	
	import mx.core.UIComponent;
	
	public class VirtualKeyboard extends UIComponent
	{
		private var exeDir:String;
		private var nativeProcessInfo:NativeProcessStartupInfo;
		private var process:NativeProcess;
		
		public function VirtualKeyboard()
		{
			super();
		}
		
		public function slideUp(exeDir:String):void {
			trace("slideup");
			if(StringUtils.trim(exeDir)!="") {
				trace("************* sliding up");
				var file:File=File.applicationDirectory.resolvePath(exeDir+"\\TouchIt.exe");
				trace("file is:"+file.nativePath);
				nativeProcessInfo=new NativeProcessStartupInfo();
				nativeProcessInfo.executable=file;
				process=new NativeProcess();
				process.start(nativeProcessInfo);
			} else {
				trace("slideup problem"+exeDir);
			}
		}
		
		public function slideDown(exeDir:String):void {
			
			if(StringUtils.trim(exeDir)!="") {
				
				var file:File=File.applicationDirectory.resolvePath(exeDir+"\\KillIt.exe");
				trace("file is:"+file.nativePath);
				nativeProcessInfo=new NativeProcessStartupInfo();
				nativeProcessInfo.executable=file;
				process=new NativeProcess();
				process.start(nativeProcessInfo);
			}
		}
		
	}
}