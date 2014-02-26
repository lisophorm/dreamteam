package com.alfo.utils
{

	
	import flash.display.Sprite;


	public class Console
	{
		private static var simpleSprite:Sprite;
		
		
		static public function log(s:*, obj:*) :void
		{
			/*if (simpleSprite==null)
			{	
				simpleSprite = new Sprite();
				MonsterDebugger.initialize(simpleSprite);
			}
			trace("["+obj+"] "+s);
			if (ExternalInterface.available)
				ExternalInterface.call("console.log", "["+obj+"] "+s.toString());

			MonsterDebugger.trace(obj==null ? simpleSprite : obj, "["+obj.toString().split(".")[obj.toString().split(".").length-1]+"] "+s.toString());
		} */
	}
}