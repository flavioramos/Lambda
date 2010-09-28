package nu.ramos.lambda.area {
	import org.osflash.signals.Signal;
	
	
	public interface IArea {
		
		function get name():String;
		
		function open(path:Array):void;
		function update(path:Array):void;
		function close():void;
		
	}
}