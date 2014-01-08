package com.lia.crypto {

	  /*AES Counter-mode for Actionscript ported from AES Counter-mode implementation in JavaScript by Chris Veness
	  	- see http://csrc.nist.gov/public statications/nistpubs/800-38a/sp800-38a.pdf*/
	
	public class AES {
		
		public static const BIT_KEY_128 : int = 128;
		public static const BIT_KEY_192 : int = 192;
		public static const BIT_KEY_256 : int = 256;

		// Sbox is pre-computed multiplicative inverse in GF(2^8) used in subBytes and keyExpansion [§5.1.1]
		private static const SBOX : Array = [0x63,0x7c,0x77,0x7b,0xf2,0x6b,0x6f,0xc5,0x30,0x01,0x67,0x2b,0xfe,0xd7,0xab,0x76,
			             0xca,0x82,0xc9,0x7d,0xfa,0x59,0x47,0xf0,0xad,0xd4,0xa2,0xaf,0x9c,0xa4,0x72,0xc0,
			             0xb7,0xfd,0x93,0x26,0x36,0x3f,0xf7,0xcc,0x34,0xa5,0xe5,0xf1,0x71,0xd8,0x31,0x15,
			             0x04,0xc7,0x23,0xc3,0x18,0x96,0x05,0x9a,0x07,0x12,0x80,0xe2,0xeb,0x27,0xb2,0x75,
			             0x09,0x83,0x2c,0x1a,0x1b,0x6e,0x5a,0xa0,0x52,0x3b,0xd6,0xb3,0x29,0xe3,0x2f,0x84,
			             0x53,0xd1,0x00,0xed,0x20,0xfc,0xb1,0x5b,0x6a,0xcb,0xbe,0x39,0x4a,0x4c,0x58,0xcf,
			             0xd0,0xef,0xaa,0xfb,0x43,0x4d,0x33,0x85,0x45,0xf9,0x02,0x7f,0x50,0x3c,0x9f,0xa8,
			             0x51,0xa3,0x40,0x8f,0x92,0x9d,0x38,0xf5,0xbc,0xb6,0xda,0x21,0x10,0xff,0xf3,0xd2,
			             0xcd,0x0c,0x13,0xec,0x5f,0x97,0x44,0x17,0xc4,0xa7,0x7e,0x3d,0x64,0x5d,0x19,0x73,
			             0x60,0x81,0x4f,0xdc,0x22,0x2a,0x90,0x88,0x46,0xee,0xb8,0x14,0xde,0x5e,0x0b,0xdb,
			             0xe0,0x32,0x3a,0x0a,0x49,0x06,0x24,0x5c,0xc2,0xd3,0xac,0x62,0x91,0x95,0xe4,0x79,
			             0xe7,0xc8,0x37,0x6d,0x8d,0xd5,0x4e,0xa9,0x6c,0x56,0xf4,0xea,0x65,0x7a,0xae,0x08,
			             0xba,0x78,0x25,0x2e,0x1c,0xa6,0xb4,0xc6,0xe8,0xdd,0x74,0x1f,0x4b,0xbd,0x8b,0x8a,
			             0x70,0x3e,0xb5,0x66,0x48,0x03,0xf6,0x0e,0x61,0x35,0x57,0xb9,0x86,0xc1,0x1d,0x9e,
			             0xe1,0xf8,0x98,0x11,0x69,0xd9,0x8e,0x94,0x9b,0x1e,0x87,0xe9,0xce,0x55,0x28,0xdf,
			             0x8c,0xa1,0x89,0x0d,0xbf,0xe6,0x42,0x68,0x41,0x99,0x2d,0x0f,0xb0,0x54,0xbb,0x16];

		// Rcon is Round Constant used for the Key Expansion [1st col is 2^(r-1) in GF(2^8)] [§5.2]
		private static const RCON : Array = [[0x00, 0x00, 0x00, 0x00],
			             [0x01, 0x00, 0x00, 0x00],
			             [0x02, 0x00, 0x00, 0x00],
			             [0x04, 0x00, 0x00, 0x00],
			             [0x08, 0x00, 0x00, 0x00],
			             [0x10, 0x00, 0x00, 0x00],
			             [0x20, 0x00, 0x00, 0x00],
			             [0x40, 0x00, 0x00, 0x00],
			             [0x80, 0x00, 0x00, 0x00],
			             [0x1b, 0x00, 0x00, 0x00],
			             [0x36, 0x00, 0x00, 0x00]];

		/** 
		 * Encrypt a text using AES encryption in Counter mode of operation
		 *
		 * Unicode multi-byte character safe
		 *
		 * @param plaintext Source text to be encrypted
		 * @param password  The password to use to generate a key
		 * @param nBits     Number of bits to be used in the key (128, 192, or 256)
		 * @returns         Encrypted text
		 */
		public static function encrypt(plaintext : String, password : String, nBits : int) : String {
			var blockSize : int = 16;  // block size fixed at 16 bytes / 128 bits (Nb=4) for AES
			if (!(nBits == BIT_KEY_128 || nBits == BIT_KEY_192 || nBits == BIT_KEY_256)) {
				  // standard allows 128/192/256 bit keys
				  throw new Error("Must be a key mode of either 128, 192, 256 bits");
			}
			plaintext = Utf8.encode(plaintext);
			password = Utf8.encode(password);

			// use AES itself to encrypt password to get cipher key (using plain password as source for key 
			// expansion) - gives us well encrypted key
			var nBytes : int = nBits / 8;  // no bytes in key
			var pwBytes : Array = new Array(nBytes);
			for (var i : int = 0;i < nBytes;i++) {
				pwBytes[i] = isNaN(password.charCodeAt(i)) ? 0 : password.charCodeAt(i);
			}
			var key : Array = cipher(pwBytes, keyExpansion(pwBytes));  // gives us 16-byte key
			key = key.concat(key.slice(0, nBytes - 16));  // expand key to 16/24/32 bytes long
			// initialise counter block (NIST SP800-38A §B.2): millisecond time-stamp for nonce in 1st 8 bytes,
			// block counter in 2nd 8 bytes
			var counterBlock : Array = new Array(blockSize);
			var alfo:Date=new Date();
			var nonce : int = (new Date()).time;  // timestamp: milliseconds since 1-Jan-1970
			var nonceSec : int = Math.floor(nonce / 1000);
			var nonceMs : int = nonce % 1000;
			// encode nonce with seconds in 1st 4 bytes, and (repeated) ms part filling 2nd 4 bytes
			for (i = 0;i < 4;i++) counterBlock[i] = (nonceSec >>> i * 8) & 0xff;
			for (i = 0;i < 4;i++) counterBlock[i + 4] = nonceMs & 0xff; 
			// and convert it to a string to go on the front of the ciphertext
			var ctrTxt : String = '';
			for (i = 0;i < 8;i++) ctrTxt += String.fromCharCode(counterBlock[i]);
			
			// generate key schedule - an expansion of the key into distinct Key Rounds for each round
			var keySchedule : Array = keyExpansion(key);
			var blockCount : int = Math.ceil(plaintext.length / blockSize);
			var ciphertxt : Array = new Array(blockCount);  // ciphertext as array of strings

			for (var b : int = 0;b < blockCount;b++) {
				// set counter (block #) in last 8 bytes of counter block (leaving nonce in 1st 8 bytes)
				// done in two stages for 32-bit ops: using two words allows us to go past 2^32 blocks (68GB)
				for (var c : int = 0;c < 4;c++) counterBlock[15 - c] = (b >>> c * 8) & 0xff;
				for (c = 0;c < 4;c++) counterBlock[15 - c - 4] = (b / 0x100000000 >>> c * 8);
			
				var cipherCntr : Array = cipher(counterBlock, keySchedule);  // -- encrypt counter block --
			    
				// block size is reduced on final block
				var blockLength : int = b < blockCount - 1 ? blockSize : (plaintext.length - 1) % blockSize + 1;
				var cipherChar : Array = new Array(blockLength);
			    
				for (i = 0;i < blockLength;i++) {  
					// -- xor plaintext with ciphered counter char-by-char --
					cipherChar[i] = cipherCntr[i] ^ plaintext.charCodeAt(b * blockSize + i);
					cipherChar[i] = String.fromCharCode(cipherChar[i]);
				}
				
				ciphertxt[b] = cipherChar.join(''); 
			}
			
			// Array.join is more efficient than repeated string concatenation in IE
			var ciphertext : String = ctrTxt + ciphertxt.join('');
			ciphertext = Base64.encode(ciphertext);  // encode in base64
			  
			//alert((new Date()) - t);
			return ciphertext;
		}

		/** 
		 * Decrypt a text encrypted by AES in counter mode of operation
		 *
		 * @param ciphertext Source text to be encrypted
		 * @param password   The password to use to generate a key
		 * @param nBits      Number of bits to be used in the key (128, 192, or 256)
		 * @returns          Decrypted text
		 */
		public static function decrypt(ciphertext : String, password : String, nBits : int) : String {
			var blockSize : int = 16;  // block size fixed at 16 bytes / 128 bits (Nb=4) for AES
			if (!(nBits == BIT_KEY_128 || nBits == BIT_KEY_192 || nBits == BIT_KEY_256)) {
				  // standard allows 128/192/256 bit keys
				  throw new Error("Must be a key mode of either 128, 192, 256 bits");
			}
			ciphertext = Base64.decode(ciphertext);
			password = Utf8.encode(password);
			//var t = new Date();  // timer
			  
			// use AES to encrypt password (mirroring encrypt routine)
			var nBytes : int = nBits / 8;  // no bytes in key
			var pwBytes : Array = new Array(nBytes);
			for (var i : int = 0;i < nBytes;i++) {
				pwBytes[i] = isNaN(password.charCodeAt(i)) ? 0 : password.charCodeAt(i);
			}
			var key : Array = cipher(pwBytes, keyExpansion(pwBytes));
			key = key.concat(key.slice(0, nBytes - 16));  // expand key to 16/24/32 bytes long
			
			// recover nonce from 1st 8 bytes of ciphertext
			var counterBlock : Array = new Array(8);
			var ctrTxt : String = ciphertext.slice(0, 8);
			for (i = 0;i < 8;i++) counterBlock[i] = ctrTxt.charCodeAt(i);
			  
			// generate key schedule
			var keySchedule : Array = keyExpansion(key);
			
			// separate ciphertext into blocks (skipping past initial 8 bytes)
			var nBlocks : int = Math.ceil((ciphertext.length - 8) / blockSize);
			var ct : Array = new Array(nBlocks);
			for (b = 0;b < nBlocks;b++) ct[b] = ciphertext.slice(8 + b * blockSize, 8 + b * blockSize + blockSize);
			var ciphertextArr : Array = ct;  // ciphertext is now array of block-length strings
			
			// plaintext will get generated block-by-block into array of block-length strings
			var plaintxt : Array = new Array(ciphertextArr.length);
			
			for (var b : int = 0;b < nBlocks;b++) {
				// set counter (block #) in last 8 bytes of counter block (leaving nonce in 1st 8 bytes)
				for (var c : int = 0;c < 4;c++) counterBlock[15 - c] = ((b) >>> c * 8) & 0xff;
				for (c = 0;c < 4;c++) counterBlock[15 - c - 4] = (((b + 1) / 0x100000000 - 1) >>> c * 8) & 0xff;
			
				var cipherCntr : Array = cipher(counterBlock, keySchedule);  // encrypt counter block

				var plaintxtByte : Array = new Array(String(ciphertextArr[b]).length);
				for (i = 0;i < String(ciphertextArr[b]).length;i++) {
					// -- xor plaintxt with ciphered counter byte-by-byte --
					plaintxtByte[i] = cipherCntr[i] ^ String(ciphertextArr[b]).charCodeAt(i);
					plaintxtByte[i] = String.fromCharCode(plaintxtByte[i]);
				}
				plaintxt[b] = plaintxtByte.join('');
			}
			
			// join array of blocks into single plaintext string
			var plaintext : String = plaintxt.join('');
			plaintext = Utf8.decode(plaintext);  // decode from UTF8 back to Unicode multi-byte chars

			return plaintext;
		}

		private static function cipher(input : Array, w : Array) : Array {    
			// main cipher function [§5.1]
			var Nb : int = 4;               // block size (in words): no of columns in state (fixed at 4 for AES)
			var Nr : int = w.length / Nb - 1; // no of rounds: 10/12/14 for 128/192/256-bit keys

			var state : Array = [[],[],[],[]];  // initialise 4xNb byte-array 'state' with input [§3.4]
			for (var i : int = 0;i < 4 * Nb;i++) state[i % 4][Math.floor(i / 4)] = input[i];
			
			state = addRoundKey(state, w, 0, Nb);
			
			for (var round : int = 1;round < Nr;round++) {
				state = subBytes(state, Nb);
				state = shiftRows(state, Nb);
				state = mixColumns(state);
				state = addRoundKey(state, w, round, Nb);
			}
			
			state = subBytes(state, Nb);
			state = shiftRows(state, Nb);
			state = addRoundKey(state, w, Nr, Nb);
			
			var output : Array = new Array(4 * Nb);  // convert state to 1-d array before returning [§3.4]
			for (var i : int = 0;i < 4 * Nb;i++) output[i] = state[i % 4][Math.floor(i / 4)];
			
			return output;
		}

		private static function keyExpansion(key : Array) : Array {  
			// generate Key Schedule (byte-array Nr+1 x Nb) from Key [§5.2]
			var Nb : int = 4;            // block size (in words): no of columns in state (fixed at 4 for AES)
			var Nk : int = key.length / 4;  // key length (in words): 4/6/8 for 128/192/256-bit keys
			var Nr : int = Nk + 6;       // no of rounds: 10/12/14 for 128/192/256-bit keys

			var w : Array = new Array(Nb * (Nr + 1));
			var temp : Array = new Array(4);
			
			for (var i : int = 0;i < Nk;i++) {
				var r : Array = [key[4 * i], key[4 * i + 1], key[4 * i + 2], key[4 * i + 3]];
				w[i] = r;
			}
			
			for ( i = Nk;i < (Nb * (Nr + 1));i++) {
				w[i] = new Array(4);
				for (var t : int = 0;t < 4;t++) temp[t] = w[i - 1][t];
				if (i % Nk == 0) {
					temp = subWord(rotWord(temp));
					for ( t = 0;t < 4;t++) temp[t] ^= RCON[i / Nk][t];
				} else if (Nk > 6 && i % Nk == 4) {
					temp = subWord(temp);
				}
				for ( t = 0;t < 4;t++) w[i][t] = w[i - Nk][t] ^ temp[t];
			}
			
			return w;
		}

		private static function subBytes(s : Array, Nb : int) : Array {    
			// apply SBox to state S [§5.1.1]
			for (var r : int = 0;r < 4;r++) {
				for (var c : int = 0;c < Nb;c++) s[r][c] = SBOX[s[r][c]];
			}
			
			return s;
		}

		private static function shiftRows(s : Array, Nb : int) : Array {    
			// shift row r of state S left by r bytes [§5.1.2]
			var t : Array = new Array(4);
			for (var r : int = 1;r < 4;r++) {
				for (var c : int = 0;c < 4;c++) t[c] = s[r][(c + r) % Nb];  // shift into temp copy
				for ( c = 0;c < 4;c++) s[r][c] = t[c];         // and copy back
			} // note that this will work for Nb=4,5,6, but not 7,8 (always 4 for AES):

			return s;  // see asmaes.sourceforge.net/rijndael/rijndaelImplementation.pdf
		}

		private static function mixColumns(s : Array) : Array {   
			// combine bytes of each col of state S [§5.1.3]
			for (var c : int = 0;c < 4;c++) {
				var a : Array = new Array(4);  // 'a' is a copy of the current column from 's'
				var b : Array = new Array(4);  // 'b' is a•{02} in GF(2^8)
				for (var i : int = 0;i < 4;i++) {
					a[i] = s[i][c];
					b[i] = s[i][c] & 0x80 ? s[i][c] << 1 ^ 0x011b : s[i][c] << 1;
				}
				// a[n] ^ b[n] is a•{03} in GF(2^8)
				s[0][c] = b[0] ^ a[1] ^ b[1] ^ a[2] ^ a[3]; // 2*a0 + 3*a1 + a2 + a3
				s[1][c] = a[0] ^ b[1] ^ a[2] ^ b[2] ^ a[3]; // a0 * 2*a1 + 3*a2 + a3
				s[2][c] = a[0] ^ a[1] ^ b[2] ^ a[3] ^ b[3]; // a0 + a1 + 2*a2 + 3*a3
				s[3][c] = a[0] ^ b[0] ^ a[1] ^ a[2] ^ b[3]; // 3*a0 + a1 + a2 + 2*a3
			}
			
			return s;
		}

		private static function addRoundKey(state : Array, w : Array, rnd : int, Nb : int) : Array {  
			// xor Round Key into state S [§5.1.4]
			for (var r : int = 0;r < 4;r++) {
				for (var c : int = 0;c < Nb;c++) state[r][c] ^= w[rnd * 4 + c][r];
			}
			
			return state;
		}

		private static function subWord(w : Array) : Array {    
			// apply SBox to 4-byte word w
			for (var i : int = 0;i < 4;i++) w[i] = SBOX[w[i]];
			
			return w;
		}

		private static function rotWord(w : Array) : Array {    
			// rotate 4-byte word w left by one byte
			var tmp : int = w[0];
			for (var i : int = 0;i < 3;i++) w[i] = w[i + 1];
			w[3] = tmp;
			
			return w;
		}
	}
}

