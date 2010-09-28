/*
Licensed under the MIT License

Copyright (c) 2010 Flavio Ramos

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

package nu.ramos.lambda {
	
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import nu.ramos.lambda.area.IArea;
	import nu.ramos.lambda.modalwindow.IModalWindow;
	import nu.ramos.lambda.navigation.Navigation;
	
	/**
	 * Lambda
	 * Lightweight site building framework.
	 *
	 * @author Flavio Ramos
	 * @version 1.0
	 */
	public class Lambda extends EventDispatcher {
		
		private static var areas						:Array = new Array();
		private static var areaContainer				:Sprite;
		private static var modalWindows					:Array = new Array();
		private static var modalWindowContainer			:Sprite;
		private static var site							:ISiteContainer;
		private static var homeName						:String;
		
		/**
		 * Use this variable for saving any type of session data. 
		 */
		public static var sessionData			:Dictionary;
		
		
		/**
		 * If true will print debug messages on console. 
		 */		
		public static var debugMode				:Boolean;
		
		
		/**
		 * This class is a singleton. Please do not instantiate it. 
		 * 
		 */
		public function Lambda() {
			throw new Error("Lambda is a static class, please do not instantiate it.");
		}
		
		/**
		 * Initalize the framework. It should be called only after all areas are added.
		 *  
		 * @param	site	ISiteContainer		Site container insntance.
		 * 
		 */
		public static function init(site:ISiteContainer):void {
			Lambda.site = site;
			
			var i:String;
			
			// areas
			areaContainer = new Sprite();
			for (i in areas) areaContainer.addChild(areas[i]);
			Sprite(site).addChild(areaContainer);
			
			// modal windows
			modalWindowContainer = new Sprite();
			for (i in modalWindows) modalWindowContainer.addChild(modalWindows[i]);
			Sprite(site).addChild(modalWindowContainer);
			
			site.start();
			
			sessionData = new Dictionary();
		}
		
		/**
		 * Insert a new area.
		 * 
		 * @param	area	IArea		Area to be added to the navigation control.
		 * 
		 */
		public static function addArea(area:IArea):void {
			if (areaContainer != null) {
				throw new Error('Lambda already started.');
			}
			
			if (areas[area.name]!=null) {
				throw new Error('Area "' + area.name + '" already exists');
			}
			
			areas[area.name] = area;
		}
		
		/**
		 * Insert a new modal window.
		 * 
		 * @param	modalWindow		IModalWindow		Modal window to be added to the navigation control.
		 * 
		 */
		public static function addModalWindow(modalWindow:IModalWindow):void {
			if (modalWindowContainer != null) {
				throw new Error('Lambda already started.');
				return;
			}
			
			if (modalWindows[modalWindow.name]!=null) {
				throw new Error('Modal window ' + modalWindow.name + ' already exists');
				return;
			}
			
			modalWindows[modalWindow.name] = modalWindow;
		}
		
		/**
		 * 
		 * Returns the area specified by name.
		 * 
		 * @param 	areaName	String		Area name.
		 * 
		 * @return	IArea 		A reference to the area's instance.
		 * 
		 */
		public static function getArea(areaName:String):IArea {
			return areas[areaName];
		}
		
		/**
		 * Returns the modal window specified by name.
		 * 
		 * @param	modalWindowName		String			Modal window name.
		 * 
		 * @return 	IModalWindow		A reference to the modal window instance.	
		 * 
		 */
		public static function getModalWindow(modalWindowName:String):IModalWindow {
			return modalWindows[modalWindowName];
		}
		
		/**
		 * Prints a message on the console.
		 * 
		 * @param message	String		Message to be print on console.
		 * 
		 */
		public static function debug(message:String):void {
			if (debugMode) trace("[DEBUG]", message);
		}
		
		/**
		 * Name of the home area.
		 * 
		 * @param homeName
		 * 
		 */
		public static function set home (homeName:String):void {
			Lambda.homeName = homeName;
		}
		
		public static function get home ():String {
			return homeName;
		}
	}
	
}