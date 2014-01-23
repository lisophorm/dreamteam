package model.entity
{
	public class TeamDTO
	{
		public function TeamDTO()
		{
		}
		[Bindable]
		public var teamID : String;
		
		[Bindable]
		public var teamName : String;
		
		[Bindable]
		public var logoImage : String;
	}
}