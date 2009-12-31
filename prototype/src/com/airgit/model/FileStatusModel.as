package com.airgit.model
{
	import mx.collections.ArrayCollection;

	public class FileStatusModel
	{
		public var untracked:ArrayCollection;
		public var tracked:ArrayCollection;
		public var modified:ArrayCollection;
		public var unresolved:ArrayCollection;
		public var all:ArrayCollection;
		public function FileStatusModel()
		{
			untracked = new ArrayCollection();
			tracked = new ArrayCollection();
			modified = new ArrayCollection();
			unresolved = new ArrayCollection();
			all = new ArrayCollection();
		}
		
		public function get flatCollection():ArrayCollection {
			var col:ArrayCollection = new ArrayCollection();
			return col;
		}
	}
}