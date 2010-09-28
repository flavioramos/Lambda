package nu.ramos.lambda.preloader {
	import flash.display.DisplayObject;
	
	public interface IPreloader {
		
		function loadProgress(p:Number):void;
		function loadComplete(site:DisplayObject):void;
		function loadError(errorMessage:String=null):void;
		
	}
}