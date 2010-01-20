package com.airgit.model
{
	import flash.filesystem.File;

	public class FileStatus
	{
		public static const UNCOMMITED:int = 0;
		public static const TRACKED:int = 4;
		public static const UNTRACKED:int = 2;
		public static const MODIFIED:int = 3;
		public static const UNRESOLVED:int = 1;
		public static const UNKNOWN:int = -1;
		
		public var reference:File;
		public var status:int;
		public var rootPath:String;
		
		public function FileStatus(reference:File){
			this.status = UNKNOWN;
			this.reference = reference;
		}
		
		public function get label():String {
			return reference.name;
		}
	}
}