package views.controls.supportClasses
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import mx.core.UIComponent;
	
	import events.ScrollSupportEvent;

	public class ScrollSupport extends EventDispatcher
	{
		protected var maxDegreeSpanforWidth:Number = 360;
		protected var _inertia:Number = 0;
		protected var _startPoint:Point;
		protected var scrollPoint:Point
		public var firstX:Number = 0;
		public var lastX:Number = 0;
		public var listX:Number = 0;
		public var minX:Number = 0;
		public var maxX:Number = 0;
		public var distance:Number = 0;
		public var scrollDetectionDistance:Number = 40;
		public var deltaMovement:Number = 0;
		public var isTouching:Boolean = false;
		protected var timer:Timer;
		public var tapEnabled:Boolean = false;
		
		protected var totalDegree:Number=0;
		
		protected var currentDegree:Number=0;
		protected var stage:Stage;
		protected var width:Number = 0
		protected var gs:Sprite;
		protected var wrapper:UIComponent;
		protected var tapDelayTime:Number;
		protected var maxTapDelayTime:Number;
		protected var fakeScrollbarVisible:Boolean = false;
		
		public function ScrollSupport( stage:Stage, width:Number, wrapper:UIComponent ):void
		{
			this.stage = stage;
			this.width = width;
			this.wrapper = wrapper;
			init();

		}
		public function init():void
		{
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown );
			timer = new Timer( 33 );
			timer.addEventListener( TimerEvent.TIMER, onListTimer);
			timer.start();
		}
		public function destroy():void
		{
			if(stage)
			{
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				stage.removeEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
				stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			}
			if(timer)
			{
				timer.removeEventListener( TimerEvent.TIMER, onListTimer);
				timer.stop();
				timer=null;
			}
			tapEnabled = false;
			
		}
		protected function onMouseDown( e:MouseEvent ):void 
		{
			trace("ScrollSupport :: onMouseDown :: " + totalDegree);
			// Set up listener - using stage - for global x,y
			stage.addEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
			stage.addEventListener( MouseEvent.MOUSE_UP, onMouseUp );
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			this._startPoint= new Point( e.stageX, e.stageY);
			
			minX = -(width/2);
			maxX = (width/2);
		}
		protected function onMouseMove( e:MouseEvent ):void 
		{
			calculateDegree( e );
		}
		protected function onMouseUp( e:MouseEvent ):void 
		{
			trace("ScrollSupport :: onMouseUp");
			totalDegree += currentDegree;
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown );
			stage.removeEventListener( MouseEvent.MOUSE_MOVE, onMouseMove );
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			if(isTouching) {
				isTouching = false;
				tapEnabled = true;
				inertia = (deltaMovement/width)*maxDegreeSpanforWidth;
			} else {
				tapEnabled = true;
				totalDegree += currentDegree;
			}
			
			onTapDisabled();
		}
		public function set inertia( n:Number ):void
		{
			_inertia = n;
		}
		public function get inertia( ):Number
		{
			return _inertia;
		}
		private function onListTimer(e:Event):void
		{
			// test for touch or tap event
			if(tapEnabled) {
				onTapDelay();
			}
			
			// scroll the list on mouse up
			if(!isTouching) {
				
				//Grind to halt
				if( Math.abs(inertia) > 1) {
					currentDegree += inertia;
					//distance += inertia;
					//totalDegree +=inertia
					inertia *= 0.9;
					tapEnabled = false;
					this.showFakeScrollbar( );
					this.dispatchEvent( new ScrollSupportEvent( ScrollSupportEvent.UPDATE, totalDegree + currentDegree ) );

				} else {
					inertia = 0;
					tapEnabled = true;
				}
				
			} else {
			}
		}
		
		public function onTapDelay():void
		{
			/*
			tapDelayTime++
			if (tapDelayTime > maxTapDelayTime)
			{
				//tap.selectItem
				tapDelayTime = 0;
				tapEnabled = false;
			}
			*/
		}
		public function onTapDisabled():void
		{
			/*
			if(tapItem){
				tapItem.unselectItem();
				tapEnabled = false;
				tapDelayTime = 0;
			}
			*/
		}
		public function calculateDegree( e:MouseEvent ):void
		{
			var d:Number = calculateDistance( e );
			// Distance as degrees must be calculated by looking at percentage
			var percentage:Number = distance / (maxX-minX); //TODO::needs fixing
			var deg:Number = percentage * maxDegreeSpanforWidth//360
				
			if (!isNaN(d))
			{
				// we can here dispatch an update event	
				currentDegree =  deg;
				
				this.dispatchEvent( new ScrollSupportEvent( ScrollSupportEvent.UPDATE, totalDegree+currentDegree ) );
				this.onTapDisabled();
					
			}
		}
		public function calculateDistance( e:MouseEvent ):Number
		{
			distance = (e.stageX - this._startPoint.x) / 4; // distance mouse has moved since beginning of recording
			
			// if distance moved is beyond a scrollDetectionDistance - let's consider it a touch
			if(Math.abs(distance) > scrollDetectionDistance)
			{
				isTouching = true;
				tapEnabled = false;
			}
			// if it is touching - let's calculate
			if(isTouching) {
			
				deltaMovement = e.stageX - lastX; 	// how much has the user moved since last event
				lastX = e.stageX;					// reset the lastX value
				
				//movement is beyond minimum -> rapidly reduced by square root 
				if(distance < minX)
					distance = minX - Math.sqrt(minX - distance);
				
				//movement is beyond maximum -> rapidly reduced by square root
				if(distance > maxX)
					distance = maxX + Math.sqrt(distance - maxX);
				
				showFakeScrollbar( e );	
				// The returned distance from the calculation is the total length of movement
				return distance;
			}
			//if user is not touching - return no number - and handle separatly
			return NaN
		}
		
		protected var degree_text:TextField;
		protected var totalDegree_text:TextField;
		protected var inertia_text:TextField;
		protected function showFakeScrollbar( e:MouseEvent=null ):void
		{
			if (this.fakeScrollbarVisible)
			{
				
			if (wrapper!=null && (e!=null || scrollPoint!=null))
			{
				if (gs==null)
					gs = new Sprite();
				
				if (degree_text==null)
				{
					degree_text = new TextField();
					wrapper.addChild( degree_text );
					degree_text.textColor = 0xFFFFFF;
				}
				if (totalDegree_text==null)
				{
					totalDegree_text = new TextField();
					wrapper.addChild( totalDegree_text );
					totalDegree_text.textColor = 0xFFFFFF;
				}
				if (inertia_text==null)
				{
					inertia_text = new TextField();
					wrapper.addChild( inertia_text );
					inertia_text.textColor = 0xFFFFFF;
				}

				if (!wrapper.contains( gs) )
				{
					wrapper.addChild( gs );
				}
				
				
					var scaleDown:Number = 1;
					if (e!=null)
					{
						scrollPoint = new Point( e.stageX, e.stageY);
						scrollPoint = wrapper.globalToContent( scrollPoint );
					}
					
					var recorded:Point = wrapper.globalToContent( this._startPoint );
							
			
					// draw scrollbar
					gs.graphics.clear();
					gs.graphics.lineStyle(1, 0xFFFFFF,.8);
					
					gs.graphics.moveTo( ( recorded.x-(width/2))*scaleDown, scrollPoint.y );
					gs.graphics.lineTo( ( recorded.x+(width/2))*scaleDown, scrollPoint.y );
					
					gs.graphics.lineStyle(2, 0xFF0000,.8);
					gs.graphics.moveTo( ( recorded.x*scaleDown), scrollPoint.y+2 );
					gs.graphics.lineTo( (recorded.x+distance)*scaleDown, scrollPoint.y+2 );
					
					//bar
					gs.graphics.lineStyle(1, 0xFFFFFF,.8);
					gs.graphics.beginFill(0xFF0000,.8)
					//end
					gs.graphics.drawCircle( scrollPoint.x*scaleDown, scrollPoint.y, 50);
					gs.graphics.beginFill(0x0000FF,.6)
					//start
					gs.graphics.drawCircle( recorded.x*scaleDown, scrollPoint.y, 25);
					gs.graphics.endFill();
					
					degree_text.x = scrollPoint.x-(degree_text.textWidth/2);
					degree_text.y = scrollPoint.y-(degree_text.textHeight+50);
					degree_text.text = Math.round(this.currentDegree).toString();
					
					
					totalDegree_text.x = scrollPoint.x-(totalDegree_text.textWidth/2);
					totalDegree_text.y = degree_text.y-(totalDegree_text.textHeight);
					totalDegree_text.text = Math.round((deltaMovement/width)*maxDegreeSpanforWidth).toString() //Math.round(this.totalDegree).toString();

					inertia_text.x = scrollPoint.x-(inertia_text.textWidth/2);
					inertia_text.y = totalDegree_text.y-(inertia_text.textHeight);
					inertia_text.text = this.inertia.toString();
					
			
			}
			}
		}
		
	}
}
