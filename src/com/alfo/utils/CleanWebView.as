package com.alfo.utils
{
	import flash.data.SQLConnection;
	import flash.data.SQLStatement;
	import flash.errors.SQLError;
	import flash.filesystem.File;
	import flash.system.Capabilities;
	import flash.utils.Timer;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	
	import org.osmf.events.TimeEvent;
	
	
	
	public class CleanWebView
	{
		
		public static var counter:Number;
		public function CleanWebView()
		{
		}
		
		public static function wipeOut():void {
			var error1:Boolean;
			var error2:Boolean;
			var isDebug:String =""
			if(Capabilities.isDebugger) {
				isDebug=".debug";
			} 
			if((Capabilities.os.indexOf("Linux") >= 0)) {
				trace("I am android");
				var sqlConnection:SQLConnection = new SQLConnection();
				try {
					sqlConnection.open(File.applicationDirectory.resolvePath("/data/data/air.IgniteFaceBook01"+isDebug+"/databases/webview.db"));
					error1=true;
				} catch (e:Error) {
					trace("no db connect"+e.message);
					error1=false;
				}
				
				
				var sqls:SQLStatement = new SQLStatement();
				sqls.sqlConnection = sqlConnection;
				sqls.text="delete from formdata";
				if(error1) {
				try {
					sqls.execute();
					trace("form cache delete successfull");
					
				} catch(error:SQLError) {
					trace("Error message:", error.message); 
					trace("Details:", error.details); 
				}
				}
				
				var sqlConnection2:SQLConnection = new SQLConnection();
				try {
					sqlConnection2.open(File.applicationDirectory.resolvePath("/data/data/air.IgniteFaceBook01"+isDebug+"/databases/webviewCookiesChromium.db"));
					trace("connected to chromium db");
					error2=true;
				} catch (e:Error) {
					trace("no db chromium connect"+e.message);
					error2=false;
				}
				
				if(error2) {
				sqls = new SQLStatement();
				sqls.sqlConnection = sqlConnection2;
				sqls.text="delete from cookies";
				
				try {
					sqls.execute();
					trace("cookies delete successfull");
					
				} catch(error:SQLError) {
					trace("Error message:", error.message); 
					trace("Details:", error.details); 
				}
				
				
				sqls.text = "SELECT * FROM cookies";
				try {
					sqls.execute();
					var tempo:ArrayCollection=new ArrayCollection(sqls.getResult().data);
					trace("count user cookies"+tempo.length);
					//countLabel.text=String(tempo.length);
					
				} catch (error:SQLError) {
					trace("error countUser");
					trace("Error message:", error.message); 
					trace("Details:", error.details); 
					
				}
				}
				
			}
			
		    function contaDb():void 
			{
				var sqlConnection2:SQLConnection = new SQLConnection();
				try {
					sqlConnection2.open(File.applicationDirectory.resolvePath("/data/data/air.IgniteFaceBook01.debug/databases/webviewCookiesChromium.db"));
					trace("connected to chromium db");
				} catch (e:Error) {
					trace("no db connect"+e.message);
				}
				
				var sqls:SQLStatement = new SQLStatement();
				sqls.sqlConnection = sqlConnection2;
				sqls.text = "SELECT * FROM cookies";
				try {
					sqls.execute();
					var tempo:ArrayCollection=new ArrayCollection(sqls.getResult().data);
					trace("TIMER count user cookies"+tempo.length);
					//countLabel.text=String(tempo.length);
					
				} catch (error:SQLError) {
					trace("error countUser");
					trace("Error message:", error.message); 
					trace("Details:", error.details); 
					
				}
				
				sqls = new SQLStatement();
				sqls.sqlConnection = sqlConnection2;
				sqls.text="delete from cookies";
				
				try {
					sqls.execute();
					trace("cookies delete successfull");
					
				} catch(error:SQLError) {
					trace("Error message:", error.message); 
					trace("Details:", error.details); 
				}
			}
		}
		public static function pauseWipe():void {
			trace("pausing wipeout");
			clearInterval(counter);
		}
		
	}
	}