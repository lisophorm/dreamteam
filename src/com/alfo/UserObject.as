package com.alfo
{
	import flash.display.Sprite;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	
	public class UserObject extends Sprite
	{
		
		private var _photo:String;
		private var _video:String;
		
		public static var USER_FACEBOOK:String = "FACEBOOK";
		public static var USER_EMAIL:String="EMAIL";
		public static var USER_TWITTER:String="TWITTER";
		
		public static var TYPE_VIDEO:String="videofile";
		public static var TYPE_PHOTO:String="jpgfile";
		
		private static var _instance:UserObject=null;
		//public var urn:String;
		
		
		public static var userXML:XML;
		
		private var tempPath:File=new File(File.applicationStorageDirectory.nativePath+File.separator+"tempUser");
		
		private var tempFile:File;
		public var xmlPath:String="youarefootball_xml"+File.separator;
		public var jpgPath:String="youarefootball_jpg"+File.separator;
		public var videoPath:String="youarefootball_video"+File.separator;
		public var thumbPath:String="youarefootball_thumb"+File.separator;
			

		
		
		public function UserObject()
		{
			trace("inizializza userObject");
		}
		
		public function get video():String
		{
			return userXML.video;
		}

		public function set video(value:String):void
		{
			userXML.video = value;
		}

		public function get photo():String
		{
			return userXML.photo;
		}
		
		public function get hometown():String {
			return userXML.hometown;
		}
		
		public function set hometown(town:String) {
			userXML.hometown=town;
		}
		
		public function set extraterms(value:Boolean):void
		{
			if(value) {
				userXML.extraterms = "1";
			} else {
				userXML.extraterms = "0";
			}
			
		}
		
		public function get extraterms():Boolean
		{
			if(userXML.extraterms=="1") {
				return true;
			} else {
				return false;
			}
		}

		public function set photo(value:String):void
		{
			userXML.photo = value;
		}





		public function get current_location():String
		{
			return userXML.current_location;
		}
		
		public function set location(value:String):void
		{
			userXML.location = value;
		}
		
		public function get location():String
		{
			return userXML.location;
		}
		
		// lat and lon
		
		public function set lat(value:Number):void
		{
			userXML.lat = value.toString();
		}
		
		public function get lat():Number
		{
			return parseFloat(userXML.lat);
		}
		
		
		public function set long(value:Number):void
		{
			userXML.long = value.toString();
		}
		
		public function get long():Number
		{
			return parseFloat(userXML.long);
		}
		
		
		public function set current_location(value:String):void
		{
			userXML.current_location = value;
		}
		
		public function set event_location(value:String):void
		{
			userXML.event_location = value;
		}
		
		public function set tablet_id(value:String):void
		{
			userXML.tablet_id = value;
		}
		
		public function get tablet_id():String
		{
			return userXML.tablet_id;
		}
		
		public static function getInstance():UserObject {
			if(_instance==null) {
				trace("******* singleton first instance");
				_instance=new UserObject();
				_instance.init();
			} else {
				trace("**************old instance");
				trace(userXML.toXMLString());
				trace("first name:"+userXML.firstname);
			}
			return _instance;
		}
		
		public function init():void {
			
			var tempDir:File;
			
			trace("***** init userobject");
			userXML =new XML("<user/>");
			var now:Date= new Date();
			userXML.added=convertASDateToMySQLTimestamp(now);
			userXML.isConnected="1";
			userXML.isBatch="0";
			userXML.photo="";
			userXML.video="";
			userXML.personalNote="";
			userXML.lat="0";
			userXML.long="0";
			trace("tempfile path:"+tempPath.nativePath);

			trace("new userobject");
			if(!tempPath.exists) {
				trace("cerating temp path");
				tempPath.createDirectory();
			}
			
			
			
			var workDirectory:File = File.documentsDirectory.resolvePath(xmlPath);
			trace("directory url:"+workDirectory.url);
			if (!workDirectory.exists) {
				trace("directory does not exists");
				//try {
				workDirectory.createDirectory();
				//} catch (e:Error) {
				trace("Failed creating working directory!");
				//}
			} else {
				trace("work dir exists");
			}
			
			
			workDirectory = File.documentsDirectory.resolvePath(jpgPath);
			trace("jpg url:"+workDirectory.url);
			if (!workDirectory.exists) {
				trace("directory does not exists");
				//try {
				workDirectory.createDirectory();
				//} catch (e:Error) {
				trace("Failed creating working directory!");
				//}
			} else {
				trace("jpg dir exists");
			}
			
			workDirectory = File.documentsDirectory.resolvePath(videoPath);
			trace("video directory url:"+workDirectory.url);
			if (!workDirectory.exists) {
				trace("video directory does not exists");
				//try {
				workDirectory.createDirectory();
				//} catch (e:Error) {
				trace("Failed creating video directory!");
				//}
			} else {
				trace("work dir exists");
			}
			
			workDirectory = File.documentsDirectory.resolvePath(thumbPath);
			trace("thumb directory url:"+workDirectory.url);
			if (!workDirectory.exists) {
				trace("thumb directory does not exists");
				//try {
				workDirectory.createDirectory();
				//} catch (e:Error) {
				trace("Failed creating thumb directory!");
				//}
			} else {
				trace("thumb dir exists");
			}
		}
		
		public function eject():void {
			trace("XML:");
			trace(userXML.toXMLString());
		}
		
		public function set urn(theURN:String):void {
			userXML.urn=theURN;
		}
		public function get urn():String {
			return userXML.urn;
		}
		
		public function set personalNote(thepersonalNote:String):void {
			userXML.personalNote=thepersonalNote;
		}
		public function get personalNote():String {
			return userXML.personalNote;
		}
		
		public function set token(thetoken:String):void {
			userXML.token=thetoken;
		}
		public function get token():String {
			return userXML.token;
		}
		
		public function set tokenSecret(thetoken:String):void {
			userXML.tokenSecret=thetoken;
		}
		public function get tokenSecret():String {
			return userXML.tokenSecret;
		}
		
		public function set firstname(thefirstname:String):void {
			userXML.firstname=thefirstname;
		}
		public function get firstname():String {
			return userXML.firstname;
		}
		public function set lastname(thelastname:String):void {
			userXML.lastname=thelastname;
		}
		public function set mobile(themobile:String):void {
			userXML.mobile=themobile;
		}
		public function set email(theemail:String):void {
			userXML.email=theemail;
		}
		public function set user_id(theuser_id:String):void {
			userXML.user_id=theuser_id;
		}
		public function set data_saved(thedata_saved:Boolean):void {
			userXML.data_saved=thedata_saved?"1":"0";
		}
		public function set usertype(theusertype:String):void {
			userXML.usertype=theusertype;
		}
		
		public function get usertype():String {
			return userXML.usertype;
		}

		public function set isConnected(theconnection:Boolean):void {
			userXML.isConnected=theconnection?"1":"0";
		}
		public function get isConnected():Boolean {
			if(userXML.isConnected=="1") {
				return true;
			} else {
				return false;
			}
		}
		
		public function set mediaType(media:String):void {
			userXML.mediaType=media;
		}
		public function get mediaType():String {
			return userXML.mediaType;
		}
		
		public function set isBatch(thebatch:Boolean):void {
			userXML.isBatch=thebatch?"1":"0";
		}
		public function get isBatch():Boolean {
			if(userXML.isBatch=="1") {
				return true;
			} else {
				return false;
			}
		}
		public function set destFileName(thedestFileName:String):void {
			userXML.destFileName=thedestFileName;
		}
		public function get destFileName():String {
			return userXML.destFileName;
		}
		
		public function saveXML():String {
			var f:File = File.documentsDirectory.resolvePath(xmlPath+userXML.urn+".xml");
			trace("save xml");

			var message:String;
			var s:FileStream = new FileStream();
			try
			{
				s.open(f,flash.filesystem.FileMode.WRITE);
				s.writeUTFBytes(userXML.toXMLString());
				message="OK";
			} catch(e:Error) {
				trace("error saving xml"+e.message);
				message= (e.message as String);
			} finally {
				s.close();
			}
			return message;
		}
		
		private function convertASDateToMySQLTimestamp( d:Date ):String {
			var s:String = d.fullYear + '-';
			s += prependZero( d.month + 1 ) + '-';
			s += prependZero( d.date ) + ' ';
			
			s += prependZero( d.hours ) + ':';
			s += prependZero( d.minutes ) + ':';
			s += prependZero( d.seconds );			
			
			return s;
		}
		
		private function prependZero( n:Number ):String {
			var s:String = ( n < 10 ) ? '0' + n : n.toString();
			return s;
		}
		
	}
}