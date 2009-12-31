package com.airgit.command
{
	import com.airgit.model.FileStatus;
	import com.airgit.model.ProjectModel;
	import com.airgit.util.Git;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	
	import mx.collections.ArrayCollection;

	public class GetFileStatus extends EventDispatcher
	{
		public var model:ProjectModel;
		private var git:Git;
		private var allFiles:Array;
		
		public function GetFileStatus(){
			allFiles = [];
		}
		
		public function execute():void {
			git = new Git(model.repositoryDirectory.nativePath+"/");
			getAllFiles(model.repositoryDirectory);
			getStatus();
			//trace(allFiles.join("\n"));
		}
		
		private function getAllFiles(dir:File):void{
			var base:String = model.repositoryDirectory.nativePath+"/";
			var fil:File;
			for each(fil in dir.getDirectoryListing()){
				if(!fil.isSymbolicLink){
					if(fil.isDirectory && fil.name != ".git"){
						getAllFiles(fil);
					}else{
						var s:FileStatus = new FileStatus(fil);
						s.rootPath = fil.nativePath.split(base)[1];
						allFiles.push(s)
					}
				}
			}
		}
		private function getStatus():void {
			git.addEventListener(Event.COMPLETE, parseStatus);
			git.execute("status");
		}
		private function parseStatus(event:Event):void{
			trace(git.response);
			var parse:String = git.response;
			var states:Array = [];
			
			var idx:int = 0;
			var edx:int = 0;
			var pattern:String = "#\t";
			while(idx > -1){
				idx = parse.indexOf(pattern, edx);
				if(idx > -1){
					edx = parse.indexOf("\n", idx);
					states.push(parse.substring(idx+pattern.length, edx));
				}
			}
			//trace(states.join("\n"));
			var path:String;
			for each(var state:String in states){
				var modified:Boolean = state.indexOf("modified:") == 0;
				if(modified){
					path = state.substr(12);
					moveFileToStatus(path, FileStatus.MODIFIED);
				}else{
					path = state;
					if(path.charAt(path.length-1) == "/"){
						moveDirectoryToStatus(path, FileStatus.UNTRACKED);
					}else{
						moveFileToStatus(path, FileStatus.UNTRACKED);
					}
				}
			}
			for each(var st:FileStatus in allFiles){
				if(st.status == FileStatus.UNKNOWN){
					st.status = FileStatus.TRACKED;
				}
			}
			model.fileStatus.all = new ArrayCollection(allFiles);
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function moveFileToStatus(path:String, state:int):void{
			for each(var st:FileStatus in allFiles){
				if(st.rootPath == path){
					st.status = state;
					break;
				}
			}
		}
		private function moveDirectoryToStatus(path:String, state:int):void{
			for each(var st:FileStatus in allFiles){
				if(st.rootPath.indexOf(path) == 0){
					st.status = state;
				}
			}
		}
	}
}