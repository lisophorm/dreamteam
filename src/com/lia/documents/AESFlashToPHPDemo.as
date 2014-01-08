package com.lia.documents {
	import fl.controls.Button;
	import fl.controls.TextArea;

	import com.lia.display.Poller;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.TextFormat;

	/**
	 * @author Shane McCartney
	 */
	public class AESFlashToPHPDemo extends Sprite {

		private var encryptUrlLoader : URLLoader = new URLLoader();		private var decryptUrlLoader : URLLoader = new URLLoader();

		public var keyInputTextField : TextArea;
		public var encryptInputTextField : TextArea;
		public var decryptInputTextField : TextArea;
		public var encryptButton : Button;
		public var decryptButton : Button;

		private var loadingMessage : Sprite;

		public function AESFlashToPHPDemo() {
			loadingMessage = new Sprite();
			
			loadingMessage.graphics.beginFill(0x000000, 0.7);
			loadingMessage.graphics.drawRect(0, 0, 550, 180);
			
			var poller : Poller = new Poller();
			poller.x = 275;
			poller.y = 90;
			
			loadingMessage.addChild(poller);
			
			/////////////////////////////////////////////////////////////////////////
			
			var buttonTextFormat : TextFormat = new TextFormat("_sans", 18, 0x000000);
			var inputTextFormat : TextFormat = new TextFormat("_sans", 14, 0x000000);
			
			keyInputTextField.setStyle("textFormat", inputTextFormat);
			encryptInputTextField.setStyle("textFormat", inputTextFormat);
			decryptInputTextField.setStyle("textFormat", inputTextFormat);
			
			encryptButton.setStyle("textFormat", buttonTextFormat);
			decryptButton.setStyle("textFormat", buttonTextFormat);
			
			keyInputTextField.text = "Shhh don't tell any one this is a secret key!";
			encryptInputTextField.text = "The truth is out there";
			
			/////////////////////////////////////////////////////////////////////////
			
			encryptButton.addEventListener(MouseEvent.MOUSE_DOWN, onEncryptMouseDown);
			decryptButton.addEventListener(MouseEvent.MOUSE_DOWN, onDecryptMouseDown);
			
			encryptUrlLoader.addEventListener(Event.COMPLETE, onEncryptDataLoaded);			decryptUrlLoader.addEventListener(Event.COMPLETE, onDecryptDataLoaded);
		}

		private function onDecryptDataLoaded(event : Event) : void {
			removeChild(loadingMessage);
			
			decryptInputTextField.text = decryptUrlLoader.data;
		}

		private function onEncryptDataLoaded(event : Event) : void {
			removeChild(loadingMessage);
			
			encryptInputTextField.text = decryptInputTextField.text = encryptUrlLoader.data;
		}

		private function onDecryptMouseDown(event : MouseEvent) : void {
			addChild(loadingMessage);
			
			var decryptUrlRequest : URLRequest = new URLRequest("http://code.flashdynamix.com/AES/aes-decrypt.php");
			
			var decryptUrlVariables : URLVariables = new URLVariables();
			decryptUrlVariables["encrypted"] = encryptInputTextField.text;
			
			decryptUrlRequest.data = decryptUrlVariables;
			decryptUrlRequest.method = URLRequestMethod.POST;
			
			decryptUrlLoader.load(decryptUrlRequest);
		}

		private function onEncryptMouseDown(event : MouseEvent) : void {
			addChild(loadingMessage);
			
			var encryptUrlRequest : URLRequest = new URLRequest("http://code.flashdynamix.com/AES/aes-encrypt.php");
			
			var encryptUrlVariables : URLVariables = new URLVariables();
			encryptUrlVariables["plain"] = encryptInputTextField.text;
			
			encryptUrlRequest.data = encryptUrlVariables;
			encryptUrlRequest.method = URLRequestMethod.POST;
			
			encryptUrlLoader.load(encryptUrlRequest);
		}
	}
}
