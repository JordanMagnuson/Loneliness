package game 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Backdrop;
	import rooms.MainWorld;
	/**
	 * ...
	 * @author Jordan Magnuson
	 */
	public class Background01 extends Entity
	{
		
		/**
		 * Background textures
		 */
		[Embed(source='../../assets/gfx/bg01.png')] private const BG:Class;
		public var image:Backdrop = new Backdrop(BG, false, false); 		
		
		public function Background01() 
		{
			type = 'background';
			layer = 100;
			graphic = image;
			x = 0;
			y = 6000;
		}
		
	}

}