package com.airgit.util
{
	import flash.desktop.NativeProcess;
	import flash.desktop.NativeProcessStartupInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NativeProcessExitEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;

	public class Bash extends EventDispatcher
	{
		private var bashLoc:String = "/bin/bash";
		private var scriptLoc:String = File.applicationDirectory.resolvePath("scripts/find-git.sh").nativePath;
		
		private var process:NativeProcess;
				
		public function Bash()
		{
			var nativeProcessStartupInfo:NativeProcessStartupInfo = new NativeProcessStartupInfo();
			nativeProcessStartupInfo.executable = new File(bashLoc);
			nativeProcessStartupInfo.arguments = new <String>[scriptLoc];
			
			process = new NativeProcess();
			process.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, captureSTDIO);
			process.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, captureSTDERR);
			process.addEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, onIOError);
			process.addEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR, onIOError);
			process.addEventListener(Event.STANDARD_OUTPUT_CLOSE, onClose);
			process.addEventListener(Event.STANDARD_ERROR_CLOSE, onClose);
			process.addEventListener(NativeProcessExitEvent.EXIT, onExit);
			process.start(nativeProcessStartupInfo);
		}
		private function captureSTDIO(event:ProgressEvent):void{
			trace("READ", process.standardOutput.readUTFBytes(process.standardOutput.bytesAvailable));
		}
		private function captureSTDERR(event:ProgressEvent):void{
			trace("STDIO ERR", process.standardError.readUTFBytes(process.standardError.bytesAvailable));
		}
		public function onIOError(event:IOErrorEvent):void{
			trace(event.toString());
		}
		public function onClose(event:Event):void{
			trace(event.toString());
		}
		public function onExit(event:NativeProcessExitEvent):void{
			trace("Process exited with", event.exitCode);
		}
	}
}