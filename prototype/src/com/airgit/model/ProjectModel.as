package com.airgit.model
{
	import flash.filesystem.File;

	public class ProjectModel
	{
		[Bindable]
		public var repositoryDirectory:File;
		
		[Bindable]
		public var console:String;
		
		[Bindable]
		public var fileStatus:FileStatusModel;
		
		public function ProjectModel()
		{
			fileStatus = new FileStatusModel();
			console = "";
		}
		
	}
}