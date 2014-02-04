package model
{
	public class ML
	{
		import flash.filesystem.*;
		
		public static var langFile:File; // The preferences prefsFile
		public static var langXML:XML; // The XML data
		public static var stream:FileStream; // The FileStream object used to read and write prefsFile data.
		
		
		public static function create():void
		{
			if (langXML==null)
			{
			langFile = File.applicationDirectory;
			langFile = langFile.resolvePath("assets/lang/translation.xml"); 

			stream = new FileStream();
			// If it exists read it 
			if (langFile.exists) {
				trace("preference file exists");
				stream.open(langFile, FileMode.READ);
				processXMLData();
			}
			else //Otherwise make a file and save it
			{
				trace("no file");
				
			}
			}
		}
		

		
		private static function processXMLData():void 
		{
			
			ML.langXML = XML(stream.readUTFBytes(stream.bytesAvailable));
			stream.close();
		}
		
		public static function t( str: String ) : String
		{
			create();
			var translated : String = str;
			try
			{
				var n : XML = ML.langXML..Column0.(text().toLowerCase()==str.toLowerCase()).parent();
				if ( n != null)
				translated =  XML(n).Column0.text();
			} catch (error:Error)
			{
			}
			return translated;
		}
		
		
	}			
		
}