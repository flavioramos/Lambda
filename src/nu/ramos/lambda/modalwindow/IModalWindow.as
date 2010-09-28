package nu.ramos.lambda.modalwindow {
	import flash.display.Sprite;
	
	public interface IModalWindow {
		
		function get name():String;
		
		function open(data:Object):void;
		function close():void;
		function update(data:Object):void;
		
	}
}