package com.alfo.utils
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.utils.ByteArray;
	
	import flashx.textLayout.formats.Float;
	
	/**
	 *  The PNGEncoder class converts raw bitmap images into encoded
	 *  images using Portable Network Graphics (PNG) lossless compression.
	 *
	 *  <p>For the PNG specification, see http://www.w3.org/TR/PNG/</p>.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 9
	 *  @playerversion AIR 1.1
	 *  @productversion Flex 3
	 */
	public class PNGEncoderAsync extends EventDispatcher
	{
		//    include "../../core/Version.as";
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  The MIME type for a PNG image.
		 */
		private static const CONTENT_TYPE:String = "image/png";
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function PNGEncoderAsync()
		{
			super();
			
			initializeCRCTable();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private
		 *  Used for computing the cyclic redundancy checksum
		 *  at the end of each chunk.
		 */
		private var crcTable:Array;
		private var IDAT:ByteArray;
		private var sourceBitmapData:BitmapData;
		private var sourceByteArray:ByteArray;
		private var transparent:Boolean;
		private var width:int;
		private var height:int;
		private var y:int;
		private var _png:ByteArray;
		private var sprite:Sprite;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  contentType
		//----------------------------------
		
		/**
		 *  The MIME type for the PNG encoded image.
		 *  The value is <code>"image/png"</code>.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function get contentType():String
		{
			return CONTENT_TYPE;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Converts the pixels of a BitmapData object
		 *  to a PNG-encoded ByteArray object.
		 *
		 *  @param bitmapData The input BitmapData object.
		 *
		 *  @return Returns a ByteArray object containing PNG-encoded image data.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function encode(bitmapData:BitmapData):void
		{
			return internalEncode(bitmapData, bitmapData.width, bitmapData.height,
				bitmapData.transparent);
		}
		
		/**
		 *  Converts a ByteArray object containing raw pixels
		 *  in 32-bit ARGB (Alpha, Red, Green, Blue) format
		 *  to a new PNG-encoded ByteArray object.
		 *  The original ByteArray is left unchanged.
		 *
		 *  @param byteArray The input ByteArray object containing raw pixels.
		 *  This ByteArray should contain
		 *  <code>4 * width * height</code> bytes.
		 *  Each pixel is represented by 4 bytes, in the order ARGB.
		 *  The first four bytes represent the top-left pixel of the image.
		 *  The next four bytes represent the pixel to its right, etc.
		 *  Each row follows the previous one without any padding.
		 *
		 *  @param width The width of the input image, in pixels.
		 *
		 *  @param height The height of the input image, in pixels.
		 *
		 *  @param transparent If <code>false</code>, alpha channel information
		 *  is ignored but you still must represent each pixel
		 *  as four bytes in ARGB format.
		 *
		 *  @return Returns a ByteArray object containing PNG-encoded image data.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 9
		 *  @playerversion AIR 1.1
		 *  @productversion Flex 3
		 */
		public function encodeByteArray(byteArray:ByteArray, width:int, height:int,
										transparent:Boolean = true):void
		{
			internalEncode(byteArray, width, height, transparent);
		}
		
		/**
		 *  @private
		 */
		private function initializeCRCTable():void
		{
			crcTable = [];
			
			for (var n:uint = 0; n < 256; n++)
			{
				var c:uint = n;
				for (var k:uint = 0; k < 8; k++)
				{
					if (c & 1)
						c = uint(uint(0xedb88320) ^ uint(c >>> 1));
					else
						c = uint(c >>> 1);
				}
				crcTable[n] = c;
			}
		}
		
		/**
		 *  @private
		 */
		private function internalEncode(source:Object, width:int, height:int,
										transparent:Boolean = true):void
		{
			// The source is either a BitmapData or a ByteArray.
			sourceBitmapData = source as BitmapData;
			sourceByteArray = source as ByteArray;
			this.transparent = transparent;
			this.width = width;
			this.height = height;
			
			if (sourceByteArray)
				sourceByteArray.position = 0;
			
			// Create output byte array
			_png = new ByteArray();
			
			// Write PNG signature
			_png.writeUnsignedInt(0x89504E47);
			_png.writeUnsignedInt(0x0D0A1A0A);
			
			// Build IHDR chunk
			var IHDR:ByteArray = new ByteArray();
			IHDR.writeInt(width);
			IHDR.writeInt(height);
			IHDR.writeByte(8); // bit depth per channel
			IHDR.writeByte(6); // color type: RGBA
			IHDR.writeByte(0); // compression method
			IHDR.writeByte(0); // filter method
			IHDR.writeByte(0); // interlace method
			writeChunk(_png, 0x49484452, IHDR);
			
			// Build IDAT chunk
			IDAT = new ByteArray();
			y = 0;
			
			sprite = new Sprite();
			sprite.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function onEnterFrame(event:Event):void
		{
			for(var i:int = 0; i < 20; i++)
			{
				writeRow();
				y++;
				if(y >= height)
				{
					sprite.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
					completeWrite();
				}
			}
		}
		
		private function completeWrite():void
		{
			IDAT.compress();
			writeChunk(_png, 0x49444154, IDAT);
			
			// Build IEND chunk
			writeChunk(_png, 0x49454E44, null);
			
			// return PNG
			_png.position = 0;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function writeRow():void
		{
			IDAT.writeByte(0); // no filter
			
			var x:int;
			var pixel:uint;
			
			if (!transparent)
			{
				for (x = 0; x < width; x++)
				{
					if (sourceBitmapData)
						pixel = sourceBitmapData.getPixel(x, y);
					else
						pixel = sourceByteArray.readUnsignedInt();
					
					IDAT.writeUnsignedInt(uint(((pixel & 0xFFFFFF) << 8) | 0xFF));
				}
			}
			else
			{
				for (x = 0; x < width; x++)
				{
					if (sourceBitmapData)
						pixel = sourceBitmapData.getPixel32(x, y);
					else
						pixel = sourceByteArray.readUnsignedInt();
					
					IDAT.writeUnsignedInt(uint(((pixel & 0xFFFFFF) << 8) |
						(pixel >>> 24)));
				}
			}
			dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS));
		}
		
		/**
		 *  @private
		 */
		private function writeChunk(png:ByteArray, type:uint, data:ByteArray):void
		{
			// Write length of data.
			var len:uint = 0;
			if (data)
				len = data.length;
			png.writeUnsignedInt(len);
			
			// Write chunk type.
			var typePos:uint = png.position;
			png.writeUnsignedInt(type);
			
			// Write data.
			if (data)
				png.writeBytes(data);
			
			// Write CRC of chunk type and data.
			var crcPos:uint = png.position;
			png.position = typePos;
			var crc:uint = 0xFFFFFFFF;
			for (var i:uint = typePos; i < crcPos; i++)
			{
				crc = uint(crcTable[(crc ^ png.readUnsignedByte()) & uint(0xFF)] ^
					uint(crc >>> 8));
			}
			crc = uint(crc ^ uint(0xFFFFFFFF));
			png.position = crcPos;
			png.writeUnsignedInt(crc);
		}
		
		public function get png():ByteArray
		{
			return _png;
		}
		
		public function get progress():Number
		{
			return y / height;
		}
	}
}