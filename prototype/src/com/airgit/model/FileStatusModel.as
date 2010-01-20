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
		public function get unCommittedCollection():ArrayCollection {
			var testuncommited:Function = function(element:*, index:int, arr:Array):Boolean {
				return (element.status == FileStatus.UNCOMMITED);
			};
			var uncommited:Array = all.source.filter(testuncommited);
			return new ArrayCollection(uncommited);
		}
		public function get flatCollection():ArrayCollection {
			return all;
		}
		public function get treeCollection():ArrayCollection {
			var col:ArrayCollection = new ArrayCollection();
			
			var testuncommited:Function = function(element:*, index:int, arr:Array):Boolean {
				return (element.status == FileStatus.UNCOMMITED);
			};
			var uncommited:Array = all.source.filter(testuncommited);
			
			var testuntracked:Function = function(element:*, index:int, arr:Array):Boolean {
				return (element.status == FileStatus.UNTRACKED);
			};
			var untracked:Array = all.source.filter(testuntracked);
			
			var testmodified:Function = function(element:*, index:int, arr:Array):Boolean {
				return (element.status == FileStatus.MODIFIED);
			};
			var modified:Array = all.source.filter(testmodified);
			
			var testtracked:Function = function(element:*, index:int, arr:Array):Boolean {
				return (element.status == FileStatus.TRACKED);
			};
			var tracked:Array = all.source.filter(testtracked);
			
			
			if(uncommited.length){
				col.addItem( {label:"Files to Commit", status:FileStatus.UNCOMMITED, children:new ArrayCollection(uncommited)} );
			}
			if(untracked.length){
				col.addItem( {label:"New Files", status:FileStatus.UNTRACKED, children:new ArrayCollection(untracked)} );
			}
			if(modified.length){
				col.addItem( {label:"Modified Files", status:FileStatus.MODIFIED, children:new ArrayCollection(modified)} );
			}
			if(tracked.length){
				col.addItem( {label:"Unchanged", status:FileStatus.TRACKED, children:new ArrayCollection(tracked)} );
			}
			
			return col;
		}
	}
}