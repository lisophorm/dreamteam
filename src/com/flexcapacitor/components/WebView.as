
package com.flexcapacitor.components  {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.FocusDirection;
	import flash.display.Stage;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.LocationChangeEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	import flash.ui.Keyboard;
	
	import mx.core.UIComponent;
	
	/**
	 * @copy flash.media.StageWebView#ErrorEvent.ERROR
	 * */
	[Event(name="error", type="flash.events.ErrorEvent")]
	
	/**
	 * @copy flash.media.StageWebView#Event.COMPLETE
	 * */
	[Event(name="complete", type="flash.events.Event")]
	
	/**
	 * @copy flash.media.StageWebView#LocationChangeEvent.LOCATION_CHANGING
	 * */
	[Event(name="locationChanging", type="flash.events.LocationChangeEvent")]
	
	/**
	 * @copy flash.media.StageWebView#LocationChangeEvent.LOCATION_CHANGE
	 * */
	[Event(name="locationChange", type="flash.events.LocationChangeEvent")]
	
	/**
	 * The StageWebView wrapped in a UIComponent. 
	 * 
	 * Size and position automatically via UIComponent
	 * Show and hide automatically via UIComponent
	 * Adds snapshot mode
	 * Adds content property (wraps String in HTML tag if it is not already)
	 * etc
	 * 
	 * To use,
	 *
	 * Loading a URL:
	 * <local:WebView source="http://google.com/" width="400" height="300"/>
	 *
	 * Loading HTML text:
	 * <local:WebView content="...html text here..." width="400" height="300"/>
	 *
	 * @copy flash.media.StageWebView
	 * */
	public class WebView extends UIComponent {
		
		//include "../core/Version.as";
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		
		//--------------------------------------------------------------------------
		//
		//  Class mixins
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Class properties
		//
		//--------------------------------------------------------------------------
		
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		
		/**
		 * @copy flash.media.StageWebView#assignFocus()
		 * */
		public function assignFocus(direction:String = "none"):void {
			webView.assignFocus(direction);
		}
		
		/**
		 *  @copy flash.media.StageWebView#dispose()
		 * */
		public function dispose():void {
			webView.dispose();
		}
		
		/**
		 * Hides the web view
		 * 
		 *  @see flash.media.StageWebView#stage
		 * */
		public function hideWebView():void {
			webView.stage = null;
		}
		
		/**
		 * Displays the web view
		 * 
		 *  @see flash.media.StageWebView#stage
		 * */
		public function showWebView():void {
			webView.stage = stage;
		}
		
		/**
		 * Load the URL passed in or load the URL specified in the source property
		 * 
		 *  @see flash.media.StageWebView#loadURL()
		 * */
		public function load(URL:String = ""):void {
			
			if (URL) {
				webView.loadURL(URL);
				_source = URL;
			}
			else if (source) {
				webView.loadURL(source);
			}
		}
		
		/**
		 * @copy flash.media.StageWebView#loadString()
		 * */
		public function loadString(value:String, mimeType:String = "text/html"):void {
			content = value;
			
			if (webView) {
				if (value && value.indexOf("<html")>=0) {
					webView.loadString(value, mimeType);
				}
				else {
					wrappedContent = htmlWrapper.replace("[content]", value || "");
					webView.loadString(wrappedContent, mimeType);
				}
			}
			
		}
		
		/**
		 * @copy flash.media.StageWebView#drawViewPortToBitmapData()
		 * */
		public function drawViewPortToBitmapData(bitmap:BitmapData):void {
			webView.drawViewPortToBitmapData(bitmap);
		}
		
		/**
		 * Creates a snapshot of the Stage Web View at the point of this call 
		 * and displays that instead of the actual Stage Web View. 
		 * Use removeSnapshot to dispose of the snapshot and show the web contents again. 
		 * 
		 * @see isSnapshotVisible
		 * @see flash.media.StageWebView#drawViewPortToBitmapData()
		 * */
		public function takeSnapshot():BitmapData {
			destroySnapshot();
			snapshotBitmapData = new BitmapData(unscaledWidth, unscaledHeight);
			webView.drawViewPortToBitmapData(snapshotBitmapData);
			webViewBitmap = new Bitmap(snapshotBitmapData);
			addChild(webViewBitmap);
			hideWebView();
			isSnapshotVisible = true;
			
			return snapshotBitmapData;
		}
		
		/**
		 * Removes the bitmap snapshot of the Stage Web View from the display list 
		 * and displays the actual Stage Web View.
		 * @copy flash.media.StageWebView#drawViewPortToBitmapData()
		 * */
		public function removeSnapshot():void {
			destroySnapshot();
			showWebView();
		}
		
		/**
		 * Removes the web view snapshot from the display list and disposes of the 
		 * bitmap data
		 * */
		private function destroySnapshot():void {
			if (webViewBitmap) {
				
				if (webViewBitmap.parent) removeChild(webViewBitmap);
				if (webViewBitmap.bitmapData) webViewBitmap.bitmapData.dispose();
				webViewBitmap = null;
				
			}
			
			if (snapshotBitmapData) {
				snapshotBitmapData.dispose();
				snapshotBitmapData = null;
			}
			
			isSnapshotVisible = false;
		}
		
		
		/**
		 * @copy flash.media.StageWebView#historyBack()
		 * */
		public function historyBack():void {
			webView.historyBack();
		}
		
		/**
		 * @copy flash.media.StageWebView#historyForward()
		 * */
		public function historyForward():void {
			webView.historyForward();
		}
		
		
		/**
		 * @copy flash.media.StageWebView#reload()
		 * */
		public function reload():void {
			webView.reload();
		}
		
		
		/**
		 * @copy flash.media.StageWebView#historyForward()
		 * */
		public function stop():void {
			webView.stop();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  Wrapper for StageWebView
		 * 
		 *  @copy flash.media.StageWebView
		 */
		public function WebView() {
			trace("born webcomponent");
			addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			
			// not sure if this is the place to give it a minimum size
			// if we don't do this it defaults to 0 x 0
			width = 480;
			height = 320;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		
		private var wrappedContent:String;
		
		/**
		 * The default HTML used to wrap the HTML content. 
		 * The Stage Web View loadString method expects the content you supply to it 
		 * to be wrapped in HTML tags. This is the default value used if content is 
		 * not wrapped in HTML tags.
		 * */
		public var htmlWrapper:String = "<!DOCTYPE HTML><html><body>[content]</body></html>";
		
		/**
		 * When set to true the source URL will be loaded when it is set. Default is true.
		 * */
		[Bindable]
		public var autoLoad:Boolean = true;
		
		private var _content:String;
		
		/**
		 * Sets the content of the webview. Default mime type is text/html.
		 * */
		[Bindable]
		public function set content(value:String):void {
			
			_content = value;
			
			if (webView) {
				if (value && value.indexOf("<html")>=0) {
					webView.loadString(value, mimeType);
				}
				else {
					wrappedContent = htmlWrapper.replace("[content]", value || "");
					webView.loadString(wrappedContent, mimeType);
				}
			}
		}
		
		public function get content():String {
			return _content;
		}
		
		/**
		 * Flag indicating if a snapshot is being shown
		 * */
		[Bindable]
		public var isSnapshotVisible:Boolean;
		
		/**
		 * When calling takeSnapshot or setting snapshotMode to true this 
		 * property will contain the bitmap data of the view port. 
		 * */
		public var snapshotBitmapData:BitmapData;
		
		/**
		 * When calling takeSnapshot or setting snapshotMode a snapshot of 
		 * the Stage Web View is taken and added to the stage. This is a
		 * reference to the displayed bitmap. 
		 * */
		public var webViewBitmap:Bitmap;
		
		/**
		 * @private
		 * */
		public function get snapshotMode():Boolean {
			return isSnapshotVisible;
		}
		
		/**
		 * When set to true hides the stage web view and displays a non-interactive 
		 * snapshot of the Stage Web View when the property was set to true.  
		 * */
		public function set snapshotMode(value:Boolean):void {
			value ? takeSnapshot() : removeSnapshot();
		}
		
		private var _webView:StageWebView;
		
		/**
		 * @private
		 * */
		public function get webView():StageWebView {
			return _webView;
		}
		
		/**
		 * @copy flash.media.StageWebView
		 * */
		[Bindable]
		public function set webView(value:StageWebView):void {
			_webView = value;
		}
		
		
		private var _source:String;
		
		/**
		 * @private
		 * */
		public function get source():String {
			return _source;
		}
		
		/**
		 * Source URL for stage web view. If autoLoad is set to true then the URL is loaded automatically.
		 * If not use load method to load the source URL
		 * 
		 * @see flash.media.StageWebView#loadURL()
		 * */
		[Bindable]
		public function set source(value:String):void {
			_source = value;
			
			if (webView && autoLoad) {
				webView.loadURL(source);
			}
		}
		
		private var _mimeType:String = "text/html";
		
		/**
		 * If enabled adds support for the back and search keys. 
		 * Back key navigates back in web view history and search navigates forward.
		 * */
		public var navigationSupport:Boolean;
		
		/**
		 * MIME type of the web view content. Default is "text/html"
		 * @see flash.media.StageWebView#loadString()
		 * */
		public function get mimeType():String {
			return _mimeType;
		}
		
		/**
		 * @private
		 */
		public function set mimeType(value:String):void {
			_mimeType = value;
		}
		
		/**
		 * @copy flash.media.StageWebView#viewPort
		 * */
		public function get viewPort():Rectangle { 
			return webView ? webView.viewPort : null; 
		}
		
		/**
		 * @copy flash.media.StageWebView#title
		 * */
		public function get title():String {
			return webView ? webView.title : null;
		}
		
		/**
		 * @copy flash.media.StageWebView#isHistoryBackEnabled()
		 * */
		public function get isHistoryBackEnabled():Boolean {
			return webView ? webView.isHistoryBackEnabled : false;
		}
		
		/**
		 * @copy flash.media.StageWebView#isHistoryForwardEnabled()
		 * */
		public function get isHistoryForwardEnabled():Boolean {
			return webView ? webView.isHistoryForwardEnabled : false;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		
		/**
		 * @copy mx.core.UIComponent#createChildren()
		 * */
		override protected function createChildren():void {
			super.createChildren();
			
			webView = new StageWebView();
			
			webView.addEventListener(Event.COMPLETE, completeHandler);
			webView.addEventListener(ErrorEvent.ERROR, errorHandler);
			webView.addEventListener(FocusEvent.FOCUS_IN, focusInViewHandler);
			webView.addEventListener(FocusEvent.FOCUS_OUT, focusOutViewHandler);
			webView.addEventListener(LocationChangeEvent.LOCATION_CHANGING, locationChangingHandler);
			webView.addEventListener(LocationChangeEvent.LOCATION_CHANGE, locationChangeHandler);
			
			// load URL or text if available
			if (autoLoad && source) {
				webView.loadURL(source);
			} else if (content) {
				trace("load content"+content);
				webView.loadString(content, mimeType);
			}
		}
		
		/**
		 * @copy mx.core.UIComponent#updateDisplayList()
		 * */
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			var point:Point;
			
			// position according to the container rather than the stage
			if (webView) {
				point = localToGlobal(new Point());
				webView.viewPort = new Rectangle(point.x, point.y, unscaledWidth, unscaledHeight);
				trace("coords"+point.x+" "+point.y);
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 * When the stage property is available add it to the web view
		 * */
		public function addedToStageHandler(event:Event):void {
			if (webView) webView.stage = stage;
			invalidateDisplayList();
			
			if (navigationSupport) stage.addEventListener( KeyboardEvent.KEY_DOWN, onKey );
		}
		
		/**
		 * When removed from the stage remove the web view
		 * */
		protected function removedFromStageHandler(event:Event):void {
			destroySnapshot();
			hideWebView();
		}
		
		/**
		 * Dispathes a focus in event when the web view gains focus.
		 * */
		protected function focusInViewHandler(event:FocusEvent):void {
			//webView.assignFocus();
			
			if (hasEventListener(event.type)) 
				dispatchEvent(event);
		}
		
		/**
		 * Dispatches a focus out event when the web view gains focus.
		 * */
		protected function focusOutViewHandler(event:FocusEvent):void {
			//webView.assignFocus(FocusDirection.TOP);
			
			if (hasEventListener(event.type)) 
				dispatchEvent(event);
		}
		
		/**
		 * Dispatches a focus in event when the web view gains focus.
		 * */
		private function onKey( event:KeyboardEvent):void {
			if( event.keyCode == Keyboard.BACK && webView.isHistoryBackEnabled ) {
				webView.historyBack();
				event.preventDefault();
			}
			
			if( event.keyCode == Keyboard.SEARCH && webView.isHistoryForwardEnabled ) {
				webView.historyForward();
			}
		}
		
		
		/**
		 * Dispatched when the page or web content has been fully loaded
		 * */
		protected function completeHandler(event:Event):void {
			if (hasEventListener(event.type))
				dispatchEvent(event);
		}
		
		/**
		 * Dispatched when the location is about to change
		 * */
		protected function locationChangingHandler(event:Event):void {
			if (hasEventListener(event.type))
				dispatchEvent(event);
		}
		
		/**
		 * Dispatched when the location has changed
		 * */
		protected function locationChangeHandler(event:Event):void {
			if (hasEventListener(event.type))
				dispatchEvent(event);
		}
		
		/**
		 * Dispatched when an error occurs
		 * */
		protected function errorHandler(event:ErrorEvent):void {
			
			if (hasEventListener(event.type))
				dispatchEvent(event);
		}
		
	}
}