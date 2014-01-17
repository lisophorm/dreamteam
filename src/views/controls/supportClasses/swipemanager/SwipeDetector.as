package views.controls.supportClasses.swipemanager
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	[Event(name="SWIPE_RIGHT", type="views.controls.supportClasses.swipemanager.SwipeEvent")]	
	[Event(name="SWIPE_LEFT", type="views.controls.supportClasses.swipemanager.SwipeEvent")]
	public class SwipeDetector extends UIComponent
	{
		private var mousePositions : Array;
		private var mouseRecorderTimer:Timer;
		
		private var positionsMaxLength : int = 18;
		private var zeroTime:int;
		private var clickInterval : int = 80;
		private var swipeThreshold : Number = 100;
		
		public function SwipeDetector()
		{
			super();
			
			mouseRecorderTimer = new Timer(20);
			mouseRecorderTimer.addEventListener(TimerEvent.TIMER, recordMouse);
			
			//addEventListener(Event.ADDED_TO_STAGE, enable);
		}
		
		public function enable(event : Event = null):void
		{
			if(stage)
			{
				stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			}
		}
		
		public function disable():void
		{
			if(stage)
			{
				stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			}
		}
		
		protected function recordMouse(event : TimerEvent) : void
		{
			mousePositions.push(stage.mouseX);
			if(mousePositions.length > positionsMaxLength)
			{
				mousePositions.shift();
			}
		}
		
		protected function mouseDownHandler(event : MouseEvent) : void
		{
			zeroTime = getTimer();	
			mouseRecorderTimer.start();
			mousePositions = [];
		}
		
		protected function mouseUpHandler(event : MouseEvent) : void
		{
			mouseRecorderTimer.stop();
			var elapsed : int = getTimer() - zeroTime;
			if(elapsed > clickInterval)
			{
				var lastSafePosition : int = Math.min(12, mousePositions.length);
				var positionOne : Number = mousePositions[0];
				var positionTwo : Number = mousePositions[lastSafePosition - 1];
				var deltaX : Number = positionTwo - positionOne;
				if(Math.abs(deltaX) > swipeThreshold)
				{
					if(deltaX > 0)
					{
						trace("SwipeDetector :: mouseUpHandler :: RIGHT");
						dispatchEvent(new SwipeEvent(SwipeEvent.SWIPE_RIGHT));
					}else
					{
						trace("SwipeDetector :: mouseUpHandler :: LEFT");
						dispatchEvent(new SwipeEvent(SwipeEvent.SWIPE_LEFT));
					}
				}
			}
		}
	}
}