package model
{
	import com.alfo.utils.Console;
	
	import events.TeamEvent;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.xml.XMLNode;
	
	public class TeamModel extends EventDispatcher
	{
		public static var list:Array = [{type: "goalkeeper", shirtno: 1}, 
										{type: "defender", shirtno: 2}, {type: "defender", shirtno: 5}, {type: "defender", shirtno: 6}, {type: "defender", shirtno: 3},
										{type: "midfielder", shirtno: 7},{type: "midfielder", shirtno:4},{type: "midfielder", shirtno:8},{type: "midfielder", shirtno:11},
										{type: "forward", shirtno:9},{type: "forward", shirtno:10}]; 
		public static var dreamteam:Bitmap; 
		public static var selectedTeam:String;
		public static var team:XMLList;
		public static var _teaminfo:XMLList;
		public static var _instance:TeamModel = new TeamModel();
		
		
		public function TeamModel()
		{
			if (_instance==null)
			{
				
			}
				
		}
		public static function add( data:Object, shirtno:int ):void
		{
			Console.log("add", TeamModel);
			Console.log( "was found?"+exists(data)+" "+data, TeamModel);
			if (!exists(data))
			{
				Console.log( "existed?", TeamModel);
				var player:Object = getShirtNo( shirtno );
				
				if (player!=null)
				{
					
					player.data = data;
					Console.log("Adding "+data.toString()+" as "+player.type, TeamModel );
					update();
				}
			}
		}
		public static function getShirtNo( shirtno:int ):Object
		{
			for (var i:int=0;i<list.length;i++)
			{
				if (list[i].shirtno == shirtno)
				{
					return list[i]; 		
				}
			}
			return null;
						
		}
		public static function exists( data:Object ):Boolean
		{
			for (var i:int=0;i<list.length;i++)
			{
				if (list[i].data == data)
				{
					return true;	
				}
			}
			return false;
		}
		public static function addBitmap(b:Bitmap):void
		{
			dreamteam = b;
		}
		public static function reset():void
		{
			for (var i:int=0;i<list.length;i++)
			{
				list[i].data = null;
			}
			update();
		}
		public static function update():void
		{
			// need to send an update event in order to highlight side buttons 
				_instance.dispatchEvent( new TeamEvent( TeamEvent.UPDATE) );
		}
		public static function isTeamComplete():Boolean
		{
			for (var i:int=0;i<list.length;i++)
			{
				if (list[i].data == null)
					return false;
			}
			return true;
		}
		
		public static function getTeamColor():uint
		{
			if (team!=null)
			{
				return uint(team.@color.toString())
			}
			return 0xFFFFFF;
		}
		public static function getTeamStatistics():XMLList
		{
			return _teaminfo.statistics..stat;
		}
		public static function getTopPlayers():XMLList
		{
			return _teaminfo.top_players..player;
		}
		public static function getGallery():XMLList
		{
			return _teaminfo.gallery..item;
		}
		public static function getTimeline():XMLList
		{
			return _teaminfo.timeline..data;
		}
		public static function getTimelineGallery():XMLList
		{
			return _teaminfo.timeline.gallery..img;
		}
		public static function getVideo():String
		{
			return _teaminfo.video.@src;
		}
		public static function set teaminfo( t:XMLList ): void
		{
			Console.log("teaminfo", TeamModel);
			_teaminfo = t;
			_instance.dispatchEvent( new TeamEvent(TeamEvent.TEAM_INFO) );
		}
		public static function get teaminfo():XMLList
		{
			return _teaminfo;
		}
	}
}