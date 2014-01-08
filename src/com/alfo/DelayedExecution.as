package com.alfo
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class DelayedExecution
	{
		private var
		_obj:Object,
		_func:Function,
		_args:Array;
		/*
		*  new DelayedExecution(100, Math, round, 4.5);
		*
		*  parameters:
		*  - delay
		*  - object
		*  - function
		*  - parameters
		*/
		public function DelayedExecution(... arguments)
		{
			if (arguments.length < 3) {
				trace('DelayedExecution-Error: missing arguments');
			} else {
				if (arguments[0] is uint || arguments[0] is Number) {
					if (arguments[1] is Object) {
						if (arguments[2] is Function) {
							_obj = arguments[1];
							_func = arguments[2];
							_args = [];
							if (arguments.length > 3) {
								for (var i:uint = 3; i < arguments.length; i++) {
									_args.push(arguments[i]);
								}
							}
							var t:Timer = new Timer(arguments[0] as Number, 1);
							t.addEventListener(TimerEvent.TIMER, exec);
							t.start();
						} else trace('DelayedExecution-Error: third argument should be a function');
					} else trace('DelayedExecution-Error: seconds argument should be an object (this-context of function)');
				} else trace('DelayedExecution-Error: first argument should be a number (milliseconds delay)');
			}
		}
		
		private function exec(e:Event = null):void
		{
			_func.apply(_obj, _args);
		}
	}
}
