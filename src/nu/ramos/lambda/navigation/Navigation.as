package nu.ramos.lambda.navigation {
	
	import nu.ramos.lambda.Lambda;
	import nu.ramos.lambda.area.AbstractBaseArea;
	import nu.ramos.lambda.event.SWFAddressEvent;
	import nu.ramos.lambda.modalwindow.IModalWindow;
	
	import org.osflash.signals.Signal;
	
	/**
	 * Navigation
	 * Handles area changing and modal window openings.
	 * 
	 * @author flavioramos
	 * 
	 */
	public final class Navigation {
		
		// private 
		private static var currentPath				:Array;
		private static var currentModal				:IModalWindow;
		private static var locked					:Boolean;
		private static var transitionManager		:TransitionManager;
		private static var prevPath					:Array;
		
		// public
		public static var onAreaChanged				:Signal = new Signal(Array, Array);
		public static var onAreaUpdated				:Signal = new Signal(Array, Array);
		public static var onModalOpened				:Signal = new Signal(String);
		public static var onModalClosed				:Signal = new Signal(String);
		
		
		// static stuff initializing
		{
			SWFAddress.addEventListener(SWFAddressEvent.CHANGE, onSWFAddressChange);
			SWFAddress.setStrict(false);
		}
		
		
		/**
		 * If set true, will use SWFAddress for deep-linking navigation. 
		 */
		public static var useSWFAddress		:Boolean;
		
		
		/**
		 * Navigation is a static class, please do not instantiate it.
		 * 
		 */
		public function Navigation() {
			throw new Error("Navigation is a static class, please do not instantiate it.");
		}
		
		private static function onSWFAddressChange(e:SWFAddressEvent):void {
			if (e.path=="") {
				if (Lambda.home!=null) open(Lambda.home.split("/"));
			} 
			else open(e.path.split("/"));
		}
		
		/**
		 * Navigate to a specific area.
		 *  
		 * @param		path			String			Path to navigate to.
		 * 
		 */
		public static function go(path:*):void {
			var p:Array;
			
			if (path is String) p = path.split("/");
			else if (path is Array) p = path;
			else {
				throw new Error('Navigation error: You must specify a string or array to open.');
				return;
			}
			
			if (p[0]=='') p.shift();
			
			var area:String = p[0];
			if (area=="" || p==currentPath || locked) return;
			if (useSWFAddress) SWFAddress.setValue(p.join("/"));
			else open(p); 
		}
		
		private static function open(path:Array):void {
			var area:String = path[0];
			locked = true;
			
			if (Lambda.getArea(area)==null) {
				throw new Error("Area " + area + " not found.");
				return;
			}
			
			if (currentPath==null) {
				AbstractBaseArea(Lambda.getArea(area)).onAreaOpened.addOnce(onAreaOpen);
				Lambda.getArea(area).open(path);
				onAreaChanged.dispatch(path, currentPath);
			} else {
				if (currentPath[0]!=area) {
					AbstractBaseArea(Lambda.getArea(area)).onAreaOpened.addOnce(onAreaOpen);
					TransitionManager.doTransition(Lambda.getArea(currentPath[0]), Lambda.getArea(path[0]), path);
					onAreaChanged.dispatch(path, currentPath);
				} else {
					locked = false;
					Lambda.getArea(currentPath[0]).update(path);
					onAreaUpdated.dispatch(path, currentPath);
				}
			}
			prevPath = currentPath;
			currentPath = path;
		}
		
		private static function onAreaOpen():void {
			locked = false;
		}
		
		/**
		 * Returns the current path as an array.
		 *  
		 * @return		Array		Path array 
		 * 
		 */
		public static function getCurrentPath():Array {
			return currentPath;
		}
		
		/**
		 * Open a specific modal window.
		 * 
		 * @param		modalName			Modal window name.
		 * @param		lockNavigation		If true will block any attempt of navigation while modal is open.
		 * @param		data				Any data you want to pass to the modal window.
		 * 
		 */
		public static function openModal(modalName:String, lockNavigation:Boolean=false, data:Object=null):void {
			if (currentModal!=null && currentModal.name==modalName) currentModal.update(data);
			else {
				onModalOpened.dispatch(modalName, data);
				currentModal = Lambda.getModalWindow(modalName);
				currentModal.open(data);
				if (lockNavigation) locked = true;
			}
		}
		
		/**
		 * Closes the current modal window (if there's any opened). 
		 * 
		 */
		public static function closeModal():void {
			onModalClosed.dispatch(currentModal.name);
			if (hasModalOpen) return;
			currentModal.close();
			currentModal = null;
			locked = false;
		}
		
		/**
		 * Check if there's any modal window opened.
		 *  
		 * @return		Boolean 
		 * 
		 */
		public static function get hasModalOpen():Boolean {
			return currentModal!=null;
		}
		
		/**
		 * Go back one step in navigation history. 
		 * 
		 */
		public static function back():void {
			if (useSWFAddress) SWFAddress.back();
			else open(prevPath);
		}
	}
}

import nu.ramos.lambda.area.AbstractBaseArea;
import nu.ramos.lambda.area.IArea;

import org.osflash.signals.Signal;


internal class TransitionManager {
	
	private static var pathArray		:Array;
	private static var area1			:IArea;
	private static var area2			:IArea;
	
	public static function doTransition(area1:IArea, area2:IArea, pathArray:Array=null):void {
		TransitionManager.area1 = area1;
		TransitionManager.area2 = area2;
		
		AbstractBaseArea(area1).onAreaClosed.addOnce(onAreaClosed);
		
		TransitionManager.pathArray = pathArray;
		
		area1.close();
	}
	
	private static function onAreaClosed():void {
		area2.open(pathArray);
	}
	
}