internal class Base64 {

	private static const code : String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

	public static function encode(str : String, utf8encode : Boolean = false) : String {  
		// http://tools.ietf.org/html/rfc4648
		var o1 : int, o2 : int, o3 : int, bits : int, h1 : int, h2 : int, h3 : int, h4 : int, e : Array = [], pad : String = '', c : int, plain : String, coded : String;
		var b64 : String = Base64.code;
		   
		plain = utf8encode ? Utf8.encode(str) : str;
		  
		c = plain.length % 3;  // pad string to length of multiple of 3
		if (c > 0) { 
			while (c++ < 3) { 
				pad += '='; 
				plain += '\0'; 
			} 
		}
		
		// note: doing padding here saves us doing special-case packing for trailing 1 or 2 chars
		for (c = 0;c < plain.length;c += 3) {  
			// pack three octets into four hexets
			o1 = plain.charCodeAt(c);
			o2 = plain.charCodeAt(c + 1);
			o3 = plain.charCodeAt(c + 2);
		      
			bits = o1 << 16 | o2 << 8 | o3;
		      
			h1 = bits >> 18 & 0x3f;
			h2 = bits >> 12 & 0x3f;
			h3 = bits >> 6 & 0x3f;
			h4 = bits & 0x3f;
		
			// use hextets to index into code string
			e[c / 3] = b64.charAt(h1) + b64.charAt(h2) + b64.charAt(h3) + b64.charAt(h4);
		}
		coded = e.join('');
		  
		coded = coded.slice(0, coded.length - pad.length) + pad;
		   
		return coded;
	}

