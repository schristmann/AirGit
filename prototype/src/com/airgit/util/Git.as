package com.airgit.util
{
	import com.airgit.model.Console;
	
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;

	
	public class Git extends EventDispatcher
	{
		private static var shell:File;
		private static function getShell():File {
			if(!shell){
				var knownShells:Array = [
					"/opt/local/bin/git",
					"/usr/local/git/bin/git"
				];
				for each(var loc:String in knownShells){
					var fil:File = new File(loc);
					if(fil.exists){
						shell = fil;
						break;
					}
				}
			}
			return shell;
		}
		
		
		private var repository:String;
		private var process:NativeProcess;
		public var response:String;
		public var error:String;
		private var commandString:String;
		private var console:Console = Console.getInstance();
		
		public function Git(repodir:String) {
			this.repository = repodir;
			process = new NativeProcess();
			process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, captureSTDIO);
			process.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, captureSTDERR);
			process.addEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, onIOError);
			process.addEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR, onIOError);
			process.addEventListener(NativeProcessExitEvent.EXIT, onExit);
		}
		public function execute(command:String):void {
			response = "";
			error = "";
			if(!process.running){
				var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
				nativeProcessStartupInfo.executable = getShell();
				nativeProcessStartupInfo.arguments = new <String>[
					"--git-dir="+repository+".git",
					"--work-tree="+repository,
					command
				];
				process.start(nativeProcessStartupInfo);
				commandString = command;
			}
			
		}
		public function executeArguments(commands:Vector.<String>):void {
			response = "";
			error = "";
			if(!process.running){
				var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
				nativeProcessStartupInfo.executable = getShell();
				nativeProcessStartupInfo.arguments = new <String>[
					"--git-dir="+repository+".git",
					"--work-tree="+repository
				];
				nativeProcessStartupInfo.arguments = nativeProcessStartupInfo.arguments.concat(commands);
				process.start(nativeProcessStartupInfo);
				commandString = commands.join(" ");
			}
		}
		private function captureSTDIO(event:ProgressEvent):void{
			response += process.standardOutput.readUTFBytes(process.standardOutput.bytesAvailable);
		}
		private function captureSTDERR(event:ProgressEvent):void{
			error += process.standardError.readUTFBytes(process.standardError.bytesAvailable);
		}
		public function onIOError(event:IOErrorEvent):void{
			trace(event.toString());
		}
		public function onExit(event:NativeProcessExitEvent):void{
			console.console = commandString+"\n"+response+error+"\n"+console.console;
			var complete:Event = new Event(Event.COMPLETE);
			dispatchEvent(complete);
		}
	}
	
	
}