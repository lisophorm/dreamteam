package views.layouts    
{
	
	import com.alfo.utils.Console;
	import com.greensock.*;
	
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import mx.core.ILayoutElement;
	import mx.core.IVisualElement;
	import mx.utils.object_proxy;
	
	import spark.components.supportClasses.GroupBase;
	import spark.core.NavigationUnit;
	import spark.layouts.supportClasses.LayoutBase;
	
	
	
	public class Carousel extends LayoutBase
	{
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function Carousel()
		{
			super();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  gap
		//----------------------------------
		
		private var _gap:Number = 0;
		
		/**
		 *  The gap between the items
		 */
		public function get gap():Number
		{
			return _gap;
		}
		
		public function set gap(value:Number):void
		{
			_gap = value;
			var layoutTarget:GroupBase = target;
			if (layoutTarget)
			{
				layoutTarget.invalidateSize();
				layoutTarget.invalidateDisplayList();
			}
		}
		
		
		
		
		//----------------------------------
		//  axisAngle
		//----------------------------------
		
		/**
		 *  @private  
		 *  The total width of all items, including gap space.
		 */
		private var _totalWidth:Number;
		
		/**
		 *  @private  
		 *  Cache which item is currently in view, to facilitate scrollposition delta calculations
		 */
		private var _centeredItemIndex:int = 0;
		private var _centeredItemCircumferenceBegin:Number = 0;
		private var _centeredItemCircumferenceEnd:Number = 0;
		private var _centeredItemDegrees:Number = 0;
		
		/**
		 *  The axis to tilt the 3D wheel 
		 */
		private var _axis:Vector3D = new Vector3D(0, 1, 0.1);
		
		private var axisX:Vector3D = Vector3D.X_AXIS;
		private var axisY:Vector3D = Vector3D.Y_AXIS;
		private var axisZ:Vector3D = Vector3D.Z_AXIS;
		
		private var myDegreeIs:Number=0;
		private var myDegreeIsOld:Number=0;
		private var vElements:Array=[];
		
		/**
		 *  The angle to tilt the axis of the wheel
		 */
		public function set axisAngle(value:Number):void
		{
			// _axis = new Vector3D(0, Math.cos(Math.PI * value /180), Math.sin(Math.PI * value /180));
			
			_axis = new Vector3D(0, Math.cos(Math.PI * value /180), Math.sin(Math.PI * value /180));
			
			
			//var axis:Vector3D = Vector3D.Y_AXIS;
			
			
			
			//_axis = new Vector3D(0, 1, 0.1);
			var layoutTarget:GroupBase = target;
			if (layoutTarget)
			{
				layoutTarget.invalidateSize();
				layoutTarget.invalidateDisplayList();
			}
		}
		public function get axisYAngle():Number
		{
			return myDegreeIs % 360;
		}
		public function set axisYAngle(value:Number):void
		{
			// _axis = new Vector3D(0, Math.cos(Math.PI * value /180), Math.sin(Math.PI * value /180));
			
			
			
			
			myDegreeIs =  value ;
			
			
			//var axis:Vector3D = Vector3D.Y_AXIS;
			
			
			
			//_axis = new Vector3D(0, 1, 0.1);
			var layoutTarget:GroupBase = target;
			if (layoutTarget)
			{
				layoutTarget.invalidateSize();
				layoutTarget.invalidateDisplayList();
			}
		}
		
		
		/**
		 *  @private 
		 *  Given the radius of the sphere, return the radius of the
		 *  projected sphere. Uses the projection matrix of the
		 *  layout target to calculate.
		 */    
		private function projectSphere(radius:Number, radius1:Number):Number
		{
			var fl:Number = target.transform.perspectiveProjection.focalLength;
			var alpha:Number = Math.asin( radius1 / (radius + fl) );
			return fl * Math.tan(alpha) * 2;
		}
		
		/**
		 *  @private
		 *  Given the totalWidth, maxHeight and maxHalfWidthDiagonal, calculate the bounds of the items
		 *  on screen.  Uses the projection matrix of the layout target to calculate. 
		 */
		private function projectBounds(totalWidth:Number, maxWidth:Number, maxHeight:Number, maxHalfWidthDiagonal:Number):Point
		{
			// Use the the total width as a circumference of an imaginary circle which we will use to
			// align the items in 3D:
			var radius:Number = _totalWidth * 0.5 / Math.PI;
			
			// Now since we are going to arrange all the items along circle, middle of the item being the tangent point,
			// we need to calculate the minimum bounding circle. It is easily calculated from the maximum width item:
			var boundingRadius:Number = Math.sqrt(radius * radius + 0.25 * maxWidth * maxWidth);
			
			var projectedBoundsW:Number = _axis.z * _axis.z * (maxHalfWidthDiagonal + 2 * radius) + 
				projectSphere(radius, boundingRadius ) * _axis.y * _axis.y;
			
			var projectedBoundsH:Number = Math.abs(_axis.z) * (maxHalfWidthDiagonal + 2 * radius) +
				maxHeight * _axis.y * _axis.y;
			
			return new Point(projectedBoundsW + 10, projectedBoundsH + 10);
		}
		
		/**
		 *  @private 
		 *  Iterates through all the items, calculates the projected bounds on screen, updates _totalWidth member variable.
		 */    
		private function calculateBounds():Point
		{
			// Calculate total width:
			_totalWidth = 0;
			
			var maxHeight:Number = 0;
			var maxWidth:Number = 0;
			var maxD:Number = 0;
			
			// Add up all the widths
			var iter:LayoutIterator = new LayoutIterator(target);
			var el:ILayoutElement;
			while (el = iter.nextElement())
			{
				var preferredWidth:Number = el.getPreferredBoundsWidth(false /*postTransform*/);
				var preferredHeight:Number = el.getPreferredBoundsHeight(false /*postTransform*/);
				
				// Add up item width
				_totalWidth += preferredWidth;
				
				// Max up item size
				maxWidth = Math.max(maxWidth, preferredWidth);
				maxHeight = Math.max(maxHeight, preferredHeight);
				
				maxD = Math.max(maxD, Math.sqrt(preferredWidth * preferredWidth / 4 + 
					preferredHeight * preferredHeight));    
			}
			
			// Add up the gap
			_totalWidth += gap * iter.numVisited;
			
			// Project        
			return projectBounds(_totalWidth, maxWidth, maxHeight, maxD);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods: LayoutBase
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		override public function set target(value:GroupBase):void
		{
			// Make sure that if layout is swapped out, we clean up
			if (!value && target)
			{
				target.maintainProjectionCenter = false;
				
				var iter:LayoutIterator = new LayoutIterator(target);
				var el:ILayoutElement;
				while (el = iter.nextElement())
				{
					el.setLayoutMatrix(new Matrix(), false /*triggerLayout*/);
				}
			}
			
			super.target = value;
			
			// Make sure we turn on projection the first time the layout
			// gets assigned to the group
			if (target)
				target.maintainProjectionCenter = true;
		}
		
		override public function measure():void
		{
			var bounds:Point = calculateBounds();
			
			target.measuredWidth = bounds.x;
			target.measuredHeight = bounds.y;
		}
		
		override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			// Get the bounds, this will also update _totalWidth
			var bounds:Point = calculateBounds();
			
			// Update the content size
			target.setContentSize(_totalWidth + unscaledWidth, bounds.y); 
			
			var radius:Number = _totalWidth * 0.5 / Math.PI;
			var gap:Number = this.gap;
			_centeredItemDegrees = Number.MAX_VALUE;
			
			var scrollPosition:Number = target.horizontalScrollPosition;
			var totalWidthSoFar:Number = 0;
			// Subtract the half width of the first element from totalWidthSoFar: 
			var iter:LayoutIterator = new LayoutIterator(target);
			var el:ILayoutElement = iter.nextElement();
			if (!el)
				return;
			totalWidthSoFar -= el.getPreferredBoundsWidth(false /*postTransform*/) / 2;
			
			// Set the 3D Matrix for all the elements:
			iter.reset();
			
			//=========================================================================
			//============Iteration Loop===============================================
			//=========================================================================
			var index:int = 0;
			var counter:int=0;
			while (el = iter.nextElement())
			{ 
				
				// Size the item, no need to position it, since we'd set the computed matrix
				// which defines the position.
				el.setLayoutBoundsSize(NaN, NaN, false /*postTransform*/);
				var elementWidth:Number = el.getLayoutBoundsWidth(false /*postTransform*/);
				var elementHeight:Number = el.getLayoutBoundsHeight(false /*postTransform*/); 
				
				
				var degrees:Number = 360 * (totalWidthSoFar + elementWidth/2 - scrollPosition ) / _totalWidth  + myDegreeIs; 
				
				// Remember which item is centered, this is used during scrolling
				var curDegrees:Number = degrees % 360;
				if (Math.abs(curDegrees) < Math.abs(_centeredItemDegrees))
				{
					_centeredItemDegrees = curDegrees;
					_centeredItemIndex = iter.curIndex;
					_centeredItemCircumferenceBegin = totalWidthSoFar - gap;
					_centeredItemCircumferenceEnd = totalWidthSoFar + elementWidth + gap;
				}
				
				// Calculate and set the 3D Matrix 
				
				//var m:Matrix3D = new Matrix3D();
				//m.appendTranslation(-elementWidth/2, -elementHeight/2 + radius * _axis.z, -radius * _axis.y );
				//m.appendRotation(-degrees, _axis);
				
				//m.appendTranslation(unscaledWidth/2, unscaledHeight/2, radius * _axis.y);
				//Rotation of Everything
				//m.appendRotation(-myDegreeIs, axisY);
				
		//		el.setLayoutMatrix3D(m, false /*triggerLayout*/);
				var mtx:Matrix = new Matrix();
				
				var a:Number = (.5+.5*Math.cos(Math.PI*2*(degrees/360)))
				
				//Console.log( (iter.curIndex/countElements), this);
			    var scale:Number = (.35+.35*Math.cos(Math.PI*2*(degrees/360)))
				var x:Number = -80+(600)*(1+Math.sin(2*Math.PI*(degrees/360)));
				
				var y:Number = 500+80*Math.cos(2*Math.PI*degrees/360);
				//mtx.translate( (x-elementWidth/2), y-elementHeight/2);
				mtx.scale( scale, scale);
			
				
				mtx.translate( x-elementWidth*(1+scale)/2, y-elementHeight*(1+scale)/2 );
				// cant set alpha value?
				el.setLayoutMatrix( mtx, false);
			
				//el.setLayoutBoundsPosition( totalWidthSoFar + elementWidth + gap, 0);
				//el.setLayoutBoundsSize( elementWidth*(_centeredItemIndex/16), elementHeight*(_centeredItemIndex/16))
				
				
				// Update the layer for a correct z-order
				if (el is IVisualElement)
				{
					IVisualElement(el).depth = Math.abs( Math.floor(180 - Math.abs(degrees % 360)) );
					
					IVisualElement(el).alpha = Math.max(a,.1);
					
					vElements[index] = { visualElement: IVisualElement(el), degrees: -curDegrees%360 };
					index +=1;
					
				}
				// Move on to next item
				totalWidthSoFar += elementWidth + gap;
				counter+=1;
			}
			
			
			
		}
	
		public function getDegree( vi:Object ):Number
		{
			var index:int = findIndex( IVisualElement(vi) );
			var d:Number = vElements[index].degrees;
			Console.log("current degrees:"+d, this);
			Console.log("descision"+(Math.abs(d+this.axisYAngle)>180), this)
			return Math.abs(d+this.axisYAngle)>180 ? (360+d+this.axisYAngle)%360 : (d+this.axisYAngle);
		}
		private function findIndex( vi:IVisualElement ):int
		{
			for (var i:int=0;i<vElements.length;i++)
			{
				if (IVisualElement(vElements[i].visualElement) == vi)
				{
					return i;
				}
			}
			return -1;
		}
		private function scrollPositionFromCenterToNext(next:Boolean):Number
		{
			var iter:LayoutIterator = new LayoutIterator(target, _centeredItemIndex);
			var el:ILayoutElement = next ? iter.nextElementWrapped() : iter.prevElementWrapped();
			if (!el)
				return 0;
			
			var elementWidth:Number = el.getLayoutBoundsWidth(false /*postTransform*/);
			
			var value:Number; 
			if (next)
			{
				if (_centeredItemDegrees > 0.1)
					return (_centeredItemCircumferenceEnd + _centeredItemCircumferenceBegin) / 2;
				
				value = _centeredItemCircumferenceEnd + elementWidth/2;
				if (value > _totalWidth)
					value -= _totalWidth;
			}
			else
			{
				if (_centeredItemDegrees < -0.1)
					return (_centeredItemCircumferenceEnd + _centeredItemCircumferenceBegin) / 2;
				
				value = _centeredItemCircumferenceBegin - elementWidth/2;
				if (value < 0)
					value += _totalWidth;
			}
			return value;     
		}
		
		override protected function scrollPositionChanged():void
		{
			if (target)
				target.invalidateDisplayList();
		}
		
		override public function getHorizontalScrollPositionDelta(scrollUnit:uint):Number
		{
			var g:GroupBase = target;
			if (!g || g.numElements == 0)
				return 0;
			
			var value:Number;     
			
			switch (scrollUnit)
			{
				case NavigationUnit.LEFT:
				{
					value = target.horizontalScrollPosition - 30;
					if (value < 0)
						value += _totalWidth;
					return value - target.horizontalScrollPosition;
				}
					
				case NavigationUnit.RIGHT:
				{
					value = target.horizontalScrollPosition + 30;
					if (value > _totalWidth)
						value -= _totalWidth;
					return value - target.horizontalScrollPosition;
				}
					
				case NavigationUnit.PAGE_LEFT:
					return scrollPositionFromCenterToNext(false) - target.horizontalScrollPosition;
					
				case NavigationUnit.PAGE_RIGHT:
					return scrollPositionFromCenterToNext(true) - target.horizontalScrollPosition;
					
				case NavigationUnit.HOME: 
					return 0;
					
				case NavigationUnit.END: 
					return _totalWidth;
					
				default:
					return 0;
			}       
		}
		
		/**
		 *  @private
		 */ 
		override public function getScrollPositionDeltaToElement(index:int):Point
		{
			var layoutTarget:GroupBase = target;
			if (!layoutTarget)
				return null;
			
			var gap:Number = this.gap;     
			var totalWidthSoFar:Number = 0;
			var iter:LayoutIterator = new LayoutIterator(layoutTarget);
			
			var el:ILayoutElement = iter.nextElement();
			if (!el)
				return null;
			totalWidthSoFar -= el.getLayoutBoundsWidth(false /*postTransform*/) / 2;
			
			iter.reset();
			while (null != (el = iter.nextElement()) && iter.curIndex <= index)
			{    
				var elementWidth:Number = el.getLayoutBoundsWidth(false /*postTransform*/);
				totalWidthSoFar += gap + elementWidth;
			}
			return new Point(totalWidthSoFar - elementWidth / 2 -gap - layoutTarget.horizontalScrollPosition, 0);
		}
		
		/**
		 *  @private
		 */ 
		override public function updateScrollRect(w:Number, h:Number):void
		{
			var g:GroupBase = target;
			if (!g)
				return;
			
			if (clipAndEnableScrolling)
			{
				// Since scroll position is reflected in our 3D calculations,
				// always set the top-left of the srcollRect to (0,0).
				g.scrollRect = new Rectangle(0, verticalScrollPosition, w, h);
			}
			else
				g.scrollRect = null;
		}
		
		
		
	}
	
}

import spark.components.supportClasses.GroupBase;
import mx.core.ILayoutElement;

class LayoutIterator 
{
	private var _curIndex:int;
	private var _numVisited:int = 0;
	private var totalElements:int;
	private var _target:GroupBase;
	private var _loopIndex:int = -1;
	
	public function get curIndex():int
	{
		return _curIndex;
	}
	
	public function LayoutIterator(target:GroupBase, index:int=-1):void
	{
		totalElements = target.numElements;
		_target = target;
		_curIndex = index;
	}
	
	public function nextElement():ILayoutElement
	{
		while (_curIndex < totalElements - 1)
		{
			var el:ILayoutElement = _target.getElementAt(++_curIndex);
			if (el && el.includeInLayout)
			{
				++_numVisited;
				return el;
			}
		}
		return null;
	}
	
	public function prevElement():ILayoutElement
	{
		while (_curIndex > 0)
		{
			var el:ILayoutElement = _target.getElementAt(--_curIndex);
			if (el && el.includeInLayout)
			{
				++_numVisited;
				return el;
			}
		}
		return null;
	}
	
	public function nextElementWrapped():ILayoutElement
	{
		if (_loopIndex == -1)
			_loopIndex = _curIndex;
		else if (_loopIndex == _curIndex)
			return null;
		
		var el:ILayoutElement = nextElement();
		if (el)
			return el;
		else if (_curIndex == totalElements - 1)
			_curIndex = -1;
		return nextElement();
	}
	
	public function prevElementWrapped():ILayoutElement
	{
		if (_loopIndex == -1)
			_loopIndex = _curIndex;
		else if (_loopIndex == _curIndex)
			return null;
		
		var el:ILayoutElement = prevElement();
		if (el)
			return el;
		else if (_curIndex == 0)
			_curIndex = totalElements;
		return prevElement();
	}
	
	public function reset():void
	{
		_curIndex = -1;
		_numVisited = 0;
		_loopIndex = -1;
	}
	
	public function get numVisited():int
	{
		return _numVisited;
	}
}

