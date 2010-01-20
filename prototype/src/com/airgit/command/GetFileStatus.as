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
		private var state:ParseState;
		
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
			//trace(git.response);
			var parse:String = git.response;
			var lines:Array = parse.split("\n");
			for each(var line:String in lines){
				if(line.indexOf("#\t") > -1){
					parseFile(line);
				}else{
					switch(line){
						case "# Changes to be committed:":
							state = ParseState.UNCOMMITTED;
							break;
						case "# Changed but not updated:":
							state = ParseState.MODIFIED;
							break;
						case "# Untracked files:":
							state = ParseState.UNTRACKED;
							break;
						default:
							break;
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
		private function parseFile(line:String):void {
			var idx:int = line.indexOf(":");
			var path:String;
			if(idx > -1){
			 	path = line.substr(idx+4);
			}else{
				path = line.substr(2);
			}
			if(path.charAt(path.length-1) == "/"){
				moveDirectoryToStatus(path, state.status);
			}else{
				moveFileToStatus(path, state.status);
			}
		}
		
		private function moveFileToStatus(path:String, state:int):void{
			for each(var st:FileStatus in allFiles){
				if(st.rootPath == path){
					if(st.status == FileStatus.UNKNOWN){
						st.status = state;
					}
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
import com.airgit.model.FileStatus;
class ParseState{
	public static var UNCOMMITTED:ParseState = new ParseState(FileStatus.UNCOMMITED);
	public static var MODIFIED:ParseState = new ParseState(FileStatus.MODIFIED);
	public static var UNTRACKED:ParseState = new ParseState(FileStatus.UNTRACKED);
	public var status:int;
	public function ParseState(fileStatus:int){
		status = fileStatus;
	}
}