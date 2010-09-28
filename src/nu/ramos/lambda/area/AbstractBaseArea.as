package nu.ramos.lambda.area {
	import flash.display.Sprite;
	
	import org.osflash.signals.Signal;
	
	public class AbstractBaseArea extends Sprite {
		
		public var onAreaOpened			:Signal = new Signal();
		public var onAreaClosed			:Signal = new Signal();
		
		public function AbstractBaseArea() {
		}
		
	}
}