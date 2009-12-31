package com.airgit.util
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	public class FileUtil
	{
		public static function readFileObject(fil:File):Object{
			var amf:Object;
			if(fil.exists){
				var stream:FileStream = new FileStream();
				stream.open(fil, FileMode.READ);
				amf = stream.readObject();
				stream.close();
			}
			return amf;
		}
		public static function writeFileObject(fil:File, obj:Object):Object{
			var stream:FileStream = new FileStream();
			stream.open(fil, FileMode.WRITE);
			stream.writeObject(obj);
			stream.close();
			return obj;
		}
	}
}