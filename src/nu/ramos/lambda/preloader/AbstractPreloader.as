package nu.ramos.lambda.preloader {
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	/**
	 * Base class for site preloading. 
	 * Extend this if you want to save some time on your site preloader.
	 * 
	 * Don't forget to implement the IPreloader class.
	 * 
	 * 
	 * @author flavioramos
	 * 
	 */
	public class AbstractPreloader extends Sprite {
		
		private var preloader		:IPreloader;
		
		/**
		 * Constructor.
		 *  
		 * @param			preloader			Reference to the IPreloader implemented class.
		 * 
		 */
		public function AbstractPreloader(preloader:IPreloader) {
			this.preloader = preloader;
		}
		
		/**
		 * Load the site SWF. 
		 * 
		 * @param			siteUrl				Path to the site SWF.
		 * 
		 */
		public function load(siteUrl:String):void {
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void {
				preloader.loadComplete(loader);
			});
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(e:Event):void {
				preloader.loadError();
			});
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, function(e:ProgressEvent):void {
				preloader.loadProgress(e.bytesLoaded/e.bytesTotal);
			});
			try {
				loader.load(new URLRequest(siteUrl));
			} catch (e:*) {
				preloader.loadError(e.message);
			}
		}

	}
}