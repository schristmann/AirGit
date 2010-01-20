package com.airgit.model
{
	public class Console
	{
		private static var instance:Console;
		public static function getInstance():Console {
			if(instance == null){
				instance = new Console();
			}
			return instance;
		}
		[Bindable]
		public var console:String = "";
	}
}