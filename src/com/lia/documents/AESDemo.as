package com.lia.documents {
	import fl.controls.Button;
	import fl.controls.TextArea;

	import com.lia.crypto.AES;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;

	/**
	 * @author Shane McCartney
	 */
	public class AESDemo extends Sprite {

		public var keyInputTextField : TextArea;		public var encryptInputTextField : TextArea;		public var decryptInputTextField : TextArea;
		public var encryptButton : Button;		public var decryptButton : Button;

		public function AESDemo() {
			var buttonTextFormat : TextFormat = new TextFormat("_sans", 18, 0x000000);
			var inputTextFormat : TextFormat = new TextFormat("_sans", 14, 0x000000);
			
			keyInputTextField.setStyle("textFormat", inputTextFormat);			encryptInputTextField.setStyle("textFormat", inputTextFormat);			decryptInputTextField.setStyle("textFormat", inputTextFormat);
			
			encryptButton.setStyle("textFormat", buttonTextFormat);			decryptButton.setStyle("textFormat", buttonTextFormat);
			
			keyInputTextField.text = "Shhh don't tell any one this is a secret key!";
			encryptInputTextField.text = "The truth is out there";
			
			encryptButton.addEventListener(MouseEvent.MOUSE_DOWN, onEncryptMouseDown);			decryptButton.addEventListener(MouseEvent.MOUSE_DOWN, onDecryptMouseDown);
		}

		private function onDecryptMouseDown(event : MouseEvent) : void {
			decryptInputTextField.text = AES.decrypt(decryptInputTextField.text, keyInputTextField.text, AES.BIT_KEY_256);
		}

		private function onEncryptMouseDown(event : MouseEvent) : void {
			encryptInputTextField.text = decryptInputTextField.text = AES.encrypt(encryptInputTextField.text, keyInputTextField.text, AES.BIT_KEY_256);
		}
	}
}