	public static function decode(str : String, utf8decode : Boolean = false) : String {
		var o1 : int, o2 : int, o3 : int, h1 : int, h2 : int, h3 : int, h4 : int, bits : int, d : Array = [], plain : String, coded : String;
		var b64 : String = Base64.code;
		
		coded = utf8decode ? Utf8.decode(str) : str; 
		  
		for (var c : int = 0;c < coded.length;c += 4) {
			// unpack four hexets into three octets
			h1 = b64.indexOf(coded.charAt(c));
			h2 = b64.indexOf(coded.charAt(c + 1));
			h3 = b64.indexOf(coded.charAt(c + 2));
			h4 = b64.indexOf(coded.charAt(c + 3));
		      
			bits = h1 << 18 | h2 << 12 | h3 << 6 | h4;
		      
			o1 = bits >>> 16 & 0xff;
			o2 = bits >>> 8 & 0xff;
			o3 = bits & 0xff;
		    
			d[c / 4] = String.fromCharCode(o1, o2, o3) + "";
			// check for padding
			if (h4 == 0x40) d[c / 4] = String.fromCharCode(o1, o2);
			if (h3 == 0x40) d[c / 4] = String.fromCharCode(o1);
		}
		plain = d.join('');

		return utf8decode ? Utf8.decode(plain) : plain; 
	}
}

