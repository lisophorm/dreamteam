package views.renderer
{
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import mx.controls.Label;
	import flash.filters.BitmapFilterQuality;
	import spark.filters.DropShadowFilter
	import spark.filters.GlowFilter
	
	import spark.components.supportClasses.ItemRenderer;
	
	
	public class logoRenderer extends ItemRenderer
	{
		public function logoRenderer()
		{
			super();
			
			// need an override method for rendering hitarea only around image (but if they are transparent - it might be an issue)
		
		
		}
		override protected function createChildren():void
		{
			super.createChildren();
		
		//	this.hitArea.width = 418;
		//	this.hitArea.height = 360;
		//	this.hitArea = this.createHitArea();
			
			
		}
		override protected function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ) : void
		{        
			super.updateDisplayList(unscaledWidth, unscaledHeight);
//			super.updateDisplayList(unscaledWidth, unscaledHeight);
			/*
			graphics.clear();
			graphics.beginFill(0,0);
			graphics.drawRect(0, 0, 200, 200);
			graphics.endFill();
			*/
		}
		
	
		protected function createHitArea():Sprite
		{
			var s:Sprite = new Sprite();
			s.graphics.beginFill(0xFFFFFF,1);
			s.graphics.drawRect(0,0, 418,360);
			s.graphics.endFill();
			return s;
		}
	
		
	}
}