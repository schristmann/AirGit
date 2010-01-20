package com.airgit.util
{
	import flash.display.Screen;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.describeType;
	
	import mx.core.IWindow;

	public class AIRUtil
	{
		public static function centerWindow(win:IWindow):void {
			var sc:Screen = Screen.mainScreen;
			var bds:Rectangle = sc.visibleBounds;
			var top:Number = (bds.height-win.nativeWindow.height)/2;
			var left:Number = (bds.width-win.nativeWindow.width)/2;
			win.nativeWindow.x = Math.max(0, left);
			win.nativeWindow.y = Math.max(0, top);
		}
		public static function loadWindowPrefs(win:IWindow, id:String="None"):void {
			var windowPrefs:String = "windowPreferences.amf";
			var classInfo:XML = describeType(win);
			var label:String = classInfo.@name.toString()+"_"+id;
			var prefs:File = File.applicationStorageDirectory.resolvePath(windowPrefs);
			var windows:Object = FileUtil.readFileObject(prefs) as Object || new Object();
			if(windows[label]){
				var size:Object = windows[label];
				win.nativeWindow.width = Math.min(size.x, win.nativeWindow.maxSize.x);
				win.nativeWindow.height = Math.min(size.y, win.nativeWindow.maxSize.y);
			}
		}
		public static function saveWindowPrefs(win:IWindow, id:String="None"):void {
			var windowPrefs:String = "windowPreferences.amf";
			var classInfo:XML = describeType(win);
			var label:String = classInfo.@name.toString()+"_"+id;
			var prefs:File = File.applicationStorageDirectory.resolvePath(windowPrefs);
			var windows:Object = FileUtil.readFileObject(prefs) as Object || new Object();
			windows[label] = new Point(win.nativeWindow.width, win.nativeWindow.height);
			FileUtil.writeFileObject(prefs, windows);
		}
	}
}