internal class Utf8 {

	public static function encode(text : String) : String {
		var result : String = "";
 
		for (var n : int = 0;n < text.length;n++) {
 
			var c : int = text.charCodeAt(n);
 
			if (c < 128) {
				result += String.fromCharCode(c);
			} else if((c > 127) && (c < 2048)) {
				result += String.fromCharCode((c >> 6) | 192);
				result += String.fromCharCode((c & 63) | 128);
			} else {
				result += String.fromCharCode((c >> 12) | 224);
				result += String.fromCharCode(((c >> 6) & 63) | 128);
				result += String.fromCharCode((c & 63) | 128);
			}
		}

		return result;
	}

	public static function decode(text : String) : String {
		var result : String = "";
		var i : int = 0;
		var c1 : int = 0, c2 : int = 0, c3 : int = 0;
 
		while ( i < text.length ) {
 
			c1 = text.charCodeAt(i);
 
			if (c1 < 128) {
				result += String.fromCharCode(c1);
				i++;
			} else if((c1 > 191) && (c1 < 224)) {
				c2 = text.charCodeAt(i + 1);
				result += String.fromCharCode(((c1 & 31) << 6) | (c2 & 63));
				i += 2;
			} else {
				c2 = text.charCodeAt(i + 1);
				c3 = text.charCodeAt(i + 2);
				result += String.fromCharCode(((c1 & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));
				i += 3;
			}
		}
 
		return result;
	}
}
