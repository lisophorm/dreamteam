package views.layouts.supportClasses
{
	import com.alfo.utils.Console;
	
	import spark.effects.animation.Animation;
	import spark.effects.animation.MotionPath;
	import spark.effects.animation.SimpleMotionPath;
	import spark.effects.easing.IEaser;
	import spark.effects.easing.Linear;
	import spark.effects.easing.Sine;
	
	import views.controls.supportClasses.AnimationTarget;

	/**
	 *  A AnimationNavigatorLayoutBase class is a base class for navigator layouts
	 *  that can animation between indices.
	 * 
	 *  <p>Subclasses need to set the <code>animationType</code> in the constructor,
	 *  and should use the <code>animationValue</code>to layout elements.</p> 
	 * 
	 *  @mxml
	 *
	 *  <p>The <code>&lt;st:AnimationNavigatorLayoutBase&gt;</code> tag inherits all of the
	 *  tag attributes of its superclass, and adds the following tag attributes:</p>
	 *
	 *  <pre>
	 *  &lt;st:AnimationNavigatorLayoutBase
	 *    <strong>Properties</strong>
	 *    duration="700"
	 *    easer="{spark.effects.easing.Linear( 0, 1 )}"
	 *  /&gt;
	 *  </pre>
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion Flex 4
	 */
	public class AnimationNavigatorLayoutBase extends NavigatorLayoutBase
	{
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Class Constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  An animationType value passed to the constructor.
		 *  When the animation type is "direct", the selectedIndex is immediately set
		 *  to the proposedIndex and the selectedIndexOffset is animated from 1 to 0.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		protected static const DIRECT:String = "direct";
		
		/**
		 *  An animationType value passed to the constructor.
		 *  When the animation type is "indirect", the selectedIndex and selectedIndexOffset
		 *  are both animated. The selectedIndexOffset gets a value between -0.5 and 0.5.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		protected static const INDIRECT:String = "indirect";
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor. 
		 * 
		 *  @param animationType The type of animation. 
		 *  
		 *  @see #
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */ 
		public function AnimationNavigatorLayoutBase( animationType:String )
		{
			super();
			
			_animationType = animationType;
			easer = new Linear( 0, 1 );
			duration = 700;
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 */
//		private var _proposedSelectedIndex2			: int = -1;
//		
//		/**
//		 *  @private
//		 */
//		private var _proposedSelectedIndex2Offset	: Number = 0;
		
		/**
		 *  @private
		 */
		private var _animationType:String = DIRECT;
		
		
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  duration
		//----------------------------------    
		
		/**
		 *  @private
		 *  Storage property for easer.
		 */
		private var _duration:Number;
		
		/** 
		 *  The duration of the animation in milliseconds. 
		 *
		 *  @default 700
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get duration():Number
		{
			return _duration;
		}
		/**
		 *  @private
		 */
		public function set duration(value:Number):void
		{
			if( _duration == value ) return;
			
			_duration = value;
			animation.duration = _duration;
		}
		
		
		//----------------------------------
		//  easer
		//----------------------------------    
		
		/**
		 *  @private
		 *  Storage property for easer.
		 */
		private var _easer:IEaser;
		
		/**
		 *  The easing behavior for this effect. 
		 *  This IEaser object is used to convert the elapsed fraction of 
		 *  the animation into an eased fraction, which is then used to
		 *  calculate the value at that eased elapsed fraction.
		 * 
		 *  @default spark.effects.easing.Linear( 0, 1 )
		 *
		 *  @see spark.effects.easing.Linear
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get easer():IEaser
		{
			return _easer;
		}
		/**
		 *  @private
		 */
		public function set easer(value:IEaser):void
		{
			if( _easer == value ) return;
			
			_easer = value;
			animation.easer = _easer;
		}
		
		
		//----------------------------------
		//  animationValue
		//----------------------------------
		
		/**
		 *  @private
		 *  Storage property for animationValue.
		 */
		private var _animationValue:Number = 0;
		
		/**
		 *  If the <code>animationType</code> is "direct" the <code>animationValue</code>
		 *  will ease from 1 to 0. If set to <code>animationType</code> is "indirect" the
		 *  <code>animationValue</code> will ease from the current value of <code>selectedIndex</code>
		 *  to the new <code>selectedIndex</code>.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function get animationValue():Number
		{
			return _animationValue % numElementsInLayout;
//			return animation.isPlaying ? _animationValue : 0;
		}
		
		
		//----------------------------------
		//  animation
		//----------------------------------   
		
		/**
		 *  @private
		 *  Storage property for animation.
		 */
		private var _animation:Animation;
		
		/**
		 *  @private
		 */
		private function get animation():Animation
		{
			if( _animation ) return _animation;
			_animation = new Animation();
			var animTarget:AnimationTarget = new AnimationTarget();
			animTarget.updateFunction = animationTargetUpdateFunction;
			animTarget.endFunction = animationTargetEndFunction;
//			switch( _animationType )
//			{
//				case DIRECT :
//				{
//					animTarget.updateFunction = animationTargetUpdateFunction;
//					animTarget.endFunction = animationTargetEndFunction;
//					break;
//				}
//				case INDIRECT :
//				{
//					animTarget.updateFunction = animationTargetUpdateFunctionIndirect;
//					animTarget.endFunction = animationTargetEndFunctionIndirect;
//				}
//			}
			
			_animation.animationTarget = animTarget;
			return _animation;
		}
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Returns whether the layout is currently animating.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function isAnimating():Boolean
		{
			return animation.isPlaying;
		}
		
		/**
		 *  To be overridden in subclasses. <code>indicesInView()</code> should be invoked
		 *  in this method updating the first and last index in view.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		protected function updateIndicesInView():void
		{
			
		}
		
		/**
		 *  @private
		 */
		private function startAnimation( from:Number, to:Number ):void
		{
			animation.stop();
			//Console.log("from:"+from+"==this.numElementsInLayout:"+this.numElementsInLayout, this) 
			//Console.log("to:"+to+"==this.numElementsInLayout:"+this.numElementsInLayout, this) 
			// from - to value provides a step by step animation sequence
			// what is the shortest path between from and to? 
			// e.g. total is 20, from = 17, to = 0, then the shortest route is from = -3 and to = 0 or from = from-total and to = to
			// how do we find shortest route Math.min(from-to, total-from)==(from-to) ? from : from-total. 
			// cases like from = 1, to = 4, produces a from of Math.min(1-4, 20-1) ? 1 : 1-20 => 1
			// cases like from = 17, to = 20, produces a from of Math.min(17-20, 20-17) ? 17 : 17-20 => 17
			// cases like from = 17, to = 4, produces a from of Math.min(17-4, 20-17) ? 17 : 17-20 => -3
				
			// cases like from = 3, to = 17, produces a from of Math.min(3-17, 20-3) ? 3 : 3-20 => 3
			// so we need a subcase 
				
			var total:Number  = this.numElementsInLayout-1;
			if (from<(total/2) && to>(total/2) )
			{
				// crossing from min into max
				if ((to-from)>(total/2))
					from = total + from + 1;
			} else if (from>(total/2) && to<(total/2) )
			{
				//crossing from max into min
				if ((from-to)>(total/2))
					from = from - (total+1);
			}
			//Console.log("from:"+from+"==to:"+to, this)
			animation.motionPaths = new <MotionPath>[ new SimpleMotionPath( "animationIndex", from, to ) ];
			animation.play();
		}
		
		/**
		 *  @private
		 */
		private function animationTargetUpdateFunction( animation:Animation ):void
		{
//			super.invalidateSelectedIndex( selectedIndex, animation.currentValue[ "animationIndex" ] );
			_animationValue = animation.currentValue[ "animationIndex" ];
		//	Console.log("animationTargetUpdateFunction:"+ animation.currentValue[ "animationIndex" ], this );
//			updateIndicesInView();
			invalidateTargetDisplayList();
		}
		
		/**
		 *  @private
		 */
		private function animationTargetEndFunction( animation:Animation ):void
		{
//			super.invalidateSelectedIndex( selectedIndex, animation.currentValue[ "animationIndex" ] );
			_animationValue = animation.currentValue[ "animationIndex" ];
//			updateIndicesInView();
			invalidateTargetDisplayList();
		}
		
		
		
//		/**
//		 *  @private
//		 */
//		private function animationTargetUpdateFunctionIndirect( animation:Animation ):void
//		{
//			var newValue:Number = animation.currentValue[ "animationIndex" ];
//			var index:int = Math.round( newValue );
//			super.invalidateSelectedIndex( index, newValue - index );
////			updateIndicesInView();
//		}
//		
//		/**
//		 *  @private
//		 */
//		private function animationTargetEndFunctionIndirect( animation:Animation ):void
//		{
//			var newValue:Number = animation.currentValue[ "animationIndex" ];
//			var index:int = Math.round( newValue );
//			super.invalidateSelectedIndex( index, newValue - index );
////			updateIndicesInView();
//		}
		
		
		
		
		//--------------------------------------------------------------------------
		//
		//  Overridden Methods
		//
		//--------------------------------------------------------------------------
		
//		override protected function updateSelectedIndex(index:int, offset:Number):void
//		{
//			var animate:Boolean = selectedIndex != index;
//			
//			super.updateSelectedIndex( index, offset );
//			
//			if( animate )
//			{
//				switch( _animationType )
//				{
//					case DIRECT :
//					{
//						//						super.invalidateSelectedIndex( index, 1 );
//						startAnimation( 1, 0 );
//						break;
//					}
//					case INDIRECT :
//					{
//						//						startAnimation( selectedIndex + selectedIndexOffset, _proposedSelectedIndex2 + _proposedSelectedIndex2Offset );
//						startAnimation( index - selectedIndex, 0 );
//						break;
//					}
//				}
//			}
//			else
//			{
//				updateIndicesInView();
//			}
//		}
		
		/**
		 *  @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */  
		override protected function invalidateSelectedIndex(index:int, offset:Number):void
		{
			var prevIndex:int = selectedIndex;
			
			super.invalidateSelectedIndex( index, 0 );
			
//			if( index == selectedIndex ) return;
			
//			if( index == _proposedSelectedIndex2 && _proposedSelectedIndex2Offset == offset ) return;
//			
//			_proposedSelectedIndex2 = index;
//			_proposedSelectedIndex2Offset = offset;
			
			if( prevIndex == -1 || !duration || isNaN( duration ) || index == -1 || prevIndex == index )
			{
//				super.invalidateSelectedIndex( index, 0 );
			}
			else
			{
//				super.invalidateSelectedIndex( index, 0 );
				
				switch( _animationType )
				{
					case DIRECT :
					{
//						super.invalidateSelectedIndex( index, 1 );
						startAnimation( 1, 0 );
						break;
					}
					case INDIRECT :
					{
						startAnimation( animation.isPlaying ? animationValue : prevIndex, index );
						break;
					}
				}
				
			}
		}
		
		override protected function updateDisplayListBetween():void
		{
			super.updateDisplayListBetween();
			
			updateIndicesInView();
		}
	}
}