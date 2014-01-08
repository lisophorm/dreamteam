package com.alfo.utils
{
	import flash.net.SharedObject;
	
	import mx.core.UIComponent;
	
	public class GreenScreenPrefs extends UIComponent
	{
		public var prefs:SharedObject=SharedObject.getLocal("greenScreenPrefs");
		public function GreenScreenPrefs()
		{
			super();
		}
		public function get photoShopPath():String {
			trace("photoshop path@"+prefs.data.photoPath);
			return prefs.data.photoPath;
		}
		public function set photoShopPath(thePath:String):void {
			prefs.data.photoPath=thePath;
		}
		
		public function get basePath():String {
			trace("settings path@"+prefs.data.photoPath);
			return prefs.data.basePath;
		}
		public function set basePath(thePath:String):void {
			prefs.data.basePath=thePath;
		}
	}
}