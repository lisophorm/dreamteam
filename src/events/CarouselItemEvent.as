package events
{
	import flash.events.Event;
	
	import model.entity.TeamDTO;
	
	import views.renderer.CarouseltemRenderer;
	
	public class CarouselItemEvent extends Event
	{
		public static const ITEM_SELECTED:String = "itemSelected";
		
		public var teamDTO:TeamDTO;
		
		public function CarouselItemEvent(type:String, data:TeamDTO, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			teamDTO = data;
		}
		
		override public function clone():Event
		{
			return new CarouselItemEvent(type, teamDTO, bubbles, cancelable);
		}
	}
}