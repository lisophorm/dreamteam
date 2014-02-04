package model.entity
{
	public class TeamDTO
	{
		public function TeamDTO()
		{
		}
		public var index : int;
		
		[Bindable]
		public var teamID : String;
		
		[Bindable]
		public var teamName : String;
		
		[Bindable]
		public var logoImage : String;
	}
}