package iamjosh.samples.components
{
	import flash.net.URLRequest;
	
	import mx.controls.Image;
	import mx.core.UIComponent;
	
	import org.bytearray.gif.player.GIFPlayer;
	
	public class AnimatedGIFImage extends Image
	{
		private var _gifImage  : UIComponent;
		
		public function AnimatedGIFImage()
		{
			super();
			this._gifImage  = new UIComponent();
		}
		
		override public function set source(value : Object) : void
		{
			if (!value is String)
			{
				throw new ArgumentError("Source must be of type String");
			}
			
			super.source = value;
		}
		
		override protected function createChildren() : void
		{
			super.createChildren();
			var player : GIFPlayer = new GIFPlayer();
			player.load(new URLRequest(this.source as String));
			this._gifImage.addChild(player);
		}
		
		override protected function updateDisplayList(unscaledWidth : Number, unscaledHeight : Number) : void
		{
			this.addChild(this._gifImage);
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
	}
}