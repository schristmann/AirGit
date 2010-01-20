package com.airgit.command
{
	import com.airgit.model.ProjectModel;
	import com.airgit.util.Git;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class CommitFiles extends EventDispatcher
	{
		public var model:ProjectModel;
		private var git:Git;
		
		public function execute(message:String):void {
			git = new Git(model.repositoryDirectory.nativePath+"/");
			git.addEventListener(Event.COMPLETE, dispatchComplete);
			git.executeArguments(new <String>["commit", "-m", message]);
		}
		
		private function dispatchComplete(evt:Event):void {
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}