package com.airgit.model.cache
{
	import com.airgit.util.FileUtil;
	
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;

	public class RecentlyOpened
	{
		private static const cacheLoc:String = "cache/RecentlyOpened.amf";
		private static var directories:ArrayCollection;
		public static function getRecentDirectories():ArrayCollection {
			loadFromDisk();
			return directories;
		}
		public static function addRecentDirectory(dir:File):void {
			loadFromDisk();
			for(var i:int=directories.length; i--; i>0){
				var old:File = directories.getItemAt(i) as File;
				if(old.nativePath == dir.nativePath){
					directories.removeItemAt(i);
				}
			}
			directories.addItemAt(dir, 0);
			directories.refresh();
			saveToDisk();
		}
		public static function removeRecentDirectory(dir:File):void {
			loadFromDisk();
			for(var i:int=directories.length; i--; i>0){
				var old:File = directories.getItemAt(i) as File;
				if(old.nativePath == dir.nativePath){
					directories.removeItemAt(i);
				}
			}
			directories.refresh();
			saveToDisk();
		}
		private static function saveToDisk():void {
			var arr:Array = directories.source;
			var cache:File = File.applicationStorageDirectory.resolvePath(cacheLoc);
			FileUtil.writeFileObject(cache, arr);
		}
		private static function loadFromDisk():void {
			if(directories == null){
				directories = new ArrayCollection();
				var cache:File = File.applicationStorageDirectory.resolvePath(cacheLoc);
				if(cache.exists){
					var arr:Array = FileUtil.readFileObject(cache) as Array;
					for each(var item:Object in arr){
						directories.addItem(new File(item.nativePath));
					}
				}
			}
		}
	}
}