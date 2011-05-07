package rooms 
{
	import flash.utils.ByteArray;
	import net.flashpunk.World;
	
	/**
	 * Just a base level class for loading XML.
	 */
	public class LevelLoader extends World
	{
		/**
		 * The loading XML file.
		 */
		public var level:XML;
		
		/**
		 * Pass the XML source into the constructor.
		 */
		public function LevelLoader(source:Class) 
		{
			var file:ByteArray = new source;
			level = XML(file.readUTFBytes(file.length));
		}
	}
}