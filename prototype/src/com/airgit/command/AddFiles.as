package com.airgit.command
{
	import com.airgit.model.FileStatus;
	import com.airgit.model.ProjectModel;
	import com.airgit.util.Git;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class AddFiles extends EventDispatcher
	{
		public var model:ProjectModel;
		private var git:Git;
		
		public function execute(fileList:Array):void {
			git = new Git(model.repositoryDirectory.nativePath+"/");
			var filesToAdd:Vector.<String> = new <String>["add"];
			for each(var status:FileStatus in fileList){
				filesToAdd.push(status.rootPath);
			}
			git.addEventListener(Event.COMPLETE, dispatchComplete);
			git.executeArguments(filesToAdd);
		}
		
		private function dispatchComplete(evt:Event):void {
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}