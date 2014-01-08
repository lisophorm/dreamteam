package com.alfo.utils
{
	import flash.data.SQLConnection;
	
	import flash.data.SQLMode;
	
	import flash.data.SQLResult;
	
	import flash.data.SQLStatement;
	
	import flash.events.SQLErrorEvent;
	
	import flash.events.SQLEvent;
	
	import flash.filesystem.File;
	
	public class SQLiteConnector
	{
		
		private static var instance:SQLiteConnector;
		
		private static var _dbLocation:File;
		
		private var _connection:SQLConnection;
		
		private var _callBackFunction:Function;
		
		private var _hasConnection:Boolean;
		
		public static function getInstance():SQLiteConnector
		{
			
			if ((instance == null))
			{
				instance = new SQLiteConnector  ;
			}
			
			return instance;
			
		}
		
		/**
		 
		 * Specify the path to the SQLite database 
		 
		 */
		
		public function set dbLocation(location:File):void
		{
			
			_dbLocation = location;
			
		}
		
		/**
		 
		 * This will always return the same connection to the db
		 
		 * @return SQLConnection
		 
		 */
		
		public function getConnection():SQLConnection
		{
			if ((_dbLocation == null))
			{
				
				throw new Error("You must first specify a path to the SQLite Database file you want to connect to and a function to handle the succesful connection event.");
				return;
			}
			if ((_connection == null))
			{
				
				_connection = new SQLConnection  ;
				
				_connection.open(_dbLocation);
				
			}
			
			return _connection;
			
		}
		
		/**
		 
		 * Set the _hasConnection variable to true
		 
		 * @param e
		 
		 */
		
		private function connectSuccess(e:SQLEvent):void
		{
			
			_hasConnection = true;
			
		}
		
		/**
		 
		 * Returns whether the SQLiteConnector already
		 
		 * has a connection or not
		 
		 * @return Boolean
		 
		 */
		
		public function get hasConnection():Boolean
		{
			
			return _hasConnection;
			
		}
		
		/**
		 
		 * Catch any SQLite errors during runtime
		 
		 * @param e
		 
		 */
		
		private function onSQLError(e:SQLErrorEvent):void
		{
			
			trace(e.error.message);
			
		}
		
	}
}