package model
{
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.system.Capabilities;
	import flash.utils.Timer;
	
	import events.DebugEvent;
	import events.RegistrationEvent;

	public class Registration extends EventDispatcher
	{
		import be.aboutme.airserver.AIRServer;
		import be.aboutme.airserver.endpoints.socket.SocketEndPoint;
		import be.aboutme.airserver.endpoints.socket.handlers.websocket.WebSocketClientHandlerFactory;
		import be.aboutme.airserver.events.AIRServerEvent;
		import be.aboutme.airserver.events.MessageReceivedEvent;
		import be.aboutme.airserver.messages.Message;
		import by.blooddy.crypto.serialization.JSON;
		
		import com.utils.Console;
		
		private var server:AIRServer;
		private var msg:String ="";
		private var hasStarted:Boolean = false;
		public function Registration()
		{
			
		}
		
		
		public function startSocket():void
		{	
			
			if (server==null)
			{
				server = new AIRServer();
				
				
				server.addEndPoint(new SocketEndPoint(1235, new WebSocketClientHandlerFactory()));
				server.addEventListener(AIRServerEvent.CLIENT_ADDED, this.clientAddedHandler, false, 0, true);
				server.addEventListener(AIRServerEvent.CLIENT_REMOVED, this.clientRemovedHandler, false, 0, true);
				server.addEventListener(MessageReceivedEvent.MESSAGE_RECEIVED, this.messageReceivedHandler, false, 0, true);
				
			}
			//start the server
			try {
		
				if (!hasStarted)
				{
					//Console.log("startSocket "+server, this);
			
					server.start();
				} else {
					server.stop();
					server.start();
				}
				hasStarted = true;
						
			} catch (e:Error)
			{
				
				this.dispatchEvent( new RegistrationEvent( RegistrationEvent.ERROR, null, e.message  ) );
			}
		}
		
		private function clientAddedHandler(event:AIRServerEvent):void
		{
		//	Console.log("Client added: " + event.client.id + "\n", this);
			delayedIdleSocket();
		}
		
		private function clientRemovedHandler(event:AIRServerEvent):void
		{
			//Console.log("Client removed: " + event.client.id + "\n", this);
		}
		
		public function stopSocket(e:Event = null):void
		{
			if (server!=null && hasStarted)
			{
				//Console.log("stopping socket", this);
				server.stop();
				//kill(); //TODO:: This stops the finger print reader to laucnh - but it never returns
			}
			hasStarted = false;
		}
		
		public function registerUser( uid:String ):void
		{
			this.sendMessage( 'register '+uid );
		}
		
		protected function idleSocket():void
		{
			var idMsg:Message = identifyMessage;
			//Console.log("sending message "+idMsg.data, this)
			
			server.sendMessageToAllClients(idMsg);
		}
		
		protected function get identifyMessage():Message
		{
			var m:Message = new Message();
			m.data = 'identify';// {'command': 'MESSAGE', 'data': 'identify'};
			return m;
		}
		
		public function sendMessage(msg:String):void
		{
			var message:Message=new Message();
			message.data=msg;
			//Console.log("sending message: "+message.data, this);
			server.sendMessageToAllClients(message);
		}
			
		
		protected function delayedIdleSocket():void
		{
			var t:Timer = new Timer(1000);
			t.addEventListener(TimerEvent.TIMER, this.startIdleSocket);
			t.start();
		}
		
		protected function startIdleSocket( e:TimerEvent ):void
		{
			
			var t:Timer = Timer(e.target);
			t.removeEventListener(TimerEvent.TIMER, startIdleSocket);
			t.stop();
			t = null;				
			this.idleSocket();
		}
	
		public function debugHandleCode(data:Object):void
		{
			handleCode(data);
		}
		
		protected function handleCode( data:Object=null ):void
		{
			if (data!=null)
			{
				dispatchEvent(new DebugEvent(DebugEvent.DEBUG, data["code"]));
				trace("Registration :: handleCode" + data["code"]);
				
				//Console.log("handleCode:"+ data["code"]+ " "+data["msg"],this);
				switch ( int(data["code"]) ) //'code' parameter is integer
				{
					case 101: 
						//- Place finger on scanner
						this.dispatchEvent( new RegistrationEvent( RegistrationEvent.SCAN_STEP_1, null, data["msg"]  ) );
					break;
					case 102:
						//- Lift finger and place a second time
						this.dispatchEvent( new RegistrationEvent( RegistrationEvent.SCAN_STEP_2, null, data["msg"]  ) );
					break;
					case 103:
						//- Lift finger and place a last time
						this.dispatchEvent( new RegistrationEvent( RegistrationEvent.SCAN_STEP_3, null, data["msg"]  ) );
					break;
					case 104:
						//- Scan successful
						this.dispatchEvent( new RegistrationEvent( RegistrationEvent.SCAN_COMPLETED, null, data["msg"]  ) );
					break;
					case 105:
						//- Low quality scan - try again
						this.dispatchEvent( new RegistrationEvent( RegistrationEvent.SCAN_AGAIN, null, data["msg"]  ) );
					break;
					case 106:
						//- Error
						this.dispatchEvent( new RegistrationEvent( RegistrationEvent.ERROR, null, data["msg"]  ) );
					break;
					case 107:
						//- Error - start all three scan again
						this.dispatchEvent( new RegistrationEvent( RegistrationEvent.SCAN_RESTART, null, data["msg"]  ) );
					break;
					case 108:
						// Send 'cancel' to reset.
						this.dispatchEvent( new RegistrationEvent( RegistrationEvent.SCAN_CANCELLED, null, data["msg"]  ) );
					break;
					case 201:
						//- Registration successful
						// I THINK THE URN SHOULD BE CREATED HERE
						this.dispatchEvent( new RegistrationEvent( RegistrationEvent.USER_REGISTERED, null, data["msg"]  ) );
					break;
					case 202:
						//- Registration Error
						this.dispatchEvent( new RegistrationEvent( RegistrationEvent.ERROR, null, data["msg"]  ) );
					break;
					case 203:
						//- Customer is already in the DB
						this.dispatchEvent( new RegistrationEvent( RegistrationEvent.USER_ALREADY_REGISTERED, data["msg"]  ) );
	
					break;
					case 301:
						//- Identify Scan finger
						this.dispatchEvent( new RegistrationEvent( RegistrationEvent.SCAN_READY, null, data["msg"]  ) );
					break;
					case 302:
						//- (Success, returns user ID)
						if (data["msg"]=="000000000") //user not found
						{
							this.dispatchEvent( new RegistrationEvent( RegistrationEvent.USER_NOT_FOUND, null, data["msg"] ) );	
						} else if ( data["msg"]=="BADSCAN" )
						{
							this.dispatchEvent( new RegistrationEvent( RegistrationEvent.SCAN_AGAIN, null, data["msg"]  ) );
						} else if ( data["msg"] == "-1" )
						{
							this.dispatchEvent( new RegistrationEvent( RegistrationEvent.SCAN_REINITIALISE, null, data["msg"]  ) );	
						} else {
							this.dispatchEvent( new RegistrationEvent( RegistrationEvent.USER_FOUND, data["msg"]  ) );
						}
					break;
					case 303 :
						//- Customer not found
						
						this.dispatchEvent( new RegistrationEvent( RegistrationEvent.USER_NOT_FOUND, data["msg"] ) );
					break;
				}
			}
		}
		private function messageReceivedHandler(event:MessageReceivedEvent):void
		{
			//Console.log("messageReceivedHandler", this);
			try {
				if (event.message.data!=null)
				{
					var dataOut:Object = by.blooddy.crypto.serialization.JSON.decode(event.message.data.toString());
					//Console.log(event.message.data.toString(), this);
					handleCode( dataOut );
				} else
				{
					this.dispatchEvent( new RegistrationEvent( RegistrationEvent.ERROR, null, "Server communication error...Try again"  ) );
				}
			} catch (e:Error)
			{
				//Console.log("Error:\n"+e.message, this)
				this.dispatchEvent( new RegistrationEvent( RegistrationEvent.ERROR, null, e.message  ) );
			}
		}
		public function openInternetExplorerWithSockets():void //not complete
		{
			if (flash.system.Capabilities.os.indexOf("Windows")!=-1)
			{
				//Console.log("Open internet explorer", this)
				var file:File=File.applicationDirectory.resolvePath("C:/Windows/System32/cmd.exe");
				var nativeProcessInfo:NativeProcessStartupInfo=new NativeProcessStartupInfo();
				nativeProcessInfo.executable=file;
				nativeProcessInfo.arguments=new <String>["/C "];
				
				var process:NativeProcess=new NativeProcess();
				process.start(nativeProcessInfo);
			} else 
			{
				this.dispatchEvent( new RegistrationEvent( RegistrationEvent.ERROR, null, "Application requires Internet Explorer (windows) to run..."  ) );	
			}
		}
		public function kill():void
		{
			//Console.log("Attempting kill", this);
			if (flash.system.Capabilities.os.indexOf("Windows")!=-1)
			{
				//Console.log("Kill Device!", this)
				var file:File=File.applicationDirectory.resolvePath("C:/Program Files/BioPlugin/M2SysPlugIn.exe");
				var nativeProcessInfo:NativeProcessStartupInfo=new NativeProcessStartupInfo();
				nativeProcessInfo.executable=file;
				nativeProcessInfo.arguments=new <String>["IS -1"];
				
				var process:NativeProcess=new NativeProcess();
				process.start(nativeProcessInfo);
			}
		}
	}
}